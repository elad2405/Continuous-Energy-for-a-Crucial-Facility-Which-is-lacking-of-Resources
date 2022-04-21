function B = B_Storage_def(i, B)
%define the B vector for the economic dispatch problem (upper and lower
%limits of the problem and which storage to update).
    list = {'Hydro', 'CAES', 'Sodium sulfur battary',...
            'Lead acid battery', 'Nickel cadmium battery',...
            'Flow_batteries', 'Capacitors'};
    [source,tf] = listdlg('ListString',list, 'PromptString',...
                      'Which one do you like to use?',...
                      'ListSize',[150,100], 'SelectionMode', 'single');
    source = sum(source);
    if (tf == 0)
        source = 0;
    end
    switch source
        case 1
            if (B(1,1) ~= 0)
                uiwait(msgbox('already updated'));
                B = B_Storage_def(i, B);
                return;
            end
            msg1 = 'What is the upper limit of the power of Hydro?';
            msg2 = 'What is the bottom limit of the power of Hydro?';
            B_new = inputdlg({msg1,msg2});
            B_new = str2double(B_new);
            B(1,1) = B_new(1);
            B(1,8) = -1*B_new(2);
            if (B(1,1) == 0)
                uiwait(msgbox ('Error! not a valid answer. Try again.'));
                B = B_Storage_def(i, B);
                return;
            end 
        case 2
            if (B(1,2) ~= 0)
                uiwait(msgbox('already updated'));
                B = B_Storage_def(i, B);
                return;
            end
            msg1 = 'What is the upper limit of the power of CAES?';
            msg2 = 'What is the bottom limit of the power of CAES?';
            B_new = inputdlg({msg1,msg2});
            B_new = str2double(B_new);
            B(1,2) = B_new(1);
            B(1,9) = -1*B_new(2);
            if (B(1,2) == 0)
                uiwait(msgbox ('Error! not a valid answer. Try again.'));
                B = B_Storage_def(i, B);
                return;
            end 
        case 3
            if (B(1,3) ~= 0)
                uiwait(msgbox('already updated'));
                B = B_Storage_def(i, B);
                return;
            end
            msg1 = ['What is the upper limit of the power of ',...
                    'Sodium sulfur battary?'];
            msg2 = ['What is the bottom limit of the power of ',...
                    'Sodium sulfur battary?'];
            B_new = inputdlg({msg1,msg2});
            B_new = str2double(B_new);
            B(1,3) = B_new(1);
            B(1,10) = -1*B_new(2);
            if (B(1,3) == 0)
                uiwait(msgbox ('Error! not a valid answer. Try again.'));
                B = B_Storage_def(i, B);
                return;
            end 
        case 4
            if (B(1,4) ~= 0)
                uiwait(msgbox('already updated'));
                B = B_Storage_def(i, B);
                return;
            end
            msg1 = ['What is the upper limit of the power of ',...
                    'Lead acid battery?'];
            msg2 = ['What is the bottom limit of the power of ',...
                    'Lead acid battery?'];
            B_new = inputdlg({msg1,msg2});
            B_new = str2double(B_new);
            B(1,4) = B_new(1);
            B(1,11) = -1*B_new(2);
            if (B(1,4) == 0)
                uiwait(msgbox ('Error! not a valid answer. Try again.'));
                B = B_Storage_def(i, B);
                return;
            end 
        case 5
            if (B(1,5) ~= 0)
                uiwait(msgbox('already updated'));
                B = B_Storage_def(i, B);
                return;
            end
            msg1 = ['What is the upper limit of the power of ',...
                    'Nickel cadmium battery?'];
            msg2 = ['What is the bottom limit of the power of ',...
                    'Nickel cadmium battery?'];
            B_new = inputdlg({msg1,msg2});
            B_new = str2double(B_new);
            B(1,5) = B_new(1);
            B(1,12) = -1*B_new(2);
            if (B(1,5) == 0)
                uiwait(msgbox ('Error! not a valid answer. Try again.'));
                B = B_Storage_def(i, B);
                return;
            end 
        case 6
            if (B(1,6) ~= 0)
                uiwait(msgbox('already updated'));
                B = B_Storage_def(i, B);
                return;
            end
            msg1 = ['What is the upper limit of the power of ',...
                    'Flow batteries?'];
            msg2 = ['What is the bottom limit of the power of ',...
                'Flow batteries?'];
            B_new = inputdlg({msg1,msg2});
            B_new = str2double(B_new);
            B(1,6) = B_new(1);
            B(1,13) = -1*B_new(2);
            if (B(1,6) == 0)
                uiwait(msgbox ('Error! not a valid answer. Try again.'));
                B = B_Storage_def(i, B);
                return;
            end 
        case 7
            if (B(1,7) ~= 0)
                uiwait(msgbox('already updated'));
                B = B_Storage_def(i, B);
                return;
            end
            msg1 = 'What is the upper limit of the power of Capacitors?';
            msg2 = 'What is the bottom limit of the power of Capacitors?';
            B_new = inputdlg({msg1,msg2});
            B_new = str2double(B_new);
            B(1,7) = B_new(1);
            B(1,14) = -1*B_new(2);
            if (B(1,7) == 0)
                uiwait(msgbox ('Error! not a valid answer. Try again.'));
                B = B_Storage_def(i, B);
                return;
            end 
        otherwise
            msgbox ('Error! not a valid answer. Try again.');
            B = B_Storage_def(i, B);
    end
    
    if (i > 1)
        B = B_Storage_def(i-1, B);
    else
        return;
    end
end