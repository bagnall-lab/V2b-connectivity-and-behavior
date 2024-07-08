%% Timer callback function
function display_img4(TimerH, ~)
    data = get(TimerH, 'UserData');
    frames = data{1};
    k = get(TimerH, 'TasksExecuted');
    set(data{3},'CData', frames(:,:,k)); %%% change to frames(:,:,k) if logical movie is used
    axis off
    stimOn = data{2};
    s = data{4};
    Trigger2 = 0; 
    if ~isempty(s)
    if k==1 && stimOn(k)>0   
        writeline(s,'5');
% % % % % %         sound(sin(1:3000));
        Trigger2 = 1
    elseif stimOn(k)>0 && stimOn(k-1)==0 && Trigger2 == 0
        writeline(s,'5');
% % % % % % % %         sound(sin(1:3000));
        Trigger2 = 1
    elseif stimOn(k)==0 && stimOn(k-1) > 0 && Trigger2 == 1
        Trigger2 = 0
    elseif stimOn(k)>0 && stimOn(k-1) > 0 && Trigger2 == 1
        Trigger2 = 0
    end
    end
    drawnow;
end
