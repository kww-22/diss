%% Gather directory information

clear
clc

% Set directory
% Choose folder path containing exported and necessary matlab files
path = uigetdir();
cd(path);

% Isolate files with .exp extension
% fileDir = dir('*.exp');
% fileDir = dir('*.txt');
  %mat_files = dir('*.m');
  fileDir = dir('*tak');

% Isolate file names from directory structure
fileNames = {fileDir.name}.';

% Convert cell array to table
% fileNames = cell2table(fileNames);

% Get number of files in directory
numFiles = length(fileNames);

%% Enter pieces of file names you wish to overwrite
names_old = "_001 ";
names_new = "";

fileNums = [];

%% For loop to replace names_old with names_new
for i = 1:length(names_old)
    
    % logical for which files contain the ith element of names_old
    names_yes = contains(fileNames,names_old(i));
    % return indicies instead of logical
    names_yes = find(names_yes);
    % number of files that contain ith element of names_old
    numNames = length(names_yes);
    % keep number of files for each participant
    fileNums = [fileNums; numNames];
        % go through each file name containing ith element of names_old and
        % replace with ith element of names_new
        for j = 1:numNames
            movefile(fullfile(path, fileNames{names_yes(j)}),...
                     fullfile(path, strrep(fileNames{names_yes(j)}, names_old(i), names_new(i))), 'f');
        end
    % redifine fileNames and directory information
    fileDir = dir('*tak');
    fileNames = {fileDir.name}.';
end

clear i j
%% Replace '000' filename with velo from recording sheet
    fileDir = dir('*75e*');
    fileNames = {fileDir.name}.';
  
for i = 1:length(fileNames)
    under_scores = strfind(fileNames{i},'_');
    movefile(fullfile(path,fileNames{i}),...
             fullfile(path, strrep(fileNames{i},fileNames{i}(under_scores(end)+1:under_scores(end)+3),string(velo_75e{i,2}*10)))) 

end

clear i

%%






