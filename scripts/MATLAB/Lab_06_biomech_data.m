% % Set the working directory (modify the path accordingly)
% cd('~/GitHub/PhysTher5110/');
% 
% % Read the raw data
% RAW_DAT = csvread('./data/gait_example_data/DDH25_0Run01.csv', 5, 0);
% 
% % Reshape and label the FORCE data
% FORCE_DAT = RAW_DAT(:, 1:9790);
% FORCE_LABS = RAW_DAT(3:4, :);
% FORCE_LABS = FORCE_LABS.';
% FORCE_LABS = array2table(FORCE_LABS, 'VariableNames', {'level1', 'level2'});
% FORCE_LABS.level1 = fillmissing(FORCE_LABS.level1, 'previous');
% FORCE_LABS.level3 = strcat(FORCE_LABS.level1, '_', FORCE_LABS.level2);
% colnames = FORCE_LABS.level3;
% FORCE_DAT = array2table(FORCE_DAT, 'VariableNames', colnames);
% writetable(FORCE_DAT, './data/gait_example_data/force_data.csv');
% 
% % Reshape and label the MOTION data
% RAW_DAT = csvread('./data/gait_example_data/DDH25_0Run01.csv', 9797, 0);
% MOTION_DAT = RAW_DAT(:, 3:end);
% MOTION_LABS = RAW_DAT(1:2, :);
% MOTION_LABS = MOTION_LABS.';
% MOTION_LABS = array2table(MOTION_LABS, 'VariableNames', {'level1', 'level2'});
% MOTION_LABS.level1 = fillmissing(MOTION_LABS.level1, 'previous');
% MOTION_LABS.level3 = strcat(MOTION_LABS.level1, '_', MOTION_LABS.level2);
% colnames = MOTION_LABS.level3;
% MOTION_DAT = array2table(MOTION_DAT, 'VariableNames', colnames);
% writetable(MOTION_DAT, './data/gait_example_data/motion_data.csv');

FORCE_DAT = readtable('force_data.csv', 'VariableNamingRule','preserve');
MOTION_DAT = readtable('motion_data.csv', 'VariableNamingRule','preserve');

% Select and rename variables
FORCE_DAT = FORCE_DAT(:, {'Treadmill Left - Force_Fx', 'Treadmill Left - Force_Fy',...
    'Treadmill Left - CoP_Cx', 'Treadmill Left - CoP_Cy'});
FORCE_DAT.Properties.VariableNames = {'force_x', 'force_y', 'cop_x', 'cop_y'};

MOTION_DAT = MOTION_DAT(:, {'DDH25:RICAL_X', 'DDH25:RICAL_Y', 'DDH25:LICAL_X', 'DDH25:LICAL_Y'});
MOTION_DAT.Properties.VariableNames = {'right_heel_x', 'right_heel_y', 'left_heel_x', 'left_heel_y'};

% Plot the data (you can customize the plots as needed)
figure;
plot(FORCE_DAT.force_y);
title('FORCE_DAT: force_y');

figure;
plot(FORCE_DAT.force_x);
title('FORCE_DAT: force_x');

figure;
plot(FORCE_DAT.cop_y);
title('FORCE_DAT: cop_y');

figure;
plot(FORCE_DAT.cop_x);
title('FORCE_DAT: cop_x');

figure;
plot(MOTION_DAT.right_heel_x);
title('MOTION_DAT: right_heel_x');

figure;
plot(MOTION_DAT.right_heel_y);
title('MOTION_DAT: right_heel_y');

figure;
plot(MOTION_DAT.left_heel_x);
title('MOTION_DAT: left_heel_x');

figure;
plot(MOTION_DAT.left_heel_y);
title('MOTION_DAT: left_heel_y');

% Down sample the FORCE data
FORCE_DAT_DS = FORCE_DAT(1:10:end, :);

% Merge the datasets
MERGED = [MOTION_DAT, FORCE_DAT_DS];
MERGED.sample = (1:size(MERGED, 1))';

% Basic plots
% figure;
% hist(MERGED.sample);
% title('Sample Histogram');

figure;
scatter(MERGED.right_heel_y, MERGED.left_heel_y);
title('Right vs. Left Heel Position');

figure;
scatter(MERGED.force_y, MERGED.right_heel_y);
title('Force vs. Right Heel Position');
