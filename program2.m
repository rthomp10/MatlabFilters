%Purpose: Filter Program
%Developed by Ryan Thompson
 
filters = figure('name','filters','position', [100 600 100 100]);
f = figure('name','Project #2  - Ryan  Thompson', 'position', [220 100 600 600]);
current_image = zeros(256,256);
preview_image = zeros(256,256);
image_loaded = false;
no_change = 1;

%Buttons - main figure
quit = uicontrol(f);
quit.String = 'Quit';
apply = uicontrol(f, 'position', [110,20,100,20]);
apply.String = 'Apply Changes';
load = uicontrol(f,'position',[20,50,60,20]);
load.String = 'Load';
save = uicontrol(f,'position',[20,80,60,20]);
save.String = 'Save';

%Buttons - Filter Tools
low_pass = uicontrol(filters);
high_pass = uicontrol(filters, 'position', [20,50,60,20]);
highboost = uicontrol(filters,'position',[20,80,60,20]);
low_pass.String = 'Low Pass';

high_pass.String = 'High Pass';

highboost.String = 'Highboost';


%button commands
save.Callback      = @save_callback;
load.Callback      = @load_callback;
quit.Callback      = @quit_callback;
apply.Callback     = @apply_callback;
highboost.Callback = @highboost_callback;

high_pass.Callback = @high_pass_callback;
low_pass.Callback = @low_pass_callback;


%Creates an axis for the current image
ax1 = subplot(1,2,1);
axis image;
title('Current');

%Creates an axis for the preview  image
ax2 = subplot(1,2,2);
axis image;
title('Preview');

%Adds image to axis
function load_callback(hObject, eventdata, handles)
    %Opens the image
    current_image = open_image;
    
    %Displays the image in current
    subplot(1,2,1);
    imshow(current_image);
    title('Current');
    axis on;
    subplot(1,2,2);
    imshow([256 256]);
    title('Preview');
    axis on;
    
    %Sends changes back to base
    assignin('base','current_image',current_image);
    assignin('base','preview_image',zeros(256,256));
    assignin('base','no_change',true);
    assignin('base','image_loaded',true);
end

%Saves a loaded image
function save_callback(src,event,handles)
    image_loaded = evalin('base','image_loaded');
    current_image = evalin('base','current_image');
    subplot(1,2,1);
    
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

%Applies changes seen by the preview to current
function apply_callback(src,eventdata,handles)
    %Brings variables into the function
    preview_image = evalin('base','preview_image');
    no_change = evalin('base','no_change');
    
    %checks if there's a change or not
    if(no_change)
        disp('No changes have been made');
        return
    end
    
    %Assigns the preview image to the current one
    current_image = preview_image;
    
    %Displays the change in current windows
    subplot(1,2,1);
    imshow(current_image);
    axis on;
    
    %Assigns variables back to base
    assignin('base','current_image',current_image);
    assignin('base','preview_image',preview_image);
    assignin('base','no_change',no_change);
end

%Applies a spacial-domain smoothing
function low_pass_callback(src,eventdata,handles)
    current_image = evalin('base','current_image');
    image_loaded = evalin('base','image_loaded');
    f = evalin('base','f');
    filters = evalin('base','filters');
    
    %Preliminary condition
    if( image_loaded == false )
       disp('Please load an image');
       return;
    end
    
    %Region size selection
    disp('Please type a region size.');
    disp('Input one integer for your desired nxn region');
    user_input = input('n = ');
    while mod(user_input,2) < 1
        disp('Number must be odd');
        user_input = input('n = ');
    end
    
    %Filter application
    preview_image = imgaussfilt(current_image,2,'FilterSize',user_input);
    
    %Displays changes
    figure(filters);
    figure(f);
    subplot(1,2,2);
    imshow(preview_image);
    axis on;
    
    %Sends changes back to base
    assignin('base','preview_image',preview_image);
    assignin('base','no_change',false);
end

%Applies a lowpass filter
function high_pass_callback(src,eventdata,handles)
    current_image = evalin('base','current_image');
    image_loaded = evalin('base','image_loaded');
    f = evalin('base','f');
    filters = evalin('base','filters');
    
    %Preliminary condition
    if( image_loaded == false )
       disp('Please load an image');
       return;
    end
    
    %Filter application
    H = ones(3,3) * -1;
    H(2,2) = 8;
    preview_image = imfilter(current_image,H,'conv');
    
    %Displays changes
    figure(filters);
    figure(f);
    subplot(1,2,2);
    imshow(preview_image);
    axis on;
    
    %Sends changes back to base
    assignin('base','preview_image',preview_image);
    assignin('base','no_change',false);
end

%Applies highboost filter with specified boost scaling coefficient
function highboost_callback(src,eventdata,handles)
    current_image = evalin('base','current_image');
    image_loaded = evalin('base','image_loaded');
    f = evalin('base','f');
    filters = evalin('base','filters');
    
    %Preliminary condition
    if( image_loaded == false )
       disp('Please load an image');
       return;
    end
    
    %Region size selection
    disp('What would you want your boost scaling coefficient to be?');
    disp('c = ');
    c = input('n = ');
    
    %Filter application
    H = ones(3,3) * -1;
    H(2,2) = 8;
    H = c*H;
    preview_image = imfilter(current_image,H,'conv');
    
    %Displays changes
    figure(filters);
    figure(f);
    subplot(1,2,2);
    imshow(preview_image);
    axis on;
    
    %Sends changes back to base
    assignin('base','preview_image',preview_image);
    assignin('base','no_change',false);
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