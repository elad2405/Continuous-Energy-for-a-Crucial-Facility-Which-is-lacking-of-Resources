function Energy_Matching ()
% the final optimization - we are optimizing the data by the hour and by
% any conditions we developed during the work on our project
%% load data
    msg = ['Would you like to analyze a new database or analyze our',...
            ' database?'];
    data_usage = questdlg(msg,'Choose database','User', 'System','System');
    switch data_usage
        case 'User'
            [Hospital, loc, Wind, Solar, month, day] = User_Hourly_Data;
            if (Hospital == -1)
                return;
            end
        case 'System'
            [Hospital, loc, Wind, Solar, month, day] = Hourly_Data(1);
            if (Hospital == -1)
                return;
            end
        otherwise
            return;
    end  
    Hospital = Hospital/1e3;
    Hospital_sz = size(Hospital);
    Hospital_max = max(Hospital);
%% limits
    msg = 'The location is near water source?';
    Water = questdlg(msg,'Water Source','Yes', 'No','No');
    switch Water
        case 'Yes'
            Water = 'Y';
        case 'No'
            Water = 'N';
        otherwise
            return;
    end
    
    prompt = 'Enter a value of \eta of the PV (in precentage):';
    opts.Interpreter = 'tex';
    PV_Eff = str2double(inputdlg(prompt,'Efficiency Value',[1 40],...
                                 {'100'},opts));
    if (isempty(PV_Eff))
        PV_Eff = 100;
    end
    if ((PV_Eff > 100) || (PV_Eff < 0))
        uiwait(msgbox('Error! Not in range, try again.', 'Error'));
        Energy_Matching();
        return;    
    end
    Solar = (PV_Eff/100) .* Solar;
%% Renewable costs
% average costs of Renewable sources. converted to MW and MWh.
    PV_capital_cost = 1100 * 1e3; %[$/MW]
    PV_cost_of_electricity = 43; %[$/MWh]
    Wind_capital_cost = 1500 * 1e3; %[$/MW]
    Wind_cost_of_electricity = 50; %[$/MWh]
    Hydro_capital_cost = 1300 * 1e3; %[$/MW]
    Hydro_cost_of_electricity = 63.9; %[$/MWh]   
%% Storage costs
    % average costs of storage sources. converted to MW and MWh.
    Hydro_Storage = 1500 * 1e3; %[$/MW]
    CAES_Storage = 650 * 1e3; %[$/MW]
    Sodium_sulfur_battary = 575 * 1e3; %[$/MWh]
    Lead_acid_battery = 1350 * 1e3; %[$/MWh]
    Nickel_cadmium_battery = 2100 * 1e3; %[$/MWh]
    Flow_batteries = 475 * 1e3; %[$/MW]
    capacitors_capital_costs = 2000 *1e3; %[$/MW]
