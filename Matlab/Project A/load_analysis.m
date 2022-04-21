function [x_day_max,x_day_min,x_day,x_day_std,x_month,x_month_std]...
         = load_analysis(Hospital,i)
%% Prealoccate
    x_day = zeros(1,365);
    x_day_std = zeros(1,365);
    x_day_max = zeros(1,365);
    x_day_min = zeros(1,365);
    x_month = zeros(1,12);
    x_month_std = zeros(1,12);

%% Calculate maximum, minimum, mean and std. of Load profile for sum func.
% per day
    for j=0:364 
        x_day_max(1,j+1) = table2array(varfun(@max,...
                                         Hospital((j*24+1):(24*j+24),i)));
        x_day_min(1,j+1) = table2array(varfun(@min,...
                                         Hospital((j*24+1):(24*j+24),i)));
        x_day(1,j+1) = table2array(varfun(@mean,...
                                         Hospital((j*24+1):(24*j+24),i)));
        x_day_std(1,j+1) = table2array(varfun(@std,...
                                         Hospital((j*24+1):(24*j+24),i)));
    end
   
%% Calculate mean for sum func. per month
    x_month(1,1) = table2array(varfun(@mean,Hospital(1:744,i)));
    x_month(1,2) = table2array(varfun(@mean,Hospital(745:1416,i)));
    x_month(1,3) = table2array(varfun(@mean,Hospital(1417:2160,i)));
    x_month(1,4) = table2array(varfun(@mean,Hospital(2161:2880,i)));
    x_month(1,5) = table2array(varfun(@mean,Hospital(2881:3624,i)));
    x_month(1,6) = table2array(varfun(@mean,Hospital(3625:4344,i)));
    x_month(1,7) = table2array(varfun(@mean,Hospital(4345:5088,i)));
    x_month(1,8) = table2array(varfun(@mean,Hospital(5089:5832,i)));
    x_month(1,9) = table2array(varfun(@mean,Hospital(5833:6552,i)));
    x_month(1,10) = table2array(varfun(@mean,Hospital(6553:7296,i)));
    x_month(1,11) = table2array(varfun(@mean,Hospital(7297:8016,i)));
    x_month(1,12) = table2array(varfun(@mean,Hospital(8017:8760,i)));


%% Calculate std for sum func. per month
    x_month_std(1,1) = table2array(varfun(@std,Hospital(1:744,i)));
    x_month_std(1,2) = table2array(varfun(@std,Hospital(745:1416,i)));
    x_month_std(1,3) = table2array(varfun(@std,Hospital(1417:2160,i)));
    x_month_std(1,4) = table2array(varfun(@std,Hospital(2161:2880,i)));
    x_month_std(1,5) = table2array(varfun(@std,Hospital(2881:3624,i)));
    x_month_std(1,6) = table2array(varfun(@std,Hospital(3625:4344,i)));
    x_month_std(1,7) = table2array(varfun(@std,Hospital(4345:5088,i)));
    x_month_std(1,8) = table2array(varfun(@std,Hospital(5089:5832,i)));
    x_month_std(1,9) = table2array(varfun(@std,Hospital(5833:6552,i)));
    x_month_std(1,10) = table2array(varfun(@std,Hospital(6553:7296,i)));
    x_month_std(1,11) = table2array(varfun(@std,Hospital(7297:8016,i)));
    x_month_std(1,12) = table2array(varfun(@std,Hospital(8017:8760,i)));
end