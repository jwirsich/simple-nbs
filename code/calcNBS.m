%calculate network based statistics from two groups
%02-04-2018 Jonathan Wirsich
conf = initConf();

%load subject matrices
conns_1 = loadConnectomes(conf.group1_sessdir, conf.regions);
conns_2 = loadConnectomes(conf.group2_sessdir, conf.regions);
matrices = cat(3, conns_1, conns_2);

%init design matrix
%TODO take covariables (age etc.)
dim_group1 = size(conns_1); 
dim_conns = size(matrices);
design = zeros(dim_conns(3), 2);

for i = 1:dim_conns(3)
    if i <= dim_group1(3)
        design(i, 1) = 1;
    else
        design(i, 2) = 1;
    end
end

%save design and connectivity matrices in NBS format
save([conf.outputdir filesep 'design.mat'], 'design');
save([conf.outputdir filesep 'matrices.mat'], 'matrices');

%init NBS
temp = load([conf.code_dir filesep 'data' filesep 'nbs' filesep 'nbsTemplate.mat']);

%NBS handle
S = temp.S;

%set global nbs parameters
S.UI.perms.ui = '5000';
S.UI.method.ui = 'Run NBS';
S.UI.test.ui = 't-test';

%load design and matrices
S.UI.design.ui = [conf.outputdir filesep 'design.mat'];
S.UI.matrices.ui = [conf.outputdir filesep 'matrices.mat'];

%load atlas coordinates and labels
S.UI.node_coor.ui = [conf.code_dir filesep 'data' filesep 'atlas' filesep 'shirer_subc' filesep 'nbs_coords.txt'];
S.UI.node_label.ui = [conf.code_dir filesep 'data' filesep 'atlas' filesep 'shirer_subc' filesep 'nbs_labels.txt'];

tcontrasts = cell(1,1);
tcontrasts_name = cell(1,1);
tcontrasts_thresh = cell(1,1);

count = 1;
%define GLM contrast
tcontrast{count} = '[1 -1]';
tcontrasts_name{count} = 'group1_ge_group2';
%define uncoorrected threshold
tcontrasts_thresh{count} = '2.5';
count = count + 1;

%make sure to be in NBS dir
cd(conf.nbs12_dir)

%iterate all defined contrasts
for i = 1:length(tcontrast)
    %set individual params
    S.UI.contrast.ui = tcontrast{i};
    S.UI.thresh.ui = tcontrasts_thresh{i};
    NBSrun(S.UI, S)
    
    %get global varibale of NBS calculation
    global nbs
    %any significant results found?
    if ~isempty(nbs.NBS.con_mat)
        tempadj=nbs.NBS.con_mat{1}+nbs.NBS.con_mat{1}';
        %convert to non sparse matrix (for numpy compability)
        adj = full(tempadj);
        %set diagonal on 1
    else 
        adj = zeros(conf.regions, conf.regions);
    end

    %only save significant results
    if ~isempty(nbs.NBS.con_mat)
        threshstr = strrep(tcontrasts_thresh{i},'.','_');
        save([conf.outputdir ...
            'nbs_' tcontrasts_name{i} '_t' threshstr '_n' S.UI.perms.ui '.mat'], 'nbs');
        save([conf.outputdir ...
            'adj_nbs_' tcontrasts_name{i} '_t' threshstr '_n' S.UI.perms.ui '.mat'], 'adj');
    end
end






