function [best_c1,best_c2]=Pso(data_train,Y_train)

E=0.00000000001;
maxnum=100;%最大迭代次数
narvs=2;%目标函数的自变量个数
particlesize=30;%粒子群规模
c1=1;%每个粒子的个体学习因子，加速度常数
c2=2;%每个粒子的社会学习因子，加速度常数
w = 0.6;
w1=1;%最大惯性因子
w2=0.1;%最小惯性因子
vmax=1;%粒子的最大飞翔速度
v=2*rand(particlesize,narvs);%粒子飞翔速度
x=4*rand(particlesize,narvs);%粒子所在位置
x1 = x;  %蜣螂更新的上一次位置


%定义适应度函数
for i=1:particlesize
	f(i)=fitness(data_train,Y_train,x(i,1),x(i,2));	
end
personalbest_x=x;
personalbest_faval=f;
[globalbest_faval,i]=min(personalbest_faval);
[globalbad_faval,j]=max(personalbest_faval);
globalbad_x = personalbest_x(j,:)
globalbest_x=personalbest_x(i,:); 
k=1;
sita = rand();
yita = rand();
lamda = 0.2;
b = 0.5;%0到1之间的一个常数
key = 0.1 ;%蜣螂前进的偏转系数
while (k<=maxnum)
	for i=1:particlesize
        if i<=6  %滚球蜣螂更新
            if sita<0.9     %执行无障碍滚球
                if yita>0.2   %方向无偏离
                    a = 1;
                else 
                    a = -1;
                end
                xtemp(i,:)=x(i,:);
                x1(i,:) = xtemp(i,:);
                x(i,:)=x(i,:)+a*k*x1(i,:)+b*abs(x(i,:)-globalbad_x);
            else            %执行有障碍滚球
                R = 180*rand();
                if R==0 || R==90 ||R==180 
                    x(i,:)=x(i,:)+tand(R)*abs(x(i,:)-x1(i,:))
                end
            end
        end
        if i>6&&i<=12       %蜣螂繁殖
            R = 1-k/maxnum;
            Lb = globalbest_x;
            Ub = globalbest_x;
            b1 = rand(1,2);
            b2 = rand(1,2);
            x(i,:) = globalbest_x + b1.*(x(i,:)-Lb) +b2.*(x(i,:)-Ub);
            for num=1:narvs
                if x(i,:)>Ub
                    x(i,:) = Ub;
                end
                if x(i,:)<Lb
                    x(i,:) = Lb;
                end
            end
        end
        if i>12&&i<=19       %蜣螂觅食
            R = 1-k/maxnum;
            Lb = personalbest_x(i,:);
            Ub =personalbest_x(i,:);
            c1 = randn;
            c2 = rand(1,2);
            x(i,:) = x(i,:) + c1*(x(i,:)-Lb) +c2.*(x(i,:)-Ub);
        end
        if 19<i<=particlesize
            S = 0.5;
            g = randn(1,2);
            x(i,:) = personalbest_x(i,:) +S*g.*(abs(x(i,:)-globalbest_x)+abs(x(i,:)-personalbest_x(i,:)))
        end
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

    disp('迭代次数为：');
    k
	k=k+1;
   
    ff(k)=globalbest_faval;
    if globalbest_faval<E
        break
    end
    
end
xbest=globalbest_x;
best_c1=xbest(1)
best_c2=xbest(2)

figure(2)
set(gcf,'color','white');
plot(1:length(ff),ff)