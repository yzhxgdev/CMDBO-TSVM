function [fmin,xbest,Convergence_curve]=PSO(data_train,Y_train,SearchAgents_no,Max_iteration,lb,ub,dim,fobj)

E=0.000001;
maxnum=Max_iteration;%最大迭代次数
narvs=dim;%目标函数的自变量个数
particlesize=SearchAgents_no;%粒子群规模
c1=2;%每个粒子的个体学习因子，加速度常数
c2=2;%每个粒子的社会学习因子，加速度常数
w = 0.6;
w1=1;%最大惯性因子
w2=0.1;%最小惯性因子
vmax=1;%粒子的最大飞翔速度
v=2*rand(particlesize,narvs);%粒子飞翔速度
x=4*rand(particlesize,narvs);%粒子所在位置



%定义适应度函数
for i=1:particlesize
	f(i)=fitness(data_train,Y_train,x(i,1),x(i,2));	
end
personalbest_x=x;
personalbest_faval=f;
[globalbest_faval,i]=min(personalbest_faval);
globalbest_x=personalbest_x(i,:); 
k=1;
while (k<=maxnum)
	for i=1:particlesize
        w=w1-(w1-w2)*k/maxnum;
		v(i,:)=w*v(i,:)+c1*rand*(personalbest_x(i,:)-x(i,:))...
			+c2*rand*(globalbest_x-x(i,:));
		for j=1:narvs
			if v(i,j)>vmax
				v(i,j)=vmax;
			elseif v(i,j)<-vmax
				v(i,j)=-vmax;
            end
		end
		x(i,:)=x(i,:)+v(i,:);
 
    end
   
    for i= 1:particlesize
        figure(1)
        plot(x(i,1),x(i,2),'*')
        hold on;
    end
    hold off;

    for i=1:particlesize            %每迭代一次更新个体最优适应值
			f(i)=fitness(data_train,Y_train,x(i,1),x(i,2));
		if f(i)<personalbest_faval(i)
			personalbest_faval(i)=f(i);
			personalbest_x(i,:)=x(i,:);
		end
	end
	[globalbest_faval,i]=min(personalbest_faval);
	globalbest_x=personalbest_x(i,:);

    
   
    ff(k)=1-globalbest_faval;
    Convergence_curve(k)=ff(k);
%     if globalbest_faval<E
%         break
%     end
    disp('迭代次数为：');
    k
	k=k+1;
end
xbest=globalbest_x;
fmin = 1-globalbest_faval;

% figure(2)
% set(gcf,'color','white');
% plot(1:length(ff),ff)