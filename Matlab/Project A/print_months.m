function print_months(x,x_std,str,loc)
%% Save the original data
    x_org = x;
    x_std_org = x_std;
%% Enter a month and find the relevent days
%     month = input('Enter a number of a month or "q" to quit: ','s');
    list = {'January', 'February', 'March', 'April', 'May', 'June',...
            'July', 'August', 'September', 'October', 'November',...
            'December'};
    [month,tf] = listdlg('ListString',list, 'Name', 'Choose a Month',...
                         'PromptString', 'Select a month to analyse:',...
                         'ListSize',[150,100], 'SelectionMode', 'Single');
    if (tf == 0)
        month = 0;
    end
    switch month
        case 1
            month = 'January';
            NumOfDays = 31;
            x = x(1,1:31);
            x_std = x_std(1,1:31);
        case 2
            month = 'February';
            NumOfDays = 28;
            x = x(1,32:59);
            x_std = x_std(1,32:59);
        case 3
            month = 'March';
            NumOfDays = 31;
            x = x(1,60:90);
            x_std = x_std(1,60:90);
        case 4
            month = 'April';
            NumOfDays = 30;
            x = x(1,91:120);
            x_std = x_std(1,91:120);
        case 5
            month = 'May';
            NumOfDays = 31;
            x = x(1,121:151);
            x_std = x_std(1,121:151);
        case 6
            month = 'June';
            NumOfDays = 30;
            x = x(1,152:181);
            x_std = x_std(1,152:181);
        case 7
            month = 'July';
            NumOfDays = 31;
            x = x(1,182:212);
            x_std = x_std(1,182:212);
        case 8
            month = 'August';
            NumOfDays = 31;
            x = x(1,213:243);
            x_std = x_std(1,213:243);
        case 9
            month = 'September';
            NumOfDays = 30;
            x = x(1,244:273);
            x_std = x_std(1,244:273);
        case 10
            month = 'October';
            NumOfDays = 31;
            x = x(1,274:304);
            x_std = x_std(1,274:304);
        case 11
            month = 'November';
            NumOfDays = 30;
            x = x(1,305:334);
            x_std = x_std(1,305:334);
        case 12
            month = 'December';
            NumOfDays = 31;
            x = x(1,335:365);
            x_std = x_std(1,335:365);
        otherwise
            return;
    end
%% Plotting the month       
    if NumOfDays == 31
        day=linspace(1,31,31);
        
    elseif NumOfDays == 30
        day=linspace(1,30,30);
        
    elseif NumOfDays == 28
        day=linspace(1,28,28);
        
    end
    if (NumOfDays ~= 0)
        figure;
        plot (day,x,'b','LineWidth',1);
        hold on;
        plot(day,(x+x_std),'--','color','red','LineWidth',0.3);
        plot(day,(x-x_std),'--','color','red','LineWidth',0.3);
        %errorbar(Sum_day,Sum_day_std,'LineStyle','none','color','red');
        title (['mean of ',str,' [kW] at ',month,' for a typical ',...
                'hospital at ',loc,' per day']);
        xlabel('Day');
        ylabel('Power Load [kW]');
        legend('mean Load per day','std');
    end
%% Start Over
msg = 'Would you like to see another month?';
Start_Over = questdlg(msg,'Another Month','Yes', 'No','Yes');
switch Start_Over
    case 'Yes'
        print_months(x_org,x_std_org,str,loc);
    case 'No'
        return;  
end