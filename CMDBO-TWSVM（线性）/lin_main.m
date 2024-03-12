% ֧��������Matlab������C-SVC, �������Ժ˺�����������㷨
% ʹ��ƽ̨ - Matlab7.12


close all
clear
clc
num = 5
arr=zeros(num,1);

load N_p   % ��������ݣ�������Ϣ�����������
load N_n   % ��������ݣ�������Ϣ�����������

 

for i=1:num

    %% ��һ��������Ԥ����
% ��ԭ�������ݲ���80%��ѵ�����ݺ�20%��Ԥ������
n_p=size(N_p,2);
n_n=size(N_n,2);
n1=randperm(n_p);      % ��1��n��n������������������ظ������У��γ�һ��1��n�еľ���
n1=n1';
n2=randperm(n_n);
n2=n2';
f_p=floor(4*n_p/5);    % ȡ80%��������Ϊѵ����������20%��ΪԤ�⼯
f_n=floor(4*n_n/5); 
data_train_p=N_p(:,n1(1:f_p));                  % ����ѵ������
data_train_n=N_n(:,n2(1:f_n));                  % ����ѵ������
data_train=[data_train_p,data_train_n];         % ѵ�����ݼ����������ࣩ
Y_train=[ones(1,f_p),-ones(1,f_n)];             % ѵ�����ݱ�ǩ�� 

data_predict_p=N_p(:,n1(f_p+1:end));            % ����Ԥ������
data_predict_n=N_n(:,n2(f_n+1:end));            % ����Ԥ������
data_predict=[data_predict_p,data_predict_n];   % Ԥ�����ݼ����������ࣩ
Y_predict=[ones(1,n_p-f_p),-ones(1,n_n-f_n)];   % Ԥ�����ݱ�ǩ�� 

% ��ز�����ʼ��
bestAccuracy=0;
k=0;
c1min=-2;
c1max=2;
c2min=-2;
c2max=2;
best_c1=0;best_c2=0;
data_train=data_train';
Y_train=Y_train';
    data_train_p=data_train_p';                  % ѵ��������Ϣȫ����������
    data_train_n=data_train_n';                  % ѵ��������Ϣȫ����������
    data_predict=data_predict';                  % Ԥ��������Ϣȫ����������

    aac=rand(10,1);
    %% �ڶ���������ѵ��Ѱ�����Ų���c1,c2
    %  ��c1��c2���������������
    indices = crossvalind('Kfold',Y_train,10);    
    tic;
    for c1=2^(c1min):1:2^(c1max)
        for c2=2^(c2min):1:2^(c2max)
            %����K-CV����,��data����ƽ����ΪK��
            for run= 1:10
                test=(indices == run); train=~test; 
                
                train_data=data_train(train,:);            % ѵ�����ݼ��������ฺ��㼯�� ������Ϣȫ��������         
                train_data_label=Y_train(train,:);         % ѵ������ǩ�������ฺ��㼯�� ������Ϣȫ��������
                
                test_data=data_train(test,:);              % Ԥ�����ݼ��������ฺ��㼯�� ������Ϣȫ��������
                test_data_label=Y_train(test,:);           % Ԥ�⼯��ǩ�������ฺ��㼯�� ������Ϣȫ��������
                
                groupA=ismember(train_data_label,1);       % �ֳ�������λ��            ������Ϣȫ��������
                groupB=ismember(train_data_label,-1);      % �ֳ�������λ��            ������Ϣȫ��������
           % ����ismember�����ľ����÷���ʹ��help ismember���Խ�һ���˽�
           
                A=train_data(groupA,:);                    % ����ѵ������                ������Ϣȫ��������
                B=train_data(groupB,:);   
                %��ģ��֧��������ѵ������
                [v1,v2]=twinsvm_lin_train(A,B,c1,c2);      
                 %��������֤��������֤,����¼��ʱ��׼ȷ��
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
    disp('׼ȷ�ʼ����Ų���');
    str = sprintf( 'Best Cross Validation Accuracy = %g%% ;Best c1 = %g ; Best c2 = %g;',bestAccuracy*100,best_c1,best_c2);
    disp(str);
    t_train=toc
    
    
    
    c1=best_c1;
    c2=best_c2;

        %% ��������ͨ�����Ų�������80%������ѵ�������������棬����20%��Ԥ�����ݽ���׼ȷ�ʼ���
        k=0;
        tic;
        [v1,v2,IB,JA]=twinsvm_lin_train(data_train_p,data_train_n,c1,c2); 
        n=size(data_predict,1);
        result=rand(n,1);
        test_data1=[data_predict,ones(n,1)];
        distance1=abs(test_data1*v1);           % �������������ƽ���Ԥ����
        distance2=abs(test_data1*v2);           % �������������ƽ���Ԥ����
        test_distance=min(distance1,distance2);
        for run1=1:n
           if test_distance(run1)==distance1(run1)
              result(run1)=1;                     % ��Ԥ����ת��Ϊ���Ϊ1��-1��Ԥ����
           else
              result(run1)=-1;                    % ��Ԥ����ת��Ϊ���Ϊ1��-1��Ԥ����
           end
        end
        for run1=1:n
          if Y_predict(run1)==result(run1)        % Ԥ��׼ȷ�ȼ���
              k=k+1;
          end
        end
        arr(i)=k/n;
        t_predict=toc
end
    arr_int = sum(arr)/num;
    disp('Ԥ��׼ȷ�ʽ��');
    str = sprintf( 'Accuracy =%g%% ',arr_int*100);
    disp(str);

%% ���Ĳ�����ͼ
tic;
% ����ѵ����
plot(data_train_p(:,1),data_train_p(:,2),'c+',data_train_n(:,1),data_train_n(:,2),'mx'); 
title('��������֧��������')
hold on
grid on
% ����Ԥ���
plot(data_predict_p(1,:),data_predict_p(2,:),'g>',data_predict_n(1,:),data_predict_n(2,:),'r<');
% ����֧������
plot(data_train_n(IB,1),data_train_n(IB,2),'ko',data_train_p(JA,1),data_train_p(JA,2),'ko');

%��ʾ����ֵĵ�
for run=1:row
    if Y_predict(run)~=result(run)
        plot(test_data1(run,1),test_data1(run,2),'ko')
        hold on
    end
end
%���Ʒ������ͼ��

plotpc(v1(1:2,:)',v1(3))
plotpc(v2(1:2,:)',v2(3))
legend('����ѵ����','����ѵ����','����Ԥ���','����Ԥ���','֧������');
t_picture=toc
hold off



            
            
            
            
