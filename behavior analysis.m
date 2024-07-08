close all;
clear all;
window1=[]; tailangle_all=[];
forward=zeros(20,6); left=zeros(20,6); right=zeros(20,6);
forward_start=zeros(20,6); left_start=zeros(20,6); right_start=zeros(20,6);
forward_starttime=zeros(20,6); left_starttime=zeros(20,6); right_starttime=zeros(20,6);


for i=1:20  % 20 videos for every excel file   
tailangle=xlsread('');% read tail angle data from excel sheet obtained from Zebrazoom
tailangle_all=[tailangle_all,tailangle];
 
figure;
plot(tailangle); % to see the trace
% plot(tailangle_all(:,i));
hold on;
sz=size(tailangle);

% % To get std dev trace of tail angles to calculate peaks
 for j=6:sz-4
     w=std(tailangle(j-5:j+4));
     window1=[window1,w];
 end
 w3=min(window1)*ones(1,9);
 window1=horzcat(w3,window1);
%  hold on;
 gcf;
title(['trial#',num2str(i)]);
hold on;
  plot(window1);
  hold on;
  h=input('threshold'); % set threshold for choosing peaks
[pks1,locs1] = findpeaks(window1,'MinPeakHeight',h,'MinPeakDistance',30);
plot(locs1,pks1,'ko','MarkerFaceColor','g');
hold on;
locs1=locs1';

% % find boundaries for each peak
for k = 1:length(locs1)
   m = locs1(k);
   while m > 1 && window1(m)>h
       m = m - 1;
   end
   b_min(k) = m;
   m = locs1(k);
   while m < length(window1) && window1(m)>h
       m = m + 1;
   end
   b_max(k) = m;
end

% % average area calculation. Forward swims will be zero. Left is positive
% and right negative.
TF = isempty(locs1);
if(TF==0)
    for j=1:length(locs1)
      a=trapz(tailangle(b_min(j):b_max(j)));
    b=round(a);
        if(b==0)
        forward(i,j)=locs1(j); % i stand for the trial#. j is how many movements there were. sometimes there are multiple tail bends in one 1000 frame trial
        forward_start(i,j)=b_min(j);
        elseif(b>0)
        left(i,j)=locs1(j);
        left_start(i,j)=b_min(j);
        elseif(b<0)
        right(i,j)=locs1(j);
        right_start(i,j)=b_min(j);
        end
    end
end
warning('off','all');
 
% % get start time info from frames

forward_starttime= (forward_start-500)*0.01;
forward_starttime(forward_starttime==-5)=0;
left_starttime= (left_start-500)*0.01;
left_starttime(left_starttime==-5)=0;  
right_starttime= (right_start-500)*0.01;
right_starttime(right_starttime==-5)=0;
end