%% PV Calculation
    if (Hospital_sz(1,1) > 24)
        msg = ['Are you interested in calculating the optimal number',...
               ' of solar panels by default or by a certain number of',...
               ' days of your choice?'];
        PV_opt = questdlg(msg,'Optimal PV','Default', 'Choice','Default');
    else
        PV_opt = 'Default';
    end
    switch PV_opt
        case 'Default'
            Days = ceil(Hospital_sz(1,1)/24);
            Weeks = ceil(Hospital_sz(1,1)/168);
            Power_needed = zeros(Days,1);
            Solar_sum = zeros(Days,1);
            Power_needed_week = zeros(Weeks,1);
            Solar_sum_week = zeros(Weeks,1);
            for i=1:Hospital_sz(1,1)
                Day = ceil(i/24);
                Week = ceil(i/168);
                Power_needed(Day,1) = Power_needed(Day,1) + Hospital(i,1);
                Solar_sum(Day,1) = Solar_sum(Day,1) + Solar(i,1)/1e6;
                %devide in 1e6 to make it MW/m
                Power_needed_week(Week,1) = Power_needed_week(Week,1) +...
                                            Hospital(i,1);
                Solar_sum_week(Week,1) = Solar_sum_week(Week,1) +...
                                         Solar(i,1)/1e6;
                %devide in 1e6 to make it MW/m
            end
            PV_needed_per_day = ceil(Power_needed ./ Solar_sum);
            PV_needed_per_week = ceil(Power_needed_week ./ Solar_sum_week);
        % %     to avoid inf value:
            for i=1:Days
                if (~Solar_sum(i,1))
                    PV_needed_per_day(i,1) = 0;
                end
            end
            for i=1:Weeks
                if (~Solar_sum_week(i,1))
                    PV_needed_per_week(i,1) = 0;
                end
            end
            [PV_needed_day, PV_critical_day] = max(PV_needed_per_day);
            [PV_needed_week,PV_critical_week] = max(PV_needed_per_week);
            PV_needed = min([PV_needed_day,PV_needed_week]);
        case 'Choice'
            prompt = 'Enter the number of days you want to calculate by:';
            PV_days = str2double(inputdlg(prompt,'PV days',[1 40],...
                                         {'7'}));
            if (isempty(PV_days))
                PV_days = 7;
            elseif (PV_days <= 0)
                uiwait(msgbox('Error! Not in range, try again.', 'Error'));
                Energy_Matching();
                return;
            end
            Days = ceil(Hospital_sz(1,1)/(24 * PV_days));
            Power_needed = zeros(Days,1);
            Solar_sum = zeros(Days,1);
            for i=1:Hospital_sz(1,1)
                Day = ceil(i / (24 * PV_days));
                Power_needed(Day,1) = Power_needed(Day,1) + Hospital(i,1);
                Solar_sum(Day,1) = Solar_sum(Day,1) + Solar(i,1)/1e6;
                %devide in 1e6 to make it MW/m
            end
            PV_needed_per_day = ceil(Power_needed ./ Solar_sum);
        % %     to avoid inf value:
            for i=1:Days
                if (~Solar_sum(i,1))
                    PV_needed_per_day(i,1) = 0;
                end
            end
            [PV_needed, PV_critical] = max(PV_needed_per_day);
        otherwise
            uiwait(msgbox('Error! try again.', 'Error'));
            Energy_Matching();
            return;
    end
    PV_area = sqrt(PV_needed);
    PV_Solar = PV_needed * (Solar/1e6);
%% Optimization
    Storage_costs = 63.91;
    Storage_use = zeros(Hospital_sz);
    Storage_load = zeros(Hospital_sz);
    days = ceil(Hospital_sz(1)/24);
    Storage_days = zeros(days,1);
    P = zeros(Hospital_sz(1,1),4);
    K = waitbar(0,'1','Name','Renewable data analysis',...
                'CreateCancelBtn', 'setappdata(gcbf,''canceling'',1)');
    setappdata(K,'canceling',0);
    for i = 1:Hospital_sz(1,1)
        waitbar(i/Hospital_sz(1,1),K,sprintf('Analyzing %0g out of %0g',...
                                             i, Hospital_sz(1,1)));
        if getappdata(K,'canceling')
            break;
        end
% %% initial opt.
        A_1 = eye(4);
        A = [A_1; -1*A_1];
        B_ub = (Hospital(i,1) + Hospital_max) * ones(1,4);
        B_ub(1,1) = PV_Solar(i,1);
        if (Wind(i,1) < 6)
            B_ub(1,2) = 0;
        end
        B_lb = zeros(1,4);
        B = [B_ub, B_lb];
        if (Water == 'N')
            B(1,3) = 0;
            B(1,7) = 0;
        end
        f = [PV_cost_of_electricity, Wind_cost_of_electricity,...
             Hydro_cost_of_electricity, Storage_costs];%f*x - cost function
        Aeq = ones(1,4);
        Beq = Hospital(i,1);
        options = optimoptions('linprog','Display','none');
        [P(i,:), ~, exitflag] = linprog(f,A,B,Aeq,Beq,[],[],options);
        if (exitflag ~= 1)
            P = zeros(1,4);
        end
        if (P(i,1) > 0)
            P(i,1) = PV_Solar(i,1);
            if (P(i,1) < Hospital(i,1))
