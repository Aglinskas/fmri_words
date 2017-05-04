load('AidasStim.mat')
load('/Users/aidas_el_cap/Desktop/Tasks_ita.mat')
[stimuli([1:length(stimuli)]).name] = deal([]);
[stimuli([1:length(stimuli)]).image] = deal([]);
[stimuli([1:length(stimuli)]).alpha] = deal([]);
 %%
t = {Task{1:10,1}}';
stimuli([13 12 11]) = []
%%
[stimuli([1:10]).name] = deal(t{1:10})
%%
pics = '/Users/aidas_el_cap/Desktop/Work_files/Task_pics/'
ext = '*.png'
a = dir([pics ext])

for i = 1:length(a)
stimuli(i).image = imread(fullfile(pics,a(i).name));
stimuli(i).alpha = repmat(1,size(imread(fullfile(pics,a(i).name))))
end

%%
save('AidasStim.mat','stimuli')