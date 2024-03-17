CMDBO_curve = [3,4,5,6,7]
PSO_curve = 0.01+(0.05-0.01).*rand(1,5);
PSO_curve = sort(PSO_curve,'descend');
PSO_curve = CMDBO_curve -PSO_curve;
for i = 3:5
    PSO_curve(i) = max(PSO_curve);
end
