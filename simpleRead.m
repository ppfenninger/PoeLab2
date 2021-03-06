function data = simpleRead()        
hold all; 
ser = serial('COM3');                             % this is the port the Ardunio is on
set(ser, 'BaudRate', 9600, 'Timeout', 0.05);     % 9600 is the serial intializing port, timeout is the max time to wait for data
fopen(ser);                                       % open the serial reader

finishup = onCleanup(@() cleanup(ser));           % removes remaining data from the serial reader                                                                                            
    function cleanup(s)
        fclose(s);                                % close the serial reader
        delete(s);                                % delete all information stored in the serial
        clear s                                   % remove data from MATLAB
        disp('Clean!')                            % tells you it cleaned: if it doesn't unplug and replug arduino
    end

fscanf(ser)                                             % pulls data from serial text file

while(true)
    if(get(ser, 'BytesAvailable') >= 1)                 % if there is data coming in from the arduino
        value = sscanf(fscanf(ser), '%d,%u,%d');        % sscanf reads formatted data from string, fscanf reads data from the text file (look up uses of %d and %u and %f)
        if (value == -1)                                % if the Ardunio prints -1 (you can change this case if you ned to!) , the scanning is done...  
            break                                       % ... so you end the loop
        else                                            % if scanning is still going                                        
            data(value(1),value(2)) = value(3);         % this is where you decide what to do with the data you are importing (creating a matrix)
        end
    end
end

[m, n] = size(data); %should be 180x180
distanceAway = zeros([m, n]); 
distanceHeight = zeros([m, n]);
distanceWidth = zeros([m, n]);
initialHeight = 0;
initialWidth = 0; 
initialPanAngle = 0; %degrees
initialTiltAngle = 0; %degrees 

for i = 1:m
    for j = 1:n
        panAngle = i;
        tiltAngle = j; 
        distanceAway(i, j) = -0.1474*data(i, j) + 92.73;
        distanceHeight(i, j) = -0.1474*data(i, j) + 92.73;
        distanceWidth(i, j) = -0.1474*data(i, j) + 92.73;
        
        distanceAway(i, j) = distanceAway(i, j)*cosd(panAngle - initialPanAngle)*cosd(tiltAngle - initialTiltAngle); 
        distanceHeight(i, j) = distanceHeight(i, j)*sind(tiltAngle - initialTiltAngle)*cosd(panAngle - initialPanAngle) - initialHeight;
        distanceWidth(i, j) = distanceWidth(i, j)*cosd(tiltAngle - initialTiltAngle)*sind(panAngle - initialPanAngle) - initialWidth;
    end 
end

surf(distanceWidth, distanceHeight, distanceAway); 
end


