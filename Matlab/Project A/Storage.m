function Price = Storage(P_max, P_min, loc)
    %% Storage costs
    % average costs of storage sources. converted to MW and MWh.
    Hydro_Storage = 1500 * 1e3; %[$/MW]
    CAES_Storage = 650 * 1e3; %[$/MW]
    Sodium_sulfur_battary = 575 * 1e3; %[$/MWh]
    Lead_acid_battery = 1350 * 1e3; %[$/MWh]
    Nickel_cadmium_battery = 2100 * 1e3; %[$/MWh]
    Flow_batteries = 475 * 1e3; %[$/MWh]
    capacitors_capital_costs = 2000 *1e3; %[$/MW]
    capacitors_cost_of_electricity = 10000 * 1e3; %[$/MWh]
    %% storage optimiztion
    %solving the economic dispatch problem.
    msg = ['Enter the number of our enregey storage ',...
           'you would like to use (1-7):'];
    number_of_storage = inputdlg(msg,'number of storage sources',...
                                 [1 50],{'7'});
    number_of_storage = str2double(number_of_storage);
    if (number_of_storage > 0)
        P_min = P_min / number_of_storage;
    else %no optimiztion for 0 sources.
        uiwait(msgbox('Can not do optimiztion. returning to main',...
                      'No optimization'));
        Price = 0;
        return;
    end
    A_1 = eye(7);
    A = [A_1; -1*A_1];% A*P<=B
    B_ub = P_max * ones(1, 7);
    B_lb = -1*P_min*zeros(1, 7);
    B = [B_ub,B_lb];
    if (number_of_storage < 7)
%if the user choose not to use all of our storage - define which one to use
        B = zeros(1,14);
        B = B_Storage_def(number_of_storage, B);
    elseif (number_of_storage == 7)
        msg = 'Do you have a limit on power of the storage?';
        Power_limit = questdlg(msg,'Power limit','Yes','No','No');
        switch Power_limit
            case 'Yes'
%if the user wants to choose upper and bottom limits for the power storage
                msg1 = 'What is the upper limit of the power of Hydro?';
                msg8 = 'What is the bottom limit of the power of Hydro?';
                msg2 = 'What is the upper limit of the power of CAES?';
                msg9 = 'What is the bottom limit of the power of CAES?';
                msg3 = ['What is the upper limit of the power of ',...
                        'Sodium sulfur battary?'];
                msg10 = ['What is the bottom limit of the power of ',...
                         'Sodium sulfur battary?'];
                msg4 = ['What is the upper limit of the power of ',...
                        'Lead acid battery?'];
                msg11 = ['What is the bottom limit of the power of ',...
                         'Lead acid battery?'];
                msg5 = ['What is the upper limit of the power of ',...
                        'Nickel cadmium battery?'];
                msg12 = ['What is the bottom limit of the power of ',...
                         'Nickel cadmium battery?'];
                msg6 = ['What is the upper limit of the power of ',...
                        'Flow batteries?'];
                msg13 = ['What is the bottom limit of the power of ',...
                         'Flow batteries?'];
                msg7 = ['What is the upper limit of the power of ',...
                        'Capacitors?'];
                msg14 = ['What is the bottom limit of the power of ',...
                         'Capacitors?'];
                msg = {msg1, msg2, msg3, msg4, msg5, msg6, msg7, msg8,...
                       msg9, msg10, msg11, msg12, msg13, msg14};
                B = inputdlg(msg, 'Storage limits');
                B = (str2double(B))';
                B(1,14) = -1*B(1,14);
                B(1,13) = -1*B(1,13);
                B(1,12) = -1*B(1,12);
                B(1,11) = -1*B(1,11);
                B(1,10) = -1*B(1,10);
                B(1,9) = -1*B(1,9);
                B(1,8) = -1*B(1,8);
            case 'No'
                Power_limit = 'N';
        end
    else %no optimiztion for more storage then 7.
        uiwait(msgbox('Can not do optimiztion. returning to main',...
                      'No optimization'));
        return;
    end
    
    f = [Hydro_Storage, CAES_Storage, Sodium_sulfur_battary,...
         Lead_acid_battery, Nickel_cadmium_battery, Flow_batteries,...
         capacitors_cost_of_electricity]; %f*x - cost function
    Aeq = ones(1,7); %Aeq*P=Beq
    Beq = P_max;
    options = optimoptions('linprog','Display','none');
    [S, ~, exitflag] = linprog(f,A,B,Aeq,Beq,[],[],options);
%price = storage price by the solution of the ecnominc dispatch problem
    if (exitflag == 1)
        Price = S(1) * Hydro_Storage + S(2) * CAES_Storage +...
                S(3) * Sodium_sulfur_battary + S(4) * Lead_acid_battery +...
                S(5) * Nickel_cadmium_battery + S(6) * Flow_batteries +...
                S(7) * (capacitors_capital_costs +...
                        capacitors_cost_of_electricity);
%% Print costs
        msg = {sprintf('Analysis for %s',loc),...
            sprintf('The Storage cost is: %g [M$]',Price/1e6),...
            [sprintf('We used for this calculation: %g [MW]', abs(S(1))),...
            sprintf(' of Hydro Storage,')],...
            sprintf('%g [MW] of CAES Storage,', abs(S(2))),...
            sprintf('%g [MW] of Sodium sulfur battary,', abs(S(3))),...
            sprintf('%g [MW] of Lead_acid_battery,', abs(S(4))),...
            sprintf('%g [MW] of Nickel cadmium battery,', abs(S(5))),...
            sprintf('%g [MW] of Flow batteries,', abs(S(6))),...
            sprintf('%g [MW] of capacitors.', abs(S(7)))};
        uiwait(msgbox(msg, 'Storage optimiztion Summary'));
    else
       uiwait(msgbox({sprintf('Analysis for %s:',loc),...
               'There is no optimal solution for the storage costs.'},...
               'No optimization'));
    end
end