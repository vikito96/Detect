function cscx_p1(hObject,~,P,t,x)
s = get(hObject,'String');
dot_index = strfind(s,'~');
smax = str2double(s(dot_index+1:end));
smin = str2double(s(1:dot_index-1));
[~,n1]=min(abs(t-smin));
[~,n2]=min(abs(t-smax));
axes(P.axes1);
plot(t(n1:n2),x(n1:n2),'k');
axis tight
ylim([-inf,1.2*max(x(n1:n2))]);
set(gca,'FontName','Times New Roman','fontsize',12);
xlabel('时间 [s]','FontName','黑体','fontsize',12);title('时域信号','FontName','黑体','fontsize',12);
end