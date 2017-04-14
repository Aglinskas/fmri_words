clear all
close all;
scanning= false;
%
opts.subjID = 'S99';
opts.numBlocks = 16; % how many blocks to run in experiment if 15 = all blocks will be presented in a random order, if less, a random subset of tasks will be selected
opts.numTrials = 40; % number of faces to be shown per block
opts.instruct_time = 6; %time in seconds that instructions are on the screen (if not self paced)  
opts.t_fixCross = 4; % time that fixation cross is on the screen
opts.StimTime = 0.5;
opts.time_to_respond = 2.5 - opts.StimTime;
opts.fmriblocks = 80;
opts.fmriTrials = 8;
opts.TR = 2.5;
% load random pics for the experiment
myTrials = func_GetMyTrials; %getTrial
% Open up Screen 
sca
Screen('Preference', 'SkipSyncTests', 1); % disable if script crashes
ptb.screens = Screen('Screens');
ptb.screenNumber = 0;
ptb.white = WhiteIndex(ptb.screenNumber);
ptb.black = BlackIndex(ptb.screenNumber);
ptb.grey = ptb.white / 2;
%ptb.inc = white - grey;
ptb.manual_winsize = [0 0 640 480];
[ptb.window, ptb.windowRect] = Screen(ptb.screenNumber, 'openwindow',[128 128 128],ptb.manual_winsize);
%[ptb.screenXpixels, ptb.screenYpixels] = Screen('WindowSize', ptb.windowRect);
ptb.ifi = Screen('GetFlipInterval', ptb.window);
[ptb.xCenter, ptb.yCenter] = RectCenter(ptb.windowRect);
Screen('BlendFunction', ptb.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
% scanner 
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
else 
    firstPulse=GetSecs;
end
ExpStart = GetSecs;

%%
exp.start = ExpStart;
for this_block = 1:opts.fmriblocks;
    

%     ptb.fontSize = 28
%     ptb.font = 'ariel'
%     
%     
% Screen('TextSize', ptb.window, ptb.fontSize);
% Screen('TextFont', ptb.window, ptb.font);
% 


trial_struct.ins_line = this_block * opts.fmriTrials - opts.fmriTrials + 1 % which line
    temp.task_Instruct = myTrials(trial_struct.ins_line).taskIntruct;
    temp.task_Name = myTrials(trial_struct.ins_line).TaskName;

%Screen('flip',ptb.window)
[temp.nx, temp.ny, temp.textbounds_i] = DrawFormattedText(ptb.window,temp.task_Name,'centerblock','center');
temp.n_lines_nm = length(strfind(temp.task_Name,'\n'))+1;

temp.n_lines_ins = length(strfind(temp.task_Instruct,'\n'))+1;
temp.line_width_ins = (temp.textbounds_i(4) - temp.textbounds_i(2)) / temp.n_lines_nm;

DrawFormattedText(ptb.window,temp.task_Instruct,'centerblock',ptb.yCenter + temp.line_width_ins*temp.n_lines_nm + temp.line_width_ins);

Screen('flip',ptb.window)


pause(opts.instruct_time)








end
%%

% Screen('flip',ptb.window)
% [temp.nx, temp.ny, temp.textbounds_i] = DrawFormattedText(ptb.window,temp.task_Instruct,'centerblock','center')
% temp.n_lines_ins = length(strfind(temp.task_Instruct,'\n'))+1;
% temp.line_width_ins = (temp.textbounds_i(4) - temp.textbounds_i(2)) / temp.n_lines_ins;
% temp.n_lines_nm = length(strfind(temp.task_Name,'\n'))+1;
% 
% DrawFormattedText(ptb.window,temp.task_Name,'center',ptb.yCenter - temp.line_width_ins*temp.n_lines_nm - temp.line_width_ins)
% Screen('flip',ptb.window)