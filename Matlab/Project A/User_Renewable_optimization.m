function User_Renewable_optimization(P_max, P_min, number_of_storage,...
                                     Storage_costs, Renewable_costs,...
                                     Renewable_database_size, loc)
%this function making optimization from the user database of renewable and
%storage costs.
%% Storage optimization
%solving the economic dispatch problem.
if (number_of_storage > 0)
    P_min = P_min / number_of_storage;
    A_1 = eye(number_of_storage);
    A = [A_1; -1*A_1];% A*P<=B
    B_ub = P_max*ones(1, number_of_storage);
    B_lb = -1*P_min*ones(1, number_of_storage);
    B = [B_ub,B_lb];
    msg = 'Do you have a limit on power of the storage?';
    Power_limit = questdlg(msg,'Power limit', 'Yes', 'No', 'No');
    switch Power_limit
        case 'Yes'
%if the user want to choose upper and bottom limits for the power storage
            for i=1:number_of_storage
                msg1 = ['What is the upper limit of the power of the',...
                       sprintf(' storage number %g?',i)];
                msg2 = ['What is the bottom limit of the power of the ',...
                       sprintf('storage number %g?',i)];
                B_new = str2double(inputdlg({msg1, msg2},'Limits'));
                B(1,i) = B_new(1);
                B(1,(i+number_of_storage)) = -1 * B_new(2);
            end
        case 'No'
    end
    f = Storage_costs; %f*x - cost function
    Aeq = ones(1, number_of_storage); %Aeq*P=Beq
    Beq = P_max;
    options = optimoptions('linprog','Display','none');
    [S, ~, exitflag] = linprog(f,A,B,Aeq,Beq,[],[],options);
%price = storage price by the solution of the ecnomin dispatch problem
    if(exitflag == 1)
        Storage_Price = Storage_costs * S;
%% Print costs of storage
        msg = sprintf('Analysis for %s:',loc);
        msg1 = sprintf('The Storage cost is: %g [M$].',...
                       Storage_Price/1e6);
        msg2 = sprintf('We used for this calculation:');
        for i=1:number_of_storage
            msg3 = [sprintf('%g [MW]', abs(S(i))),...
                    sprintf(' of Storage number %g', i)];
            msgbox({msg, msg1,msg2,msg3},sprintf('Storage number %g', i));
        end
    else
         msgbox({sprintf('Analysis for %s:',loc),...
                 'There is no optimal solution for the storage costs.'},...
                 'No optimization');
    end
end

%% Renewable sources optimization
%solving the economic dispatch problem.
number_of_renewable = Renewable_database_size-number_of_storage;
if (number_of_renewable > 0)
    if (number_of_storage>0)
        P_min = P_min / (number_of_renewable+1);
        A_1 = eye(number_of_renewable + 1);
        A = [A_1; -1*A_1];% A*P<=B
        B_ub = P_max*ones(1, (number_of_renewable+1));
        B_lb = -1*P_min*ones(1, (number_of_renewable+1));
        B = [B_ub,B_lb];
        msg = 'Do you have a limit on power of the sources?';
        Power_limit = questdlg(msg,'Power limit','Yes','No','No');
        switch Power_limit
            case 'Yes'
%if the user want to choose upper and bottom limits for the power storage
                for i=1:(number_of_renewable+1)
                    msg1 = ['What is the upper limit of the power of',...
                            sprintf(' the source number %g?',i)];
                    msg2 = ['What is the bottom limit of the power ',...
                            sprintf('of the source number %g?',i)];
                    B_new = str2double(inputdlg({msg1, msg2},'Limits'));
                    B(1,i) = B_new(1);
                    B(1,(i+number_of_renewable+1)) = -1 * B_new(2);
                end
            case 'No'        
        end
        f = [Renewable_costs, Storage_Price]; %f*x - cost function
        Aeq = ones(1, (number_of_renewable+1)); %Aeq*P=Beq
        Beq = P_max;
    else
        P_min = P_min / number_of_renewable;
        A_1 = eye(number_of_renewable);
        A = [A_1; -1*A_1];% A*P<=B
        B_ub = P_max*ones(1, number_of_renewable);
        B_lb = -1*P_min*ones(1, number_of_renewable);
        B = [B_ub,B_lb];
        msg = 'Do you have a limit on power of the sources?';
        Power_limit = questdlg(msg,'Power limit','Yes','No','No');
        switch Power_limit
            case 'Yes'
%if the user want to choose upper and bottom limits for the power storage
                for i=1:number_of_renewable
                    msg1 = ['What is the upper limit of the power ',...
                            sprintf('of the source number %g?',i)];
                    msg2 = ['What is the bottom limit of the power ',...
                            sprintf('of the source number %g?',i)];
                    B_new = str2double(inputdlg({msg1, msg2},'Limits'));
                    B(1,i) = B_new(1);
                    B(1,(i+number_of_renewable+1)) = -1 * B_new(2);
                end
            case 'No'
        end
        f = Renewable_costs; %f*x - cost function
        Aeq = ones(1, number_of_renewable); %Aeq*P=Beq
        Beq = P_max;
    end
    
    options = optimoptions('linprog','Display','none');
    [P, ~, exitflag] = linprog(f,A,B,Aeq,Beq,[],[],options);
%price = storage price by the solution of the ecnomin dispatch problem
    if (exitflag == 1)
        Renewable_Price = f * P;
    %% Print costs of renewable sources
        msg = sprintf('Analysis for %s:',loc);
        msg1 = ['The cost for the renewable',...
                sprintf(' sources is: %g [M$]', Renewable_Price/1e6)];
        msg2 = 'We used for this calculation:';
        for i=1:number_of_renewable
            msg3 = sprintf('%g [MW] of source number %g', abs(P(i)),i);
            uiwait(msgbox({msg, msg1, msg2, msg3},'Summary'));
        end
    else
        msg = sprintf('Analysis for %s:',loc);
        msg1 = ['There is no optimal solution for the renewable sources',...
               ' costs.'];
        uiwait(msgbox({msg, msg1},'No optimization'));
    end
end
end