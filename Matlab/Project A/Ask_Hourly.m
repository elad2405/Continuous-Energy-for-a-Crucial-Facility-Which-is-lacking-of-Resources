function [Hospital, loc, Wind, Solar, month, day, number_of_sources,...
          Power_limit, B, data_usage, Water] = Ask_Hourly(data_usage)
% this function made for accessing the hourly anlysis.
% if we have the confirmation we need to identify to which function we need
% to send.
%% Ask of use
    if (data_usage == 2)
        [Hospital, loc, Wind, Solar, month, day] = User_Hourly_Data();
        if (Hospital == -1)
            number_of_sources = 0;
            Power_limit = 0;
            B = 0;
            loc = 0;
            data_usage = 0;
            Water = 'N';
            return;
        end
    elseif (data_usage == 1)
       [Hospital, loc, Wind, Solar, month, day] = Hourly_Data(data_usage);
        if (Hospital == -1)
            number_of_sources = 0;
            Power_limit = 0;
            B = 0;
            data_usage = 0;
            Water = 'N';
            return;
        end
    elseif (data_usage == 0)
        Hospital = 0;
        loc = 0;
        Wind = 0;
        Solar =0;
        month = 0;
        day = 0;
        number_of_sources = 0;
        Power_limit = 0;
        B = 0;
        Water = 'N';
        return;
    end
    Hospital = Hospital / 1e3;
    [number_of_sources, Power_limit, B] = Hourly_Renewable_limits();
    if (Power_limit == 0)
        Water = 'N';
        return;
    end
    msg = 'The location is near water source?';
    Water = questdlg(msg,'Water Source','Yes', 'No','No');
    switch Water
        case 'Yes'
            Water = 'Y';
        case 'No'
            Water = 'N';
            B(1,3) = 0;
            B(1,7) = 0;
    end
    if (number_of_sources > 4)
        return;
    end
end