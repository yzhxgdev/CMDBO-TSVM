function [ H] = ker_Gaussian(A,B,ker)
%% 高斯核函数
% ker_Gaussian(A,B,ker)的计算
s=ker.width;
m=size(A,1);n=size(B,2);
H=rand(m,n);
for i=1:m
    for j=1:n
        H(i,j)=exp(-s*norm(A(i,:)'-B(:,j))^2);
    end
end
end

