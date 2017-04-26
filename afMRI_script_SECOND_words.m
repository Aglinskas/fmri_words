close all;
Screen('Preference', 'SkipSyncTests', 1); % disable if script crashes. 
sca;
subjID = 'S99'

% save(subjID)
%     if expBlock == 16
%         save(subjID)
%         break
%     end
% % %  
%subjID = datestr(date)

load(subjID)
c_expBlock = expBlock
when_to_stop = expBlock + 16
%% PTB CODE
screens = Screen('Screens');
screenNumber = max(screens); % Draw to the external screen if avaliable
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;
inc = white - grey;
%% SLF try
[window, windowRect] = Screen(screenNumber, 'openwindow',[128 128 128]);
% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
% Query the frame duration
ifi = Screen('GetFlipInterval', window);
% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);
% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
%% scanner 
% Wait for first pulse
if scanning
    try 
    a=instrfind('Tag', 'SerialResponseBox');fclose(a);
end
    Cfg.ScannerSynchShowDefaultMessage = 1;
    Cfg.synchToScannerPort = 'SERIAL';
    Cfg.responseDevice = 'LUMINASERIAL';
    Cfg.serialPortName = 'COM1'
    Cfg = InitResponseDevice(Cfg); %LUMINA box: ASCII + highest baud rate (115200)

    DrawFormattedText (window, 'WAITING FOR THE SCANNER','center','center');
    Screen('flip',window);
    ASF_WaitForScannerSynch([], Cfg);
    firstPulse=GetSecs;
    Screen('flip',window);
end
ExpStart = GetSecs;
%%  BLOCKS here
% Beginning of a block, task instructions, fixation cross
for expBlock = c_expBlock : fmriblocks
    %% Sets up the task and prompts
    save(subjID)
    if expBlock == when_to_stop
        save(subjID)
        break
    end
   taskName = myTrials(expBlock * fmriTrials - fmriTrials + 1).TaskName;
   taskIntruct = myTrials(expBlock * fmriTrials - fmriTrials + 1).taskIntruct;
% Task Name
Screen('TextSize', window, 28);
Screen('TextFont', window, 'Courier');
DrawFormattedText(window, taskName, 'center', 'center', white);
% Task instructions
Screen('TextSize', window, 24);
Screen('TextFont', window, 'Courier');
lower_third = 600;
cCenter = xCenter - length(taskIntruct);
DrawFormattedText(window, taskIntruct, cCenter, lower_third, white);
Screen('Flip', window);
WaitSecs(instruct_time); % length of time that task and instructions are on the screen
fixCrossDimPix = 40;
% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the cent1er of our monitor for us)
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];

% Set the line width for our fixation cross
lineWidthPix = 4;
Screen('DrawLines', window, allCoords,lineWidthPix, white, [xCenter e4 - 220]); % change 2350 is the y coord
Screen('Flip', window);

WaitSecs(t_fixCross); %Time that fixation cross is on the screen
%%
a_t = ceil((GetSecs - ExpStart)/TR)*TR;
while GetSecs - ExpStart < a_t
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EXPERIMENTAL RUN. 1 loop of code below = 1 trial
for ExpTrial = expBlock * fmriTrials - (fmriTrials - 1) : expBlock * fmriTrials; % code that matches blocks, trials, and trials per block
    pressed=0;
    % PICTURE EXP CODE
            % theImageLocation = myTrials(ExpTrial).filepath; % gets picture from myTrials
            % theImage = imread(theImageLocation);
            % % Get the size of the image
            % [s1, s2, s3] = size(theImage);
            % 
            % if s1 > screenYpixels || s2 > screenYpixels
            %     disp('ERROR! Image is too big to fit on the screen');
            %     sca;
            %     return;
            % end
            % 
            % imageTexture = Screen('MakeTexture', window, theImage);

 e1 = xCenter - s2/2;
 e2 = xCenter + s2/2;
 e3 = yCenter - s1/2 - 150;
 e4 = yCenter + s1/2 - 150;
 
            % Screen('DrawTexture', window, imageTexture, [], [e1 e3 e2 e4],0);
            DrawFormattedText(window, myTrials(ExpTrial).word, 'center', e4 - 220, white);
lower_third = 600;
% Flip to the screen
Screen('Flip', window); % the image is now on the screen
timePresented = GetSecs - ExpStart;
t_presented = GetSecs;
myTrials(ExpTrial).time_presented = timePresented;
WaitSecs(StimTime);
Screen('FillRect', window, grey); % screen  is now blanc
Screen('DrawLines', window, allCoords,lineWidthPix, white, [xCenter e4 - 220]); % fix cross after face
Screen('Flip', window); % fix cross on screen waiting for response
while GetSecs<time_to_respond+t_presented + 0.5
%% scanner button reposne
% in a while loop when you want to collect the response
if scanning == true
if Cfg.hardware.serial.oSerial.BytesAvailable
    sbuttons = str2num(fscanf(Cfg.hardware.serial.oSerial)); %
    if pressed==0
        switch sbuttons
            case {1, 2, 3, 4}
RT = GetSecs-t_presented;
                pressed = 1;
                response = sbuttons;
                 myTrials(ExpTrial).resp=response;
        myTrials(ExpTrial).RT=RT;
        end
       
    end
end 
end % ends 'if scanning'
if scanning == false
        [a, RT,key] = KbCheck;
        if a == 1;
        myTrials(ExpTrial).response = keyNames{find(key,'1')};
        myTrials(ExpTrial).RT = RT - t_presented;
        myTrials(ExpTrial).RT
        clear a;clear key
        end
end
end
end 
end
expName = strcat(subjID, {'_Results.mat'});
wrkspc = strcat(subjID, {'_workspace.mat'});
save(expName{1,1},'myTrials');
save(wrkspc{1,1})
sca;