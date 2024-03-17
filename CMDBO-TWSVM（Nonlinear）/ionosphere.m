clear
clc

%使用wine数据集

f = fopen("ionosphere.data");
data = textscan(f,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%s');
D = [];
for i = 1:length(data)-1
     D= [D,data{1,i}];
end
fclose(f);
n = size(D,1);
D_p = D(1:126,:);
D_n = D(127:n,:);
N_p = D_p';
N_n = D_n';
save N_p.mat N_p;
save N_n.mat N_n;
