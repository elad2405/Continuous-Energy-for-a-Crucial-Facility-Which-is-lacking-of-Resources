function [number_of_storage, Power_limit, B] = Hourly_Storage_limits()  
% This function made for getting the limits for the hourly analsys with our
% storage sources
    msg = ['Enter the number of our enregey storage you would like to',...
           ' use (1-7):'];
    number_of_storage = str2double(inputdlg(msg, 'Storage sources',...
                                            [1 50], {'7'}));
    B = zeros(1,14);
    if (isempty(number_of_storage))
        number_of_storage = 0;
        Power_limit = 0;
    end
    if ((number_of_storage < 7) && (number_of_storage > 0))
        B = B_Storage_def(number_of_storage, B);
        Power_limit = 'Y';
    elseif (number_of_storage == 7)
        msg = 'Do you have a limit on power of the storage?';
        Power_limit = questdlg(msg,'Power limit', 'Yes', 'No', 'No');
        switch Power_limit
            case 'Yes'
%if the user want to choose upper and bottom limits for the power storage
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
                msg7 = ['What is the upper limit of the power of',...
                        ' Capacitors?'];
                msg14 = ['What is the bottom limit of the power of',...
                         ' Capacitors?'];
                msg = {msg1, msg2, msg3, msg4, msg5, msg6, msg7, msg8,...
                       msg9, msg10, msg11, msg12, msg13, msg14};
                B = (str2double(inputdlg(msg,'Limits')))';
                B(1,14) = -1 * B(1,14);
                B(1,13) = -1 * B(1,13);
                B(1,12) = -1 * B(1,12);
                B(1,11) = -1 * B(1,11);
                B(1,10) = -1 * B(1,10);
                B(1,9) = -1 * B(1,9);
                B(1,8) = -1 * B(1,8);
                if ((B(1,1) == 0) && (B(1,2) == 0) && (B(1,3) == 0) &&...
                    (B(1,4) == 0) && (B(1,5) == 0) && (B(1,6) == 0) &&...
                    (B(1,7) == 0) && (B(1,8) == 0) && (B(1,10) == 0) &&...
                    (B(1,11) == 0) && (B(1,12) == 0) && (B(1,13) == 0)&&...
                    (B(1,14) == 0))
                    Power_limit = 'N';
                    uiwait(msgbox ('Returning to defult values'));
                end
            case 'No'
                Power_limit = 'N';
        end
    else %no optimiztion for more storage then 7.
        uiwait(msgbox ('Can not do optimiztion. returning to main',...
                       'Error'));
        return;
    end
end