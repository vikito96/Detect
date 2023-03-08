function cscx_p3(hObject,~,P,f1,P2)
s = get(hObject,'String');
dot_index = strfind(s,'~');
smax = str2double(s(dot_index+1:end));
smin = str2double(s(1:dot_index-1));
[~,n1]=min(abs(f1-smin));
[~,n2]=min(abs(f1-smax));
axes(P.axes2);
plot(f1(n1:n2),P2(n1:n2),'k');
axis tight
ylim([-inf,1.2*max(P2(n1:n2))]);
set(gca,'FontName','Times New Roman','fontsize',12);
xlabel('频率f [Hz]','FontName','黑体','fontsize',12);title('频域信号','FontName','黑体','fontsize',12);
end