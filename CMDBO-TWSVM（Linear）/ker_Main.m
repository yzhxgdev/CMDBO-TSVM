% ֧��������Matlab������C-SVC, ���������Ժ˺�����������㷨
% ʹ��ƽ̨ - Matlab7.12


close all
clear
clc

load N_p   % ��������ݣ�������Ϣ�����������
load N_n   % ��������ݣ�������Ϣ�����������

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

ker = struct('type','gauss','width',1);

% ��ز�����ʼ��
bestAccuracy=0;
k=0;
smin=-1.3;
c1min=-1.3;
smax=1.3;
c1max=1.3;
c2min=-1.3;
c2max=1.3;
aac=rand(10,1);
best_c1=0;best_c2=0;
data_train=data_train';
Y_train=Y_train';

%% �ڶ���������ѵ��Ѱ�����Ų���c1,c2
%  ��c1��c2���������������
indices = crossvalind('Kfold',Y_train,10);
tic;
for s=2^(smin):1:2^(smax)
ker.width=s;
  for c1=2^(c1min):1:2^(c1max)
     for c2=2^(c2min):1:2^(c2max)
        % ����K-CV����,��data����ƽ����ΪK��
        for run= 1:10
            test=(indices == run); train=~test; 
            
            train_data=data_train(train,:);            % ѵ�����ݼ��������ฺ��㼯�� ������Ϣȫ��������         
            train_data_label=Y_train(train,:);         % ѵ������ǩ�������ฺ��㼯�� ������Ϣȫ��������
            
            test_data=data_train(test,:);              % Ԥ�����ݼ��������ฺ��㼯�� ������Ϣȫ��������
            test_data_label=Y_train(test,:);           % Ԥ�⼯��ǩ�������ฺ��㼯�� ������Ϣȫ��������
            
            groupA=ismember(train_data_label,1);       % �ֳ�������λ��            ������Ϣȫ��������
            groupB=ismember(train_data_label,-1);      % �ֳ�������λ��            ������Ϣȫ��������
       % ����ismember�����ľ����÷����μ�help ismember
       
            A=train_data(groupA,:);                    % ����ѵ������                ������Ϣȫ��������
            B=train_data(groupB,:);   
            %��ģ��֧��������ѵ������
            [v1,v2]=twinsvm_ker_train(ker,A,B,c1,c2);      
            %��������֤��������֤,����¼��ʱ��׼ȷ��
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
        cv=sum(aac)/10;
        if (cv>bestAccuracy)
            bestAccuracy=cv;
            best_c1=c1;
            best_c2=c2;
            best_s=s;
        end
    end
  end
end
disp('׼ȷ�ʼ����Ų���');
str = sprintf( 'Best Cross Validation Accuracy = %g%%; best s= %g; Best c1 = %g; Best c2 = %g;',bestAccuracy*100,best_s,best_c1,best_c2);
disp(str);

t_train=toc


%% ��������ͨ�����Ų�������80%������ѵ�������������棬����20%��Ԥ�����ݽ���׼ȷ�ʼ���
 k=0;
 c1=best_c1;
 c2=best_c1;
 ker.width=best_s;
 data_train_p=data_train_p';                  % ѵ��������Ϣȫ���µľ������������
 data_train_n=data_train_n';                  % ѵ��������Ϣȫ���µľ������������
 data_predict=data_predict';                  % Ԥ��������Ϣȫ���µľ������������
 tic;
 [v1,v2,IB,JA]=twinsvm_ker_train(ker,data_train_p,data_train_n,c1,c2); 
 C=[data_train_p;data_train_n]';
 data_predict=ker_Gaussian(data_predict,C,ker);
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
    if Y_predict(run1)==result(run1)       % Ԥ��׼ȷ�ȼ���
       k=k+1;
    end
 end
 aac=k/n;
 t_predict=toc
 disp('Ԥ��׼ȷ�ʽ��');
 str = sprintf( 'Accuracy =%g%% ',aac*100);
 disp(str);

