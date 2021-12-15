clc
clear
clear a

a = arduino('COM5','Mega2560');
% arr = randi([1 4],1,5)
keep = 0;

for i = 1:1
    playTone(a, 'D7', 660,.1);
    pause(.15);
    playTone(a, 'D7', 660,.1);
    pause(.300);
    playTone(a, 'D7', 660,.1);
    pause(.300);
    playTone(a, 'D7', 510,.1);
    pause(.15);
    playTone(a, 'D7', 660,.1);
    pause(.300);
    playTone(a, 'D7', 770,.1);
    pause(.550);
end 

pause(0.5); 

for i = 1:5

% Array arr contains order input from user1
% Array A contains answers from user2
A = zeros(1,i); 
arr = zeros(1,i);

% Input from user1 
for l = 1:i

counter11 = 0;    
counter21 = 0;
counter31 = 0;
counter41 = 0;
counter5 = 0;

while (counter5 ~= 1)
    value1 = readDigitalPin(a,'D3');
    value2 = readDigitalPin(a,'D4');
    value3 = readDigitalPin(a,'D5');
    value4 = readDigitalPin(a,'D6');

    if value1 == 0
          counter11 = 1; 
          writeDigitalPin(a, 'D8', 1);
          arr(l) = 1; 
    end

    if counter11 == 1
        if value1 == 1
            counter5 = 1;
            writeDigitalPin(a, 'D8', 0);
        end 
    end 

    if value2 == 0
        counter21 = 1; 
        writeDigitalPin(a, 'D9', 1);
        arr(l) = 2; 
    end

    if counter21 == 1
        if value2 == 1
            counter5 = 1;
            writeDigitalPin(a, 'D9', 0);
            
        end 
    end 

    if value3 == 0
        counter31 = 1; 
        writeDigitalPin(a, 'D10', 1);
        arr(l) = 3;
    end 

    if counter31 == 1
        if value3 == 1
            counter5 = 1; 
            writeDigitalPin(a, 'D10', 0);
        end 
    end 

    if value4 == 0
        counter41 = 1;
        writeDigitalPin(a, 'D11', 1);
        arr(l) = 4;  
    end 
    
    if counter41 == 1
        if value4 == 1
            counter5 = 1; 
            writeDigitalPin(a, 'D11', 0);
        end 
    end     

    
end 

end

pause(0.5);
playTone(a, 'D7', 1200, 0.3);
pause(0.5);

% User2 playing
for j = 1:i

counter1 = 0;    
counter2 = 0;
counter3 = 0;
counter4 = 0;
counter = 0;
while (counter ~= 1)
    value1 = readDigitalPin(a,'D3');
    value2 = readDigitalPin(a,'D4');
    value3 = readDigitalPin(a,'D5');
    value4 = readDigitalPin(a,'D6');

    if value1 == 0
          counter1 = 1; 
          writeDigitalPin(a, 'D8', 1);
          A(j) = 1; 
    end

    if counter1 == 1
        if value1 == 1
            counter = 1;
            writeDigitalPin(a, 'D8', 0);
        end 
    end 

    if value2 == 0
        counter2 = 1; 
        writeDigitalPin(a, 'D9', 1);
        A(j) = 2; 
    end

    if counter2 == 1
        if value2 == 1
            counter = 1;
            writeDigitalPin(a, 'D9', 0);
            
        end 
    end 

    if value3 == 0
        counter3 = 1; 
        writeDigitalPin(a, 'D10', 1);
        A(j) = 3;
    end 

    if counter3 == 1
        if value3 == 1
            counter = 1; 
            writeDigitalPin(a, 'D10', 0);
        end 
    end 

    if value4 == 0
        counter4 = 1;
        writeDigitalPin(a, 'D11', 1);
        A(j) = 4;  
    end 
    
    if counter4 == 1
        if value4 == 1
            counter = 1; 
            writeDigitalPin(a, 'D11', 0);
        end 
    end     

    
end 

    
end 

% Output each round to check order from user1 and answer from user2
disp(A); 
disp(arr(1:i)); 

% Check if order and answer are match or not
for k = 1:i
    if (A(k) ~= arr(k))
        keep = 1;  
        break; 
    end 
end 

if keep == 1
    
    playTone(a, 'D7', 300,.5);
    pause(.30);
    playTone(a, 'D7', 200,.5);
    pause(.30);
    playTone(a, 'D7', 100,.5);
    pause(.30);
    playTone(a, 'D7', 50,.5);
    pause(.30);
    
   break;
end 

playTone(a, 'D7', 800, 0.3);
pause(0.5);
playTone(a, 'D7', 800, 0.3);
pause(1);


% End 
if i == 5
    
writeDigitalPin(a, 'D8', 1);
playTone(a, 'D7', 1000, 0.3);
pause(0.1);
writeDigitalPin(a, 'D8', 0);
pause(0.1);
writeDigitalPin(a, 'D9', 1);
playTone(a, 'D7', 1100, 0.3);
pause(0.1);
writeDigitalPin(a, 'D9', 0);
pause(0.1);
writeDigitalPin(a, 'D10', 1);
playTone(a, 'D7', 1200, 0.3);
pause(0.1);
writeDigitalPin(a, 'D10', 0);
pause(0.1);
writeDigitalPin(a, 'D11', 1);
playTone(a, 'D7', 1300, 0.3);
pause(0.1);
writeDigitalPin(a, 'D11', 0);
pause(0.1);

end 

end 
