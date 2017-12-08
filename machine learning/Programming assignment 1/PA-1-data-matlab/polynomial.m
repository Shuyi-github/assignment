clear;
load('poly_data.mat')

%    [sampx,index]=datasample(sampx,25);
%    sampy=sampy(index,1);
% sampx=[sampx,-1.5,-1,0,1,1.5];
% sampy=[sampy;25;-15;-10;10;25];

a=sampx';
lamda=5;
k=5;
noise=5;
r_samp=size(sampx,1);   % row 1
c_samp=size(sampx,2);   % column 50
M(1,1)=1;
%MX=zeros(6,50);

for j=1:c_samp
%     MX(:,j)=M'; 
for i=1:k
    temp=sampx(1,j)^i;
   M(1,i+1)=temp;       %Matrix M is phi(x)
end
MX(:,j)=M'; 
% disp(M');
end

% for least-squares
thetals=inv(MX*MX')*MX*sampy;
ls_result=predictive(thetals,polyx,k);
ls_s_result=predictive(thetals,sort(sampx),k);
error_LS=immse(ls_result, polyy);
hold on
plot(polyx,ls_result,'b');
% plot(x,sampx,'y',y,sampy,'g');
% plot(obj,'g');
plot(sort(sampx),ls_s_result,'r');
plot(sampx,sampy,'.');
% plot(polyx,polyy,'g');
legend('true function','estimated function with sample','sample data')
title('Least-squares')
hold off
% disp(s);

% for regularized LS
I=eye(k+1);
% lamda=2;
thetarls=inv(MX*MX'+lamda*I)*MX*sampy;
rls_result=predictive(thetarls,polyx,k);
rls_s_result=predictive(thetals,sort(sampx),k);
error_RLS=immse(rls_result, polyy);
figure;
hold on;
plot(polyx,rls_result,'b',sampx,sampy,'.',sort(sampx),rls_s_result,'r');
% plot(polyx,polyy,'r');
legend('true function','sample data','estimated function with sample')
title('regularized LS')
hold off;

% for L1-regularized LS
K=2*(k+1);
I1=ones(K,1);
I2=ones(K,K)
h=[MX*MX',(-1)*(MX*MX');(-1)*(MX*MX'),MX*MX'];
f=(lamda)*I1-[MX*sampy;(-1)*MX*sampy];
lb=[0;0];
A1=(-1)*I2;
theta=quadprog(h,f,A1,zeros(K,1),[],[],zeros(K,1),[]);
thetalasso=zeros(k+1,1);
thetalasso=theta(1:k+1,:)-theta(k+2:K,:);
lasso_result=predictive(thetalasso,polyx,k);
lasso_s_result=predictive(thetalasso,sort(sampx),k);
error_lasso=immse(lasso_result, polyy);
figure;
plot(polyx,lasso_result,'b',sampx,sampy,'.',sort(sampx),lasso_s_result,'r');
legend('true function','sample data','estimated function with sample')
title('Lasso')
% for robust regression
In=eye(c_samp);
f_rs=[zeros(k+1,1);ones(c_samp,1)];
A=[-MX',(-1)*In;MX',(-1)*In];
b=[-sampy;sampy];
x= linprog(f_rs,A,b);
thetars=x(1:k+1,1);
rr_result=predictive(thetars,polyx,k);
rr_s_result=predictive(thetars,sort(sampx),k);
error_RS = immse(rr_result, polyy); % mean-squared error
figure;
hold on;
plot(sort(sampx),rr_s_result,'r',sampx,sampy,'.');
% plot(polyx,rs_result,'b',sampx,sampy,'.');
plot(polyx,rr_result,'b');
legend('estimated function with sample','sample data','true function')
title('robust regression')
hold off;

% for Bayesian regression

I100=eye(100);
sigma_es=(I*(5^(-1))+(noise)^(-1)*MX*MX')^(-1);
mu_es=(noise)^(-1)*(sigma_es*MX*sampy);

mu_pred=predictive(mu_es,polyx,k);
sigma_pred=(predictive(sigma_es,polyx,k))*((predictive(1,polyx,k))');

mu_s_pred=predictive(mu_es,sort(sampx),k);
sigma_s_pred=predictive(sigma_es,sort(sampx),k)*((predictive(1,sort(sampx),k))');

std_poly=(mu_pred);
std_samp=(mu_s_pred);
error_BR=immse(mu_pred,polyy); % mean-squared error
figure;
hold on;
plot(sort(sampx),mu_s_pred,'b',polyx,mu_pred,'r',sampx,sampy,'.');
plot(polyx,std_poly,'g',sort(sampx),std_samp,'y');
legend('sample as inputs','polyx as inputs','sample','standard deviation for sample','standard deviation for polyx');
title('Bayesian regression')
hold off;


