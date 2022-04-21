function optimal_sol_print(Hospital, loc, capital_Price,...
                           cost_of_electricity_Price, Storage_costs,...
                           P, S, S_sum, P_max, S_max, month, day,...
                           Storage_sum, SOC)
% this function made for printing the solution on the command window
msg = [sprintf('The optimal solution for %s is:',loc),newline,...
      sprintf('The capital cost is: %g [M$]',capital_Price/1e6),newline,...
      sprintf('The electricity cost is: %g [$/hour]',...
              cost_of_electricity_Price), newline,...
      sprintf('The cost of storage is: %g [M$]',...
              max(Storage_costs(:,1))/1e6), newline,...
      sprintf('In order to calculate the above variables, '),...
      sprintf('we used this data:'), newline,...
      sprintf('%g [MW] of PV (max value), ', abs(max(P(:,1)))),...
      sprintf('%g [MW] of Wind (max value), ', abs(max(P(:,2)))),...
      sprintf('%g [MW] of Hydro (max value), ', abs(max(P(:,3)))),...
      sprintf('%g [MWh] of Storage.', Storage_sum), newline,...
      sprintf('In order to calculate the Storage above,'),...
      sprintf('we used this data:'), newline,...
      sprintf('%g [MW] of Hydro Storage (max value),',...
              abs(max(S(:,1)))), newline,...
      sprintf('%g [MW] of CAES Storage (max value),',...
              abs(max(S(:,2)))), newline,...
      sprintf('%g [MW] of Sodium sulfur battary (max value),',...
              abs(max(S(:,3)))), newline,...
      sprintf('%g [MW] of Lead acid_battery (max value),',...
              abs(max(S(:,4)))), newline,...
      sprintf('%g [MW] of Nickel cadmium battery (max value),',...
              abs(max(S(:,5)))), newline,...
      sprintf('%g [MW] of Flow batteries (max value),',...
              abs(max(S(:,6)))), newline,...
      sprintf('%g [MW] of capacitors (max value).',...
              abs(max(S(:,7)))), newline,...
      sprintf('The maximum Power per hour that is required is: %g[MW]',...
              (max(S_sum(:,1))))];
msgbox(msg,'Optimiztion summary');

%% Orginazing months
switch month
    case 1
        month = 'January';
    case 2
        month = 'February';
    case 3
        month = 'March';
    case 4
        month = 'April';
    case 5
        month = 'May';
    case 6
        month = 'June';
    case 7
        month = 'July';
    case 8
        month = 'August';
    case 9
        month = 'September';
    case 10
        month = 'October';
    case 11
        month = 'November';
    case 12
        month = 'December';
