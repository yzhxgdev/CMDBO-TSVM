function y=fitness(data_train,Y_train,c1,c2,s,ker)

%  交叉验证
num = 5;%交叉验证划分的个数
indices = crossvalind('Kfold',Y_train,5);
k=0;
tic;
%采用K-CV方法,将data大致平均分为K组
for run=1:num
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
    %用pso算法寻找最优参数
    ker.width = s;
    [v1,v2]=twinsvm_ker_train(ker,A,B,c1,c2);      
     %下面用验证集进行验证,并记录此时的准确率
    C=[A;B]';
    test_data=ker_Gaussian(test_data,C,ker);
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
acc = sum(aac)/num
y=1-acc;