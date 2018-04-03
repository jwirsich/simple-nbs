%load connectomes lying in one folder (assuming no other files in folder)
% 02-04-2018 Jonathan Wirsich
function conns = loadConnectomes(folder, regions)

    files = dir(folder);
    fileIndex = find(~[files.isdir]);
    
    conns = zeros(regions, regions, length(fileIndex));
    
    for y = 1:length(fileIndex)
        tmp = load([folder filesep files(fileIndex(y)).name]);
        conns(:, :, y) = tmp.conn;
    end
            
end