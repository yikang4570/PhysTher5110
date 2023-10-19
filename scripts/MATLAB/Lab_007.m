%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% MSP Instrumentation Lab 07: Data visualization
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% load data
data_ANSCOMBE = readtable('data_ANSCOMBE.csv', 'VariableNamingRule','preserve');
data_CI_ERRORS = readtable('data_CI_ERRORS.csv', 'VariableNamingRule','preserve');
data_FINAL_RATINGS = readtable('data_FINAL_RATINGS.csv', 'VariableNamingRule','preserve');
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% scatter plots/regressions from slide 3:
figure; hold on;
subplot(221); plot(data_ANSCOMBE.xVal(1:11), data_ANSCOMBE.yVal(1:11), 'ro');xlim([0,20]); ylim([0,15])
subplot(222); plot(data_ANSCOMBE.xVal(12:22), data_ANSCOMBE.yVal(12:22), 'go');xlim([0,20]); ylim([0,15])
subplot(223); plot(data_ANSCOMBE.xVal(23:33), data_ANSCOMBE.yVal(23:33), 'bo');xlim([0,20]); ylim([0,15])
subplot(224); plot(data_ANSCOMBE.xVal(34:end), data_ANSCOMBE.yVal(34:end), 'mo');xlim([0,20]); ylim([0,15])
%
% linear regression fit (just duplicate this snipped with updated variable
% names and indices to do the regressions for the other subplots)
mdl1 = fitlm(data_ANSCOMBE.xVal(1:11), data_ANSCOMBE.yVal(1:11))
subplot(221); hold on; plot(data_ANSCOMBE.xVal(1:11), ...
    (mdl1.Coefficients.Estimate(2)*data_ANSCOMBE.xVal(1:11)+...
    mdl1.Coefficients.Estimate(1)),'r-');
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% boxplot with overlays from slide 11:
%
% create a grouping variable from the data table:
g = {data_FINAL_RATINGS.Speed, data_FINAL_RATINGS.Elevation};
figure; hold on;
figure; boxplot(data_FINAL_RATINGS.Effort, g);
hold on; plot(1, data_FINAL_RATINGS.Effort(1:4:end), 'ko')
hold on; plot(2, data_FINAL_RATINGS.Effort(2:4:end), 'ko')
hold on; plot(3, data_FINAL_RATINGS.Effort(3:4:end), 'ko')
hold on; plot(4, data_FINAL_RATINGS.Effort(4:4:end), 'ko')
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bar plot with overlays from slide 12:
%
figure; hold on; bar(1:4, [mean(data_FINAL_RATINGS.Effort(1:4:end)), ...
    mean(data_FINAL_RATINGS.Effort(2:4:end)),mean(data_FINAL_RATINGS.Effort(3:4:end)),...
    mean(data_FINAL_RATINGS.Effort(4:4:end))], 'FaceAlpha', 0.4);
xticklabels({'SS low', 'SS high', 'Fast low', 'Fast high'})
hold on; plot(1:2, [data_FINAL_RATINGS.Effort(1:4:end),data_FINAL_RATINGS.Effort(2:4:end)] , 'ko-')
hold on; plot(3:4, [data_FINAL_RATINGS.Effort(3:4:end),data_FINAL_RATINGS.Effort(4:4:end)], 'ko-')
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% histograms on slide 14:
%
% create response time variable:
responseTime = data_CI_ERRORS.target + data_CI_ERRORS.constant_error;
%
%
figure;hold on;
subplot(121); 
h1700 = histogram(responseTime(data_CI_ERRORS.target == 1700 & ...
    strcmp(data_CI_ERRORS.group, 'Blocked')), 'Normalization', 'CountDensity');
hold on; 
h1500 = histogram(responseTime(data_CI_ERRORS.target == 1500 & ...
    strcmp(data_CI_ERRORS.group, 'Blocked')), 'Normalization', 'CountDensity');
hold on;
h1900 = histogram(responseTime(data_CI_ERRORS.target == 1900 & ...
    strcmp(data_CI_ERRORS.group, 'Blocked')), 'Normalization', 'CountDensity');
