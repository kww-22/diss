%% velo_append.m
% 
% MATLAB script to rename c3d files for my dissertation by appending the
% throw speed to the end of file name
% 
% author: Kyle Wasserberger MS, CSCS
%         Sports Medicine and Movement Laboratory Auburn University,
%         Auburn, AL, USA
%         
% last updated: 2021-04-23
%% Gather directory information

clear
clc

% Set directory
% Choose folder path containing exported and necessary matlab files
path = uigetdir();
cd(path);

% Isolate files with .exp extension
% fileDir = dir('*.exp');
fileDir = dir('*.txt');

% Isolate file names from directory structure
fileNames = {fileDir.name}.';

% Convert cell array to table
% fileNames = cell2table(fileNames);

% Get number of files in directory
numFiles = length(fileNames);
%% find indicies of warmup and condition throws
inds_warm = find(contains(fileNames,"warmup"));
inds_cond = find(~contains(fileNames,"warmup"));

inds_e = find(contains(fileNames,"_e_"));
inds_v = find(contains(fileNames,"_v_"));

%%

zNumE = find(contains(fileNames(inds_v),"p12 "));
%% read in csv data

datawarm = readtable('C:\Users\OliverLab\Documents\GitHub\diss\sup\velo_csvs\masters\data_warm.csv');
% remove random first column
datawarm = datawarm(:,2:end);

%% Enter pieces of file names you wish to overwrite
% names_old = " - exp";
% names_new = "";
% 
% fileNums = [];
% 
% %% For loop to replace names_old with names_new
% for i = 1:length(names_old)
%     
%     % logical for which files contain the ith element of names_old
%     names_yes = contains(fileNames,names_old(i));
%     % return indicies instead of logical
%     names_yes = find(names_yes);
%     % number of files that contain ith element of names_old
%     numNames = length(names_yes);
%     % keep number of files for each participant
%     fileNums = [fileNums; numNames];
%         % go through each file name containing ith element of names_old and
%         % replace with ith element of names_new
%         for j = 1:numNames
%             movefile(fullfile(path, fileNames{names_yes(j)}),...
%                      fullfile(path, strrep(fileNames{names_yes(j)}, names_old(i), names_new(i))), 'f');
%         end
%     % redifine fileNames and directory information
%     fileDir = dir('*txt');
%     fileNames = {fileDir.name}.';
% end
% 
% clear i j

%% check to make sure pID and throw # match btwn data csv and filename

% two checks: first is to ensure that pXX portion of file name matches pXX
% from pID column in csv file. second is to ensure that throw # in file 
% name (i.e., 001, 002, 003 etc...) matches throw # from the csv

for i = 1:length(inds_warm)
    
    check_file = split(fileNames{inds_warm(i)}(1:end-4),'_');
    check_csv = {datawarm.pID{i}, 0 , datawarm.throw(i)}';

    if strcmp(check_file{1},check_csv{1}) && str2double(check_file{3}) == check_csv{3} 
        disp('yeet fam') % replace with file renaming code
    else
        disp('naw') % replace with error generating code
    end
end

%% Draft junk
num2str(datawarm.velo(i)*10)
% replace(fileNames{inds_warm(1)},fileNames{inds_warm(1)}(end-6:end-4),num2str(10*datawarm.velo(1)))
%
% fullfile(path,fileNames{inds_warm(1)})
% 
% fullfile(path,replace(fileNames{inds_warm(1)},fileNames{inds_warm(1)}(end-6:end-4),num2str(10*datawarm.velo(1))))
% 
% % find the position of the "." in the filename
% dot_ind = strfind(fileNames{inds_warm(1)},".");