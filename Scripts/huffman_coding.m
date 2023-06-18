clearvars;
close all;
clc;


%% Part 1)

% Reading the image data into a matrix
src_img = imread("ITC.png");


%% Part 2) Histogram & Probability Calculation

% No of symbols
n = 256;

% Plotting a histogram for the image
histogram(src_img);

% Total no of pixels
order = size(src_img);
img_size = order(1)*order(2);

% Calculating the probability of occurence of each color
p = zeros(1, n);
for i = 0:(n-1)
    log_mat = (src_img == i);
    p(i+1) = sum(log_mat, 'all')/img_size;
end

P = p;

%% Part 3) Huffman Coding

% % Sample test for Huffman coding
% p = [0.46, 0.30, 0.12, 0.06, 0.03, 0.02, 0.01];
% n = length(p);
% P = p;

% Created a cell array to hold the array of symbols
symbols = cell(1, n);

% Initialized with the symbol strings
for i = 0:(n-1)
    symbols(i+1) = {[string(i)]};
end

Symbols = symbols;

% Initialized the codeBook of empty strings
codeBook = strings(1, n);

% Iterations
for i = 1:(n-1)
    % Sort the current symbol probabilities in ascending order
    [sort_p, ind] = sort(p);
    
    % Sort the symbols in the same order as above
    symbols = symbols(ind);
 
    p = sort_p;
    
    % Store the string arrays contained in cells in containers
    mat1 = symbols{1};
    mat2 = symbols{2};
    
    % Update the codebook for the lower aggregate symbol
    for j = 1:length(mat1)
        codeBook(str2double(mat1(j)) + 1) = "1" + codeBook(str2double(mat1(j)) + 1);
    end
    
    % Update the codebook for the upper aggregate symbol
    for j = 1:length(mat2)
        codeBook(str2double(mat2(j)) + 1) = "0" + codeBook(str2double(mat2(j)) + 1);
    end
    
    % Tie the lower and upper symbols together
    p = [p(1) + p(2), p(3:length(p))];
    jointSymbol = {[mat1, mat2]};
    symbols = symbols(2:length(symbols));
    symbols(1) = jointSymbol;
end

% Initialize the values of entropy & avg length
entropy = 0;
avg_length = 0;

% Iteratively evaluate the entropy and avg length of the symbols
for i = 1:n
    entropy = entropy - P(i)*log2(P(i));
    avg_length = avg_length + P(i)*strlength(codeBook(i));
end

% Calculate the efficiency of the code
efficiency = (entropy/avg_length)*100;

% Display all the characteristic features
disp(['Entropy of source letters: ', num2str(entropy)]);
disp(['Average codeword length: ', num2str(avg_length)]);
disp(['Efficiency: ', num2str(efficiency)]);

% Creating a table of sybols and codebook
Symbols = transpose(Symbols);
Codes = transpose(codeBook);
Probability = transpose(P);
T = table(Symbols, Probability, Codes);

% % To save the table in the form of an excel file
% writetable(T, "huffman_code.xlsx");