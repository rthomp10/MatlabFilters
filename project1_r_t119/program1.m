%Purpose: Matrix and Image Relationship
%Developed by Ryan Thompson

%Creates a uniform grey 256x256 image
image1 = zeros(256,256);
image1(:,:) = 150;
image1 = uint8(image1);
figure;
imshow(image1);

%Creates a vertical gradient image
image2 = zeros(256,256);
for a=1:256
    image2(a,:) = a-1;
end
image2 = uint8(image2);
figure;
imshow(image2);

%Creates a horizontal gradient image
image3 = zeros(256,256);
for a=1:256
    image3 (:,a) = a-1;
end
image3 = uint8(image3);
figure;
imshow(image3);

%Creates a diagonal gradient image
image4 = zeros(256,256);
for r=1:256
    for c=1:256
        image4 (r,c) = uint8( (r+c-2)/2 );
    end
end
image4 = uint8(image4);
figure;
imshow(image4);

%Saves image4 as .jpeg
imwrite(image4, 'homework1_4.jpg');

%Combines flipped versions of image4
image5 = quadmirror(image4);
figure;
imshow(image5);

%Saves image5 as a .gif
imwrite(image5, 'homework1_5.gif');

%Imports an image and converts it to grayscale
disp('Please open an image file of your choice');
figure;
image6 = open_image;
if( ndims(image6) > 2 )
    disp('Converting to grayscale');
    image6 = rgb2gray(image6);
end
image6 = uint8(image6);
imshow(image6);

%mirrors image6 4 ways
image7 = quadmirror(image6);
figure;
imshow(image7);

%Saves image7 as a .pgm
imwrite(image7, 'homework1_7.pgm');

%Takes previous images and uses them
% as a color reference in a new image
image11 = zeros(256,256,3);
image11 = uint8(image11);
image11(:,:,1) = image2;
image11(:,:,2) = image3;
image11(:,:,3) = image4;
figure;
imshow(image11);

%Saves image11 as a .ppm
imwrite(image11, 'homework1_11.ppm');

%Image import
image13 = open_image('lena_color.jpg');
imshow(image13);

%Quaddruple mirror of image13
image14 = quadmirror(image13);
imshow(image14);

%Saves image14 as a .pnm
imwrite(image14, 'homework1_14.pnm');

%Closing
disp('Press any key to continue...');
pause;
close all;

%Imports and converts an image to a matrix
function [varargout]=open_image(varargin)
%[picture]=open_image(file)
current_directory=cd;

if nargin<1,
    [file,path]=uigetfile({...
        '*.jpg;*.jpeg;*.bmp;*.gif;*.tif;*.tiff;*.png;*.pbm;*.pgm;*.ppm;*.pnm;*.pcx;*.ras;*.xwd;*.cur;*.ico','All Image Types';...
        '*.jpg;*.jpeg','JPEG (*.jpg, *.jpeg)';...
        '*.bmp','BMP (*.bmp)';...
        '*.gif','GIF (*.gif)';...
        '*.tif;*.tiff','TIFF (*.tif, *.tiff)';...
        '*.png','PNG (*.png)';...
        '*.pbm;*.pgm;*.ppm;*.pnm','PNM (*.pbm, *.pgm, *.ppm, *.pnm)';...
        '*.pcx','PCX (*.pcx)';...
        '*.ras','RAS (*.ras)';...
        '*.xwd','XWD (*.xwd)';...
        '*.cur;*.ico','Cursors and Icons (*.cur, *.ico)';...
        '*.*','All files (*.*)'});  
    if isequal(file,0)|isequal(path,0)
       disp('File not found');
       picture=[];
       return
    end
    if strcmp(current_directory,path) == 0 & ~isequal(path,0)
        cd(path);
    end
else
    file=varargin{1};
end
varargout{1}=imread(file);
if nargout > 1
    varargout{2}=file;
end
if nargout > 2
    varargout{3}=path;
end
cd(current_directory);
end
%Makes a quaddruple mirror of an image
function y = quadmirror(x)
    y = [x, fliplr(x); flipud(x), flipud(fliplr(x))];
end