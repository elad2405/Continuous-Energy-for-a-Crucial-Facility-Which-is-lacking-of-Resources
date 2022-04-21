clc;
close all;

%% Database access
% This section made for accessing our database
msg ='Would you like to see which hospitals we have in the database?';
data_list = questdlg(msg,'See Hospitals','Yes', 'No','Yes');
switch data_list
    case 'Yes'
        msg = ['Alaska (AK), Los Angeles (LA), New York (NY),',...
               'San Fransisco (SF), Texas(TX)'];
        uiwait(msgbox(msg, 'Hospitals locations','help'));
    case 'No'
end
max_vec = zeros(1,5);
min_vec = zeros(1,5);
[max_vec, min_vec] = Data_analysis(max_vec, min_vec);

max_AK = max_vec(1,1);
min_AK = min_vec(1,1);
max_LA = max_vec(1,2);
min_LA = min_vec(1,2);
max_NY = max_vec(1,3);
min_NY = min_vec(1,3);
max_SF = max_vec(1,4);
min_SF = min_vec(1,4);
max_TX = max_vec(1,5);
min_TX = min_vec(1,5);

%% Use sources
% This section made for anlysis our databse with our Renewable sources
if ((max_AK~=0) || (max_LA~=0)|| (max_NY~=0) || (max_SF~=0) || (max_TX~=0))
    if (max_AK ~=0)
        Renewable(max_AK, min_AK, 'Alaska');
    end
    if (max_LA ~=0)
        Renewable(max_LA, min_LA, 'Los Angeles');
    end
    if (max_NY ~=0)
        Renewable(max_NY, min_NY, 'New York');
    end
    if (max_SF ~=0)
        Renewable(max_SF, min_SF, 'San Fransisco');
    end
    if (max_TX ~=0)
        Renewable(max_TX, min_TX, 'Texas');
    end
end

%% Insert a database
% This section made for inserting new database
database_size = 0;
msg = 'Would you like to add a hospital to the database?';
insert_database = questdlg(msg,'Insert Database','Yes', 'No','No');
switch insert_database
    case 'Yes'
        msg = ['How many files are in the database? ',...
               'Enter a number or press 0 to quit.'];
        database_size = str2double(inputdlg(msg,'Size of database'));
        max_vec = zeros(1,database_size);
        min_vec = zeros(1,database_size);
        for i=1:database_size
            [max_vec(1,i),min_vec(1,i),Hospital_loc] = new_database();
            if((max(1,i) == 0) && (min(1,i) == 0) && (Hospital_loc == 0))
                return;
            end
        end
    case 'No'
end

%% Use sources on the User Database
% This section made for anlysis the new databse with our Renewable sources
if (database_size ~= 0)
    for i=1:database_size
        Renewable(max_vec(1,i), min_vec(1,i), string(Hospital_loc));
        if((max(1,i) == 0) && (min(1,i) == 0) && (Hospital_loc == 0))
                return;
        end
    end
end

%% Insert a Renewable costs database
% This section made for inserting new database
Renewable_database_size = 0;
msg = ['Would you like to add new costs of renewable sources to the'...
       ' database?'];
insert_database = questdlg(msg,'Insert Renewable Database', 'Yes',...
                           'No','No');
switch insert_database
    case 'Yes'
        msg = ['How many new renewable sources cost are in the ',...
               'database? (including storage sources). ',...
               'Enter a number or press 0 to quit:'];
        Renewable_database_size = str2double(inputdlg(msg,...
                                               'Renewable database size'));
        if (Renewable_database_size > 0)
            [number_of_storage, Storage_costs, Renewable_costs] =...
                                User_Renewable_costs(Renewable_database_size);
        end
    case 'No'
end

%% Use new sources
% This section made for using the new renewable costs database on our
% database
if (((max_AK~=0) || (max_LA~=0)|| (max_NY~=0) || (max_SF~=0) ||...
    (max_TX~=0)) && (Renewable_database_size~=0))
    if (max_AK ~=0)
        User_Renewable_optimization(max_AK, min_AK, number_of_storage,...
                                    Storage_costs, Renewable_costs,...
                                    Renewable_database_size, 'Alaska');
    end
    if (max_LA ~=0)
        User_Renewable_optimization(max_LA, min_LA, number_of_storage,...
                                    Storage_costs, Renewable_costs,...
                                    Renewable_database_size,'Los Angeles');
    end
    if (max_NY ~=0)
        User_Renewable_optimization(max_NY, min_NY, number_of_storage,...
                                    Storage_costs, Renewable_costs,...
                                    Renewable_database_size, 'New York');
    end
    if (max_SF ~=0)
        User_Renewable_optimization(max_SF, min_SF, number_of_storage,...
                                    Storage_costs, Renewable_costs,...
                                    Renewable_database_size,...
                                    'San Fransisco');
    end
    if (max_TX ~=0)
        User_Renewable_optimization(max_TX, min_TX, number_of_storage,...
                                    Storage_costs, Renewable_costs,...
                                    Renewable_database_size, 'Texas');
    end
end

%% Use sources on the User Database
% This section made for anlysis the new databse with the new Renewable 
%sources databse.
if ((~isempty(database_size)) && (~isempty(Renewable_database_size)))
    if ((database_size ~= 0) && (Renewable_database_size~=0))
        for i=1:database_size
            loc = sprintf('place number %g:\n', i);
            User_Renewable_optimization(max_vec(1,i), min_vec(1,i),...
                                        number_of_storage, Storage_costs,...
                                        Renewable_costs,...
                                        Renewable_database_size, loc);
        end
    end
end
%% Hourly analysis
% This section made for anlysis our databse with our Renewable sources by
% the hour.
msg = 'Would you like to do a hourly analysis with our database?';
data_usage = questdlg(msg,'Hourly analysis','Yes', 'No','No');
switch data_usage
    case 'Yes'
        data_usage = 1;
    case 'No'
        data_usage = 0;
end
Hourly_Renewable (data_usage);

%% User Hourly analysis
% This section made for anlysis the User databse with our Renewable sources
% by the hour.
msg = ['Would you like to do a hourly analysis to your database ',...
       'with our Renewable sources?'];
data_usage = questdlg(msg,'User hourly analysis','Yes', 'No','No');
switch data_usage
    case 'Yes'
        data_usage = 2;
    case 'No'
        data_usage = 0;
end
Hourly_Renewable (data_usage);

%% Final optimization
% This section made for anlysis a databse with our Renewable sources by the
% hour. This is the final optimiztion and we analyze the data according to
% everything we have learned so far.
msg = 'Would you like to do the final optimization?';
data_usage = questdlg(msg,'Final analysis','Yes', 'No','No');
switch data_usage
    case 'Yes'
        Energy_Matching ();
end

%% Thank U
msg = [sprintf('We have reached the end of the data analysis.'),newline,...
       sprintf('We hope we helped you understand them and we wish '),...
       sprintf('you success in your implementation.'),newline,...
       sprintf('                                            Thank you!');];
msgbox(msg, 'Thank U');