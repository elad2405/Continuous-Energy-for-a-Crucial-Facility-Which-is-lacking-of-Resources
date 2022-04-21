function [x_day_max,x_day_min] = data_tables(Hospital_data,loc)
% We getting a data table with 12 col. of Load profile and a location and
% generate a plot for the sum of load profile (or each one if we need to).
% We compute the maximum and minimum power load.

%% first section
% This section making order in the data.

    Date_Time = table2array(Hospital_data(1:8760,1));
    Hospital = Hospital_data(1:8760,2:12);

%% second section
% This section computes from the load profile table.
% We are computing the maximum, minimum, mean and the std. of the load
% profile for each given load per day and month.

    [Sum_day_max_vec,Sum_day_min_vec,Sum_day,Sum_day_std,Sum_month,...
     Sum_month_std] = load_analysis(Hospital,11);
    x_day_max = max(Sum_day_max_vec)/1e3;
    x_day_min = min(Sum_day_min_vec)/1e3;
    max_loc = table2array(Hospital(1:8760,11)) == x_day_max*1e3;
    max_date = string(Date_Time(max_loc,1));
    min_loc = table2array(Hospital(1:8760,11)) == x_day_min*1e3;
    min_date = string(Date_Time(min_loc,1));
%% third section
% This section making figure for each profile of data and prints to the
% command line the maximum and minimum for each location
    print_plt(Hospital_data.Sum,Sum_day,Sum_day_std,Sum_month,...
              Sum_month_std,'Load profile',loc,x_day_max,x_day_min);
    msg1 = sprintf('The maximum daily Load Power at %s is: %g [MW].\n',loc,...
            x_day_max);
    msg2 = sprintf('The maximum daily Load occurs at %s\n',max_date);
    msg3 = sprintf('The minimum daily Load Power at %s is: %g [MW].\n',loc,...
            x_day_min);
    msg4 = sprintf('The minimum daily Load occurs at %s\n',min_date);
    uiwait(msgbox({msg1,msg2,msg3,msg4},'Load profile Summary'));
    print_months(Sum_day,Sum_day_std,'Load profile',loc);
end