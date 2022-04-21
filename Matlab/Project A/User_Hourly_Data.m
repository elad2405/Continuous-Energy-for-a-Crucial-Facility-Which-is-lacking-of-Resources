function [Hospital, loc, Wind, Solar, month, day] = User_Hourly_Data()
% this function made for getting the data for the hourly analysis from the
% user
msg1 = 'The Weather data base should be a csv file with 3 columns. ';
msg2 = ['(the first coloumn is the date, the second coloumn is the',...
        ' wind data and the third coloumn is the solar irradiation data)'];
msg3 = ' and at least 8760 hourly load data. ';
msg4 = 'The data should not have a title in the first row! ';
msg5 = 'Choose the weather data file.';
msg = [msg1, newline, msg2, newline, msg3, newline, msg4, newline,...
       msg5];
uiwait(msgbox(msg,'Weather instructions'));
[file,path] = uigetfile('Data\*.csv');
data_path = string([path, file]);
if (path == 0)
    Hospital = -1;
    loc = 0;
    Wind = 0;
    Solar = 0;
    month = 0;
    day = 0;
    return;
end
Weather_Data = readtable(data_path,'ReadVariableNames',false);
Wind = table2array(Weather_Data (1:8760,2));
Solar = table2array(Weather_Data (1:8760,3));
%% Database of U.S. Hospitals
msg1 = ['The data base should be a csv file with at least 12 columns',...
        ' and at least 8760 hourly load data.', newline];
msg2 = 'Insert the hospital data file name:';
msg = [msg1, msg2];
uiwait(msgbox(msg,'Database instructions'));
[file,path] = uigetfile('Data\*.csv');
data_path = string([path, file]);
if (path == 0)
    Hospital = -1;
    loc = 0;
    Wind = 0;
    Solar = 0;
    month = 0;
    day = 0;
    return;
end
Hospital_data = readtable(data_path);
Hospital = table2array(Hospital_data (1:8760,12));
loc = inputdlg('Insert the location of the hospital:', 'Hospital Location');
loc = string(loc);
msg = ['Do you want an analysis for a specific day or a ',...
       'specific month or for a whole year?'];
time = questdlg(msg,'Time','Day', 'Month','Year', 'Day');
switch time
    case 'Day'
        msg = ['Which format of a day do you want to enter? number',...
               ' of a day or date as DD-MM?: '];
        day_format = questdlg(msg,'Date format','Number', 'Date(DD-MM)',...
                              'Number');
        switch day_format 
            case 'Number'
                msg = ['Which day do you want to analyze? ',...
                       '(Enter a number from 1 to 365):'];
                prompt = {msg};
                day = inputdlg(prompt, 'Day input');
                day = str2double(day);
                if ((day < 366) && (day > 0))
                    Hospital = Hospital((24*(day-1)+1):(24*day), 1);
                    Wind = Wind((24*(day-1)+1):(24*day), 1);
                    Solar = Solar((24*(day-1)+1):(24*day), 1);
                    day = num2str(day);
                    month = 0;
                else
                    uiwait(msgbox('Error! Not in range, try again.',...
                                  'Error'));
                    [Hospital, loc, Wind, Solar, month, day] =...
                        Hourly_Data(data_usage);
                    return;    
                end
            case 'Date(DD-MM)'
                msg = ['Which day do you want to analyze? ',...
                       '(Enter a date):'];
                prompt = {msg};
                day = inputdlg(prompt, 'Day input');
                day = [day,'-2021'];
                day1 = '01-Jan-2021';
                day = datenum((join(string(day))),'dd-mm-yyyy')...
                      - datenum(day1) + 1;
                if ((day < 1) || (day > 365))
                    uiwait(msgbox('Error! Not in range, try again.',...
                                  'Error'));
                    [Hospital, loc, Wind, Solar, month, day] =...
                        Hourly_Data(data_usage);
                    return;    
                end
                Hospital = Hospital((24*(day-1)+1):(24*day), 1);
                Wind = Wind((24*(day-1)+1):(24*day), 1);
                Solar = Solar((24*(day-1)+1):(24*day), 1);
                day = num2str(day);
                month = 0;
        end
    case 'Month'
        day = 0;
        list = {'January', 'February', 'March', 'April', 'May', 'June',...
                'July', 'August', 'September', 'October', 'November',...
                'December'};
        [month,~] = listdlg('ListString',list,'Name','Select month',...
                            'ListSize',[150,100],'SelectionMode','Single');
        switch month
            case 1
                Hospital_month = Hospital(1:744, 1);
                Wind_month = Wind(1:744, 1);
                Solar_month = Solar(1:744, 1);
            case 2
                Hospital_month = Hospital(745:1416, 1);
                Wind_month = Wind(745:1416, 1);
                Solar_month = Solar(745:1416, 1);
            case 3
                Hospital_month = Hospital(1417:2160, 1);
                Wind_month = Wind(1417:2160, 1);
                Solar_month = Solar(1417:2160, 1);
            case 4
                Hospital_month = Hospital(2161:2880, 1);
                Wind_month = Wind(2161:2880, 1);
                Solar_month = Solar(2161:2880, 1);
            case 5
                Hospital_month = Hospital(2881:3624, 1);
                Wind_month = Wind(2881:3624, 1);
                Solar_month = Solar(2881:3624, 1);
            case 6
                Hospital_month = Hospital(3625:4344, 1);
                Wind_month = Wind(3625:4344, 1);
                Solar_month = Solar(3625:4344, 1);
            case 7
                Hospital_month = Hospital(4345:5088, 1);
                Wind_month = Wind(4345:5088, 1);
                Solar_month = Solar(4345:5088, 1);
            case 8
                Hospital_month = Hospital(5089:5832, 1);
                Wind_month = Wind(5089:5832, 1);
                Solar_month = Solar(5089:5832, 1);
            case 9
                Hospital_month = Hospital(5833:6552, 1);
                Wind_month = Wind(5833:6552, 1);
                Solar_month = Solar(5833:6552, 1);
            case 10
                Hospital_month = Hospital(6553:7296, 1);
                Wind_month = Wind(6553:7296, 1);
                Solar_month = Solar(6553:7296, 1);
            case 11
                Hospital_month = Hospital(7297:8016, 1);
                Wind_month = Wind(7297:8016, 1);
                Solar_month = Solar(7297:8016, 1);
            case 12
                Hospital_month = Hospital(8017:8760, 1);
                Wind_month = Wind(8017:8760, 1);
                Solar_month = Solar(8017:8760, 1);
            otherwise
                fprintf('Try again. \n');
                [Hospital, loc, Wind, Solar, month, day] =...
                    User_Hourly_Data(data_usage);
                return;        
        end
        Hospital = Hospital_month;
        Wind = Wind_month;
        Solar = Solar_month;
    case 'Year'
        day = 0;
        month = 0;
end
end