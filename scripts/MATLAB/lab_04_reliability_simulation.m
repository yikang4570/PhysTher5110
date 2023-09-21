% Generate random population data
rng(1); % Set random seed for reproducibility
pop = rand(10000, 1) * 19 + 1;

k = 1000;
n = 10;

means = NaN(k, 1);
sds = NaN(k, 1);
count = NaN(k, 1);

for i = 1:k
    samp = datasample(pop, n, 'Replace', true);
    
    means(i) = mean(samp);
    sds(i) = std(samp);
    count(i) = numel(samp);
end

SIMS = table(means, sds, count);

% Create a histogram
figure;
histogram(SIMS.means, 30, 'EdgeColor', 'black', 'FaceColor', '#56B4E9');
xlabel('Distribution of Sample Means');
xlim([0, 20]);

% Generate data
x = 0:0.1:2*pi;
y = 2 * sin(x);

% Calculate variance
variance_y = var(y);
disp(variance_y);

% Create a line plot
figure;
plot(x, y);
xlabel('X Variable');
ylabel('Y Variable');

% Simulate data with noise
rng(10); % Set random seed for reproducibility
e1 = randn(size(x));
y1 = 2 * sin(x) + e1;

e2 = randn(size(x));
y2 = 2 * sin(x) + e2;

DAT2 = table(x', y1', y2', 'VariableNames', {'x', 'y1', 'y2'});

% Calculate mean of y1 and y2
DAT2.mean_y = mean([DAT2.y1, DAT2.y2], 2);

% Display the head of DAT2
disp(head(DAT2));

% Loop through columns and calculate ACE and RMSE
iter_colnames = DAT2.Properties.VariableNames(2:end);
iter = cell(1, numel(iter_colnames));
ace = NaN(1, numel(iter_colnames));
rmse = NaN(1, numel(iter_colnames));

for i = 1:numel(iter_colnames)
    colname = iter_colnames{i};
    disp(colname);
    
    y_hat = 2 * sin(DAT2.x);
    iter{i} = colname;
    ace(i) = sum(DAT2.(colname) - y_hat) / length(y_hat);
    rmse(i) = sqrt(sum((DAT2.(colname) - y_hat).^2) / length(y_hat));
end

SIM_DAT = table(iter', ace', rmse', 'VariableNames', {'iteration', 'ace', 'rmse'});
disp(SIM_DAT);

% Reshape DAT2 for plotting
DAT2_LONG = stack(DAT2, iter_colnames, 'NewDataVariableName','y_val',...
    'IndexVariableName','iteration');
% DAT2_LONG.Properties.VariableNames{'NewDataVariableName'} = 'iteration';
% DAT2_LONG.Properties.VariableNames{'IndexVariableName'} = 'y_val';

% Sort the data
DAT2_LONG = sortrows(DAT2_LONG, {'iteration', 'x'});

% Create a color palette for plotting
% cbPalette = {'#000000', '#E69F00', '#56B4E9', '#009E73', '#F0E442', '#0072B2', '#D55E00', '#CC79A7'};

% Plot the data
figure;
gscatter(DAT2_LONG.x, DAT2_LONG.y_val, DAT2_LONG.iteration, cbPalette, '.', 10);
xlabel('X Variable');
ylabel('Y Variable');
lgd = legend('Location', 'southoutside', 'Orientation', 'horizontal');
title(lgd, 'Iteration');