end
%% Plotting    
hour = linspace(1,8760,8760);
sz = size(Hospital);
if (month ~= 0)
%% Monthly
    figure;
        hold all;
        t = string(sprintf('Renewable sources at %s', month));
        sgtitle(t, 'FontSize', 20);
        subplot(2,2,1);
            hold all;
            plot (hour(1:sz(1)), P(:,1));
            plot (hour(1:sz(1)), P_max(1)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('PV');
        subplot(2,2,2);
            hold all;
            plot (hour(1:sz(1)), P(:,2));
            plot (hour(1:sz(1)), P_max(2)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('Wind');
        subplot(2,2,3);
            hold all;
            plot (hour(1:sz(1)), P(:,3));
            plot (hour(1:sz(1)), P_max(3)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('Hydro');
        subplot(2,2,4);
            hold all;
            plot (hour(1:sz(1)), P(:,4));
            plot (hour(1:sz(1)), P_max(4)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('Storage');
    figure;
        t = string(sprintf('Storage sources at %s', month));
        sgtitle(t, 'FontSize', 20);
        subplot(4,2,1);
            hold all;
            plot (hour(1:sz(1)), S(:,1));
            plot (hour(1:sz(1)), S_max(1)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('Hydro');
        subplot(4,2,2);
            hold all;
            plot (hour(1:sz(1)), S(:,2));
            plot (hour(1:sz(1)), S_max(2)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('CAES');
        subplot(4,2,3);
            hold all;
            plot (hour(1:sz(1)), S(:,3));
            plot (hour(1:sz(1)), S_max(3)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('Sodium sulfur battary');
        subplot(4,2,4);
            hold all;
            plot (hour(1:sz(1)), S(:,4));
            plot (hour(1:sz(1)), S_max(4)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('Lead acid battery');
        subplot(4,2,5);
            hold all;
            plot (hour(1:sz(1)), S(:,5));
            plot (hour(1:sz(1)), S_max(5)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('Nickel cadmium battery');
        subplot(4,2,6);
            hold all;
            plot (hour(1:sz(1)), S(:,6));
            plot (hour(1:sz(1)), S_max(6)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('Flow batteries');
        subplot(4,2,7);
            hold all;
            plot (hour(1:sz(1)), S(:,7));
            plot (hour(1:sz(1)), S_max(7)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('Capacitors');
        subplot(4,2,8);
            hold all;
            plot (hour(1:sz(1)), P(:,4));
            plot (hour(1:sz(1)), P_max(4)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('Total storage');
    figure;
        hold all;
        plot (hour(1:sz(1)), SOC);
        xlabel('Hour');
        ylabel('SOC [%]');
        t = string(sprintf('SOC of the storage sources at %s', month));
        title(t);
else
    if (day == 0)
%% Yearly
        figure;
            sgtitle('Renewable sources for a year', 'FontSize', 20);
            hold all;
            subplot(2,2,1);
                hold all;
                plot (hour(1:sz(1)), P(:,1));
                plot (hour(1:sz(1)), P_max(1)*ones(sz));
                legend('Power','max value');
                xlabel('Hour');
                ylabel('Power[MW]');
                title('PV');
            subplot(2,2,2);
                hold all;
                plot (hour(1:sz(1)), P(:,2));
                plot (hour(1:sz(1)), P_max(2)*ones(sz));
                legend('Power','max value');
                xlabel('Hour');
                ylabel('Power[MW]');
                title('Wind');
            subplot(2,2,3);
                hold all;
                plot (hour(1:sz(1)), P(:,3));
                plot (hour(1:sz(1)), P_max(3)*ones(sz));
                legend('Power','max value');
                xlabel('Hour');
                ylabel('Power[MW]');
                title('Hydro');
            subplot(2,2,4);
                hold all;
                plot (hour(1:sz(1)), P(:,4));
                plot (hour(1:sz(1)), P_max(4)*ones(sz));
                legend('Power','max value');
                xlabel('Hour');
                ylabel('Power[MW]');
                title('Storage');
        figure;
            sgtitle('Storage sources for a year', 'FontSize', 20);
            subplot(4,2,1);
                hold all;
                plot (hour(1:sz(1)), S(:,1));
                plot (hour(1:sz(1)), S_max(1)*ones(sz));
                legend('Power','max value');
                xlabel('Hour');
                ylabel('Power[MW]');
                title('Hydro');
            subplot(4,2,2);
                hold all;
                plot (hour(1:sz(1)), S(:,2));
                plot (hour(1:sz(1)), S_max(2)*ones(sz));
                legend('Power','max value');
                xlabel('Hour');
                ylabel('Power[MW]');
                title('CAES');
            subplot(4,2,3);
                hold all;
                plot (hour(1:sz(1)), S(:,3));
                plot (hour(1:sz(1)), S_max(3)*ones(sz));
                legend('Power','max value');
                xlabel('Hour');
                ylabel('Power[MW]');
                title('Sodium sulfur battary');
            subplot(4,2,4);
                hold all;
                plot (hour(1:sz(1)), S(:,4));
                plot (hour(1:sz(1)), S_max(4)*ones(sz));
                legend('Power','max value');
                xlabel('Hour');
                ylabel('Power[MW]');
                title('Lead acid battery for a Year');
            subplot(4,2,5);
                hold all;
                plot (hour(1:sz(1)), S(:,5));
                plot (hour(1:sz(1)), S_max(5)*ones(sz));
                legend('Power','max value');
                xlabel('Hour');
                ylabel('Power[MW]');
                title('Nickel cadmium battery');
            subplot(4,2,6);
                hold all;
                plot (hour(1:sz(1)), S(:,6));
                plot (hour(1:sz(1)), S_max(6)*ones(sz));
                legend('Power','max value');
                xlabel('Hour');
                ylabel('Power[MW]');
                title('Flow batteries');
            subplot(4,2,7);
                hold all;
                plot (hour(1:sz(1)), S(:,7));
                plot (hour(1:sz(1)), S_max(7)*ones(sz));
                legend('Power','max value');
                xlabel('Hour');
                ylabel('Power[MW]');
                title('Capacitors');
            subplot(4,2,8);
                hold all;
                plot (hour(1:sz(1)), P(:,4));
                plot (hour(1:sz(1)), P_max(4)*ones(sz));
                legend('Power','max value');
                xlabel('Hour');
                ylabel('Power[MW]');
                title('Total storage');
        figure;
        hold all;
        plot (hour(1:sz(1)), SOC);
        xlabel('Hour');
        ylabel('SOC [%]');
        t = string(sprintf('SOC of the storage sources for a year'));
        title(t);
    else
%% Daily
        day = str2double(day);
        day1 = datetime('1-Jan-2021','TimeZone','local','Format','d-MMMM');
        day = day1 + day -1;
        day = string(day);
        figure;
        t = string(sprintf('Renewable sources at %s', day));
        sgtitle(t, 'FontSize',20);
        hold all;
        subplot(2,2,1);
            hold all;
            plot (hour(1:sz(1)), P(:,1));
            plot (hour(1:sz(1)), P_max(1)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('PV');
        subplot(2,2,2);
            hold all;
            plot (hour(1:sz(1)), P(:,2));
            plot (hour(1:sz(1)), P_max(2)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('Wind');
        subplot(2,2,3);
            hold all;
            plot (hour(1:sz(1)), P(:,3));
            plot (hour(1:sz(1)), P_max(3)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('Hydro');
        subplot(2,2,4);
            hold all;
            plot (hour(1:sz(1)), P(:,4));
            plot (hour(1:sz(1)), P_max(4)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('Storage');
	figure;
        hold all;
        plot (hour(1:sz(1)), P(:,1), 'LineWidth', 1);
        plot (hour(1:sz(1)), P(:,2), 'LineWidth', 1);
        plot (hour(1:sz(1)), P(:,3), 'LineWidth', 1);
        plot (hour(1:sz(1)), P(:,4), 'LineWidth', 1);
        plot (hour(1:sz(1)), (Hospital * 1.1),'Color', 'k',...
              'LineStyle', '--');
        xlabel('Hour');
        ylabel('Power[MW]');
        legend('PV', 'Wind', 'Hydro', 'Storage', 'Consumption');
        t = string(sprintf('Renewable sources at %s', day));
        title(t);
    
    figure;
        t = string(sprintf('Storage sources at %s', day));
        sgtitle(t, 'FontSize', 20);
        subplot(4,2,1);
            hold all;
            plot (hour(1:sz(1)), S(:,1));
            plot (hour(1:sz(1)), S_max(1)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('Hydro');
        subplot(4,2,2);
            hold all;
            plot (hour(1:sz(1)), S(:,2));
            plot (hour(1:sz(1)), S_max(2)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('CAES Storage');
        subplot(4,2,3);
            hold all;
            plot (hour(1:sz(1)), S(:,3));
            plot (hour(1:sz(1)), S_max(3)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('Sodium sulfur battary');
        subplot(4,2,4);
            hold all;
            plot (hour(1:sz(1)), S(:,4));
            plot (hour(1:sz(1)), S_max(4)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('Lead acid battery');
        subplot(4,2,5);
            hold all;
            plot (hour(1:sz(1)), S(:,5));
            plot (hour(1:sz(1)), S_max(5)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('Nickel cadmium battery');
        subplot(4,2,6);
            hold all;
            plot (hour(1:sz(1)), S(:,6));
            plot (hour(1:sz(1)), S_max(6)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('Flow batteries');
        subplot(4,2,7);
            hold all;
            plot (hour(1:sz(1)), S(:,7));
            plot (hour(1:sz(1)), S_max(7)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('Capacitors');
        subplot(4,2,8);
            hold all;
            plot (hour(1:sz(1)), P(:,4));
            plot (hour(1:sz(1)), P_max(4)*ones(sz));
            legend('Power','max value');
            xlabel('Hour');
            ylabel('Power[MW]');
            title('Total storage');
	figure;
        hold all;
        plot (hour(1:sz(1)), S(:,1));
        plot (hour(1:sz(1)), S(:,2));
        plot (hour(1:sz(1)), S(:,3));
        plot (hour(1:sz(1)), S(:,4));
        plot (hour(1:sz(1)), S(:,5));
        plot (hour(1:sz(1)), S(:,6));
        plot (hour(1:sz(1)), S(:,7));
        plot (hour(1:sz(1)), P(:,4));
        xlabel('Hour');
        ylabel('Power[MW]');
        legend('Hydro Storage', 'CAES', 'Sodium sulfur battary',...
               'Lead acid battery','Nickel cadmium battery',...
               'Flow batteries','Capacitors','Storage');
        t = string(sprintf('Renewable storage sources at %s', day));
        title(t);
    figure;
        hold all;
        plot (hour(1:sz(1)), SOC);
        xlabel('Hour');
        ylabel('SOC [%]');
        t = string(sprintf('SOC of the storage sources at %s', day));
        title(t);
    end
end
end