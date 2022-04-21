function B = Hourly_Wind_Solar (Wind, Solar, B)
% seeting restrictions for disabling wind and solar
if (Wind < 6)
    B(1,2) = 0; % Wind
    B(1,6) = 0; % Wind
end
if (Solar < 2)
    B(1,1) = 0; % Solar
    B(1,5) = 0; % Solar
end

end