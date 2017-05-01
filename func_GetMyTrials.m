%source(1).filepaths{1,1} %surce(i) name counter, filepaths{i,1} picture counter
%myTrials = source

function myTrials = func_testTrials;

%ISI = 3;
%time_to_respond = 3.5;
monuments = 'Monuments/*.jpg';% directory of the faces folder
monuments2 = 'Monuments';
names = dir(monuments);
names = names(arrayfun(@(x) ~strcmp(x.name(1),'.'),names));
%numTrials = 40;
source = func_getpic5();
%rng((rand * GetSecs));
%% parameters, fix to feed to the func
numTrials = 40;
numBlocks = 16;
num_fmriTrials = 8; % has to divide evenly by numTrials
num_fmriBlocks = numTrials * numBlocks / num_fmriTrials; % total number of trials / fmriTrials
sort = 1; % 1 myTrials in fmri sequence puts, elses
%control_task = Task{14,1};% which task is control task?
%monuments_task = Task{15,1};
n_rep = ceil(numTrials / 3);

% % Task{1,1} = 'Colore dei capelli';
% % Task{1,2} = '1 = Bionda\n2 = Scura\n3 = Pelata\n4 = Altro';
% Task{2,1} = 'Memoria remota?'; %episodic
% Task{2,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% Task{3,1} = 'Quanto attraente?';
% Task{3,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% Task{4,1} = 'Quanto amichevole?';
% Task{4,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% Task{5,1} = 'Quanto affidabile?';
% Task{5,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% % Task{6,1} = 'Emozioni positive?';
% % Task{6,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% Task{7,1} = 'Quanto familiare?'; % semantic access 1
% Task{7,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% % Task{8,1} = 'Quanto scriveresti?';%semantic access 2
% % Task{8,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% Task{9,1} = 'Nome comune?';
% Task{9,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% Task{10,1} = 'Quanti fatti ricordi?';
% Task{10,2}  = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% Task{11,1} = 'Che lavoro fa?';
% Task{11,2} = '1 = Presentatore TV/attore\n2 = Cantante/Musicista\n3 = Politico/Sportivo\n4 = Altro/Non so';
% Task{12,1} = 'Volto distintivo?';
% Task{12,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% % Task{13,1} = 'Quanto integra?';
% % Task{13,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% Task{14,1} = 'Stesso volto?';
% Task{14,2} = '1 = Volto diverso\n2 = Stesso volto';
% Task{15,1} = 'Stesso monumento?'; %control
% Task{15,2} = '1 = Monumento diverso\n2 = Stesso monumento';
% Task{16,1} = 'Stesso monumento?';
% Task{16,2} = '1 = Volto diverso\n2 = Stesso volto';
% Task{17,1} = 'Stesso monumento?';
% Task{17,2} = '1 = Volto diverso\n2 = Stesso volto';
%%
% Task{1,1} = 'Colore dei capelli';
% Task{1,2} = '1 = Bionda\n2 = Scura\n3 = Pelata\n4 = Altro';
Task{1,1} = 'Memoria remota?'; %episodic
Task{1,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
Task{2,1} = 'Quanto attraente?';
Task{2,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
Task{3,1} = 'Quanto amichevole?';
Task{3,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
Task{4,1} = 'Quanto affidabile?';
Task{4,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
                % Task{6,1} = 'Emozioni positive?';
                % Task{6,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
Task{5,1} = 'Quanto familiare?'; % semantic access 1
Task{5,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
                % Task{8,1} = 'Quanto scriveresti?';%semantic access 2
                % Task{8,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
Task{6,1} = 'Nome comune?';
Task{6,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
Task{7,1} = 'Quanti fatti ricordi?';
Task{7,2}  = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
Task{8,1} = 'Che lavoro fa?';
Task{8,2} = '1 = Presentatore TV/attore\n2 = Cantante/Musicista\n3 = Politico/Sportivo\n4 = Altro/Non so';
Task{9,1} = 'Volto distintivo?';
Task{9,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
Task{10,1} = 'Cognome comune?';
Task{10,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% Task{10,1} = 'Sicuramente conoscere\n(nome e cognome)?';
% Task{10,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
                % Task{10,1} = 'Quanto integra?';
                % Task{10,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
Task{11,1} = 'Stesso nome?';
Task{11,2} = '1 = Nome diverso\n2 = Stesso nome';
Task{12,1} = 'Stesso nome?';
Task{12,2} = '1 = Nome diverso\n2 = Stesso nome';
Task{13,1} = 'Stesso nome?';
Task{13,2} = '1 = Nome diverso\n2 = Stesso nome';
% Task{14,1} = 'Stesso monumento?'; %control
% Task{14,2} = '1 = Monumento diverso\n2 = Stesso monumento';
% Task{15,1} = 'Stesso monumento?';
% Task{15,2} = '1 = Monumento diverso\n2 = Stesso monumento';
% Task{16,1} = 'Stesso monumento?';
% Task{16,2} = '1 = Monumento diverso\n2 = Stesso monumento';

Task{14,1} = 'Stesso nome?'; %control
Task{14,2} = '1 = nome diverso\n2 = Stesso nome';
Task{15,1} = 'Stesso nome?';
Task{15,2} = '1 = nome diverso\n2 = Stesso nome';
Task{16,1} = 'Stesso nome?';
Task{16,2} = '1 = nome diverso\n2 = Stesso nome';
%%
%% Task names and task instructions
randTask = 1 : 16;
%randTask = randperm(length(Task));
for b_count = 1 : numBlocks
for l_count = b_count * numTrials - (numTrials - 1) : b_count * numTrials;
    myTrials(l_count).TaskName = Task{randTask(b_count),1};
    myTrials(l_count).taskIntruct = Task{randTask(b_count),2};
end
end

start_line = 1;
for block_counter = 1: numBlocks

    pres_order = randperm(length(source)); %shuffles presentation order 
   
   for trial = start_line : start_line + numTrials - 1
       name = source(pres_order(trial)).name;
       unshown_pics = find(source(pres_order(trial)).imShow == 0);
       
      if isempty(unshown_pics) == 1;
         source(pres_order(trial)).imShow = zeros(1,length(source(pres_order(trial)).imShow));
          unshown_pics = find(source(pres_order(trial)).imShow == 0);
       end
       
       select_pic_to_show_ind = randi(length(unshown_pics),1);
       select_pic_to_show = unshown_pics(select_pic_to_show_ind);
       pic_to_show = source(pres_order(trial)).filepaths{select_pic_to_show,1};
       
       write_line = trial + block_counter * numTrials - numTrials;
       myTrials(write_line).filepath = pic_to_show{1,1};
       source(pres_order(trial)).imShow(select_pic_to_show) = 1;
       myTrials(write_line).blockNum = block_counter;
       myTrials(write_line).trialnum = trial;
   end
end



%function a = func_getmon();
%numTrials = 40;
%a = struct;

for mb = 14:16
mon_task_index = find([myTrials.blockNum] == mb);
norm_ll = 1 : numTrials;
s_ll = Shuffle(norm_ll);
for ll = 1 : numTrials;
% a(ll).name = names(ll).name;
myTrials(mon_task_index(ll)).filepath = strcat(monuments2, '/',names(s_ll(ll)).name);
end
end


    % Adds repetition for control and monuments tasks
   %% Code for the Control Task [Randomly repeats some of the pictures]
% n_rep has been moved to top of code, next to the parameters
for cb_ind = 11:13
c_block = find([myTrials.blockNum] == cb_ind);
c_block(length(c_block)) = [];
%if CurrentTask{1,1}{1,1} == control_task;
r_cb = Shuffle(c_block); 
    for i_OW = 1 : n_rep; %repeats some of the faces
        myTrials(r_cb(i_OW) + 1).filepath = myTrials(r_cb(i_OW)).filepath;
    end
end
% end of Control Task code

%% Monuments task code
for mb = 14:16
m_block = find([myTrials.blockNum] == mb);
% for i = 1 : numTrials
%     myTrials(m_block(1) + i - 1).filenames = myTrials(i).monuments;
% end
m_block(length(m_block)) = [];
%if CurrentTask{1,1}{1,1} == control_task;
r_cm = Shuffle(m_block);  
    for i_OM = 1 : n_rep %repeats some of the faces
        myTrials(r_cm(i_OM) + 1).filepath = myTrials(r_cm(i_OM)).filepath;
    end
end
% fmriblocks
% 


%%

% for i = 1 : length(myTrials);
% %myTrials(i).ISI = ISI;
% myTrials(i).time_to_respond = time_to_respond;
% end

% %% Skips first trials of control tasks
% % for monuments task
%  mon_counter1 = find([myTrials.blockNum] == 15);
%  mon_counter2 = [myTrials(mon_counter1(1):mon_counter1(length(mon_counter1))).fmriblock];
%  umf = unique(mon_counter2); % fmri blocks for the monuments task
% 
%  for i = 1 : length(umf);
%   mon_counter = find ([myTrials.fmriblock] == umf(i));
%  %myTrials(mon_counter(1)).ISI = 0.3;
%  myTrials(mon_counter(1)).time_to_respond = 0.3;
%  end
%  
%  face_counter1 = find([myTrials.blockNum] == 14);
%  face_counter2 = [myTrials(face_counter1(1):face_counter1(length(face_counter1))).fmriblock];
%  uff = unique(face_counter2); % fmri blocks for the monuments task
% 
%  for i = 1 : length(uff);
%   face_counter = find ([myTrials.fmriblock] == uff(i));
%  %myTrials(face_counter(1)).ISI = 0.3;
%  myTrials(face_counter(1)).time_to_respond = 0.3;
%  end
%  
 
%  
%  %for faces control task
%  faces_counter(1,:) = find([myTrials.blockNum] == 14);
%  faces_counter(2,:) = [myTrials(faces_counter(1):faces_counter(length(faces_counter))).fmriblock];
%  ucf = unique(faces_counter(2,:)); % fmri blocks for the monuments task
% 
%  for i = 1 : length(ucf)
%   faces_counter = find ([myTrials.fmriblock] == ucf(i))
%  myTrials(faces_counter(1)).ISI = 0.2
%  myTrials(faces_counter(1)).time_to_respond = 0.2
%  end
%  
%sorting should be left as the last step
s_line = [0;8;16;24;32];
   %r_fmri_blocks = randperm(num_fmriBlocks);
  r_fmri_run = 1:5;
for k = 1 : 5;
     %r_fmri_blocks = Shuffle(1:15);
     for o = 0 : 15
for i = 1 : num_fmriTrials;
    myTrials(s_line(k) + i + o*40).fmriRun = r_fmri_run(k);
end
end
end
[~,index] = sortrows([myTrials.fmriRun].'); myTrials = myTrials(index); clear index;


%rand_fmri_b = [shuffle_conds(1:16);shuffle_conds(17:32);shuffle_conds(33:48);shuffle_conds(49:64);shuffle_conds(65:80)]
% old shuffling, revert to this if script crashes
rand_fmri_b = [Shuffle(1:16),Shuffle(17:32),Shuffle(33:48),Shuffle(49:64),Shuffle(65:80)]';

s_line = 0;
for i = 1 : num_fmriBlocks;
    for k = 1: num_fmriTrials;
        myTrials(s_line + k).fmriBlock = rand_fmri_b(i);
    end
    s_line = s_line + num_fmriTrials;
end

if sort == 1;
    [~,index] = sortrows([myTrials.fmriBlock].'); myTrials = myTrials(index); clear index;
end

%%
for i = 1:length(myTrials)
a = strsplit(myTrials(i).filepath,'/');
if strcmp(a{1},'People')
    myTrials(i).word = a{2};
elseif strcmp(a{1},'Monuments')
    w = a{2};
    trim = {'.jpg' 'copy' '1' '2' '3' '4' '5' '6' '7' '8' '9' '0'};
    for tt = 1:length(trim);
    w = strrep(w,trim{tt},'');
    end
    
    if strcmp(w(1),' ')
        w = w(2:end);
    end
    if strcmp(w(end),' ')
        w = w(1:end-1);
    end
    myTrials(i).word = w;
else 
    error('wut')
end 
end % ends the function

%[myTrials.Stim] = deal(myTrials.word)
for i = 1:length(myTrials)
    spc_ind = strfind(myTrials(i).word,' ');
    if isempty(spc_ind)
        myTrials(i).Stim = myTrials(i).word;
    else
    spc_ind = spc_ind(1);
    myTrials(i).Stim = replaceBetween(myTrials(i).word,myTrials(i).word(1:spc_ind-1),myTrials(i).word(spc_ind+1:end),'\n');
    end
end

myTrials(1).StimType = nan;
m_inds = find(ismember([myTrials.blockNum],[14 15 16]));
f_inds = find(ismember([myTrials.blockNum],[1:13]));
[myTrials(m_inds).StimType] = deal(2);
[myTrials(f_inds).StimType] = deal(1);

myTrials(1).time_presented = [];
myTrials(1).TR = [];
myTrials(1).resp = [];
myTrials(1).RT = [];

%myTrials = func_GetMyTrials;




%sp = cellfun(@(x) length(strfind(x,' ')),{myTrials.word})';
%{myTrials(find(sp == 3)).word}'
%source(pres_order(1)).filepaths{1,1}
%for block_prefill2 = 1 : numBlocks
%for line_prefill2 = block_prefill2 * numTrials - (numTrials - 1) : block_prefill2 * numTrials;
   
   
    %pres_order(line_prefill2)
    %myTrials(line_prefill2).line_prefill2 = line_prefill2;
    %myTrials(line_prefill2).block_prefill2 = block_prefill2;
    %myTrials(line_prefill).TaskName = Task{randTask(block_prefill),1};
%end
%end
    

