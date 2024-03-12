clear
clc

%使用wine数据集

f = fopen("statlog.data");
data = textscan(f,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f');
D = [];
for i = 1:length(data)
     D= [D,data{1,i}];
end
D = sortrows(D,14);
D1 = D(:,1:12);
fclose(f);
n = size(D1,1);
D_p = D1(1:150,:);
D_n = D1(151:n,:);
N_p = D_p';
N_n = D_n';
save N_p.mat N_p;
save N_n.mat N_n;
