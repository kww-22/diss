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

%% read in csv data

datawarm = readtable('C:\Users\OliverLab\Documents\GitHub\diss\sup\velo_csvs\masters\data_warm.csv');

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