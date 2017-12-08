
function [ f ] = predictive( t,x,k)
% use polyx as input in predictive funciton
load('poly_data.mat')
%x_r=size(x,1);  %polyx r
x_c=size(x,2);  %polyx 100

for j=1:x_c
for i=0:k
    temp=x(1,j)^i;
    N(1,i+1)=temp;      
end
M(j,:)=N;
end
% f=M;
f=M*t;
end

