function [X_norm] = normlize(data)
[m,n] = size(data); 
X_norm = zeros(size(data));
for i = 1:n
col_min = min(data(:,i));
col_max = max(data(:,i));
X_norm(:,i) = (data(:,i) - col_min) / (col_max - col_min);
end