% if there is a shortage - do opt. without PV
                B_ub = (Hospital(i,1) - P(i,1)) * ones(1,4);
                B_ub(1,1) = 0;
                if (Wind(i,1) < 6)
                    B_ub(1,2) = 0;
                end
                B_lb = zeros(1,4);
                B = [B_ub, B_lb];
                if (Water == 'N')
                    B(1,3) = 0;
                    B(1,7) = 0;
                end
                f = [PV_cost_of_electricity, Wind_cost_of_electricity,...
                     Hydro_cost_of_electricity, Storage_costs];%f*x - cost function
                Aeq = ones(1,4);
                Beq = Hospital(i,1) - P(i,1);
                options = optimoptions('linprog','Display','none');
                [P(i,:), ~, exitflag] = linprog(f,A,B,Aeq,Beq,[],[],options);
                P(i,1) = PV_Solar(i,1);
                if (exitflag ~= 1)
                    P = zeros(1,4);
                end
            elseif (P(i,1) > Hospital(i,1))
% if there is surplus - PV usage, charging in place with the surplus
                P(i,1) = PV_Solar(i,1);
                P(i,2) = 0;
                P(i,3) = 0;
                P(i,4) = Hospital(i,1)- PV_Solar(i,1);
            else
% exactly - use only PV
                P(i,1) = PV_Soalr(i,1);
                P(i,2) = 0;
                P(i,3) = 0;
                P(i,4) = 0;
            end
        end
% Storage size calculation
        if (P(i,4) > 0)
            if (i >= 2)
                Storage_use(i,1) = Storage_use((i-1),1) + P(i,4);
            else
                Storage_use(i,1) = P(i,4);
            end
        else
            if (i >= 2)
                Storage_load(i,1) = Storage_load((i-1),1) + P(i,4);
            else
                Storage_load(i,1) = P(i,4);
            end
        end
    end
    delete(K);
    for i = 1:Hospital_sz(1)
         Day = ceil(i/24);
         Storage_days(Day,1) = Storage_days(Day,1)+ Hospital(i,1) +...
                               P(i,4);
    end
    for i = 1:Days
        if (Storage_days(i,1) < 0)
            Storage_days(i,1) = 0;
        end
    end
    if (Hospital_sz(1) > 24)
        Storage_size = ceil(max(Storage_use)) + ceil(max(Storage_days));
    else
        Storage_size = ceil(max(Storage_use));
    end
