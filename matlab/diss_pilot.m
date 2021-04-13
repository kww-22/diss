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
  %mat_files = dir('*.m');

% Isolate file names from directory structure
fileNames = {fileDir.name}.';

% Convert cell array to table
% fileNames = cell2table(fileNames);

% Get number of files in directory
numFiles = length(fileNames);

%%
% remove junk from end of file name
for i = 1:numFiles
    movefile(fullfile(path, fileNames{i}), fullfile(path, strrep(fileNames{i}, " - exp", "")), 'f');
end

% for i = 1:numFiles
%     movefile(fullfile(path, fileNames{i}), fullfile(path, strrep(fileNames{i}, 'alex-pilot', 'p01')), 'f');
% end
% % 
% % re-get directory info with new file names
% fileDir = dir('*.txt');
% fileNames = {fileDir.name}.';
%%
% download cutsom file reading function
websave('extractData.m',...
    'https://raw.githubusercontent.com/kww-22/matlab/master/extractData.m');

%% initialize variables

elbVar = [];
shldrIR = [];
height = [];
mass = [];
velo = [];
pid = [];

%% collect data from each trial
for i = 1:numFiles
    
    % get sampling frequency, subject height & mass from file header
    txt = textscan(fopen(fileNames{i}), '%q','Delimiter','//');
    txt = txt{1};
    fs  = str2double(txt{10});
    height_i = str2double(txt{16});
    mass_i = str2double(txt{19});
    
    % extract data (variable names in row 9 from xGen exported txt files +
    % number of single values exported
    data = extractData(fileNames{i},'text',11);
    
    % find max hand velo (conditioned on handedness) to approximate arm
    % cocking & acceleration
    if max(data.LwristLinVelo) > max(data.RwristLinVelo)
    [~,ind] = max(data.LwristLinVelo);
    else    
    [~,ind] = max(data.RwristLinVelo);
    end
    
    % trim trial to .5 seconds before max hand velo
    %data = data(ind-round(fs/2):ind,:);
    
    % add extracted variables to master matricies
    height = [height; height_i];
    mass = [mass; mass_i];
    
    if max(data.LwristLinVelo) > max(data.RwristLinVelo)
    elbVar = [elbVar; max(data.elbVar)];
    shldrIR = [shldrIR; max(data.shldrIR)];
    else
    elbVar = [elbVar; min(data.elbVar)*-1];
    shldrIR = [shldrIR; min(data.shldrIR)*-1];
    end
    % find velos and id numbers in file names
    velo_i = fileNames{i}(end-7:end-4);
    velo = [velo; str2double(velo_i)];
    pid = [pid; fileNames{i}(1:3)];
end

% clean up after yourself
clear ans dash data height_i i ind m mass_i path txt velo_i
%%

tab = table(pid, mass, height, elbVar, shldrIR, velo,...
    'VariableNames',["pid", "mass", "height", "elbVar", "shldrIR", "velo"]);
writetable(tab,'pilot-data.csv');

%% plot velo on y, torque on x
figure('color','w');
hold('on')
subplot(1,2,1)
scatter(tab.elbVar,tab.velo, 'markerfacecolor','blue');
xlabel('Elbow Varus Torque (Nm)');
ylabel('Throwing Speed (mph)');
xlim([min(elbVar)-3 max(elbVar)+3]);
pbaspect([1 1 1]); % set square plotting space
subplot(1,2,2)
scatter(tab.shldrIR,tab.velo,'markerfacecolor','red');
xlabel('Shoulder Internal Rotation Torque (Nm)');
ylabel('Throwing Speed (mph)');
xlim([min(shldrIR)-3 max(shldrIR)+3]);
pbaspect([1 1 1]); % set square plotting space

%% 

data = extractData(fileNames.fileNames{19},'text',9);
% data = data(240:end,:);
plot(data.("Sample #")/238,data.handAngVelo)
hold on
plot(data.("Sample #")/238, data.shldrIR)
plot(data.("Sample #")/238, data.elbVar)