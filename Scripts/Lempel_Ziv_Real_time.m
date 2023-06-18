clear all
img = imread("Scenery.png");           % Original image
img = imresize(img,[60,100]);           % Resolution decreased to have a reasonable execution time
img = rgb2gray(img);            % Since original image has three channels, converting it into black and white          
imshow(img);

bitstream = [];
for i=1:60                              % Reorganizing image into a bitstream
    for j=1:100  
        l = dec2bin(img(i,j),8);
        for k=1:8
            bitstream = [bitstream str2num(l(k))];
        end
    end
end
bitstream      % Generated bitstream

b = bitstream;                   %  Real time Lempel Ziv Algorithm
c = {b(1)};
Address = {string(1)};          % Address book
l = length(b);
part = [];
code = {'0'+string(b(1))};        % Encoded phrases
null = '0';
j = 2;
while (l-1>0)
    x = b(2:length(b));
    m = 1;
    for i=1:length(c)
       if(min(strfind(x,(c{(i)})))==1)
           if(length(c{(i)})>=m)
               if(length(x)==length(c{(i)}))  
                   part = [x(length(c{(i)}))];
                   code(j) = {Address(i,:)};               % Codewords being generated as soon as a new phrase is discovered
               else
                   part =[c{(i)} x(length(c{(i)})+1)];
                   m = length(part);
                   code(j) = {Address(i,:) + string(x(length(c{(i)})+1))};
               end
            
           end
        end
    end
    if(m==1)
        part = x(1);
        code(j) = {null+string(x(1))};
    end
    c = {c{1:length(c)} [part]};
    j = j + 1;
    b = b(m+1:length(b));
    l = length(b);
    k = length(c);
    n = ceil(log2(k+1));
    d = 1:k;
    if(n~=0)
        Address = dec2bin(d,n);
    end
    if(n~=0)
        null = dec2bin(0,n);
    else
        null = '0';
    end
end

c
code
L=0;
z = length(c);
for s=1:z
    L = L + strlength(code{s});            % To calculate number of bits in the encoded string
end
CR = L/length(bitstream)        % Ratio of number of bits in encoded message to the original number of bits