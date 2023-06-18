clearvars;
close all;
clc;

% Read image file
img = imread('ITC.png');

% Convert to grayscale if color image
if ndims(img) == 3
    img = rgb2gray(img);
end

% Reshape image into 1D vector
img_vec = img(:);

% % Sample test
% img_vec = zeros(1, 20000);

% Initialize RLE variables
rl_val = [];
rl_count = [];
count = 1;

% Loop through image vector and count consecutive pixels
for i = 1:length(img_vec)-1
    if img_vec(i) == img_vec(i+1)
        count = count + 1;
    else
        rl_val = [rl_val, img_vec(i)];
        rl_count = [rl_count, count];
        count = 1;
    end
end

% Add last run of pixels to RLE variables
rl_val = [rl_val, img_vec(end)];
rl_count = [rl_count, count];

% Creating the code
run_bits = floor(log2(max(rl_count))) + 1;
Code = string(dec2bin(rl_val, 8)) + string(dec2bin(rl_count, run_bits));

% Creating a table with the set of run_lengths, symbols, code
rl_count = transpose(rl_count);
rl_val = transpose(rl_val);
T = table(rl_count, rl_val, Code);

% Display compression ratio
compression_ratio = ((run_bits + 8)*length(rl_count))/(length(img_vec));
disp(['Compression Ratio: ', num2str(compression_ratio)]);

% % Write the table to an excel file
% writetable(T, "RLE_pixels.txt");