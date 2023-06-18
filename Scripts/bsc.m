function [output] = bsc(data, p)
    output = "";
    
    for i = 1:strlength(data)
        
        % Generate a random number between 0 & 1
        x = rand;
        
        % Allot p parts of the range to flip; else transmit
        if x < p
            if extract(data, i) == "1"
                output = output + '0';
            else
                output = output + '1';
            end
        else
            output = output + extract(data, i);
        end
    end
end