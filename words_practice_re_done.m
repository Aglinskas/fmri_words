clear;close all;clc
t_pracStart = GetSecs
scanning  = false;
commandwindow
subID = 'wS2'
myTrials = func_myPracticeTrials(5,1);
exp.pics_dir = './Pilot_pics/';
exp.pics_fn_temp = 'Pilot_pics.0%s.jpeg'; %num2str(1,'%.2i')
exp.ins_time = 4;
exp.fixCross_time = 6;
exp.stimTime = .5;
exp.respTime = 2;

key.keys = KbName('Keynames');
key.spaceKey = find(strcmp(key.keys,'space'));
% key.respkeys1234 = [find(strcmp(key.keys,'1!'))
% find(strcmp(key.keys,'2@'))
% find(strcmp(key.keys,'3#'))
% find(strcmp(key.keys,'4$'))];

key.respkeys1234 = [find(strcmp(key.keys,'a'))
find(strcmp(key.keys,'z'))
find(strcmp(key.keys,'m'))
find(strcmp(key.keys,'k'))];

slides.intro = 1:4;
slides.ready = 5;
slides.Q_slides = 6:17;
ptb.screen = 0;
ptb.win_size = [0 0 1280 800];%[0 0 640 480];
[ptb.window,ptb.rect] = Screen('OpenWindow',ptb.screen,[128 128 128],ptb.win_size);

if scanning
            try 
            a=instrfind('Tag', 'SerialResponseBox');fclose(a);
            end
            Cfg.ScannerSynchShowDefaultMessage = 1;
            Cfg.synchToScannerPort = 'SERIAL';
            Cfg.responseDevice = 'LUMINASERIAL';
            Cfg.serialPortName = 'COM1'
            Cfg = InitResponseDevice(Cfg); %LUMINA box: ASCII + highest baud rate (115200)
            DrawFormattedText (ptb.window, 'WAITING FOR THE SCANNER','center','center');
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