%% SOC
    SOC = zeros(Hospital_sz);
    Charge = zeros(Hospital_sz);
    K = waitbar(0,'1','Name','SOC analysis', 'CreateCancelBtn',...
                'setappdata(gcbf,''canceling'',1)');
    setappdata(K,'canceling',0);
    for i = 1:Hospital_sz(1,1)
        waitbar(i/Hospital_sz(1,1),K,sprintf('Analyzing %0g out of %0g',...
                                             i, Hospital_sz(1,1)));
        if getappdata(K,'canceling')
            break;
        end
        if (P(i,4) > 0)
            if (i >= 2)
                SOC(i,1) = SOC((i-1),1) - 100 * P(i,4) / Storage_size;
            else
                SOC(i,1) = 100 * (Storage_size - P(i,4)) / Storage_size;
            end
        elseif (P(i,4) < 0)
            if (i >= 2)
                SOC(i,1) = SOC((i-1),1) - 100 * P(i,4) / Storage_size;
            else
                SOC(i,1) = 100;
            end
        else
            if (i >= 2)
                SOC(i,1) = SOC((i-1),1);
            else
                SOC(i,1) = 100;
            end
        end
        if ((SOC(i,1) > 0) && (SOC(i,1) < 100) && (P(i,4) <= 0))
            if (i >= 2)
                Charge(i,1) = ((100 - round(SOC((i-1),1),5)) / 100) *...
                              Storage_size;
            end
            if (P(i,2) > 0)
                P(i,2) = (P(i,2) + 0.1*Charge(i,1));
                P(i,4) = P(i,4) - 0.1*Charge(i,1);
                SOC(i,1) = SOC((i-1),1) - 100 * P(i,4) / Storage_size;
            elseif (P(i,3) > 0)
                P(i,3) = P(i,3) + 0.1*Charge(i,1);
                P(i,4) = P(i,4) - 0.1*Charge(i,1);
                SOC(i,1) = SOC((i-1),1) - 100 * P(i,4) / Storage_size;
            end
        end  
        if (SOC(i,1) > 100)
            if (i >= 2)
                Charge(i,1) = ((100 - round(SOC((i-1),1),5)) / 100) *...
                              Storage_size;
            end
            if (P(i,1) > (Hospital(i,1)+Charge(i,1)))
                P(i,1) = Hospital(i,1) + Charge(i,1);
                P(i,2) = 0;
                P(i,3) = 0;
                P(i,4) = -1 * Charge(i,1);
                SOC(i,1) = SOC((i-1),1) - 100 * P(i,4) / Storage_size;
            elseif (P(i,2) > (Hospital(i,1)+Charge(i,1)))
                P(i,1) = 0;
                P(i,2) = Hospital(i,1) + Charge(i,1);
                P(i,3) = 0;
                P(i,4) = -1 * Charge(i,1);
                SOC(i,1) = SOC((i-1),1) - 100 * P(i,4) / Storage_size;
            elseif (P(i,3) > (Hospital(i,1)+Charge(i,1)))
                P(i,1) = 0;
                P(i,2) = 0;
                P(i,3) = Hospital(i,1) + Charge(i,1);
                P(i,4) = -1 * Charge(i,1);
                SOC(i,1) = SOC((i-1),1) - 100 * P(i,4) / Storage_size;
            end
            SOC(i,1) = round(SOC(i,1),5);
        end
    end
    delete(K);
    SOC_min = min(SOC);
    if ((SOC_min > 0) || ((SOC_min < 0) && (SOC_min > (-10))))
        Storage_size = Storage_size - floor(((SOC_min/100)*Storage_size));
        for i = 1:Hospital_sz(1,1)
            if (P(i,4) > 0)
                if (i >= 2)
                    SOC(i,1) = SOC((i-1),1) - 100 * P(i,4) / Storage_size;
                else
                    SOC(i,1) = 100 * (Storage_size - P(i,4)) / Storage_size;
                end
            elseif (P(i,4) < 0)
                if (i >= 2)
                    SOC(i,1) = SOC((i-1),1) - 100 * P(i,4) / Storage_size;
                else
                    SOC(i,1) = 100;
                end
            else
                if (i >= 2)
                    SOC(i,1) = SOC((i-1),1);
                else
                    SOC(i,1) = 100;
                end
            end
            if (SOC(i,1) > 100)
                if (i >= 2)
                    Charge(i,1) = ((100 - round(SOC((i-1),1),5)) / 100) *...
                                  Storage_size;
                end
                if (P(i,1) > (Hospital(i,1)+Charge(i,1)))
                    P(i,1) = Hospital(i,1) + Charge(i,1);
                    P(i,2) = 0;
                    P(i,3) = 0;
                    P(i,4) = -1 * Charge(i,1);
                    SOC(i,1) = SOC((i-1),1) - 100 * P(i,4) / Storage_size;
                elseif (P(i,2) > (Hospital(i,1)+Charge(i,1)))
                    P(i,1) = 0;
                    P(i,2) = Hospital(i,1) + Charge(i,1);
                    P(i,3) = 0;
                    P(i,4) = -1 * Charge(i,1);
                    SOC(i,1) = SOC((i-1),1) - 100 * P(i,4) / Storage_size;
                elseif (P(i,3) > (Hospital(i,1)+Charge(i,1)))
                    P(i,1) = 0;
                    P(i,2) = 0;
                    P(i,3) = Hospital(i,1) + Charge(i,1);
                    P(i,4) = -1 * Charge(i,1);
                    SOC(i,1) = SOC((i-1),1) - 100 * P(i,4) / Storage_size;
                end
                SOC(i,1) = round(SOC(i,1),4);
            end
        end
    end
    [~, Storage_critical] = min(SOC);
