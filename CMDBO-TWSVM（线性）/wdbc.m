clear
clc

%使用wine数据集

f = fopen("wdbc.data");
data = textscan(f,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%s');
D = [];
for i = 1:length(data)-1
     D = [D,data{1,i}];
end
fclose(f);
D_p = D(1:357,:);
D_n = D(358:569,:);
% D_p = normlize(D_p);
% D_n = normlize(D_n);
N_p = D_p';
N_n = D_n';
save N_p.mat N_p ;
save N_n.mat N_n;
