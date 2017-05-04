
        stim{1}=shuffle({'armadillo', 'bradipo', 'capra', 'castoro', 'cinghiale', 'coniglio', 'coyote', 'criceto', 'donnola', 'formichiere', 'gazzella', 'iena', 'koala', 'lemure', 'leone', 'lepre', 'lince', 'lontra', 'maiale', 'marmotta', 'ornitorinco', 'pantera', 'pecora', 'procione', 'puzzola', 'riccio', 'scimmia', 'scoiattolo', 'talpa', 'tigre', 'volpe', 'zebra'});
  stim{2}=shuffle({'airone', 'allodola', 'anatra', 'aquila', 'avvoltoio', 'canarino', 'cicogna', 'cigno', 'colomba', 'corvo', 'fagiano', 'falco', 'fenicottero', 'gabbiano', 'gallina', 'gallo', 'gazza', 'gufo', 'merlo', 'oca', 'pappagallo', 'passero', 'pavone', 'pellicano', 'pettirosso', 'picchio', 'piccione', 'pinguino', 'quaglia', 'rondine', 'struzzo', 'tacchino'});
   stim{3}=shuffle({'amaca', 'barile', 'baule', 'biberon', 'binocolo', 'borraccia', 'bussola', 'caminetto', 'campana', 'cardine', 'cestino', 'ciuccio', 'colino', 'dado', 'gruccia', 'imbuto', 'lampadina', 'latta', 'lucchetto', 'padella', 'pila', 'rossetto', 'rubinetto', 'secchio', 'sgabello', 'sigaro', 'stufa', 'tappo', 'torcia', 'tovagliolo', 'trottola', 'vassoio'});
     stim{4}=shuffle({'arancia', 'asparago', 'avocado', 'carciofo', 'carota', 'castagna', 'cavolo', 'cetriolo', 'ciliegia', 'cocco', 'fagiolo', 'fico', 'fungo', 'granoturco', 'kiwi', 'lampone', 'lattuga', 'melanzana', 'melone', 'mora', 'nocciolina', 'oliva', 'peperone', 'pisello', 'pistacchio', 'porro', 'ravanello', 'sedano', 'spinacio', 'uva', 'zucca', 'zucchino'});

    
    stimPath='/Users/Scott/Documents/Studies/OldScannerPresentationFIles/Scott/Cross Training/pictures_Italian';
    cc=0;
    for i=1:length(stim)
        for j=1:length(stim{i})
            cc=cc+1;
            stimuli(cc).name=stim{i}{j};
            stimuli(cc).image=imread([stimPath '/' stim{i}{j} '.jpg']);
            stimuli(cc).image=imresize(stimuli(cc).image,[200,200]);
%             stimuli(cc).alpha=stimuli(cc).image~=stimuli(1).image(1,1,1);
%             stimuli(cc).alpha=double(stimuli(cc).alpha);
        end
    end
    
    
    save myStimuli stimuli % -v7.3 