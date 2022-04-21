function Renewable(P_max, P_min, loc)
    %% Renewable costs
    % average costs of Renewable sources. converted to MW and MWh.
    PV_capital_cost = 1100 * 1e3; %[$/MW]
    PV_cost_of_electricity = 43; %[$/MWh]
    Wind_capital_cost = 1500 * 1e3; %[$/MW]
    Wind_cost_of_electricity = 50; %[$/MWh]
    Hydro_capital_cost = 1300 * 1e3; %[$/MW]
    Hydro_cost_of_electricity = 63.9; %[$/MWh]
    
    %% Storage costs
    % average costs of Storage sources. converted to MW and MWh.
    Storage_costs = Storage(P_max, P_min, loc);
    %% Making a margin
    % we took a 10 precent margin for continuous power supply
    P_max = P_max * 1.1; % 10 precent margin of safty
    P_min = P_min * 0.9; % 10 precent margin of safty 
    
    %% Optimization - Economic Dispatch
    %solving the economic dispatch problem.
    msg = ['Enter the number of our enregey sources',...
          ' you would like to use (1-4):'];
    number_of_sources = inputdlg(msg,'number of renewable sources',...
                                 [1 35],{'4'});
    number_of_sources = str2double(number_of_sources);
    if (number_of_sources > 0)
        P_min = P_min / number_of_sources;
    else %no optimiztion for 0 sources.
        uiwait(msgbox('Can not do optimiztion. returning to main',...
                      'No optimization'));
        return;
    end
    
    A_1 = eye(4);
    A = [A_1; -1*A_1];% A*P<=B
    B_ub = P_max * ones(1, 4);
    B_lb = -1*P_min*zeros(1, 4);
    B = [B_ub,B_lb];
    if (number_of_sources < 4)
%if the user choose not to use all of our sources - define which one to use
        B = zeros(1,8);
        B = B_def(number_of_sources, B);
    elseif (number_of_sources == 4)
        msg = 'Do you have a limit on power of the storage?';
        Power_limit = questdlg(msg,'Power limit','Yes','No','No');
        switch Power_limit
            case 'Yes'
%if the user want to choose upper and bottom limits for the power supply
                msg1 = 'What is the upper limit of the power of Solar?';
                msg5 = 'What is the bottom limit of the power of Solar?';
                msg2 = 'What is the upper limit of the power of Wind?';
                msg6 = 'What is the bottom limit of the power of Wind?';
                msg3 = 'What is the upper limit of the power of Hydro?';
                msg7 = 'What is the bottom limit of the power of Hydro?';
                msg4 = ['What is the upper limit of the power of the ',...
                        'Storage?'];
                msg8 = ['What is the bottom limit of the power of the ',...
                        'Storage?'];
                msg = {msg1, msg2, msg3, msg4, msg5, msg6, msg7, msg8};
                B = inputdlg(msg, 'Sources limits');
                B = (str2double(B))';
                B(1,8) = -1*B(1,8);
                B(1,7) = -1*B(1,7);
                B(1,6) = -1*B(1,6);
                B(1,5) = -1*B(1,5);
            case 'No'
        end
    else %no optimiztion for more sources then 4.
        uiwait(msgbox('Can not do optimiztion. returning to main',...
                      'No optimization'));
        return;
    end
       
    f = [PV_cost_of_electricity, Wind_cost_of_electricity,...
         Hydro_cost_of_electricity, Storage_costs]; %f*x - cost function
    Aeq = ones(1,4); %Aeq*P=Beq
    Beq = P_max;
    options = optimoptions('linprog','Display','none');
    [P, ~, exitflag] = linprog(f,A,B,Aeq,Beq,[],[],options);
    if (exitflag == 1)
        %capital price = Construction costsor Initial capital needed
        capital_Price = P(1) * PV_capital_cost + P(2) *...
                        Wind_capital_cost + P(3) * Hydro_capital_cost;
        %cost of electricity Price = Operating costs
        cost_of_electricity_Price = P(1) * PV_cost_of_electricity +...
                                    P(2) * Wind_cost_of_electricity +...
                                    P(3) * Hydro_cost_of_electricity;
%% Print costs
        msg = {sprintf('The capital cost is: %g [M$]',...
                       capital_Price/1e6),...
               sprintf('The electricity cost is: %g [$]',...
                       cost_of_electricity_Price),...
               [sprintf('We used for this calculation: %g [MW] of PV, ',...
                       abs(P(1))),...
                sprintf('%g [MW] of Wind, ', abs(P(2))),...
                sprintf('%g [MW] of Hydro.\n', abs(P(3)))]};
        uiwait(msgbox(msg, 'Renewable sources optimiztion Summary'));
    else
        uiwait(msgbox({sprintf('Analysis for %s:',loc),...
               ['There is no optimal solution for the renewable sources',...
               ' costs.']}, 'No optimization'));
    end
end