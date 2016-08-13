/* 
 * Matérn 3/2 GP with Poisson likelihood, SDE-based version
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
    vector[N] x;          //The log-intensity process
}

model {
    real lda;         //The parameter lambda 
    real m_deriv;     //Filtering distribution of x'(k) | x_1:k
    real P_deriv;
    real m;           //Predicted distribution of x(k) | x_1:(k-1)
    real P;
    matrix[2,2] A;    //Process matrix of the 2D dynamic system
    vector[2] Q;      //Noise variances of the 2D dynamic system
    real covQ;        //Noise covariance of the 2D dynamic system
    real cov;         //For storing the predictive covariance in the loop

    lda = sqrt(3)  / lscale;
    A[1,1] = (1+dt*lda)*exp(-dt*lda);
    A[1,2] = dt*exp(-dt*lda);
    A[2,1] = -dt*lda*lda*exp(-dt*lda);
    A[2,2] = (1-dt*lda)*exp(-dt*lda);
    Q[1] = stdev*stdev * (1 - exp(-2*dt*lda) * ((1+dt*lda)*(1+dt*lda) + dt*lda*dt*lda));
    Q[2] = stdev*stdev * (lda*lda - exp(-2*dt*lda)*(lda*lda*(1-dt*lda)*(1-dt*lda) + dt*dt*lda*lda*lda*lda));
    covQ = 2 * stdev*stdev * dt * dt * lda * lda * lda * exp(-2*dt*lda);
     
    x[1]  ~ normal(mu, stdev);
    m_deriv = 0; 
    P_deriv = pow(stdev*lda,2);

    for (n in 2:N) {
        m = mu + A[1,1]*(x[n-1]-mu)+ A[1,2] * m_deriv;
	P = Q[1] + A[1,2] * A[1,2] * P_deriv;
        x[n] ~ normal(m, sqrt(P));
        cov = covQ + A[1,2]*A[2,2]*P_deriv;
	m_deriv = A[2,1]*(x[n-1]-mu) + A[2,2]*m_deriv  + (cov/P) * (x[n]-m);
	P_deriv = A[2,2]*A[2,2]*P_deriv + Q[2] - cov*cov/P;
    }

    lscale ~ student_t(2,0,1);
    stdev ~ student_t(2,0,1); 

    y ~ poisson_log(x);
}
