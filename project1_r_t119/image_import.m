figure;
image6 = open_image;
imshow(image6);

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