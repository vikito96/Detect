function cscx_p3(hObject,~,p)
global f1 P2;
% x = get(v.p1,'UserData');
% y = get(v.p2,'UserData');
s = get(hObject,'String');
dot_index = strfind(s,'~');
smax = str2double(s(dot_index+1:end));
smin = str2double(s(1:dot_index-1));
[~,n1]=min(abs(f1-smin));
[~,n2]=min(abs(f1-smax));
axes(p.axes2);
plot(f1(n1:n2),P2(n1:n2),'k');
axis tight
set(gca,'FontName','Times New Roman','fontsize',12);
xlabel('频率f [Hz]','FontName','黑体','fontsize',12);title('频域信号','FontName','黑体','fontsize',12);
end