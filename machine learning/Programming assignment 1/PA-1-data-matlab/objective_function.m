function [ tr ] = objective_function( y,a,theta )

%   Detailed explanation goes here

b=abs(y-a'*theta);
tr=b.^2;
end

