clc;
clear;
close all
%% read an input image
[filename,pathname]=uigetfile('*.*','select image');
input = imread([pathname,filename]);
figure
imshow(input)
title('original image')
green = input(:,:,2);
% rgb2gray conversion
input1 = rgb2gray(input);
figure
imshow(input1)
title('gray image')
%green compenent subtraction
img = green - input1;
figure
imshow(img)
title('subtraction of green component ')
%% Applying median filter 
medfilt = medfilt2(img);
figure
imshow(medfilt)
title('filtered image')
%% Thresholding an image
threshold = graythresh(img);
thres = imbinarize(medfilt,threshold);
figure
imshow(thres)
title('threshold image')
%% Morphological filters
% Morphological to fill holes
morph = imfill(thres,'holes');
figure
imshow(morph)
title('imfill function')
%
bwmorp = bwmorph(thres,'remove');
figure
imshow(bwmorp)
title('morphological operation ')

%
a = nonzeros(bwmorp);
add = sum(sum(a));

%% Label an image 
st = regionprops(bwmorp,'Area','BoundingBox');
area_vector = cat(st.Area);
average_area = mean(area_vector);
figure
imshow(input)
title('weed detection')
for k=1 : length(st)
    Areaa = st(k).Area;
    if Areaa < average_area
        thisBB = st(k).BoundingBox;
        rectangle('Position',[thisBB(1),thisBB(2),thisBB(3),thisBB(4)],'EdgeColor','y','linewidth',2)
    else
    end
end

%% metrices
% calculate ture postive values
sg = input1 >0;
gt = bwmorp > 0;

TP = sum(sum(sg & gt));
% fprintf('true postive values :%d\n',TP)

% calculate ture negative values
seg = bwmorp > 256;
gtt = input1 > 256;

TN = sum(sum(seg == 0 & gtt==0));
% fprintf('true negative values :%d\n',TN)

%calculate flase postive values 
FP = sum(sum(bwmorp)) - TP;
% fprintf('flase postive values :%d\n',FP)

%calculate flase negative values 
FN = sum(input1(bwmorp==0))/sum(input1(:));
% fprintf('flase negative values :%f\n',FN*100)

%%

% sensitivity
SN = TN/(TP+TN);
fprintf('Sensitivity values :%f\n',SN*100)

%SPECIFICITY
SP = TN/(TN+FP);
fprintf('Speficity values :%f\n',SP*100)

% postive predictive value
PV = TP./(TP+FP);
fprintf('Postive predicated values :%f\n',PV*100)

%negative predictive values 
NP = TN/(TN+FN);
fprintf('Negative predicated values :%f\n',NP*100)