%% Storage
    K = waitbar(0,'1','Name','Storage data analysis',...
                'CreateCancelBtn', 'setappdata(gcbf,''canceling'',1)');
    setappdata(K,'canceling',0);
    S = zeros(Hospital_sz(1,1),7);
    for i = 1:Hospital_sz(1,1)
        waitbar(i/Hospital_sz(1,1),K,sprintf('Analyzing %0g out of %0g',...
                                           i, Hospital_sz(1,1)));
        if getappdata(K,'canceling')
            break;
        end
        if (P(i,4) > 0)
            A_1 = eye(7);
            A = [A_1; -1*A_1];
            B_ub = P(i,4) * ones(1,7);
            B_lb = zeros(1,7);
            B = [B_ub,B_lb];
            if (Water == 'N')
                B(1,1) = 0;
                B(1,8) = 0;
            end
            Aeq = ones(1,7); %Aeq*P=Beq
            Beq = P(i,4);
            f = [Hydro_Storage, CAES_Storage, Sodium_sulfur_battary,...
                 Lead_acid_battery, Nickel_cadmium_battery,...
                 Flow_batteries, capacitors_capital_costs]; %f*x - cost function
            options = optimoptions('linprog','Display','none');
            [S(i,:), ~, exitflag] = linprog(f,A,B,Aeq,Beq,[],[],options);
            if (exitflag ~= 1)
                S = zeros(1,7);
            end
        elseif (P(i,4) < 0)
            if (i>2)
                Counter =0;
                for j = 1:7
                    if (sum(S(1:(i-1),j)) ~= 0)
                        Counter = Counter +1;
                    end
                end
                for j = 1:7
                    if (sum(S(1:(i-1),j)) ~= 0)
                        S(i,j) = P(i,4)/Counter;
                    end
                end
            end
        else
            for j = 1:7
                    S(i,j) = 0;
            end
        end
    end
    delete(K); 
