function [max_vec, min_vec] = Data_analysis(max_vec, min_vec)
% This function give access to our Database.
%% Ask of Use
    msg = 'Would you like to use our database?';
    data_usage = questdlg(msg,'Use Database','Yes', 'No','Yes');
    switch data_usage
    case 'Yes'
        [max_vec, min_vec] = Database(max_vec, min_vec);
    case 'No'
        return;
    end
end