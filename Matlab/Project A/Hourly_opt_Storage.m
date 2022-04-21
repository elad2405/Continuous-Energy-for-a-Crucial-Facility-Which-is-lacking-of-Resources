function S = Hourly_opt_Storage(P_max, P_min, number_of_storage, B,...
                                Water, Power_limit)
% This function made for optimise hourly analsys with out storage sources
    %% Storage costs
    % average costs of storage sources. converted to MW and MWh.
    Hydro_Storage = 1500 * 1e3; %[$/MW]
    CAES_Storage = 650 * 1e3; %[$/MW]
    Sodium_sulfur_battary = 575 * 1e3; %[$/MWh]
    Lead_acid_battery = 1350 * 1e3; %[$/MWh]
    Nickel_cadmium_battery = 2100 * 1e3; %[$/MWh]
    Flow_batteries = 475 * 1e3; %[$/MWh]
    capacitors_cost_of_electricity = 10000 * 1e3; %[$/MWh]
    %% storage optimiztion
    %solving the economic dispatch problem.
    if (number_of_storage > 0)
        P_min = P_min / number_of_storage;
    else %no optimiztion for 0 sources.
        fprintf ('Can not do optimiztion. returning to main\n');
        return;
    end
    A_1 = eye(7);
    A = [A_1; -1*A_1];% A*P<=B
    if (Power_limit == 'N')
        B_ub = P_max * ones(1, 7);
        B_lb = -1 * P_min * zeros(1, 7);
        B = [B_ub,B_lb];
        if (Water == 'N')
            B(1,1) = 0;
            B(1,8) = 0;
        end
    end
    f = [Hydro_Storage, CAES_Storage, Sodium_sulfur_battary,...
         Lead_acid_battery, Nickel_cadmium_battery, Flow_batteries,...
         capacitors_cost_of_electricity]; %f*x - cost function
    Aeq = ones(1,7); %Aeq*P=Beq
    Beq = P_max;
    options = optimoptions('linprog','Display','none');
    [S, ~, exitflag] = linprog(f,A,B,Aeq,Beq,[],[],options);
%price = storage price by the solution of the ecnominc dispatch problem
    if (exitflag ~= 1)
        S = zeros(7,1);
    end
end