clc
clear
close

% Code for function webcam to check center position is from Dr.Becker,
% University of Houston
% Code for function webcam to check color of LEDs is from Farhan Ahamed
% Hameed and Suraj Kamya

a = arduino('COM5','Mega2560','Libraries','Adafruit\MotorShieldV2');
shield = addon(a,'Adafruit\MotorShieldV2');

while(1)

button1 = readDigitalPin(a,'D37');
button2 = readDigitalPin(a,'D39');

while(button1 == 1)
    move_center;
    button1 = readDigitalPin(a,'D37');
    if button1 == 0
        reset2;
        break;
    end 
end 

arr = zeros(1,3);
counter = 0;

while (button2 == 1)
    color = check_color;
    if color == 1
        arr(counter) = 1; 
        counter = counter + 1; 
    elseif color == 2
        arr(counter) = 2;
        counter = counter + 1; 
    elseif color == 3
        arr(counter) = 3;
        counter = counter + 1; 
    end 

button2 = readDigitalPin(a,'D39');

    if button2 == 0
        break; 
    end 
    
end 

for i = 1:counter
    if arr(i) == 2
        elbow_moveDown(250);
        elbow_moveUp(250);
    elseif arr(i) == 1
        elbow_moveDown(250);
        base_moveLeft(230);
        reset;
    elseif arr(i) == 3
        elbow_moveDown(250);
        base_moveRight(450);
        reset;
    end 
end 

% button1 = readDigitalPin(a,'D37');

    if readDigitalPin(a,'D37') == 0
       elbow_moveUp(300); 
       break; 
    end

end 

% Read Analog Input 
% Base 

disp('Done'); 

function sum = input_base()
    sum = 0;
    z = 2; 
    for i = 1:z
        sum = sum + readVoltage(a,'A10');
    end 

    sum = sum / z; 
end 

% Elbow
function sum = input_elbow()
    sum = 0;
    z = 2; 
    for i = 1:z
        sum = sum + readVoltage(a,'A11');
    end 

    sum = sum / z; 
end 

% Control Elbow 
% Move Down
function [] = elbow_moveDown(target)
    valIn = input_elbow;
    error = valIn - target; 
    while error > 30 && valIn > target
        elbow_motor = dcmotor(shield,2); 
        elbow_motor.speed = -0.3; 
        valIn = input_elbow;
        error = abs(valIn - target);        
    end 
    stop(elbow_motor); 
end 

% Move Up
function [] = elbow_moveUp(target)
    valIn = input_elbow;
    error = valIn - target; 
    while error > 30 && valIn < target
        elbow_motor = dcmotor(shield,2); 
        elbow_motor.speed = 0.3; 
        valIn = input_elbow;
        error = abs(valIn - target);        
    end 
    stop(elbow_motor); 
end 

function [] = elbow_stop()
    elbow_motor = dcmotor(shield,2);
    stop(elbow_motor);
end 

% Control Base 
% Move Left
function [] = base_moveLeft(target)
    valIn = input_base;
    error = valIn - target; 
    while error > 30 && valIn > target
        base_motor = dcmotor(shield,4); 
        base_motor.speed = 0.3; 
        valIn = input_base;
        error = abs(valIn - target);        
    end 
    stop(base_motor); 
end 

% Move Up
function [] = base_moveRight(target)
    valIn = input_base;
    error = valIn - target; 
    while error > 30 && valIn < target
 
        base_motor.speed = -0.3; 
        valIn = input_base;
        error = abs(valIn - target);        
    end 
    stop(base_motor); 
end 

function [] = base_stop()
    base_motor = dcmotor(shield,4);
    stop(base_motor);
end 

% Reset to move robotic arm back to original position

function [] = reset()
    pos = input_base;
    if pos > 390
        base_moveLeft(380);
    elseif pos < 360
        base_moveRight(380); 
    end 
    elbow_moveUp(318);
end 


function [] = reset2()
    elbow_moveDown(250);
end 

% Webcam to check position
% Position x and y
function [x, y] = webcam()
    clear('cam'); % clear the cam object so you can make a new one
    cam = webcam('HD 2MP Webcam'); %open the camera
while(1)
    RGB = snapshot(cam);
    figure(1)
    imshow(RGB) %original
    %%%%%%%%%%%%%% FROM colorThresholder %%%%%%%%%%%%%%%%%%
    % I used the Matlab app colorThresholder to find the points for my mask, which is red
    % Convert RGB image to chosen color space
    I = rgb2hsv(RGB);
    % Define thresholds for channel 1 based on histogram settings
    channel1Min = 0.694;
    channel1Max = 0.000;
    % Define thresholds for channel 2 based on histogram settings
    channel2Min = 0.059;
    channel2Max = 1.000;
    % Define thresholds for channel 3 based on histogram settings
    channel3Min = 0.141;
    channel3Max = 0.882;
    % Create mask based on chosen histogram thresholds
    sliderBW = ( (I(:,:,1) >= channel1Min) | (I(:,:,1) <= channel1Max) ) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
    BW = sliderBW;
    % Initialize output masked image based on input image.
    maskedRGBImage = RGB;
    % Set background pixels where BW is false to zero.
    maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
    %%%%%%%%%%%%% END FROM colorThresholder %%%%%%%%%%%%%%%%
    figure(2);clf;
    imshow(maskedRGBImage)
    %https://www.mathworks.com/help/images/ref/bwconncomp.html is easier.
    CC = bwconncomp(sliderBW);
    s = regionprops(CC,'Centroid','Area');
    centroids = cat(1,s.Centroid);
    areas = cat(1,s.Area);
    [m,ind] = max(areas); % find the largest connected component
    figure(3);clf;
    imshow(double(sliderBW))
    hold on
    %plot(centroids(:,1),centroids(:,2),'b*')
    % for i = 1:numel(areas) % this shows all the spots
    % text(centroids(i,1),centroids(i,2),num2str(areas(i) ),'color','r')
    % end
    plot(centroids(ind,1),centroids(ind,2),'m*','markersize',32)
    disp('x')
    disp(centroids(ind,1))
    x = centroids(ind,1);
    disp('y')
    disp(centroids(ind,2))
    y = centroids(ind,2); 
    % put a star on the largest connected component.
    % This is where you should aim your robot.
