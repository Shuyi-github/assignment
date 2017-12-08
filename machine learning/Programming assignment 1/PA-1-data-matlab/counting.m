clear;
load('count_data.mat')
% trainx=[trainx;trainx.^2];
% testx=[testx;testx.^2];
lamda=5;
r_train=size(trainx,1);   % get the row&colomn size of this matrix
c_train=size(trainx,2);
k=r_train;

MX=trainx;
[r,c]=size(MX);

thetals=(MX*MX')^(-1)*MX*trainy;
ls_result=predictive2(thetals,testx);
%ls_s_result=predictive(thetals,trainx,k);
mse_LS=immse(ls_result, testy);
mae_LS=mae(ls_result,testy);
hold on
plot(ls_result,'r')
plot(testy,'b');
legend('predict count','true count')
title('Least-squares')
hold off

I=eye(r); %
% lamda=2;
thetarls=inv(MX*MX'+lamda*I)*MX*trainy;
rls_result=predictive2(thetarls,testx);
%rls_s_result=predictive(thetals,sort(sampx),k);
mse_RLS=immse(rls_result, testy);
mae_RLS=mae(ls_result,testy);
figure;
hold on;
plot(rls_result,'r');
plot(testy,'b');
legend('predict count','true count')
title('regularized LS')
hold off;

%  for L1-regularized LS
K=2*(k+1);
I1=ones(2*(r_train),1);
h=[MX*MX',(-1)*(MX*MX');(-1)*(MX*MX'),MX*MX'];
f=(lamda)*I1-[MX*trainy;(-1)*MX*trainy];
theta=quadprog(h,f,[],[],[],[],zeros(K,1),[]);
thetalasso=theta(1:k,:)-theta(k+1:2*k,:);
lasso_result=predictive2(thetalasso,testx);
mse_lasso=immse(lasso_result, testy);
mae_lasso=mae(lasso_result,testy);
figure;
hold on;
plot(lasso_result,'r');
plot(testy,'b');
legend('predict count','true count')
title('L1-regularized LS')
hold off;


% for robust regression
In=eye(400);
f_rs=[zeros(r,1);ones(c,1)];
A=[-MX',(-1)*In;MX',(-1)*In];
b=[-trainy;trainy];
x= linprog(f_rs,A,b);
thetars=x(1:r,1);
rr_result=predictive2(thetars,testx);
mse_RR = immse(rr_result, testy); % mean-squared error
mae_RR=mae(rr_result,testy);
figure;
hold on;
plot(rr_result,'r');
plot(testy,'b');
legend('predict count','true count')
title('robust regression')
hold off;

% for Bayesian regression
%variance=mean(sampx(:));

I100=eye(100);
sigma_es=(I*(5^(-1))+(5)^(-1)*MX*MX')^(-1);
mu_es=(5)^(-1)*(sigma_es*MX*trainy);

mu_pred=predictive2(mu_es,testx);
mse_BR=immse(mu_pred,testy); % mean-squared error
mae_BR=mae(mu_pred,testy);
figure;
hold on;
plot(mu_pred,'r')
plot(testy,'b')
legend('predict count','true count')
title('Bayesian regression')
hold off;
