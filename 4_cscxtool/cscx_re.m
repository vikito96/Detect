function cscx_re(hObject,~,V,P,alphaF,Sk,ac,t,a_end)


if (get(hObject,'Value') == 1)
    alphas=P.EES.String;
    dot_index = strfind(alphas,'~');
    smax = str2double(alphas(dot_index+1:end));
    smin = str2double(alphas(1:dot_index-1));
    [~,Iac1]=min(abs(alphaF(2:end)-ac(1)));%ac1����
    [~,n1]=min(abs(alphaF-smin));
    n1=max(2,n1);
    [~,n2]=min(abs(alphaF-smax));
    n2=max(Iac1+1,n2);
    
    Nthw=str2double(get(V.p5,'string'));
    thv=str2double(get(V.p6,'string'))/100;
    Nthv = fix(thv*Nthw);%�ص���
    level=str2double(get(V.p7,'string'))/100;
    X=str2double(get(V.p8,'string'))/100;
    if Nthw>a_end*t(end)|| Nthw<=0 || rem(Nthw,1)~=0
        errordlg('��ⴰ����������Ƿ�');
        return;
    end
    if thv>=1 || thv<0
        errordlg('��ⴰ�ص��ʴ���');
        return;
    end
    if Nthw*(1-thv)<=1
        errordlg('��ⴰ��϶��С');
        return;
    end
    if level>=1 || level<0
        errordlg('��ⴰ��ֵϵ������');
        return;
    end
    if X<0
        errordlg('������ϵ������');
        return;
    end
    
    
    
    %������ֵ����
    Nth=ceil(length(Sk)/(Nthw-Nthv));%��������
    thi=zeros(size(Sk,1),Nth);%������ֵ����
    ath=zeros(1,Nth);%���ڶ�Ӧѭ��Ƶ��
    for i=1:Nth
        N1=(Nthw-Nthv)*(i-1)+1;%�����
        N2=min(((Nthw-Nthv)*(i-1)+Nthw),length(Sk));%���յ�
        thic=sort(Sk(:,N1:N2),2);%���������д���
        thin=round(level*(N2-N1+1));%������ֵ����
        thi(:,i)=thic(:,thin);
        ath(i)=alphaF(ceil((N1+N2)/2));%���е�ѭ��Ƶ��
    end
    th= interp1(ath,thi',alphaF(2:end),'pchip','extrap');%��ֵ������ֵ����
    P.p3.UserData.th=th;
    
    %������Ͷ�Ӧ��ֵ
    B=zeros(2*length(ac),1);%������
    Bn=zeros(2*length(ac),1);%���������
    m=zeros(1,length(ac));%�������ڷ�ֵ
    mn=zeros(1,length(ac));%�������ڷ�ֵ���
    for bi=1:length(ac)
        B(2*bi-1)=ac(bi)-X*ac(1);%�±߽�
        B(2*bi)=ac(bi)+X*ac(1);%�ϱ߽�
        [~,Bn(2*bi-1)]=min(abs(alphaF(2:end)-B(2*bi-1)));%�±߽�����
        [~,Bn(2*bi)]=min(abs(alphaF(2:end)-B(2*bi)));%�ϱ߽�����
        [m(:,bi),mn(:,bi)]=max(Sk(:,Bn(2*bi-1):Bn(2*bi)),[],2);
        mn(:,bi)=mn(:,bi)+Bn(2*bi-1)-1;
    end
    
    %��ֵ��Ӧ����ֵ
    thn=th(mn);%�������ֵ��Ӧ��ֵ
    
    pp=(m./thn);%��ֵ����ֵ��
    ppp=round(geomean(pp),2);%����ƽ����ֵ��
    
    
    %ͼ3����AWES
    axes(P.axes3);
    plot(alphaF(n1:n2),Sk(n1-1:n2-1),'k','linewidth',0.75,'HandleVisibility','off')
    axis tight
    set(gca,'FontName','Times New Roman','fontsize',12);
    ylim([-inf,1.2*max(Sk)]);
    title('����Ӧ��Ȩ������AWES','FontName','����','fontsize',12);xlabel('ѭ��Ƶ�ʦ� [Hz]','FontName','����','fontsize',12);
    hold on
    plot(alphaF(Iac1+1),Sk(Iac1),'ro','LineWidth',1.5,'MarkerSize',8)%�Ʋ���Ƶ
    plot(alphaF(n1:n2),th(n1-1:n2-1),'r-.','linewidth',1.5,'HandleVisibility','off')%��ֵ����
    lgd=legend([num2str(ac(1)) 'Hz']);
    lgd.FontName='Times New Roman';
    lgd.FontSize=14;
    legend('boxoff')
    hold off
    
    %ͼ4���ı���Ϣ
    set(P.edit1,'String',num2str(ppp));
    
    if ppp<1
        P.text0= uicontrol('Parent',P.p4,'Style','text','String','δ��⵽ˮ��Ŀ��','Position',[5 208 555 20],'fontsize',14,'FontName','����');
        set(P.edit4,'String','/');
    else
        P.text0= uicontrol('Parent',P.p4,'Style','text','String','��⵽ˮ��Ŀ��','Position',[5 208 555 20],'fontsize',14,'FontName','����','ForegroundColor','r');
    end
    
end
end