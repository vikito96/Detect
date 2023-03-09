function cscx_sound(hObject,~,x,Fs)
if strcmp(get(hObject,'string'),'播放')
    set(hObject,'String','停止');
    sound(x,Fs);
elseif strcmp(get(hObject,'string'),'停止')
    set(hObject,'String','播放');
    clear sound
end
end