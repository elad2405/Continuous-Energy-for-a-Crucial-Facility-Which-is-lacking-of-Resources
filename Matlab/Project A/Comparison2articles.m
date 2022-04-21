function Comparison2articles()
%% initialize
acc = 262800;
% int = 2.311 / 100;
int2 = linspace(-10,10,9)/100;
trans_A = zeros(1,5);
trans_B = zeros(1,5);

Op_cost_Project = zeros(1,acc);
Op_cost_A = zeros(1,acc);
Op_cost_B = zeros(1,acc);
Project_cost = zeros(1,acc);
A_cost = zeros(1,acc);
B_cost = zeros(1,acc);
%% costs
figure;
for k=1:9
    alpha = 1 + (int2(k)/8760); %value of money

    Capital_Project = 106.86548;
    Capital_A = 33.827;
    Capital_B = 27.7;

    Op_cost_Project(1) = 1.1353/8760;
    Op_cost_A(1) = 7.856/8760;
    Op_cost_B(1) = 17.32/8760;

    Project_cost(1) = Capital_Project + Op_cost_Project(1);
    A_cost(1) = Capital_A + Op_cost_A(1);
    B_cost(1) = Capital_B + Op_cost_B(1);
    % Calculations
    time = linspace(1,30,acc);
    for i = 2:acc
        Op_cost_Project(i) = Op_cost_Project(i-1) * alpha;
        Op_cost_A(i) = Op_cost_A(i-1) * alpha;
        Op_cost_B(i) = Op_cost_B(i-1) * alpha;

        Project_cost(i) = Project_cost(i-1) + Op_cost_Project(i);
        A_cost(i) = A_cost(i-1) + Op_cost_A(i);
        B_cost(i) = B_cost(i-1) + Op_cost_B(i);

        if (Project_cost(i) == A_cost(i)) ||...
           ((Project_cost(i) < A_cost(i))&&(Project_cost(i-1) > A_cost(i-1)))
            year = floor(time(i));
            month = floor((time(i) - year) * 12);
            day = floor((time(i) - year) * 365);
            for j = 1:month
                if (j==1)||(j==3)||(j==5)||(j==7)||...
                   (j==8)||(j==10)||(j==12)
                    day = day - 31;
                elseif j == 2
                    day = day - 28;
                else
                    day = day - 30;
                end
            end
            hour = floor((time(i) - year) * 8760);
            hour = hour - 24*floor(hour/24);
            trans_A = [year, month,day,hour,i];
        elseif (Project_cost(i) == B_cost(i)) ||...
           ((Project_cost(i) < B_cost(i))&&(Project_cost(i-1) > B_cost(i-1)))
            year = floor(time(i));
            month = floor((time(i) - year) * 12);
            day = floor((time(i) - year) * 365);
            for j = 1:month
                if (j==1)||(j==3)||(j==5)||(j==7)||...
                   (j==8)||(j==10)||(j==12)
                    day = day - 31;
                elseif j == 2
                    day = day - 28;
                else
                    day = day - 30;
                end
            end
            hour = floor((time(i) - year) * 8760);
            hour = hour - 24*floor(hour/24);
            trans_B = [year, month,day,hour,i];
        end
    end
    % Prints
    msg = [sprintf('Our Project wiil be more beneficial than article A'),...
           sprintf(' after %g years, %g month, %g days and %g hours.',...
                   trans_A(1),trans_A(2),trans_A(3),trans_A(4)),newline,...
           sprintf('Our Project wiil be more beneficial than article B'),...
           sprintf(' after %g years, %g month, %g days and %g hours.\n',...
                   trans_B(1),trans_B(2),trans_B(3),trans_B(4))];
    msgbox(msg,'Comparison summary');
    % Graphs
        hold all;
%         if k == 5
%             figure;
%         elseif k == 9
%             figure;
%         elseif k == 13
%             figure;
%         elseif k == 17
%             figure;
%         end
%         if (k < 5)
%             subplot(3,3,k);
%         elseif (k < 9)
%             subplot(2,2,(k-4));
%         elseif (k < 13)
%             subplot(2,2,(k-8));
%         elseif (k < 17)
%             subplot(2,2,(k-12));
%         else
%             subplot(2,2,(k-16));
%         end
        subplot(3,3,k);
        hold on;
        plot(time,Project_cost);
        if (trans_A(5) ~= 0)
            plot(time,A_cost,'o-','MarkerIndices',trans_A(5));
        else
            plot(time,A_cost);
        end
        if (trans_B(5) ~= 0)
            plot(time,B_cost,'o-','MarkerIndices',trans_B(5));
        else
            plot(time,B_cost);
        end
        xlabel('Year');
        ylabel('Total Cost [M$]');
        title(['\alpha = ',num2str(int2(k)+1)]);
        sgtitle('Total cost of the optimizations');
        legend('Our optimization','Article A','Article B');
end
end