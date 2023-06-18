clearvars;
close all;
clc;

% Read and store the image in the form of a matrix
src_img = imread("ITC.png");

order = size(src_img);
img_size = order(1)*order(2);

%% Part 6) Binary Symmetric Channels (BSCs)

% Initializing the new image matrix
new_img = zeros(order);

% Building a Look-up table for converting decimal to binary
lookup_table = strings(1, 256);
for i = 1:256
    lookup_table(i) = dec2bin(i-1, 8);
end

p = 0.5;
for i = 1:order(1)
    for j = 1:order(2)
        
        % Passing the input string through the BSC
        input_string = lookup_table(src_img(i, j) + 1);
        output_string = bsc(input_string, p);
        new_img(i, j) = find(lookup_table == output_string);
    end
end

% Displaying the image received through the channel
imshow(new_img, [0, 255]);