end

end 

% Quadrant 

function x = checkQuadrant(a, b)
    
    c_x = 330;
    c_y = 230;

    error_x = abs(c_x - a);
    error_y = abs(c_y - b);

    if error_x < 30 && error_y < 30
        x = 0; 
    end 

    if a > c_x && b < c_y
        x = 1; 
    end 

    if a < c_x && b < c_y
        x = 2; 
    end 

    if a < c_x && b > c_y
        x = 3; 
    end 

    if a > c_x && b > c_y
        x = 4; 
    end 

end 

% Move Robotic Arm to center
function [] = move_center()

[x, y] = webcam(); 

quad = checkQuadrant(x,y); 

if(quad == 0)
    elbow_stop();
    base_stop();

elseif(quad == 1)
    base_moveLeft();
    elbow_moveDown();  

elseif(quad == 2)
    base_moveRight();
    elbow_moveDown();
 
elseif(quad == 3)
    base_moveRight();
    elbow_moveUp();

elseif(quad == 4)
    base_moveLeft();
    elbow_moveUp();
end 

end 


% Webcam to check color of LEDs

function color = check_color()

  imaqreset          %delete and resets image aquisition toolbox functions
  info = imaqhwinfo;  %Information regarding the Adaptors 
  vid= videoinput('winvideo','1', 'RGB24_320X240');  %videoinput('apaptername','device_ID','format')
  set(vid, 'FramesPerTrigger', Inf);   %Specify number of frames to acquire per trigger using selected video source
  set(vid, 'ReturnedColorspace', 'rgb') %Set the video input as RGB or grayscale.
  vid.FrameGrabInterval = 5;      %An interval between frames, Here 5 frame interval between two frames
  start(vid);                     % start
  preview(vid);                   %Visualize the video
      
    % Set loop from the value of slider
while(vid.FramesAcquired<=300)    % Its a loop which runs for 300 frames, It can be varied as required.
    % current snapshot
      im = getsnapshot(vid);            %To convert the live stream video into a screenshot 
    
    % Red color detection
      r=im(:,:,1); g=im(:,:,2); b=im(:,:,3); % r= red object g= green and b= blue objects
      diff_red=imsubtract(r,rgb2gray(im));   % To separate RED objects from a gray image
      diff_r=medfilt2(diff_red,[3 3]);       % Applting median filter
      bw_r=imbinarize(diff_r,0.2);           % To convert grayscale image to Black and white with a threshold value of 0.2
      area_r=bwareaopen(bw_r,300);           % To remove objects less than 300 pixels
      R=sum(area_r(:));                      % Used as a function for segregation
      rm=immultiply(area_r,r);  gm=g.*0;  bm=b.*0; %Multiplies the red detected object with red to visualize.
      image_r=cat(3,rm,gm,bm);                     %combines all RGB image
      subplot(2,2,2);
      imshow(image_r);                             % Displays the image
      title('RED');                               
        
    % Green color detection 
      r=im(:,:,1); g=im(:,:,2); b=im(:,:,3);
      diff_green=imsubtract(g,rgb2gray(im));
      diff_g=medfilt2(diff_green,[3 3]);
      bw_g=imbinarize(diff_g,0.071);
      area_g=bwareaopen(bw_g,300);
      G=sum(area_g(:));
      gm=immultiply(area_g,g);  rm=r.*0;  bm=b.*0;
      image_g=cat(3,rm,gm,bm);
      subplot(2,2,3);
      imshow(image_g);
      title('GREEN');
         
    % Blue color detection
      r=im(:,:,1); g=im(:,:,2); b=im(:,:,3);
      diff_blue=imsubtract(b,rgb2gray(im));
      diff_b=medfilt2(diff_blue,[3 3]);
      bw_b=imbinarize(diff_b,0.2);
      area_b=bwareaopen(bw_b,300);
      B=sum(area_b(:));
      bm=immultiply(area_b,b);  gm=g.*0;  rm=r.*0;
      image_b=cat(3,rm,gm,bm);
      subplot(2,2,4);
      imshow(image_b);
      title('BLUE');
       
if((R>G) && (R>B))                         %if the area of Red is greater than Green and Blue then its Red
    color = 3; 
 elseif((G>R) && (G>B))                    %if the area of Green is greater than Red and Blue then its Green
    color = 1; 
 elseif((B>R) && (B>G))                    %if the area of Blue is greater than red and Green then its Blue
    color = 2;
end      

end
      %Once the program has run, the data's are cleared.
      stop(vid);                              
      delete(vid);
end 
