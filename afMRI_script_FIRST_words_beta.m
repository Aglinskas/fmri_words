close all;
scanning= true ;
Screen('Preference', 'SkipSyncTests', 1); % disable if script crashes. 
sca
%% parameters
subjID = 'S99'
numBlocks = 16; % how many blocks to run in experiment if 15 = all blocks will be presented in a random order, if less, a random subset of tasks will be selected
numTrials = 40; % number of faces to be shown per block
instruct_time = 6; %time in seconds that instructions are on the screen (if not self paced)  
t_fixCross = 4; % time that fixation cross is on the screen
StimTime = 0.5;
time_to_respond = 2.5 - StimTime;
fmriblocks = 80;
fmriTrials = 8;
debug_mode = 0;
TR = 2.5;
%% load random pics for the experiment
myTrials = func_GetMyTrials; %getTrials
%% Set up KbCheck and keyboard related things
enabledKeyes = [30;31;32;33;44];
responseKeyes = [30;31;32;33];
spaceKey = [44];
keyNames = KbName('KeyNames');
RestrictKeysForKbCheck(enabledKeyes);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PTB CODE
% Get the screen numbers
screens = Screen('Screens');
screenNumber = 0%max(screens); % Draw to the external screen if avaliable
% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;
inc = white - grey;
%% SLF try
[window, windowRect] = Screen(screenNumber, 'openwindow',[128 128 128],[0 0 640 480]);
% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
% Query the frame duration
ifi = Screen('GetFlipInterval', window);
% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
%% set up corners
%theImageLocation = myTrials(1).filepath; % gets picture from myTrials
%theImage = imread(theImageLocation);
%[s1, s2, s3] = size(theImage);
%e1 = xCenter - s2/2; % right edge of picture
%e2 = xCenter + s2/2; % left edgle of picture
%e3 = yCenter - s1/2 - 150; % top of picture
%e4 = yCenter + s1/2 - 150; % bottom of picture
%%
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
%%
ExpStart = GetSecs;
%%  BLOCKS here
for expBlock = 1 : fmriblocks
    %% Sets up the task and prompts
    save(subjID,'myTrials')
    if expBlock == 17
        save(subjID)
        break
    end
   taskName = myTrials(expBlock * fmriTrials - fmriTrials + 1).TaskName;
   taskIntruct = myTrials(expBlock * fmriTrials - fmriTrials + 1).taskIntruct;
%% 
Screen('TextSize', window, 28);
Screen('TextFont', window, 'Courier');
DrawFormattedText(window, taskName, 'center', 'center', white);
% Task instructions
%Screen('TextSize', window, 24);
%Screen('TextFont', window, 'Courier');
%lower_third = 600;
%t_offset = 0;
%cCenter = xCenter - length(taskIntruct); %change
%DrawFormattedText(window, taskIntruct, cCenter, lower_third, white);

Screen('Flip', window);

WaitSecs(instruct_time); % length of time that task and instructions are on the screen
%fixCrossDimPix = 40;
%xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
%yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
%allCoords = [xCoords; yCoords];

% Set the line width for our fixation cross
%lineWidthPix = 4;
%Screen('DrawLines', window, allCoords,lineWidthPix, white, [xCenter e4 - t_offset]); % change 2350 is the y coord
DrawFormattedText(window, '+', 'center','center', white);
Screen('Flip', window);
WaitSecs(t_fixCross); % Time that fixation cross is on the screen
a_t = ceil((GetSecs - ExpStart)/TR)*TR;
while GetSecs - ExpStart < a_t
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EXPERIMENTAL RUN. 1 loop of code below = 1 trial
for ExpTrial = expBlock * fmriTrials - (fmriTrials - 1) : expBlock * fmriTrials; % code that matches blocks, trials, and trials per block
    pressed=0;
%  e1 = xCenter - s2/2;
%  e2 = xCenter + s2/2;
%  e3 = yCenter - s1/2 - 150;
%  e4 = yCenter + s1/2 - 150;
%                         % Screen('DrawTexture', window, imageTexture, [], [e1 e3 e2 e4],0);
DrawFormattedText(window, myTrials(ExpTrial).Stim, 'center','center', white);
%lower_third = 600;

% Flip to the screen
Screen('Flip', window); % the image is now on the screen
timePresented = GetSecs - ExpStart;
t_presented = GetSecs;
myTrials(ExpTrial).time_presented = timePresented;
myTrials(ExpTrial).TR = timePresented / 2.5;
WaitSecs(StimTime);
%Screen('FillRect', window, grey); % screen  is now blanc
%Screen('DrawLines', window, allCoords,lineWidthPix, white, [xCenter e4 - t_offset]); % fix cross after face
DrawFormattedText(window, '+', 'center','center', white);
Screen('Flip', window); % fix cross on screen waiting for response
r_ons = GetSecs;
while GetSecs<time_to_respond+r_ons %0.5 offset seems important, dunno why tho
%% scanner button reposne
% in a while loop when you want to collect the response
if scanning == true
if Cfg.hardware.serial.oSerial.BytesAvailable
    RT = GetSecs-r_ons;
    sbuttons = fscanf(Cfg.hardware.serial.oSerial); %
    sbuttons = strrep(sbuttons,'5','');
    
    if ~isempty(sbuttons)
    myTrials(ExpTrial).RT = RT ;
    myTrials(ExpTrial).response = sbuttons;
%     disp(myTrials(ExpTrial).response)
%     disp(myTrials(ExpTrial).RT)
    end
    
end 
end % ends 'if scanning loop'
if scanning == false 
        [a, RT,key] = KbCheck;
        if a == 1;
        myTrials(ExpTrial).response = keyNames{find(key)};
        myTrials(ExpTrial).RT = RT - r_ons;
        clear a;clear key; clear RT;
        end
end
end
end
end
expName = strcat(subjID, {'_Results.mat'});
wrkspc = strcat(subjID, {'_workspace.mat'});
save(expName{1,1},'myTrials');
save(wrkspc{1,1});
DrawFormattedText(window, 'End of Run', 'center','center', white)
Screen('Flip', window); % fix cross on screen waiting for response
WaitSecs(5)
sca;