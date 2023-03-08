function cscx_EES(hObject,~,P,alphaF,Sk,ac1)

th=P.p3.UserData.th;
alphas = get(hObject,'String');
dot_index = strfind(alphas,'~');
smax = str2double(alphas(dot_index+1:end));
smin = str2double(alphas(1:dot_index-1));
[~,Iac1]=min(abs(alphaF(2:end)-ac1));%ac1索引
[~,n1]=min(abs(alphaF-smin));
n1=max(2,n1);
[~,n2]=min(abs(alphaF-smax));
n2=max(Iac1+1,n2);

axes(P.axes3);
plot(alphaF(n1:n2),Sk(n1-1:n2-1),'k','linewidth',0.75,'HandleVisibility','off')
axis tight 
xticks('auto') 
set(gca,'FontName','Times New Roman','fontsize',12);
hold on
ylim([-inf,1.2*max(Sk)]);
title('自适应加权包络谱AWES','FontName','黑体','fontsize',12);xlabel('循环频率α [Hz]','FontName','黑体','fontsize',12);
plot(alphaF(Iac1+1),Sk(Iac1),'ro','LineWidth',1.5,'MarkerSize',8)%推测轴频
plot(alphaF(n1:n2),th(n1-1:n2-1),'r-.','linewidth',1.5,'HandleVisibility','off')%阈值曲线
lgd=legend([num2str(ac1) 'Hz']);
lgd.FontName='Times New Roman';
lgd.FontSize=14;
legend('boxoff')
hold off
end