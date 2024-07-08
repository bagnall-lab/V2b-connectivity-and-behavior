%%%%% modified from Robert Wang's better_vlc
%%%%% Iris Zhu
% clear all;
%% Parameters
STIMULUS_TIME = 20; % seconds between the start of the stimulus and the start of the next stimulus
                        % in ZEN put 220 (frames) as a cycle
FRAMEPERIOD = 0.066; % 1/30, which is 30FPS

% Change the 2 integers depending on the resolution of the projector screen
%% Aligning the fish
close all
% figure2('WindowState', 'fullscreen','MenuBar', 'none',  'ToolBar', 'none','units','normalized','outerposition',[0 0 1 1]) 
figure3('WindowState', 'fullscreen','MenuBar', 'none',  'ToolBar', 'none','units','normalized','outerposition',[0 0 1 1]) 
filePath = 'Stim\OMR\';
stimFile = 'test_OMR.xlsx';
% Display the figure in the second monitor (projector)
black_screen = zeros(100,100, 'logical');
black_screen(1) = 1;
grid = black_screen;
grid(49:51,:) = 1;
grid(:,49:51) = 1;
h = imshow(grid);
% colormap(mymap);
% set(h,'outerposition',[0 0 400 400])
%% Load the movies
disp('LOADING')
[~,~,order] = xlsread(stimFile);
movies = cell(length(order), 2);
uniquecheck = size(unique(order),1);
if uniquecheck == 1
    load([filePath, order{1}, '.mat']);
    for movie_id=1:length(order)
        movies{movie_id,1} = F;
    end
else
    for movie_id=1:length(order)
        load([filePath, order{movie_id}, '.mat']);
        movies{movie_id,1} = F;
        movies{movie_id,2} = ones(1,70);
    end
end
disp('LOADED')
disp('Press a key to start tail imaging!')
pause
%% Send tigger
% s = serialport("COM3",115200);
s = [];
%% Send UDP tigger to OrbitalView to start recording
% u = udp('localhost', 6611);
% fopen(u);
% fwrite(u, 's');
% disp('Press a key to start stimuli presentation!')
% pause
%% Play the movies
% Each movie is played for 2 seconds, then wait 18 seconds to play the next one
% The period of movie is 20 seconds
time = cell(length(order), 1);
unix_time = cell(length(order), 1);
for movie_id=1:length(order)
    movie = movies{movie_id,1};
    num_frames = size(movie, 3); %%% change this if movie is not logical
    stimInfo =  movies{movie_id,2}; 
    d = datetime('now');
    time{movie_id} = datestr(d);
    unix_time{movie_id} = posixtime(d);
    % setting up the timer callback function
    t = timer('ExecutionMode', 'fixedRate','Period', FRAMEPERIOD,...
        'TasksToExecute', num_frames,'TimerFcn', @display_img4,...
        'UserData', {movie,stimInfo,h,s});    
    tic
    start(t);wait(t);
    toc
    set(h,'CData', black_screen);    
    disp(['Stimulus', num2str(movie_id), ' - ', order{movie_id},' finished'])
    pause(STIMULUS_TIME - num_frames*FRAMEPERIOD);
end
% clear s; 
% resetdaq;
%% close OrbitalView (also ends recording)
% fwrite(u, 'q');
% fclose(u);
%% save time stamps
date = datetime('now');
DateString1 = datestr(date,29);
DateString2 = datestr(date,13);
DateString2 = strrep(DateString2,':','-');
fileName = strcat([DateString1,'_',DateString2],'-stimTime.mat');
saveFilename = fullfile('C:\Users\zhu.s\OrbitalView',fileName);
save(saveFilename,'time','unix_time');

%% Timer callback function
function display_img_new(TimerH, ~)
    data = get(TimerH, 'UserData');
    frames = data{1};
    k = get(TimerH, 'TasksExecuted');
    set(data{3},'CData', frames(:,:,:,k)); %%% change to frames(:,:,k) if logical movie is used
     axis off
    drawnow;
end
