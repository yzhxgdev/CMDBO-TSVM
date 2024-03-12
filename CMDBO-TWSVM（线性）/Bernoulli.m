clear;
clc;

%% Bernoulli
y_4=zeros(1,10^5);
y_4(1)= 0.152;   
lambda = 0.4;
for i = 1 : 10^5-1   
       if (y_4(i)<=(1-lambda)) && ((y_4(i)>0))
          y_4(i+1) = y_4(i)/(1-lambda);
       else 
          y_4(i+1)=(y_4(i)-1+lambda)/lambda;
       end    
end

%% 画图

% subplot(3,4,4)
h4=histogram(y_4,200);
h4.FaceColor=[0 0 1];
xlim([0,1])%设置x轴范围
xlabel('Bernoulli map')


