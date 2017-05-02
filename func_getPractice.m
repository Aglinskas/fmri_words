function a = func_getPractice()

stimuli = 'People'; % directory of the faces folder
names = 'practice_names.txt'; %directory to names.txt

% Read in peoples names from the .txt file
fileID = fopen(names,'r');
C = textscan(fileID,'%q %*q %*d %f','Delimiter',',');
fclose(fileID);
%% Clean invisible files
% /Volumes/Aidas_HDD/Script_backups/fmri haloween test/Aidas/fmri_pilot/People)
% s_path = pwd;
% for p = 1: length(C{1})
%    cd  strcat('People/',C{1}{p},'/selected/')
%    delete ._*
%    cd ../../../
% end
% cd(s_path);
% 
% for p = 1 : 40;
% a = strcat('People/',C{1}{p},'/selected/');
% dir(a)
% end
% 
% %%%
for i = 1 : length(C{1,1});
selected_name = C{1,1}{i,1}; % just an initial value
%num_people = length(C{1,1});
%C{1,1} has all the names C{1,1}{2,1} is second one on the list. 1-294
% strcat(lastnames, {', '}, firstnames)
a(i).name = selected_name;
% go in the 'selected' folder and figure out how many pics it has
selected_name2 = strcat(stimuli, {'/'}, selected_name,{'/'}, 'selected' ,{'/'},'*.jpg');
%selected_name3 = selected_name2{1,1};
%temp(i).filenames = dir(selected_name2{1,1})
c = dir(selected_name2{1,1});
c = c(arrayfun(@(x) ~strcmp(x.name(1),'.'),c))
for ii = 1 : length(c) %length(dir(selected_name2{1,1}));
    tempc{ii,1} = c(ii).name;
    tempd{ii,1} = strcat(stimuli, {'/'}, selected_name,{'/'}, 'selected' ,{'/'},c(ii).name);
end
a(i).filenames = tempc;
a(i).filepaths = tempd;
a(i).imShow = zeros(1,length(tempc));
clear tempc;
clear tempd;
%B0 = selected_name2{1,1}; %strcat makes a cell, this takes the value from it
%B1 = dir(B0); % holds the contents of the directory
% listDir(~[listDir.isdir]).name
%%%% 
%B1(~[B1.isdir]).name
%B1;
%num_files2 = size(B1);
%struct2table(B1) gives a table


%fullpath = strcat(selected_name2,{'/'},B1(5).name)
%picture = strcat(stimuli, {'/'}, selected_name)


% selecting a random name
%num_pics = 0;
%while num_pics < 1
%choose_name = randi([1 num_people],1);
%choose_name = selected_name;
%chosen_name = C{1,1}{choose_name};
%chosen_path = strcat(stimuli, {'/'}, selected_name,{'/'}, 'selected' );

% go in the 'selected folder' get random pic
%path_to_name = chosen_path{1,1};
%folder_contents = dir(path_to_name);
%num_pics = length(folder_contents(~[folder_contents.isdir])); 
end
% folder_contents(~[folder_contents.isdir]).name lists all the pics
%chosen_path{1,1}(~[chosen_path{1,1}.isdir]).name
%select_random_pic_num = randi([3 num_pics + 2],1);

%random_pic_name = folder_contents(select_random_pic_num).name;
%chosen_pic_path = strcat(chosen_path, {'/'},random_pic_name);
%y = chosen_pic_path{1,1};
end
% folder_contents(~[folder_contents.isdir]).name lists all the pics
%chosen_path{1,1}(~[chosen_path{1,1}.isdir]).name
%select_random_pic_num = randi([3 num_pics + 2],1);

%random_pic_name = folder_contents(select_random_pic_num).name;
%chosen_pic_path = strcat(chosen_path, {'/'},random_pic_name);
%y = chosen_pic_path{1,1};