function cscx_p1(hObject,~,p)
global t x;
% x = get(v.p1,'UserData');
% y = get(v.p2,'UserData');
s = get(hObject,'String');
dot_index = strfind(s,'~');
smax = str2double(s(dot_index+1:end));
smin = str2double(s(1:dot_index-1));
[~,n1]=min(abs(t-smin));
[~,n2]=min(abs(t-smax));
axes(p.axes1);
plot(t(n1:n2),x(n1:n2),'k');
axis tight
set(gca,'FontName','Times New Roman','fontsize',12);
xlabel('时间 [s]','FontName','黑体','fontsize',12);title('时域信号','FontName','黑体','fontsize',12);
end