%% Display How many PV necessary
    PV_Counter = 0;
    Wind_Counter = 0;
    for i=1:Hospital_sz(1)
        if ((P(i,1) == PV_Solar(i,1)) && (PV_Solar(i,1) ~= 0))
            PV_Counter = PV_Counter + 1;
        end
        if (P(i,2) > 0)
            Wind_Counter = Wind_Counter + 1;
        end
    end
    if (Hospital_sz(1) == 8760)
        PV_Counter = PV_Counter / 365;
        Wind_Counter = Wind_Counter / 365;
    elseif ((Hospital_sz(1) > 24) && (Hospital_sz(1) < 8760))
        if ((month == 1)||(month == 3)||(month == 5)||(month == 7)||...
            (month == 8)||(month == 10)||(month == 12))
            PV_Counter = PV_Counter / 31;
            Wind_Counter = Wind_Counter / 31;
        elseif (month == 2)
            PV_Counter = PV_Counter / 28;
            Wind_Counter = Wind_Counter / 28;
        else
            PV_Counter = PV_Counter / 30;
            Wind_Counter = Wind_Counter / 30;
        end
    end
    if (Hospital_sz(1,1) == 8760)
        Date = 'a certain year';
    elseif (Hospital_sz(1,1) == 24)
        Date = str2double(day);
        day1 = datetime('1-Jan-2021','TimeZone','local','Format','d-MMMM');
        Date = day1 + Date -1;
        Date = string(Date);
    else
        switch month
            case 1
                Date = 'January';
            case 2
                Date = 'February';
            case 3
                Date = 'March';
            case 4
                Date = 'April';
            case 5
                Date = 'May';
            case 6
                Date = 'June';
            case 7
                Date = 'July';
            case 8
                Date = 'August';
            case 9
                Date = 'September';
            case 10
                Date = 'October';
            case 11
                Date = 'November';
            case 12
                Date = 'December';
        end
    end
    if (isequal(PV_opt, 'Default'))
        if (PV_needed == PV_needed_day)
            Storage_critical = ceil(Storage_critical/24);
            part = 'day';
            critical_PV = PV_critical_day;
        else
            Storage_critical = ceil(Storage_critical/168);
            part = 'week';
            critical_PV = PV_critical_week;
        end
    else
        Storage_critical = ceil(Storage_critical/(24*PV_days));
        part = sprintf('%g days',PV_days);
        critical_PV = PV_critical;
    end
    msg = [sprintf('The optimal number of Solar panels needed for'),...
         sprintf(' %s at %s is: %g', loc, Date, PV_needed),...
         sprintf(' with efficiency of %g%%.', PV_Eff),newline,...
         sprintf('Assuming each panel is in the size of a square '),...
         sprintf('meter, the area needed for this is: %g [m] x %g [m]',...
                          PV_area, PV_area), newline,...
         sprintf('The critical %s for PV is %s number %g.', part, part,...
                 critical_PV), newline,...
         sprintf('The critical %s for Storage is %s number %g.', part,...
                 part, Storage_critical), newline,...  
         sprintf('We used PV in full power for an average'),...
         sprintf(' of %g hours per day.', PV_Counter),newline,...      
         sprintf('In addition, We used the power of the wind for an'),...
         sprintf(' average of %g hours per day.', Wind_Counter)];
    msgbox(msg, 'PV needed');
%% print of the solution
    P_max =[(max(P(:,1))) ; (max(P(:,2))) ; (max(P(:,3))) ;...
            (max(P(:,4)))];
    S_max =[abs(max(S(:,1))) ; abs(max(S(:,2))) ; abs(max(S(:,3))) ;...
            abs(max(S(:,4))) ; abs(max(S(:,5))) ; abs(max(S(:,6))) ;...
            abs(max(S(:,7)))];
    S_sum = sum(S_max);
    
    Storage_costs = S_max(1) * Hydro_Storage + S_max(2) * CAES_Storage +...
                    S_max(3) * Sodium_sulfur_battary +...
                    S_max(4) * Lead_acid_battery +...
                    S_max(5) * Nickel_cadmium_battery +...
                    S_max(6) * Flow_batteries +...
                    S_max(7) * capacitors_capital_costs;
	M = [Hydro_Storage CAES_Storage Sodium_sulfur_battary...
         Lead_acid_battery Nickel_cadmium_battery Flow_batteries...
         capacitors_capital_costs];
    if ((mean(M) * Storage_size) < Storage_costs)
        Storage_costs = mean(M) * Storage_size;
    end
    %capital price = Construction costsor Initial capital needed
    capital_Price = max(P(:,1)) * PV_capital_cost +...
                    max(P(:,2)) * Wind_capital_cost +...
                    max(P(:,3)) * Hydro_capital_cost;
    %cost of electricity Price = Operating costs
    cost_of_electricity_Price = P(:,1) * PV_cost_of_electricity +...
                                P(:,2) * Wind_cost_of_electricity +...
                                P(:,3) * Hydro_cost_of_electricity;
    if (capital_Price == 0)
     uiwait(msgbox('There is no optimal solution for the sources costs.',...
                   'No optimization'));
    else
        optimal_sol_print(Hospital/1.1, loc, capital_Price,...
                          max(cost_of_electricity_Price), Storage_costs,...
                          P, S, S_sum, P_max, S_max, month, day,...
                          Storage_size, SOC);
    end
%% Start Over
    msg = 'Would you like to use another one?';
    Start_Over = questdlg(msg,'Another Database','Yes', 'No','Yes');
    switch Start_Over
        case 'Yes'
            Energy_Matching ();
        case 'No'
            return;
    end
end