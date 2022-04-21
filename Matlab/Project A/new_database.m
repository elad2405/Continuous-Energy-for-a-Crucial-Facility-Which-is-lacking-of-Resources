function [max,min,Hospital_loc] = new_database()
% This function getting new database
    msg = ['The data base should be a csv file with at least 12 ',...
            'columns and at least 8760 hourly load data. ',...
            'Choose the hospital data file.'];
    uiwait(msgbox(msg,'Database instructions'));
    [file,path] = uigetfile('Data\*.csv');
    data_path = string([path, file]);
    if (path == 0)
        max = 0;
        min = 0;
        Hospital_loc = 0;
        return;
    else
        Hospital_data = readtable(data_path);
        Hospital_data = Hospital_data (1:8760,:);
        Hospital_loc = inputdlg('Insert the location of the hospital:',...
                                'Location of hospital');
        [max,min] = data_tables(Hospital_data,char(Hospital_loc));
    end
end