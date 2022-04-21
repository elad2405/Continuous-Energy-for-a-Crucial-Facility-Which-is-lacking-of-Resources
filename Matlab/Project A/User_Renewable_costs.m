function [Storage_num, Storage_costs, Renewable_costs] =...
                              User_Renewable_costs(Renewable_database_size)
% this function collects from the user a databse of costs for the renewable
% sources and storage.
    %% Renewable and storage costs
    Storage_costs = 0;
    msg = 'How many of them are storage sources?';
    Storage_num = str2double(inputdlg(msg,'Number of storage sources'));
    if (isempty(Storage_num))
        Storage_num = 0;
        Storage_costs = 0;
    end
    if (Storage_num > 0)
        if (Storage_num < Renewable_database_size)
            Storage_costs = zeros(1, Storage_num);
            for i=1:Storage_num
                msg = ['Enter the cost of storage source',...
                       sprintf(' number %g ', i), 'in MW or MWh:'];
                Storage_costs(1,i) = str2double(inputdlg(msg,...
                                                       'Cost of storage'));
            end
        else
            msg = ['Error! the number of storage sources is beeger ',...
                   'than the number of renewable source.',...
                   'Enter a new number of storage sources. (the ',...
                   sprintf('maximum number avilabe is %g)\n',...
                           Renewable_database_size)];
            uiwait(msgbox(msg,'Error'));
            [Storage_num, Storage_costs, Renewable_costs] =...
                             User_Renewable_costs(Renewable_database_size);
            return;
        end
    end
    Renewable_costs = zeros(1, (Renewable_database_size - Storage_num));
    for i=1:(Renewable_database_size - Storage_num)
        msg = [sprintf('Enter the cost of renewable source number %g ',...
                        i), 'in MW or MWh:'];
        cost = str2double(inputdlg(msg,'Cost of renewable sources'));
        if (isempty(cost))
            cost = 0;
        end
        Renewable_costs(1,i) = cost;
    end
end