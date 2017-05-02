function myTrials = func_myPracticeTrials(numTrials,task_order);
ins = 5
monuments = 'Monuments/*.jpg';% directory of the faces folder
monuments2 = 'Monuments';
names = dir(monuments);
names = names(arrayfun(@(x) ~strcmp(x.name(1),'.'),names));
source = func_getPractice;
%% parameters, fix to feed to the func
numBlocks = 12;
n_rep = ceil(numTrials / 3);
if ins == 5 % Shorty Italian instructions
Task{1,1} = 'Memoria remota?'; %episodic
Task{1,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
Task{2,1} = 'Quanto attraente?';
Task{2,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
Task{3,1} = 'Quanto amichevole?';
Task{3,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
Task{4,1} = 'Quanto affidabile?';
Task{4,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
Task{5,1} = 'Quanto familiare?'; % semantic access 1
Task{5,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
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
Task{11,1} = 'Stesso Nome?';
Task{11,2} = '1 = Stesso nome\n2 = Nome diverso';
Task{12,1} = 'Stesso Nome?'; %control
Task{12,2} = '1 = Stesso nome\n2 = Nome diverso';
end
%% Task names and task instructions
if task_order == 1
randTask = 1 : numBlocks;
elseif task_order == 2
randTask = Shuffle(1:numBlocks);
end
%randTask = randperm(length(Task));
for b_count = 1 : numBlocks
for l_count = b_count * numTrials - (numTrials - 1) : b_count * numTrials;
    myTrials(l_count).TaskName = Task{randTask(b_count),1};
    myTrials(l_count).taskIntruct = Task{randTask(b_count),2};
    myTrials(l_count).task_number = randTask(b_count);
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
mon_task_index = find([myTrials.task_number] == 12);
for ll = 1 : numTrials;
% a(ll).name = names(ll).name;
myTrials(mon_task_index(ll)).filepath = strcat(monuments2, '/',names(ll).name);
end
    % Adds repetition for control and monuments tasks
   %% Code for the Control Task [Randomly repeats some of the pictures]
c_block = find([myTrials.task_number] == 11);
c_block(length(c_block)) = [];
r_cb = Shuffle(c_block); 
    for i_OW = 1 : n_rep; %repeats some of the faces
        myTrials(r_cb(i_OW) + 1).filepath = myTrials(r_cb(i_OW)).filepath;
    end
%% Monuments task code 
m_block = find([myTrials.task_number] == 12);
m_block(length(m_block)) = [];
r_cm = Shuffle(m_block);  
    for i_OM = 1 : n_rep %repeats some of the faces
        myTrials(r_cm(i_OM) + 1).filepath = myTrials(r_cm(i_OM)).filepath;
    end
    
% Add words and stim

for i = 1:length(myTrials);
temp = strsplit(myTrials(i).filepath,'/');
temp = strrep(temp,'.jpg','');
myTrials(i).word = temp{2};
spc_ind = strfind(temp{2},' ');
if isempty(spc_ind)
    myTrials(i).Stim = myTrials(i).word;
else
spc_ind = spc_ind(1);
myTrials(i).Stim = [myTrials(i).word(1:spc_ind-1) '\n' myTrials(i).word(spc_ind+1:end)];
end
end
end % ends the function

