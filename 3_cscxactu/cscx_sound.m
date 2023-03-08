function cscx_sound(hObject,~,x,Fs)
if get(hObject,'Value')==1
    sound(x,Fs);
end
end