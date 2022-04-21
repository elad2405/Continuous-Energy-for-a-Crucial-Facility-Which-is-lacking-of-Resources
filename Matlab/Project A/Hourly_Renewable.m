function Hourly_Renewable (data_usage)
% this function made for hourly analsys with our renewable sources
    [Hospital, loc, Wind, Solar, month, day, number_of_sources,...
     Power_limit, B, data_usage, Water] = Ask_Hourly(data_usage);
     if ((data_usage == 0) || (Power_limit == 0))
        return;
     end
%% Renewable hours claculation
    Wind_sz = size(Wind);
    Hours_of_sources = 0;
    for i=1:Wind_sz
        if (Wind(i,1) >= 6)
            Hours_of_sources = Hours_of_sources + 1; 
        elseif (Solar(i,1) >= 2)
            Hours_of_sources = Hours_of_sources + 1;
        end
    end
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
    Flow_batteries = 475 * 1e3; %[$/MWh]
    capacitors_capital_costs = 2000 *1e3; %[$/MW]
    capacitors_cost_of_electricity = 10000 * 1e3; %[$/MWh]
%% Storage limits
    [number_of_storage, Storage_Power_limit, B_Storage] =...
                                                   Hourly_Storage_limits();
    if ((Storage_Power_limit == 0))
        return;
    end
    Hospital_max = max(Hospital * 1.1);
    Storage_sum = 0;
%% Optimization - Economic Dispatch
    %solving the economic dispatch problem. 
    opt =@(x, y, z) Hourly_opt_Renewable(x * 1.1, x * 0.9, y, z,...
                                         number_of_sources, B, Water,...
                                         Power_limit, number_of_storage,...
                                         Storage_Power_limit, B_Storage,...
                                         Hospital_max, Storage_sum);
    [P, S, SOC] = ...
                arrayfun(opt, Hospital, Wind, Solar,'UniformOutput',false);
    SOC = (cell2mat(SOC))';
    Storage_sum = sum(SOC);
    P = (cell2mat(P'))';
    S = (cell2mat(S'))';
    for i=1:Wind_sz
        if (P(i,4) > 0)
            Hours_of_sources = Hours_of_sources + 1;
        end
    end
    %% SOC
    SOC_sz = size(SOC);
    for i = 2:SOC_sz(2)
        if (i>2)
            if (SOC(1,(i-1)) ~= SOC(1,(i-2)))
                SOC(1,i) = SOC(1,(i-1)) + SOC(1,i);
            end
        else
            if (SOC(1,(i-1)) ~= 0)
                SOC(1,i) = SOC(1,(i-1)) + SOC(1,i);
            end
        end
    end
    SOC = Storage_sum - SOC;
    while (min(SOC) > 0.5*Storage_sum)
        SOC = SOC - 0.5 * Storage_sum;
        Storage_sum = 0.5 * Storage_sum;
    end
    SOC = Storage_sum - SOC;
    SOC2 = zeros(1,SOC_sz(2));
    SOC2(1,1) = SOC(1,1);
    for i = 2:SOC_sz(2)
        if ((SOC(1,i) >= 0) && (P(i,4) < 0))
            SOC2(1,i) = SOC2(1,i-1) - Storage_sum/Hours_of_sources;
        else
            SOC2(1,i) = SOC(1,i);
        end
        if (P(i,1) > 0)
            P(i,1) = P(i,1) - Hospital_max + Storage_sum/Hours_of_sources;
        end
        if (P(i,2) > 0)
            P(i,2) = P(i,2) - Hospital_max + Storage_sum/Hours_of_sources;
        end
        if (P(i,3) > 0)
            P(i,3) = P(i,3) - Hospital_max + Storage_sum/Hours_of_sources;
        end
        if (P(i,4) < 0)
            P(i,4) = - Storage_sum/Hours_of_sources;
            number_of_storage_needed = 0;
            for j = 1:number_of_storage
                if (S(i,j) == -Hospital_max)
                    number_of_storage_needed = number_of_storage_needed+1;
                end
            end    
        end
        for j = 1:number_of_storage
            if (S(i,j) == -Hospital_max)
                S(i,j) = -Storage_sum/Hours_of_sources/number_of_storage_needed;
            end
        end
    end
    SOC = Storage_sum - SOC2;
    %% continue
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
                    S_max(7) * (capacitors_capital_costs +...
                                capacitors_cost_of_electricity);
	M = [Hydro_Storage CAES_Storage Sodium_sulfur_battary...
         Lead_acid_battery Nickel_cadmium_battery Flow_batteries...
         (capacitors_capital_costs+capacitors_cost_of_electricity)];
    if ((mean(M) * Storage_sum) < Storage_costs)
        Storage_costs = mean(M) * Storage_sum;
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
        optimal_sol_print(Hospital, loc, capital_Price,...
                          max(cost_of_electricity_Price), Storage_costs,...
                           P, S, S_sum, P_max, S_max, month, day,...
                           Storage_sum, (SOC/max(SOC)*100));
    end
    %% Start Over
    msg = 'Would you like to use another one?';
    Start_Over = questdlg(msg,'Another Database','Yes', 'No','Yes');
    switch Start_Over
        case 'Yes'
            Hourly_Renewable (data_usage);
        case 'No'
            return;
    end
end