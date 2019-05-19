%Purpose: Graphical User Interface Demonstration
%Developed by Ryan Thompson

f = figure;
img = zeros(256,256);
image_loaded = false;
axis image;

%buuton creations
quit = uicontrol;
quit.String = 'Quit';
load = uicontrol(f,'position',[20,50,60,20]);
load.String = 'Load';
save = uicontrol(f,'position',[20,80,60,20]);
save.String = 'Save';

%button commands
save.Callback = @save_callback;
load.Callback = @load_callback;
quit.Callback = @quit_callback;

%Adds image to axis
function load_callback(hObject, eventdata, handles)
    %Retrieving base variables
    current_image = evalin('base', 'img');
    current_image = open_image; 
    
    imshow(current_image);
    axis on;
    
    %Sending variables back to base
    assignin('base','img',current_image);
    assignin('base','image_loaded',true);
end

%Saves a loaded image
function save_callback(src,event,handles)
    image_loaded = evalin('base','image_loaded');
    current_image = evalin('base','img');
    
    if(image_loaded)
        save_image(current_image);
        return
    end
    
    disp('Please load an image before trying to save');
end

%Quits out of the program
function quit_callback(src,eventdata,handles)
    close all;
end

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

function save_image(varargin)
%save_image(image,file,type)
%must specify an 'image' array
%if no 'file' is specified, will prompt for filename
%if no 'type' is specified, will attempt to ascertain from filename

current_directory=cd;
if nargin<1,
    fprintf(2,'must specify an image array as first argument of save_image()\n');
    return;
end
image=varargin{1};
if nargin >= 3
    file=varargin{2};
    ftype=varargin{3};
elseif nargin == 2
    file=varargin{2};
else
    [file,path,findex]=uiputfile({...
        '*.ppm','PPM (*.ppm)';...
        '*.pgm','PGM (*.pgm)';...
        '*.pbm;*.pgm;*.ppm;*.pnm','PNM (*.pnm)';...
        '*.jpg;*.jpeg','JPEG (*.jpg)';...
        '*.png','PNG (*.png)';...
        '*.bmp','BMP (*.bmp)';...
        '*.tif;*.tiff','TIFF (*.tif)';...
        '*.pcx','PCX (*.pcx)';...
        '*.ras','RAS (*.ras)';...
        '*.xwd','XWD (*.xwd)';...
        '*.*','All files (*.*)'},...
        'Save Image as ...');  
    if isequal(file,0) | isequal(path,0)
        disp('User pressed cancel');
        return;
    end
    cd(path);
end
if nargin >= 3
    imwrite(varargin{:});
else
    imwrite(image,file);
end 
cd(current_directory);
end