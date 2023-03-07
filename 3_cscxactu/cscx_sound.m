function cscx_sound(hObject,~,~)
global x Fs;
v =  get(hObject,'Value');

if v==1
    sound(x,Fs);
end
%clear sound
end