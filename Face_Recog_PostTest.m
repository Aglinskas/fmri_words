Screen('Preference', 'SkipSyncTests', 1); % disable if script crashes. 
sca; %        
%% SUBJECT ID
subjID = 'wS1'
do_MIA = 1;
%% Keyboard
KbName('UnifyKeyNames');
kbnames = KbName('KeyNames');
RestrictKeysForKbCheck([]);
%%
% PsychDefaultSetup(2);
% Get the screen numbers 
screens = Screen('Screens');
screenNumber = max(screens); % Draw to the external screen if avaliable
%screenNumber = min(screens); % always draws on the main screen 
%screenNumber = 0 % overwrite
% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;
inc = white - grey;
%%SLF try
[window, windowRect] = Screen(screenNumber, 'openwindow',[128 128 128]);
% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
% Query the frame duration
ifi = Screen('GetFlipInterval', window);
% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);
% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
% Blank Screen is up. 
%% Actual thing
% Get the pics from the experiment
list = func_getpic5;
names = {};
names = {list.name}';
[recog(1:length(list)).name] = deal([]);
[recog(1:length(list)).RT] = deal([]);
[recog(1:length(list)).response] = deal([]);
[recog(1:length(list)).name] = deal(names{:});
%%
% Get parameters and and sizes and edges
[s1 s2 s3] = size(imread(list(1).filepaths{1}{1}));
e1 = xCenter - s2/2; % right edge of picture
e2 = xCenter + s2/2; % left edgle of picture
e3 = yCenter - s1/2 - 150; % top of picture
e4 = yCenter + s1/2 - 150; % bottom of picture
%%

for face = 1:length(recog)
theImageLocation = list(face).filepaths{1}{1}; % gets picture from list
theImage = imread(theImageLocation);
imageTexture = Screen('MakeTexture', window, theImage);
Screen('DrawTexture', window, imageTexture, [], [e1 e3 e2 e4],0);

% Text Yes/No21233211
task_name = 'Conosci questa persona?'
task_ins_text= '1 = Si\n2 = No'
Screen('TextSize', window, 28); 
Screen('TextFont', window, 'Courier');
DrawFormattedText(window, task_ins_text, 'center',yCenter + 100 , white); %shift up
DrawFormattedText(window, task_name, 'center', 15 , white); %shift up
Screen('Flip', window);
% Keyboard code 
%% Keyboard code
RestrictKeysForKbCheck([30 31]); % 1! 2@
t_on = GetSecs;
[secs, keyCode, deltaSecs] = KbWait(-1);
recog(face).RT = secs - t_on;
rsps = cell2mat(kbnames(find(keyCode == 1)));
rsps = str2num(rsps(1));
recog(face).response = rsps;
%% lights up the answer in yellow 
t = strsplit(task_ins_text,'\\n')
colors = {255;255;255;255};
colors{rsps} = [0 255 0];
[a b] = DrawFormattedText(window, [t{1} '\n'], 'center', yCenter + 100, colors{1})
DrawFormattedText(window, [t{2} '\n'], a, b, colors{2});

DrawFormattedText(window, task_name, 'center', 15 , white); %shift up
Screen('DrawTexture', window, imageTexture, [], [e1 e3 e2 e4],0);
Screen('Flip', window);
WaitSecs(0.5)
%Screen('Flip', window);WaitSecs(0.5)
save([subjID '_recog'],'recog')
end

if do_MIA == 1
%% Last slide
theImageLocation = 'Other/Last_slide_rank_Qs.001.jpeg';
theImage = imread(theImageLocation);
imageTexture = Screen('MakeTexture', window, theImage);
Screen('DrawTexture', window, imageTexture, [], windowRect,0)
Screen('Flip', window);
RestrictKeysForKbCheck([44])
KbWait(-1)
%%
%%
RestrictKeysForKbCheck([44]);
KbWait(-1)
sca;

% open '/Users/aidas_el_cap/Desktop/00_fmri_pilot_final/Food RSA Rating/Multi_Item_arrangement_instructions.pdf'
cd 'Food RSA Rating'
addpath(genpath(pwd))
run START_performMultiarrangement_AIDAS.m
end
cd /Users/aidas_el_cap/Desktop/00_fmri_pilot_final/
%%
% rspns = str2num(myTrials(ExpTrial).response{1}(1));
% t = strsplit(taskIntruct,'\\n');
% colors = {255;255;255;255};
% colors{rspns} = [255 255 0];
% [a b] = DrawFormattedText(window, [t{1} '\n'], cCenter, 350, colors{1});
% for i = 2:length(t);
% [a b] = DrawFormattedText(window, [t{i} '\n'], a, b, colors{i});
% end
% Screen('Flip', window);
%%
% [s1 s2 s3] = size(imread(myTrials(1).filepath));
% e1 = xCenter - s2/2; % right edge of picture
% e2 = xCenter + s2/2; % left edgle of picture
% e3 = yCenter - s1/2 - 150; % top of picture
% e4 = yCenter + s1/2 - 150; % bottom of picture