function B = B_def(i, B)
%define the B vector for the economic dispatch problem (upper and lower
%limits of the problem and which sources to update).
    list = {'Solar', 'Wind', 'Hydro', 'Storage'};
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
                B = B_def(i, B);
                return;
            end
            msg1 = 'What is the upper limit of the power of Solar?';
            msg2 = 'What is the bottom limit of the power of Solar?';
            B_new = inputdlg({msg1,msg2});
            B_new = str2double(B_new);
            B(1,1) = B_new(1);
            B(1,5) = -1*B_new(2);
            if (B(1,1) == 0)
                uiwait(msgbox ('Error! not a valid answer. Try again.'));
                B = B_def(i, B);
                return;
            end 
        case 2
            if (B(1,2) ~= 0)
                uiwait(msgbox('already updated'));
                B = B_def(i, B);
                return;
            end
            msg1 = 'What is the upper limit of the power of Wind?';
            msg2 = 'What is the bottom limit of the power of Wind?';
            B_new = inputdlg({msg1,msg2});
            B_new = str2double(B_new);
            B(1,2) = B_new(1);
            B(1,6) = -1*B_new(2);
            if (B(1,2) == 0)
                uiwait(msgbox ('Error! not a valid answer. Try again.'));
                B = B_def(i, B);
                return;
            end 
        case 3
            if (B(1,3) ~= 0)
                uiwait(msgbox('already updated'));
                B = B_def(i, B);
                return;
            end
            msg1 = 'What is the upper limit of the power of Hydro?';
            msg2 = 'What is the bottom limit of the power of Hydro?';
            B_new = inputdlg({msg1,msg2});
            B_new = str2double(B_new);
            B(1,3) = B_new(1);
            B(1,7) = -1*B_new(2);
            if (B(1,3) == 0)
                uiwait(msgbox ('Error! not a valid answer. Try again.'));
                B = B_def(i, B);
                return;
            end 
        case 4
            if (B(1,4) ~= 0)
                uiwait(msgbox('already updated'));
                B = B_def(i, B);
                return;
            end
            msg1 = 'What is the upper limit of the power of Storage?';
            msg2 = 'What is the bottom limit of the power of Storage?';
            B_new = inputdlg({msg1,msg2});
            B_new = str2double(B_new);
            B(1,4) = B_new(1);
            B(1,8) = -1*B_new(2);
            if (B(1,4) == 0)
                uiwait(msgbox ('Error! not a valid answer. Try again.'));
                B = B_def(i, B);
                return;
            end 
        otherwise
            uiwait(msgbox ('Error! not a valid answer. Try again.'));
            B = B_def(i, B);
            return;
    end
    if (i > 1)
        B = B_def(i-1, B);
    else
        return;
    end
end