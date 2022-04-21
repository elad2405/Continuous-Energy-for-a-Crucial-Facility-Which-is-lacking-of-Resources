function [max_vec,min_vec] = Database(max_vec, min_vec)
% accessing the database
%% Database of U.S. Hospitals
    list = {'Alaska', 'Los Angeles', 'New York', 'San Francisco', 'Texas'};
    [loc,~] = listdlg('ListString',list,'Name','Select a country',...
                      'PromptString','Select a country:', 'ListSize',...
                      [150,100]);
    loc = sum(loc);
    switch loc
        case 1
            Hospital_AK_data = readtable('RefBldgHospitalNew2004_v1.3_7.1_8A_USA_AK_FAIRBANKS2.csv');
            Hospital_AK_data = Hospital_AK_data (1:8760,:);
            [max_vec(1,1),min_vec(1,1)] = data_tables(Hospital_AK_data,...
                                                      'Alaska');
        case 2
            Hospital_LA_data = readtable('RefBldgHospitalNew2004_7.1_5.0_3B_USA_CA_LOS_ANGELES.csv');
            Hospital_LA_data = Hospital_LA_data (1:8760,:);
            [max_vec(1,2),min_vec(1,2)] = data_tables(Hospital_LA_data,...
                                                      'Los Angeles');
        case 3
            Hospital_NY_data = readtable('RefBldgHospitalNew2004_v1.3_7.1_4A_USA_MD_BALTIMORE.csv');
            Hospital_NY_data = Hospital_NY_data (1:8760,:);
            [max_vec(1,3),min_vec(1,3)] = data_tables(Hospital_NY_data,...
                                                      'New York');
        case 4
            Hospital_SF_data = readtable('RefBldgHospitalNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.csv');
            Hospital_SF_data = Hospital_SF_data (1:8760,:);
            [max_vec(1,4),min_vec(1,4)] = data_tables(Hospital_SF_data,...
                                                      'San Francisco');
        case 5
            Hospital_TX_data = readtable('RefBldgHospitalNew2004_v1.3_7.1_2A_USA_TX_HOUSTON.csv');
            Hospital_TX_data = Hospital_TX_data (1:8760,:);
            [max_vec(1,5),min_vec(1,5)] = data_tables(Hospital_TX_data,...
                                                      'Texas');
        case 15
            Hospital_AK_data = readtable('RefBldgHospitalNew2004_v1.3_7.1_8A_USA_AK_FAIRBANKS2.csv');
            Hospital_AK_data = Hospital_AK_data (1:8760,:);
            [max_vec(1,1),min_vec(1,1)] = data_tables(Hospital_AK_data,...
                                                      'Alaska');
            Hospital_LA_data = readtable('RefBldgHospitalNew2004_7.1_5.0_3B_USA_CA_LOS_ANGELES.csv');
            Hospital_LA_data = Hospital_LA_data (1:8760,:);
            [max_vec(1,2),min_vec(1,2)] = data_tables(Hospital_LA_data,...
                                                      'Los Angeles');
            Hospital_NY_data = readtable('RefBldgHospitalNew2004_v1.3_7.1_4A_USA_MD_BALTIMORE.csv');
            Hospital_NY_data = Hospital_NY_data (1:8760,:);
            [max_vec(1,3),min_vec(1,3)] = data_tables(Hospital_NY_data,...
                                                      'New York');
            Hospital_SF_data = readtable('RefBldgHospitalNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.csv');
            Hospital_SF_data = Hospital_SF_data (1:8760,:);
            [max_vec(1,4),min_vec(1,4)] = data_tables(Hospital_SF_data,...
                                                      'San Francisco');
            Hospital_TX_data = readtable('RefBldgHospitalNew2004_v1.3_7.1_2A_USA_TX_HOUSTON.csv');
            Hospital_TX_data = Hospital_TX_data (1:8760,:);
            [max_vec(1,5),min_vec(1,5)] = data_tables(Hospital_TX_data,...
                                                      'Texas');
            return;
        case 0
            return;
        otherwise
            disp('Error! Not in database, try again');
    end
%% Start Over
    if (loc ~= 15)
        msg = 'Would you like to use another one?';
        Start_Over = questdlg(msg,'Another Database','Yes', 'No','Yes');
        switch Start_Over
            case 'Yes'
            [max_vec, min_vec] = Database(max_vec, min_vec);
            case 'No'
                return;
        end
    end
end