clearvars;
close all;
clc;

% To read the image in the form of a matrix
src_img = imread("moon.jpg");

% If the image has color channels, convert it into a grayscale image
if ndims(src_img) == 3
    src_img = rgb2gray(src_img);
end

% Convert the image into the form of a string array
input_string = string(dec2bin(src_img, 8));
input_string = reshape(input_string, [1, length(input_string)]);

% % Sample test
% n = 20000;
% input_string = string(dec2bin(zeros(1, n), 8));

% Initialize the Run_lengths array
Run_lengths = [];

% Initialize the counter & index values
index = 1;
counter = 0;

% Extract the 1st bit
bit = extract(input_string(1), 1);
for i = 1:length(input_string)
    for j =  1:strlength(input_string(1))
        
        % Increment the counter if the bit remains the same
        if(bit == extract(input_string(i), j))
            counter = counter + 1;
        % Update the Run_lengths array when the bit is not the same
        else
            Run_lengths(index) = counter;
            bit = extract(input_string(i), j);
            index = index + 1;
            counter = 1;
        end
    end
end

% Once again update the 'Run_lengths' array
Run_lengths(index) = counter;

% To get the 1st bit as a numerical value
bit = str2num(extract(input_string(1), 1));

% Create an array Extra_bits that needs to be appended to run length to get
% the codeword
Extra_bits = mod(linspace(0, length(Run_lengths) - 1, length(Run_lengths)) + bit*ones(1, length(Run_lengths)), 2);
Extra_bits = transpose(string(Extra_bits));

% Transpose to make it compatible for a string sum
Run_lengths = transpose(Run_lengths);

% Making the code
run_bits = floor(log2(max(Run_lengths))) + 1;
Code = string(dec2bin(Run_lengths, run_bits)) + Extra_bits;

% Creating a table with the set of run_lengths, symbols, code
T = table(Run_lengths, Extra_bits, Code);

% Calculating the compression_ratio
compression_ratio = (length(Run_lengths)*(run_bits + 1))/(length(input_string)*8);
disp(['Compression Ratio: ', num2str(compression_ratio)]);

% % Write the table to an excel file
% writetable(T, "RLE_binary.txt");