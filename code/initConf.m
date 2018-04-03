% Initialze path configuration for NBS ananlysis
% 02-04-2018 Jonathan Wirsich
function conf = initConf()
    conf.code_dir = '/media/jwirsich/DATAPART1/git/simple_nbs';
    
    conf.atlas = 'shirer_subc';
    conf.regions = 91;
    conf.atlas_dir = ['/media/jwirsich/DATAPART1/git/simple-rsfmri/atlas/' conf.atlas];
    conf.nbs12_dir = '/media/jwirsich/DATAPART1/git/simple_nbs/lib/NBS1.2';

    conf.group1_sessdir = '/media/jwirsich/DATAPART1/localdata/simple-rs/nbs/controls'; 
    conf.group2_sessdir = '/media/jwirsich/DATAPART1/localdata/simple-rs/nbs/patients';
    conf.outputdir = '/media/jwirsich/DATAPART1/localdata/simple-rs/nbs/';
    

end
