clear
clc

%使用wine数据集

f = fopen("train_data_parkinson.data");
data = textscan(f,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f');
D = [];
for i = 1:length(data)
     D = [D,data{1,i}];
end
fclose(f);
D = sortrows(D,29);
D1 = D(:,1:28);
D_p = D1(1:520,:);
D_n = D1(521:1040,:);
% D_p = normlize(D_p);
% D_n = normlize(D_n);
N_p = D_p';
N_n = D_n';
save N_p.mat N_p ;
save N_n.mat N_n;
