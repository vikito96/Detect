function cscx_re(hObject,~,V,P,alphaF,Sk,ac,t,a_end)


if (get(hObject,'Value') == 1)
    alphas=P.EES.String;
    dot_index = strfind(alphas,'~');
    smax = str2double(alphas(dot_index+1:end));
    smin = str2double(alphas(1:dot_index-1));
    [~,Iac1]=min(abs(alphaF(2:end)-ac(1)));%ac1索引
    [~,n1]=min(abs(alphaF-smin));
    n1=max(2,n1);
    [~,n2]=min(abs(alphaF-smax));
    n2=max(Iac1+1,n2);
    
    Nthw=str2double(get(V.p5,'string'));
    thv=str2double(get(V.p6,'string'))/100;
    Nthv = fix(thv*Nthw);%重叠率
    level=str2double(get(V.p7,'string'))/100;
    X=str2double(get(V.p8,'string'))/100;
    if Nthw>a_end*t(end)|| Nthw<=0 || rem(Nthw,1)~=0
        errordlg('检测窗过长或输入非法');
        return;
    end
    if thv>=1 || thv<0
        errordlg('检测窗重叠率错误');
        return;
    end
    if Nthw*(1-thv)<=1
        errordlg('检测窗间隙过小');
        return;
    end
    if level>=1 || level<0
        errordlg('检测窗幅值系数错误');
        return;
    end
    if X<0
        errordlg('检测带宽系数错误');
        return;
    end
    
    
    
    %排序法阈值曲线
    Nth=ceil(length(Sk)/(Nthw-Nthv));%窗口数量
    thi=zeros(size(Sk,1),Nth);%窗口阈值曲线
    ath=zeros(1,Nth);%窗口对应循环频率
    for i=1:Nth
        N1=(Nthw-Nthv)*(i-1)+1;%窗起点
        N2=min(((Nthw-Nthv)*(i-1)+Nthw),length(Sk));%窗终点
        thic=sort(Sk(:,N1:N2),2);%升序重排列窗口
        thin=round(level*(N2-N1+1));%窗口阈值索引
        thi(:,i)=thic(:,thin);
        ath(i)=alphaF(ceil((N1+N2)/2));%窗中点循环频率
    end
    th= interp1(ath,thi',alphaF(2:end),'pchip','extrap');%插值生成阈值曲线
    P.p3.UserData.th=th;
    
    %检测带宽和对应峰值
    B=zeros(2*length(ac),1);%检测带宽
    Bn=zeros(2*length(ac),1);%检测带宽序号
    m=zeros(1,length(ac));%检测带宽内峰值
    mn=zeros(1,length(ac));%检测带宽内峰值序号
    for bi=1:length(ac)
        B(2*bi-1)=ac(bi)-X*ac(1);%下边界
        B(2*bi)=ac(bi)+X*ac(1);%上边界
        [~,Bn(2*bi-1)]=min(abs(alphaF(2:end)-B(2*bi-1)));%下边界索引
        [~,Bn(2*bi)]=min(abs(alphaF(2:end)-B(2*bi)));%上边界索引
        [m(:,bi),mn(:,bi)]=max(Sk(:,Bn(2*bi-1):Bn(2*bi)),[],2);
        mn(:,bi)=mn(:,bi)+Bn(2*bi-1)-1;
    end
    
    %峰值对应的阈值
    thn=th(mn);%检测带宽峰值对应阈值
    
    pp=(m./thn);%峰值和阈值比
    ppp=round(geomean(pp),2);%几何平均峰值比
    
    
    %图3，画AWES
    axes(P.axes3);
    plot(alphaF(n1:n2),Sk(n1-1:n2-1),'k','linewidth',0.75,'HandleVisibility','off')
    axis tight
    set(gca,'FontName','Times New Roman','fontsize',12);
    ylim([-inf,1.2*max(Sk)]);
    title('自适应加权包络谱AWES','FontName','黑体','fontsize',12);xlabel('循环频率α [Hz]','FontName','黑体','fontsize',12);
    hold on
    plot(alphaF(Iac1+1),Sk(Iac1),'ro','LineWidth',1.5,'MarkerSize',8)%推测轴频
    plot(alphaF(n1:n2),th(n1-1:n2-1),'r-.','linewidth',1.5,'HandleVisibility','off')%阈值曲线
    lgd=legend([num2str(ac(1)) 'Hz']);
    lgd.FontName='Times New Roman';
    lgd.FontSize=14;
    legend('boxoff')
    hold off
    
    %图4，文本信息
    set(P.edit1,'String',num2str(ppp));
    
    if ppp<1
        P.text0= uicontrol('Parent',P.p4,'Style','text','String','未检测到水下目标','Position',[5 208 555 20],'fontsize',14,'FontName','黑体');
        set(P.edit4,'String','/');
    else
        P.text0= uicontrol('Parent',P.p4,'Style','text','String','检测到水下目标','Position',[5 208 555 20],'fontsize',14,'FontName','黑体','ForegroundColor','r');
    end
    
end
end