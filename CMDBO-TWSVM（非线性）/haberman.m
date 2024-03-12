clear
clc

%使用wine数据集

f = fopen("haberman.data");
data = textscan(f,'%f,%f,%f,%f');
D = [];
for i = 1:length(data)
     D= [D,data{1,i}];
end
D = sortrows(D,4);
D1 = D(:,1:3);
fclose(f);
n = size(D1,1);
D_p = D1(1:225,:);
D_n = D1(226:n,:);
N_p = D_p';
N_n = D_n';
save N_p.mat N_p;
save N_n.mat N_n;