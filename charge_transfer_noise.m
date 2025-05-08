clear all;
[d,si,h]=abfload('');% load full path to file
sz=size(d);
area_stim=[];area_control=[];area_all=[];

r=sz(1)/2;
y=1/r;
% m1=1.5*r; m2=1.55*r; m3=0.63*r; m4=0.68*r;% uncomment for noise
% calculation
m1=0.73*r; m2=0.78*r; m3=0.63*r; m4=0.68*r;

 
 for i=1:sz(3)
 %for calculating area of curve_during stim with baseline subtraction. 
 %2 refers to the multiclamp channel that recording was done in
    in0=d(m1:m2,2,i);
    base=min(in0);
    in1=in0-base; 
    area1=trapz(y,in1);
    area_stim=[area_stim,area1];
    
    %for calculating area of curve_spontaneous with baseline subtraction 
     in2=d(m3:m4,2,i);
    base2=min(in2);
    in3=in2-base2;
    area2=trapz(y,in3);
    area_control=[area_control,area2];
 end
 area_control=transpose(area_control);
 area_stim=transpose(area_stim);
 area_all=horzcat(area_control,area_stim);