title('blocked'); ylabel('density'); xlabel('time produced (ms)');

subplot(122); 
h1700 = histogram(responseTime(data_CI_ERRORS.target == 1700 & ...
    strcmp(data_CI_ERRORS.group, 'Random')), 'Normalization', 'CountDensity');
hold on; 
h1500 = histogram(responseTime(data_CI_ERRORS.target == 1500 & ...
    strcmp(data_CI_ERRORS.group, 'Random')), 'Normalization', 'CountDensity');
hold on;
h1900 = histogram(responseTime(data_CI_ERRORS.target == 1900 & ...
    strcmp(data_CI_ERRORS.group, 'Random')), 'Normalization', 'CountDensity');
title('random'); ylabel('density'); xlabel('time produced (ms)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% I am extracting the error data and compiling it into a matrix (42 rows X 210 columns),
% which is easier to use for plotting in matlab. The open brackets just mean that matlab
% will auto-expand the matrix to the correct other dimension since I only specified the
% first dimension. I could’ve alternatively put 42 there instead and it would’ve done the
% same thing. The apostrophe at the end is what matlab uses to transpose an matrix.
% In this case, that allows me to go from a 210x42 to a 42x210.
 
errorDat = reshape(data_CI_ERRORS.absolute_error,210,[])';

% I am taking advantage of the way your data is organized: I can setup the plot
% command to index every other row, since you alternate between blocked and
% random participants. Note that the subplot numbers (121, 122) are also
% shorthand: it is N subplot rows, N subplot colums, and which of the subplots
% do you want to plot on. So, 121 is 1 row, 2 columns, plot on the first one.
% these can be separated by commas, as in. 1,2,1 if it helps conversion.
% dots and whiskers from slide 17:

figure; hold on; subplot(121); errorbar(1:70, mean(errorDat(1:2:end,1:70)), std(errorDat(1:2:end,1:70)),'-ok');
subplot(121); errorbar(71:140, mean(errorDat(1:2:end,71:140)), std(errorDat(1:2:end,71:140)),'-om');
subplot(121); errorbar(140:210, mean(errorDat(1:2:end,140:210)), std(errorDat(1:2:end,140:210)),'-om');
subplot(121); title('blocked'); xlabel('trial')

figure; hold on; subplot(122); errorbar(1:70, mean(errorDat(2:2:end,1:70)), std(errorDat(2:2:end,1:70)),'-ok');
subplot(122); errorbar(71:140, mean(errorDat(2:2:end,71:140)), std(errorDat(2:2:end,71:140)),'-om');
subplot(122); errorbar(140:210, mean(errorDat(2:2:end,140:210)), std(errorDat(2:2:end,140:210)),'-om');
subplot(121); title('blocked'); xlabel('trial')

% or, simpler if all one color:
figure; errorbar(1:210, mean(errorDat(1:2:end,:)), std(errorDat(1:2:end,:)));


% Rotini plots from slide 18:
 
figure;hold on; subplot(121); plot(1:70, errorDat(1:2:end,1:70),'r', ...
    71:140,errorDat(1:2:end,71:140), 'g', 141:210, errorDat(1:2:end,141:210), 'b') 
subplot(121); plot(1:70, mean(errorDat(1:2:end,1:70)),...
    'k', 71:140, mean(errorDat(1:2:end,71:140)), 'k', 141:210, mean(errorDat(1:2:end,141:210)), 'k')
subplot(121); title('blocked'); xlabel('trial')

subplot(122); plot(1:70, errorDat(2:2:end,1:70),'r',...
    71:140,errorDat(2:2:end,71:140), 'g', 141:210, errorDat(2:2:end,141:210), 'b')
subplot(122); plot(1:70, mean(errorDat(2:2:end,1:70)),...
    'k', 71:140, mean(errorDat(2:2:end,71:140)), 'k', 141:210, mean(errorDat(2:2:end,141:210)), 'k')
subplot(121); title('blocked'); xlabel('trial')












