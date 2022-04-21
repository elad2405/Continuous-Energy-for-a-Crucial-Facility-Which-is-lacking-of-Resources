function [Price, S] = Hourly_Storage (P_max, P_min, number_of_storage,...
                                      Water, Power_limit, B)
% this function made for hourly analsys with our storage sources
    %% Work with this function
    if (number_of_storage > 7)
        return;
    end
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
%     opt = @(x) Hourly_opt_Storage(P_max, P_min, number_of_storage, B,...
%                                   Power_limit);
    S = Hourly_opt_Storage(P_max, P_min, number_of_storage, B,...
                           Water, Power_limit);
    Price = S(1) * Hydro_Storage + S(2) * CAES_Storage +...
            S(3) * Sodium_sulfur_battary +...
            S(4) * Lead_acid_battery +...
            S(5) * Nickel_cadmium_battery +...
            S(6) * Flow_batteries +...
            S(7) * (capacitors_capital_costs +...
                           capacitors_cost_of_electricity);
    if (Price == 0)
%         fprintf('There is no optimal solution for the storage costs.\n');
    end
end