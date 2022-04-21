function y = print_plt(x,y,~,z,z_std,str,loc,y_max,y_min)
 %% Section 1
 % We are making axes for hour, day and month and spliting the data
    hour = linspace(1,8760,8760);
    day = linspace(1,365,365);
    month = linspace(1,12,12);
    
    y_max = y_max * 1e3;
    y_min = y_min * 1e3;
    y_max_vec = ones(1,8760) * y_max;
    y_min_vec = ones(1,8760) * y_min;
%% Section 2
% This section making figure for each profile of data   
% The first plot is the hourly power load in a year. 
    figure;
       t = string(sprintf('Data analysis for a typical hospital at %s',...
                          loc));
        sgtitle(t, 'FontSize', 20);
        subplot(3,2,1);
        plot(hour, x);
        hold on;
        plot(hour,y_max_vec,'--','color','red','LineWidth',0.3);
        plot(hour,y_min_vec,'--','color','red','LineWidth',0.3);
        title ([str,' [kW] per hour']);
        xlim([0.5,8760.5]);
        xlabel('Hour');
        ylim([(y_min-500),(y_max+500)]);
        ylabel('Power Load [kW]');
        legend('Load per hour','yearly max and min of load');
 
% The second plot is the monthly mean power load for a year.
        subplot(3,2,2);
        plot (month,z,'blue');
        hold on;
        errorbar(z,z_std,'LineStyle','none','color','red');
        title (['mean of ',str,' [kW] per month']);
        xlim([0.5,12.5]);
        xlabel('Month');
        ylabel('Power Load [kW]');
        legend('mean Load per month','std');
        
% The third plot is the daily mean power load at the first half of a year.        
        subplot(3,2,3);
        plot (day,y,'blue');
        hold on;
        plot(hour,y_max_vec,'--','color','red','LineWidth',0.3);
        plot(hour,y_min_vec,'--','color','red','LineWidth',0.3);
        title (['mean of ',str,' [kW] at 1/1 - 1/7 per day']);
        xlim([0.5,182.5]);
        xlabel('Day');
        ylim([(y_min-500),(y_max+500)]);
        ylabel('Power Load [kW]');
        legend('mean Load per day','yearly max and min of load');
        
% The forth plot is the daily mean power load at the second half of a year.
        subplot(3,2,4);
        plot (day,y,'blue');
        hold on;
        plot(hour,y_max_vec,'--','color','red','LineWidth',0.3);
        plot(hour,y_min_vec,'--','color','red','LineWidth',0.3);
        title (['mean of ',str,' [kW] at 1/7 - 31/12 per day']);
        xlim([182.5,365.5]);
        xlabel('Day');
        ylim([(y_min-500),(y_max+500)]);
        ylabel('Power Load [kW]');
        legend('mean Load per day','yearly max and min of load');
        
% The fifth plot is the hourly power load at June first - a typical day
% of summer.
        subplot(3,2,5);
        plot(hour(1,1:24), x(3626:3649,1));
        title ([str,' [kW] at 1/6 per hour']);
        xlim([1,24]);
        xlabel('Hour');
        ylabel('Power Load [kW]');
        
% The sixth plot is the hourly power load at December first - a typical
% day of winter.
        subplot(3,2,6);
        plot(hour(1,1:24), x(8018:8041,1));

        title ([str,' [kW] at 1/12 per hour']);
        xlim([1,24]);
        xlabel('Hour');
        ylabel('Power Load [kW]');
end