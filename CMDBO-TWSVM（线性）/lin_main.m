% 支持向量机Matlab工具箱C-SVC, 孪生线性核函数二类分类算法
% 使用平台 - Matlab7.12


close all
clear
clc
num = 5
arr=zeros(num,1);

load N_p   % 正类点数据，特征信息存放在列里面
load N_n   % 负类点数据，特征信息存放在列里面

 

for i=1:num

    %% 第一步：数据预处理
% 由原来的数据产生80%的训练数据和20%的预测数据
n_p=size(N_p,2);
n_n=size(N_n,2);
n1=randperm(n_p);      % 对1到n的n个正整数进行随机不重复的排列，形成一个1行n列的矩阵
n1=n1';
n2=randperm(n_n);
n2=n2';
f_p=floor(4*n_p/5);    % 取80%的数据作为训练集，其余20%作为预测集
f_n=floor(4*n_n/5); 
data_train_p=N_p(:,n1(1:f_p));                  % 正类训练数据
data_train_n=N_n(:,n2(1:f_n));                  % 负类训练数据
data_train=[data_train_p,data_train_n];         % 训练数据集（含正负类）
Y_train=[ones(1,f_p),-ones(1,f_n)];             % 训练数据标签集 

data_predict_p=N_p(:,n1(f_p+1:end));            % 正类预测数据
data_predict_n=N_n(:,n2(f_n+1:end));            % 负类预测数据
data_predict=[data_predict_p,data_predict_n];   % 预测数据集（含正负类）
Y_predict=[ones(1,n_p-f_p),-ones(1,n_n-f_n)];   % 预测数据标签集 

% 相关参数初始化
bestAccuracy=0;
k=0;
c1min=-2;
c1max=2;
c2min=-2;
c2max=2;
best_c1=0;best_c2=0;
data_train=data_train';
Y_train=Y_train';
    data_train_p=data_train_p';                  % 训练数据信息全在列里面了
    data_train_n=data_train_n';                  % 训练数据信息全在列里面了
    data_predict=data_predict';                  % 预测数据信息全在列里面了

    aac=rand(10,1);
    %% 第二步：数据训练寻找最优参数c1,c2
    %  将c1和c2划分网格进行搜索
    indices = crossvalind('Kfold',Y_train,10);    
    tic;
    for c1=2^(c1min):1:2^(c1max)
        for c2=2^(c2min):1:2^(c2max)
            %采用K-CV方法,将data大致平均分为K组
            for run= 1:10
                test=(indices == run); train=~test; 
                
                train_data=data_train(train,:);            % 训练数据集（含正类负类点集） 数据信息全在行里面         
                train_data_label=Y_train(train,:);         % 训练集标签（含正类负类点集） 数据信息全在行里面
                
                test_data=data_train(test,:);              % 预测数据集（含正类负类点集） 数据信息全在行里面
                test_data_label=Y_train(test,:);           % 预测集标签（含正类负类点集） 数据信息全在行里面
                
                groupA=ismember(train_data_label,1);       % 分出正类点的位置            数据信息全在行里面
                groupB=ismember(train_data_label,-1);      % 分出正类点的位置            数据信息全在行里面
           % 关于ismember函数的具体用法，使用help ismember可以进一步了解
           
                A=train_data(groupA,:);                    % 正类训练数据                数据信息全在行里面
                B=train_data(groupB,:);   
                %用模糊支持向量机训练数据
                [v1,v2]=twinsvm_lin_train(A,B,c1,c2);      
                 %下面用验证集进行验证,并记录此时的准确率
                row=size(test_data,1);
                result=rand(row,1);
                test_data1=[test_data,ones(row,1)];
                distance1=abs(test_data1*v1);
                distance2=abs(test_data1*v2);
                test_distance=min(distance1,distance2);
                for run1=1:row
                    if test_distance(run1)==distance1(run1)
                        result(run1)=1;
                    else
                        result(run1)=-1;
                    end
                end
              for run1=1:row
                  if test_data_label(run1)==result(run1)
                      k=k+1;
                  end
              end
              aac(run)=k/row;
              k=0;
            end
            cv=sum(aac)/10;
            if (cv>bestAccuracy)
                bestAccuracy=cv;
                best_c1=c1;
                best_c2=c2;
            end
        end
    end
    disp('准确率及最优参数');
    str = sprintf( 'Best Cross Validation Accuracy = %g%% ;Best c1 = %g ; Best c2 = %g;',bestAccuracy*100,best_c1,best_c2);
    disp(str);
    t_train=toc
    
    
    
    c1=best_c1;
    c2=best_c2;

        %% 第三步：通过最优参数，对80%的数据训练，产生分类面，利用20%的预测数据进行准确率计算
        k=0;
        tic;
        [v1,v2,IB,JA]=twinsvm_lin_train(data_train_p,data_train_n,c1,c2); 
        n=size(data_predict,1);
        result=rand(n,1);
        test_data1=[data_predict,ones(n,1)];
        distance1=abs(test_data1*v1);           % 靠近正类点所在平面的预测结果
        distance2=abs(test_data1*v2);           % 靠近负类点所在平面的预测结果
        test_distance=min(distance1,distance2);
        for run1=1:n
           if test_distance(run1)==distance1(run1)
              result(run1)=1;                     % 将预测结果转化为标记为1与-1的预测结果
           else
              result(run1)=-1;                    % 将预测结果转化为标记为1与-1的预测结果
           end
        end
        for run1=1:n
          if Y_predict(run1)==result(run1)        % 预测准确度计算
              k=k+1;
          end
        end
        arr(i)=k/n;
        t_predict=toc
end
    arr_int = sum(arr)/num;
    disp('预测准确率结果');
    str = sprintf( 'Accuracy =%g%% ',arr_int*100);
    disp(str);

%% 第四步：绘图
tic;
% 绘制训练点
plot(data_train_p(:,1),data_train_p(:,2),'c+',data_train_n(:,1),data_train_n(:,2),'mx'); 
title('线性孪生支持向量机')
hold on
grid on
% 绘制预测点
plot(data_predict_p(1,:),data_predict_p(2,:),'g>',data_predict_n(1,:),data_predict_n(2,:),'r<');
% 绘制支持向量
plot(data_train_n(IB,1),data_train_n(IB,2),'ko',data_train_p(JA,1),data_train_p(JA,2),'ko');

%标示出错分的点
for run=1:row
    if Y_predict(run)~=result(run)
        plot(test_data1(run,1),test_data1(run,2),'ko')
        hold on
    end
end
%绘制分类面的图像

plotpc(v1(1:2,:)',v1(3))
plotpc(v2(1:2,:)',v2(3))
legend('正类训练点','负类训练点','正类预测点','负类预测点','支持向量');
t_picture=toc
hold off



            
            
            
            
