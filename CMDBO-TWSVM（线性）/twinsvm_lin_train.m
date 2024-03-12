%% 双支持向量分类机训练函数
function [v1,v2,IB,JA]=twinsvm_lin_train(A,B,c1,c2)
%% 线性孪生支持向量机的训练函数
%% IB、JA分别是用来寻找支持向量所对应的下标
lower=1e-5;
q=size(A,1);S=size(B,1);
e1=ones(q,1);e2=ones(S,1); 


% 计算H,G
H=[A,e1];
G=[B,e2];
Q=G*inv(H'*H+0.05*eye(size(H'*H,1)))*G';
Q1=inv(H'*H+0.05*eye(size(H'*H,1)))*G';
% 产生矩阵f
f=-e2;
% 变量限制
lb=zeros(S,1);
ub=c1*ones(S,1);
% 产生初始点x0
x0=zeros(S,1);
% 求最优解x
[x,fval,exitflag]=quadprog(Q,f,[],[],[],[],lb,ub,x0);
v1=-Q1*x;
% 根据孪生支持向量机的要求，寻找支持向量下标（B类数据的下标）
[m,n]=size(x);
IB=rand(m,n);
run=max(m,n);
for i=1:run
    if (x(i)>lower&&x(i)<c1)
        IB(i)=1;
    else
        IB(i)=0;
    end
end
IB=find(IB>0);


% 计算H,G
G=[A,e1];
H=[B,e2];
Q=G*inv(H'*H+0.05*eye(size(H'*H,1)))*G';
Q1=inv(H'*H+0.05*eye(size(H'*H,1)))*G';
% 产生矩阵f
f=-e1;
% 变量限制
lb=zeros(q,1);
ub=c2*ones(q,1);
% 产生初始点x0
x0=zeros(q,1);
% 求最优解x
[x,fval,exitflag]=quadprog(Q,f,[],[],[],[],lb,ub,x0);
v2=-Q1*x;
% 根据孪生支持向量机的要求，寻找支持向量下标（A类数据的下标）
[m,n]=size(x);
JA=rand(m,n);
run=max(m,n);
for i=1:run
    if (x(i)>lower&&x(i)<c2)
        JA(i)=1;
    else
        JA(i)=0;
    end
end
JA=find(JA>0);





