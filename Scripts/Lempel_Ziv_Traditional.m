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
bitstream;     % Generated bitstream

b = bitstream;
c = {b(1)};
l = length(b);
part = [];

while (l-1>0)                          
    x = b(2:length(b));
    k = length(c);
    m = 1;
    for i=1:k
       if(min(strfind(x,(c{(i)})))==1)
           if(length(c{(i)})>=m)
               if(length(x)==length(c{(i)}))  
                   part = [x(length(c{(i)}))];             % Extracting phrases
               else
                   part =[c{(i)} x(length(c{(i)})+1)];
                   m = length(part);
               end
            
           end
        end
    end
    if(m==1)
        part = x(1)
    end
    c = {c{1:length(c)} [part]};
    b = b(m+1:length(b));
    l = length(b);
end
n = ceil(log2(length(c)));
i = 1:length(c)-1;
Address = dec2bin(i,n);                 % Creating addresses for phrases
null = dec2bin(0,n); 
code = {};                               
for j=1:length(c)                    % Assigning codewords based on newly created addresses
    m = 0;    
    for k=1:length(c)-1
        l1 = length(c{j});                                              
        l2 = length(c{k});
        if((l1-l2 == 1) && (~isempty(strfind(c{j},c{k}))))
            if(min(strfind(c{j},c{k}))==1)
               code(j) = {Address(k,:) + string(c{j}(length(c{j})))};
               m = 1;
            end
        end
    end
    if(m == 0)
        code(j) = {null + string(c{j})};
    end
end
c                 % The final list of phrases
code              % Corresponding list of codewords
L=0;
z = length(c);
for s=1:z              % to calculate number of bits in the encoded message
    L = L + strlength(code{s});       
end
CR = L/length(bitstream) % The compression ratio