/* 
 * Matérn 3/2 GP with Poisson likelihood, basic implementation
 * ------------------------------------------------------------
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
    vector[N] x;          //The log-intensity process
}

model {
    vector[N] muvec;
    matrix[N,N] Sigma;

    for (i in 1:N) {
        muvec[i] = mu;
    }

    for (i in 1:N) {
        Sigma[i,i] = stdev*stdev;
        for (j in 1:(i-1)) {
            Sigma[i,j] = stdev*stdev * (1 + sqrt(3)*dt*(i-j)/lscale) * exp(-sqrt(3)*dt*(i-j)/lscale);
            Sigma[j,i] = Sigma[i,j];
        }
    }

    x ~ multi_normal(muvec,Sigma);

    lscale ~ student_t(2,0,1);
    stdev ~ student_t(2,0,1); 

    y ~ poisson_log(x);      
}