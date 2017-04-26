clear all
close all;
cd '/Users/aidasaglinskas/Desktop/fmri_words/'
subj_id = 'S99'

if ~exist([subj_id '_wrkspc.mat']) % if first Run, set up (files no exist)
scanning = false;
opts.subjID = subj_id;
opts.numBlocks = 16; % how many blocks to run in experiment if 15 = all blocks will be presented in a random order, if less, a random subset of tasks will be selected
opts.numTrials = 40; % number of faces to be shown per block
opts.instruct_time = 6; %time in seconds that instructions are on the screen (if not self paced)  
opts.t_fixCross = 4; % time that fixation cross is on the screen
opts.StimTime = 0.5;
opts.time_to_respond = 2.5 - opts.StimTime;
opts.fmriblocks = 80;
opts.fmriTrials = 8;
opts.TR = 2.5;
opts.offset = .1 % how much to take away from response time for nice round TRs 
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
%[ptb.screenXpixels, ptb.screenYpixels] = Screen('WindowSize', ptb.windowRect);;
else
    load([subj_id '_wrkspc.mat'])
end
% open screen
[ptb.window, ptb.windowRect] = Screen(ptb.screenNumber, 'openwindow',[128 128 128],ptb.manual_winsize);
ptb.ifi = Screen('GetFlipInterval', ptb.window);
[ptb.xCenter, ptb.yCenter] = RectCenter(ptb.windowRect);
%Screen('BlendFunction', ptb.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
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
            %Screen('flip',window); 
            Screen('flip',ptb.window); 
            ASF_WaitForScannerSynch([], Cfg);
            firstPulse=GetSecs;
            %Screen('flip',window);
            Screen('flip',ptb.window);
        else 
            firstPulse=GetSecs;
        end
ExpStart = firstPulse;
%%
exp.start = ExpStart;
wh_blocks = myTrials(length([myTrials.time_presented])+1).fmriBlock : opts.fmriblocks;

for this_block = wh_blocks;
    
temp.ins_line = this_block * opts.fmriTrials - opts.fmriTrials + 1; % which line
    temp.task_Instruct = myTrials(temp.ins_line).taskIntruct;
    temp.task_Name = myTrials(temp.ins_line).TaskName;
% Present Task Instructions
[temp.nx, temp.ny, temp.textbounds_i] = DrawFormattedText(ptb.window,temp.task_Name,'centerblock','center');
temp.n_lines_nm = length(strfind(temp.task_Name,'\n'))+1;
temp.n_lines_ins = length(strfind(temp.task_Instruct,'\n'))+1;
temp.line_width_ins = (temp.textbounds_i(4) - temp.textbounds_i(2)) / temp.n_lines_nm;

DrawFormattedText(ptb.window,temp.task_Instruct,'centerblock',ptb.yCenter + temp.line_width_ins*temp.n_lines_nm + temp.line_width_ins);
[x t_presented] = Screen('flip',ptb.window);

while GetSecs < t_presented + opts.instruct_time
    %do nothing
    % Wait instruction time 
end
% Fixation Cross
DrawFormattedText(ptb.window,'+','center','center');
[x t_presented] = Screen('flip',ptb.window);
while GetSecs < t_presented + opts.instruct_time %t_presented + opts.instruct_time
    % Wait dixation cross
end

for trial_ind = 1:opts.fmriTrials

%present name
l = length([myTrials.time_presented]) + 1;
DrawFormattedText(ptb.window, myTrials(l).word,'center','center');

temp.when_to_flip = ceil((GetSecs-exp.start) / opts.TR) * opts.TR;
temp.when_to_flip = temp.when_to_flip + exp.start;

[x t_presented] = Screen('flip',ptb.window,temp.when_to_flip);

myTrials(l).time_presented = t_presented - exp.start;
myTrials(l).TR = myTrials(l).time_presented / 2.5;
while GetSecs < t_presented + opts.StimTime
    % Wait stim on screen
end

DrawFormattedText(ptb.window,'+','center','center');
[x t_presented] = Screen('flip',ptb.window);
keyIsDown = 0;
while GetSecs < t_presented + opts.time_to_respond - opts.offset;
 % wait response time
            % If Scanning
            if scanning == true
            if Cfg.hardware.serial.oSerial.BytesAvailable
                sbuttons = str2num(fscanf(Cfg.hardware.serial.oSerial)); %
                if pressed==0
                    switch sbuttons
                        case {1, 2, 3, 4}
            RT = GetSecs-t_presented;
                            pressed = 1;
                            response = sbuttons;
               %myTrials(ExpTrial).resp=response;
               %myTrials(ExpTrial).RT=RT;
               myTrials(l).resp=response;
               myTrials(l).RT=RT;
                    end
                end
            end
            elseif ~scanning & ~keyIsDown% if not scanning
                [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
                if keyIsDown % if key pressed
                    oldTextColor=Screen('TextColor', ptb.window, [0 255 0]);
                    DrawFormattedText(ptb.window,'+','center','center');
                    [x temp.colourchange] = Screen('flip',ptb.window);
                    oldTextColor=Screen('TextColor', ptb.window, [0 0 0]);
                    myTrials(l).resp = KbName(find(keyCode));
                    myTrials(l).RT = GetSecs - t_presented;
                end % ends key if down if statement
                
                
            end % ends 'if scanning loop'
end % Ends wait for response
end %ends fmri Trials

% if end of run
exp.when_to_stop = arrayfun(@(x) myTrials(max(find([myTrials.fmriRun] == x))).fmriBlock,unique([myTrials.fmriRun]));
if ismember(this_block,exp.when_to_stop);
    DrawFormattedText(ptb.window,sprintf('End of Run %d/%d',myTrials(l).fmriRun,max([myTrials.fmriRun])),'center','center');
    [x t_presented] = Screen('flip',ptb.window);
   while GetSecs < t_presented + 5
       %wait
   end
   
    save([subj_id '_wrkspc.mat']);
    save([subj_id '_myTrials.mat'],'myTrials');
    sca
    break
end % ends if end-of-run
end % ends fmri blocks


