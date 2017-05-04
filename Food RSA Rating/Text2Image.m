% %%
% Task{1,1} = 'Colore dei capelli';
% Task{1,2} = '1 = Bionda\n2 = Scura\n3 = Altro\n4 = Pelata';
% Task{2,1} = 'Prima memoria (quanto remota)?'; %episodic
% Task{2,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% Task{3,1} = 'Quanto attraente?';
% Task{3,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% Task{4,1} = 'Quanto amichevole?';
% Task{4,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% Task{5,1} = 'Quanto affidabile?';
% Task{5,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% Task{6,1} = 'Emozioni positive?';
% Task{6,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% Task{7,1} = 'Quanto familiare?'; % semantic access 1
% Task{7,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% Task{8,1} = 'Quanto scrivere?';%semantic access 2
% Task{8,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% Task{9,1} = 'Comune il nome?';
% Task{9,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% Task{10,1} = 'Quanti fatti ricordare?';
% Task{10,2}  = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% Task{11,1} = 'Che lavoro?';
% Task{11,2} = '1 = Presentatore TV/attore\n2 = Cantante/Musicista\n3 = Politico/Sportivo\n4 = Altro/Non so';
% Task{12,1} = 'Quanto distintivo (volto)?';
% Task{12,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% Task{13,1} = 'Quanto integra?';
% Task{13,2} = '1 = Moltissimo\n2 = Molto\n3 = Poco\n4 = Pochissimo';
% Task{14,1} = 'Stesso volto?';
% Task{14,2} = '1 = Volto diverso\n2 = Stesso volto';
% Task{15,1} = 'Stesso monumento?'; %control
% Task{15,2} = '1 = monumento diverso\n2 = Stesso monumento';
% %% aidas' changes

%clear
%stim={ 'ATTRACTIVE','HONEST','MEMORY','FACES','ESSAY', 'ATTRACTIVE','HONEST','MEMORY','FACES','ESSAY'};
% stim = Task(1:13,1);
cd('/Users/aidas_el_cap/Desktop/00_fmri_pilot_final/Food RSA Rating')
stim = Task;

%% rest of code
for ii=1:length(stim)
I=ones(400,400);
ind=strfind(stim{ii},'\n');
if numel(ind)>0
RGB = insertText(I,[100 100],stim{ii}(1:ind-1),'FontSize',33); %44
RGB = insertText(RGB,[100 160],stim{ii}(ind+2:end),'FontSize',33); 
else
RGB = insertText(I,[0 100],stim{ii},'FontSize',44);
end
%RGB=imgaussfilt(RGB(:,:,:),0.1);
imshow(RGB)

x=find((RGB(110,:,3))<1);
x=x(round(length(x)/2));
y=find((RGB(:,110,3))<1);
y=y(round(length(y)/2));
x = x+1;
zeros(size(RGB));
outIm=squeeze(RGB(y-50:y+59,x-140:x+139,1));
outIm(:,:,2)=outIm;
outIm(:,:,3)=outIm(:,:,1);
stimuli(ii).name=stim{ii};
stimuli(ii).image=outIm;
stimuli(ii).alpha=double(outIm~=1);
% imshow(outIm)
% pause(.01)
end
save AidasStim stimuli