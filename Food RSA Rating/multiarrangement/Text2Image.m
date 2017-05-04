clear
stim={    'cassola'
    'piadina'
    'pasta al\npesto'
    'tagliatelle al\nragu'
    'cannoli'
    'panettone'
    'tortellini'
    'canederli'
    'ndujia'
    'casatiello'
    'mozzarella di\nbufala'
    'taralli'
    'ragu di\ncervo'
    'carbonara'
    'gorgonzola'
    'patate riso\ne cozze'
    'ribollita'
    'mortadella'
    'pandoro'
    'parmigiano'
    'pizzoccheri'
    'orecchiette'
    'friarelli'
    'polenta e\nosei'
    'cotoletta'
    'cozze ripiene\nal sugo'
    'arancini'
    'pastiera'
    'carne salada'
    'gnocco fritto'
    'amatriciana'
    'cacio e\npepe'};

for ii=1:length(stim)
I=ones(400,400);
ind=strfind(stim{ii},'\n');
if numel(ind)>0
RGB = insertText(I,[100 100],stim{ii}(1:ind-1),'FontSize',44);
RGB = insertText(RGB,[100 160],stim{ii}(ind+2:end),'FontSize',44);
else
RGB = insertText(I,[100 100],stim{ii},'FontSize',44);
end
% RGB=imgaussfilt(RGB(:,:,:),0.1);
imshow(RGB)

x=find((RGB(110,:,3))<1);
x=x(round(length(x)/2));
y=find((RGB(:,110,3))<1);
y=y(round(length(y)/2));

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
save FoodStim stimuli