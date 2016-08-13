/* 
 * Matérn 3/2 GP with Poisson likelihood, reparametrization
 * ---------------------------------------------------------
 * Copyright: Juho Kokkala
 * Date: 10 August 2016
 * License: MIT
 */

data {
    int<lower=0> N;    
    int<lower=0> y[N];
    real<lower=0> dt;     //Time between consecutive observations
}

parameters {
    real mu;              //Mean level of the log-intensity process
    real<lower=0> lscale; //Lengthscale of the process
    real<lower=0> stdev;  //Standard deviation of the process
    vector[N] x_std;      //Auxiliary variables, N(0,1)  
}

transformed parameters{
    vector[N] x;          //The log-intensity process
    matrix[N,N] Sigma;

    for (i in 1:N) {
        Sigma[i,i] = stdev*stdev;
        for (j in 1:(i-1)) {
            Sigma[i,j] = stdev*stdev * (1 + sqrt(3)*dt*(i-j)/lscale) * exp(-sqrt(3)*dt*(i-j)/lscale);
            Sigma[j,i] = Sigma[i,j];
        }
    }

    x = mu + cholesky_decompose(Sigma)*x_std;
}

model {
    x_std ~ normal(0,1);

    lscale ~ student_t(2,0,1);
    stdev ~ student_t(2,0,1); 

    y ~ poisson_log(x);
}
