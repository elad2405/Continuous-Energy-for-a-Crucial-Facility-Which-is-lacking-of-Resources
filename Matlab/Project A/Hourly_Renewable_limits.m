function [number_of_sources, Power_limit, B] = Hourly_Renewable_limits()
% This function made for getting the limits for the hourly analsys with our
% storage sources
    msg = ['Enter the number of our enregey sources you would like to',...
           ' use (1-4):'];
    number_of_sources = str2double(inputdlg(msg,'Energy sources',[1 50],...
                                            {'4'}));
    B = zeros(1,8);
    if (isempty(number_of_sources))
        number_of_sources = 0;
        Power_limit = 0;
    end
    if (number_of_sources < 4 && number_of_sources > 0)
        B = B_def(number_of_sources, B);
        Power_limit = 'Y';
    elseif (number_of_sources == 4)
        msg = 'Do you have a limit on power of the sources?';
        Power_limit = questdlg(msg, 'Power limit', 'Yes', 'No', 'No');
        switch Power_limit
            case 'Yes'
%if the user want to choose upper and bottom limits for the power storage
                msg1 = 'What is the upper limit of the power of Solar?';
                msg5 = 'What is the bottom limit of the power of Solar?';
                msg2 = 'What is the upper limit of the power of Wind?';
                msg6 = 'What is the bottom limit of the power of Wind?';
                msg3 = 'What is the upper limit of the power of Hydro?';
                msg7 = 'What is the bottom limit of the power of Hydro?';
                msg4 = ['What is the upper limit of the power of the',...
                        ' Storage?'];
                msg8 = ['What is the bottom limit of the power of the',...
                        ' Storage?'];
                msg = {msg1, msg2, msg3, msg4, msg5, msg6, msg7, msg8};
                B = (str2double(inputdlg(msg,'Limits')))';
                B(1,8) = -1 * B(1,8);
                B(1,7) = -1 * B(1,7);
                B(1,6) = -1 * B(1,6);
                B(1,5) = -1 * B(1,5);
                Power_limit = 'Y';
                if ((B(1,1) == 0) && (B(1,2) == 0) && (B(1,3) == 0) &&...
                    (B(1,4) == 0) && (B(1,5) == 0) && (B(1,6) == 0) &&...
                    (B(1,7) == 0) && (B(1,8) == 0))
                    Power_limit = 'N';
                    uiwait(msgbox ('Returning to default values'));
                end
            case 'No'
                Power_limit = 'N';
        end
    else %no optimiztion for more sources then 4 or less then 0.
        uiwait(msgbox ('Can not do optimiztion. returning to main',...
                       'Error'));
        return;
    end
end