% intro slides
for i = slides.intro
trial.sl_ind = i;
trial.sl_fn = fullfile(exp.pics_dir,sprintf(exp.pics_fn_temp,num2str(trial.sl_ind,'%.2i')));
trial.img = imread(trial.sl_fn);
temp.txt_ind = Screen('MakeTexture',ptb.window,trial.img);
Screen('DrawTexture',ptb.window,temp.txt_ind,[],ptb.win_size);
Screen(ptb.window,'Flip');
RestrictKeysForKbCheck(key.spaceKey);
keyIsDown = 0;
%pause(.5);
while ~keyIsDown
[keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
end %ends key wait
WaitSecs(.5)
end %ends intro slides

% Main Practice
trial = [];
for t_ind = 1:length(slides.Q_slides)
 trial.slide_num = slides.Q_slides(t_ind);
 trial.mt_lines = find([myTrials.blockNum] == t_ind);
 for show_slide = [trial.slide_num slides.ready]
 trial.slide_fn = fullfile(exp.pics_dir,sprintf(exp.pics_fn_temp,num2str(show_slide,'%.2i')));
 trial.slide_img = imread(trial.slide_fn);
 trial.slide_texture = Screen('MakeTexture',ptb.window,trial.slide_img)
 Screen('DrawTexture',ptb.window,trial.slide_texture,[],ptb.win_size)
 Screen('Flip',ptb.window)
 
         RestrictKeysForKbCheck(key.spaceKey);
         keyIsDown = 0;
         while ~keyIsDown
            keyIsDown = KbCheck;
         end
         WaitSecs(.5)
 end
 
[ptb.xCenter, ptb.yCenter] = RectCenter(ptb.win_size)
% Task ins screen 
temp.task_Instruct = myTrials(trial.mt_lines(1)).taskIntruct;
temp.task_Name = myTrials(trial.mt_lines(1)).TaskName;
[temp.nx, temp.ny, temp.textbounds_i] = DrawFormattedText(ptb.window,temp.task_Name,'centerblock','center');
temp.n_lines_nm = length(strfind(temp.task_Name,'\n'))+1;
temp.n_lines_ins = length(strfind(temp.task_Instruct,'\n'))+1;
temp.line_width_ins = (temp.textbounds_i(4) - temp.textbounds_i(2)) / temp.n_lines_nm;
DrawFormattedText(ptb.window,temp.task_Instruct,'centerblock',ptb.yCenter + temp.line_width_ins*temp.n_lines_nm + temp.line_width_ins);
Screen('flip',ptb.window)
pause(exp.ins_time)
DrawFormattedText(ptb.window,'+','center','center')
Screen('flip',ptb.window)
pause(exp.fixCross_time)

 
for mt_line = trial.mt_lines

DrawFormattedText(ptb.window,myTrials(mt_line).Stim,'center','center');
Screen('Flip',ptb.window)
pause(exp.stimTime)

DrawFormattedText(ptb.window,'+','center','center')
[trial.crap trial.time0] = Screen('flip',ptb.window);
if find(trial.mt_lines==mt_line) < 3
    cond = '~keyPressed | GetSecs < trial.time0+exp.respTime';
else
    cond = 'GetSecs < trial.time0+exp.respTime';
end
keyPressed = 0;
pressed = 0;
RestrictKeysForKbCheck(key.respkeys1234)
while eval(cond);
 % wait response time
            % If Scanning
if scanning == true
            if Cfg.hardware.serial.oSerial.BytesAvailable
                sbuttons = str2num(fscanf(Cfg.hardware.serial.oSerial)); %
                if pressed==0
                    switch sbuttons
                        case {1, 2, 3, 4}
            RT = GetSecs-trial.time0;
                            pressed = 1;
                            response = sbuttons;
               %myTrials(ExpTrial).resp=response;
               %myTrials(ExpTrial).RT=RT;
               myTrials(mt_line).resp=response;
               myTrials(mt_line).RT=RT;
                    % Colour Change
                    oldTextColor=Screen('TextColor', ptb.window, [0 255 0]);
                    DrawFormattedText(ptb.window,'+','center','center');
                    [x temp.colourchange] = Screen('flip',ptb.window);
                    oldTextColor=Screen('TextColor', ptb.window, [0 0 0])
                    keyPressed = 1;
                    end
                end
            end
            elseif ~scanning% if not scanning
                [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
                if keyIsDown % if key pressed
                    oldTextColor=Screen('TextColor', ptb.window, [0 255 0]);
                    DrawFormattedText(ptb.window,'+','center','center');
                    [x temp.colourchange] = Screen('flip',ptb.window);
                    oldTextColor=Screen('TextColor', ptb.window, [0 0 0]);
                    myTrials(mt_line).resp = KbName(find(keyCode));
                    myTrials(mt_line).RT = GetSecs - trial.time0;
                    keyPressed = 1;
                    pause(.3)
                end % ends key if down if statement    
            end % ends 'if      canning loop'
                
end % Ends wait for response
if isempty(myTrials(mt_line).resp)
            oldTextColor=Screen('TextColor', ptb.window, [255 0 0]);
            DrawFormattedText(ptb.window,'+','center','center');
            [x temp.colourchange] = Screen('flip',ptb.window);
            oldTextColor=Screen('TextColor', ptb.window, [0 0 0]);                 
            pause(1)
end
RestrictKeysForKbCheck(key.spaceKey)
end %ends mt_lines 
end % ends first half of the practice;


%[ptb.window,ptb.rect] = Screen('OpenWindow',ptb.screen,[128 128 128],ptb.win_size);
temp.txt = 'Great Job! \nNow that you know the instructions\nyou''ll see the questions again in randomised order\nThe same as you will in the experiment\n\n(Press Space Key To Continue)';
DrawFormattedText(ptb.window,temp.txt,'center','center')
Screen('Flip',ptb.window)
RestrictKeysForKbCheck(key.spaceKey)
myTrials1st = myTrials;
myTrials = func_myPracticeTrials(5,2)

KbWait
RestrictKeysForKbCheck(key.respkeys1234)
for test_block = unique([myTrials.blockNum]);
    ttrial.test_block_ind = test_block%test_block;
    ttrial.mt_inds = find([myTrials.blockNum] == ttrial.test_block_ind);
    
    DrawFormattedText(ptb.window,myTrials(ttrial.mt_inds(1)).TaskName,'center','center')
    Screen('flip',ptb.window)
    WaitSecs(exp.ins_time)
    DrawFormattedText(ptb.window,'+','center','center')
    Screen('flip',ptb.window)
    WaitSecs(exp.fixCross_time)
    for test_trial = ttrial.mt_inds
        DrawFormattedText(ptb.window,myTrials(test_trial).Stim,'center','center')
        Screen('flip',ptb.window)
        WaitSecs(exp.stimTime)
        DrawFormattedText(ptb.window,'+','center','center')
        [temp.crap ttrial.t0] = Screen('flip',ptb.window)
        while GetSecs < ttrial.t0 + exp.respTime
          if scanning
          else
             [keyIsDown, secs, keyCode] = KbCheck;
             if keyIsDown
                 myTrials(test_trial).resp = KbName(keyCode);
                 myTrials(test_trial).RT = GetSecs - ttrial.t0;
             end
        end
        end % end response loop
    end % end block ttials
end % ends vlock


temp.txt = 'That''s it, end of practice :)\nGo tell the experimenter how awesome you did!'
DrawFormattedText(ptb.window,temp.txt,'center','center')
Screen('Flip',ptb.window)
RestrictKeysForKbCheck(key.spaceKey)
KbWait
sca

pracTime = (GetSecs - t_pracStart) / 60;
save([subID '_practice'])