function [P, S, Storage_sum] = Hourly_opt_Renewable(P_max, P_min, Wind, Solar,...
                                       number_of_sources, B, Water,...
                                       Power_limit, number_of_storage,...
                                       Storage_Power_limit, B_Storage,...
                                       total_max, Storage_sum)
% This function made for optimise hourly analsys with out renewable sources
    %% Renewable costs
    % average costs of Renewable sources. converted to MW and MWh.
    PV_cost_of_electricity = 43; %[$/MWh]
    Wind_cost_of_electricity = 50; %[$/MWh]
    Hydro_cost_of_electricity = 63.9; %[$/MWh]
    %% Storage costs
    % average costs of Storage sources. converted to MW and MWh.
    [Storage_costs, S] = Hourly_Storage (P_max, P_min, number_of_storage,...
                                         Water, Storage_Power_limit,...
                                         B_Storage);
                                     
	% Beacause we are loading the storage when it isnt in use, we adding
    % the cost of it to the cost of the renewable cost. We will take half
    % of the cost of storage.
    PV_cost_of_electricity = PV_cost_of_electricity + 0.5 * Storage_costs; %[$/MWh]
    Wind_cost_of_electricity =  Wind_cost_of_electricity + ...
                                0.5 * Storage_costs; %[$/MWh]
    Hydro_cost_of_electricity =  Hydro_cost_of_electricity +...
                                 0.5 * Storage_costs; %[$/MWh]
    %% Optimization - Economic Dispatch
    %solving the economic dispatch problem.
    if (number_of_sources > 0)
        P_min = P_min / number_of_sources;
    else %no optimiztion for 0 sources.
        fprintf ('Can not do optimiztion. returning to main\n');
        return;
    end
    
    A_1 = eye(4);
    A = [A_1; -1*A_1];% A*P<=B
    if (Power_limit == 'N')
        B_ub = (P_max + total_max) * ones(1,4);
        B_ub(1,4) = P_max;
        B_lb = -1 * P_min * zeros(1, 4);
        B_lb(1,4) = total_max;
        B = [B_ub,B_lb];
        if (Water == 'N')
            B(1,3) = 0;
            B(1,7) = 0;
        end
    elseif (Power_limit == 'Y')
        B(1,4) = P_max;
        B(1,8) = total_max;
        if (Water == 'N')
            B(1,3) = 0;
            B(1,7) = 0;
        end
    end
    B = Hourly_Wind_Solar (Wind, Solar, B);
    f = [PV_cost_of_electricity, Wind_cost_of_electricity,...
         Hydro_cost_of_electricity, Storage_costs];%f*x - cost function
    Aeq = ones(1,4);%Aeq*P=Beq
    Beq = P_max;
    options = optimoptions('linprog','Display','none');
    [P, ~, exitflag] = linprog(f,A,B,Aeq,Beq,[],[],options);
    if (exitflag ~= 1)
        P = zeros(4,1);
    end
    if (P(4,1) == 0)
        S = zeros(7,1);
    elseif (P(4,1) < 0)
        for i = 1:number_of_storage
            if (S(i) ~= 0)
                S(i) = -1 * total_max;
            end
        end
    else
        Storage_sum = Storage_sum + P(4,1);
    end
end