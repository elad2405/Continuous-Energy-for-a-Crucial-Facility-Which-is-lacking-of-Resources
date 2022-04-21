function [Hospital, loc, Wind, Solar, month, day] = Hourly_Data(data_usage)
% this function made for getting the data for the hourly analysis
%% Database of U.S. Hospitals
    list = {'Alaska', 'Los Angeles', 'New York', 'San Francisco', 'Texas'};
    [loc,tf] = listdlg('ListString',list,'Name','Select a country',...
                       'PromptString','Choose one of this states:',...
                       'ListSize',[150,100], 'SelectionMode', 'Single');
    if (tf == 0)
        loc = 0;
    end
    switch loc
        case 1
            Hospital_AK_data = readtable('RefBldgHospitalNew2004_v1.3_7.1_8A_USA_AK_FAIRBANKS2.csv');
            Hospital = table2array(Hospital_AK_data (1:8760,12));
            Weather_Data = readtable('AK_Wind_iridiance.csv',...
                                     'ReadVariableNames',false);
            Wind = table2array(Weather_Data (1:8760,2));
            Solar = table2array(Weather_Data (1:8760,3));
            loc = 'Alaska';
        case 2
            Hospital_LA_data = readtable('RefBldgHospitalNew2004_7.1_5.0_3B_USA_CA_LOS_ANGELES.csv');
            Hospital = table2array(Hospital_LA_data (1:8760,12));
            Weather_Data = readtable('LA_Wind_iridiance.csv',...
                                     'ReadVariableNames',false);
            Wind = table2array(Weather_Data (1:8760,2));
            Solar = table2array(Weather_Data (1:8760,3));
            loc = 'Los Angeles';
        case 3
            Hospital_NY_data = readtable('RefBldgHospitalNew2004_v1.3_7.1_4A_USA_MD_BALTIMORE.csv');
            Hospital = table2array(Hospital_NY_data (1:8760,12));
            Weather_Data = readtable('NY_Wind_iridiance.csv',...
                                     'ReadVariableNames',false);
            Wind = table2array(Weather_Data (1:8760,2));
            Solar = table2array(Weather_Data (1:8760,3));
            loc = 'New York';
        case 4
            Hospital_SF_data = readtable('RefBldgHospitalNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.csv');
            Hospital = table2array(Hospital_SF_data (1:8760,12));
            Weather_Data = readtable('SF_Wind_iridiance.csv',...
                                     'ReadVariableNames',false);
            Wind = table2array(Weather_Data (1:8760,2));
            Solar = table2array(Weather_Data (1:8760,3));
            loc = 'San Francisco';
        case 5
            Hospital_TX_data = readtable('RefBldgHospitalNew2004_v1.3_7.1_2A_USA_TX_HOUSTON.csv');
            Hospital = table2array(Hospital_TX_data (1:8760,12));
            Weather_Data = readtable('TX_Wind_iridiance.csv',...
                                     'ReadVariableNames',false);
            Wind = table2array(Weather_Data (1:8760,2));
            Solar = table2array(Weather_Data (1:8760,3));
            loc = 'Texas';

        otherwise
            Hospital = -1;
            loc = 0;
            Wind = 0;
            Solar = 0;
            month = 0;
            day = 0;
            return;
    end
%% Choose time for analysis
    msg = ['Do you want an analysis for a specific day or a ',...
            'specific month or for a whole year?'];
    time = questdlg(msg,'Time','Day', 'Month','Year', 'Day');
switch time
    case 'Day'
        msg = ['Which format of a day do you want to enter? number',...
               ' of a day or date as DD-MM?:'];
        day_format = questdlg(msg,'Date format','Number', 'Date(DD-MM)',...
                              'Number');
        switch day_format 
            case 'Number'
                msg = ['Which day do you want to analyze? ',...
                       '(Enter a number from 1 to 365):'];
                prompt = {msg};
                day = inputdlg(prompt, 'Day input');
                day = str2double(day);
                if (isempty(day))
                    day = -1;
                end
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
                day = inputdlg(msg, 'Day input');
                if (isempty(day))
                    day = '00-00';
                end
                day = [day,'-2021'];
                day1 = '01-Jan-2021';
                if (~strcmp(day, '00-00-2021'))
                    day = datenum((join(string(day))),'dd-mm-yyyy')...
                          - datenum(day1) + 1;
                else
                    day = -1;
                end
                  
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
        [month,tf] = listdlg('ListString', list,'Name','Select month',...
                             'PromptString',...
                             'Which month do you want to analyze?',...
                            'ListSize',[150,100],'SelectionMode','Single');
        if(tf == 0)
            month = 0;
        end
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
                uiwait(msgbox('Try again.'));
                [Hospital, loc, Wind, Solar, month, day] =...
                    Hourly_Data(data_usage);
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