function cscx_comp(hObject,~,v,p,h)
global nfft   Fs L x Nv Nw ;
global f_end2 alphaF SUM1F;
global t f1 P2 n_x;
global ac1 th  Sk P V;
global a_end ac
if (get(hObject,'Value') == 1)
    %% ����
    [filename,pathname]=uigetfile({'*.wav';'*.mp3';'*.txt'},'ѡ�������Ƶ�ļ�');
    if isequal(filename,0)||isequal(pathname,0)
        errordlg('û��ѡ���ļ���','����');
        return;
    end
    dot_index = strfind(filename,'.');
    filekind = filename(dot_index+1:end);
    
    f_end =round(str2double(get(v.p3,'string')));%Ƶ�׷���������Ƶ�ʽ�ֹ��Χ
    f_end2=f_end;%SCD������Ƶ�ʽ�ֹ��Χ
    
    if (strcmp(filekind,'mp3')||strcmp(filekind,'wav'))==1
        [data,Fs]=audioread(strcat(pathname,filename));
        L=str2double(get(v.p1,'string'))*Fs+1;%�������ݵ�����ѭ��Ƶ�ʷֱ��ʣ�Fs/L   60000x76801 (34.3GB)
        NFFT = 2^nextpow2(L);% Ƶ�׷����е�FFT������FFTƵ�ʷֱ��ʣ�Fs/NFFT
        if (L>length(data))
            errordlg('���������ļ����ȣ�','����');
        else
            x1=data(1:L,1)';
            t =(0:L-1)*(1/Fs);
        end
    elseif strcmp(filekind,'txt')==1
        fid=fopen(strcat(pathname,filename));
        sz=textscan(fid,'%f%f');
        fclose(fid);
        t=sz{1,1};
        x=sz{1,2};
        t1=t(2:end);
        dt=t1-t(1:end-1);
        dtmean=mean(dt);
        Fs=round(1/dtmean);
        L=str2double(get(v.p1,'string'))*Fs+1;%�������ݵ�����ѭ��Ƶ�ʷֱ��ʣ�Fs/L   60000x76801 (34.3GB)
        NFFT = 2^nextpow2(L);% Ƶ�׷����е�FFT������FFTƵ�ʷֱ��ʣ�Fs/NFFT
        if (L>length(x))
            errordlg('���������ļ����ȣ�','����');string
        else
            x1 = x(1:L);t = t(1:L);
        end
    end
    x=x1-mean(x1);%ȥ��ֵ�����Ը�����Ҫѡ��
    %% ѭ��ƽ�ȼ���
    % Nw = 2048*128;  % ѭ��ƽ�ȷ�������������Fs/f_end2<Nw��L��
    Nw= max(min(2^nextpow2(round(Fs/0.1)-1),L),round(Fs/f_end2));
    NwF = 128;  % ѭ��ƽ�ȷ�������������Fs/(2*f_end2)<Nw��L��;df ~ 1.5*Fs/Nw
    Nv = fix(2/3*Nw);	 % ѭ��ƽ�ȷ��������ص�����
    nfft =Nw;		 % ѭ��ƽ�ȷ�������SCD�е�FFT������SCDƵ�ʷֱ��ʣ�Fs/nfft
    a_end=round(str2double(get(v.p2,'string')));            % ѭ��ƽ�ȷ�����������ֵֹ
    
    opt.coh = 1;            % compute sepctral coherence? (yes=1, no=0)
    [SF,alphaF,~,~] = Fast_SC(x,NwF,a_end,Fs,opt);
    SUM_CF=abs(SF(:,1:end));
    SUM_CF=sum(SUM_CF);
    SUM1F=SUM_CF/sum(SUM_CF);
    %% ����Ӧ��Ȩ����
    YY = fft(SF');
    k = kurtosis(abs(YY));%��Ƭ����Ҷ�Ͷ�(AW)
    k=k./repmat(max(k,[],2),1,length(k));%��һ��
    Sk=mean(abs((SF(:,2:end).*(repmat(k(1,:)',1,size(SF,2)-1))).^2));%����Ӧ��Ȩ�����ף�AWES��
    %% ��ֵ���ͻ�ͼ
    
    %ͼ1����ʱ���ź�
    n_x = min(L,Fs);
    axes(p.axes1);
    plot(t,x,'k');
    axis tight
    set(gca,'FontName','Times New Roman','fontsize',12);
    xlabel('ʱ�� [s]','FontName','����','fontsize',12);title('ʱ���ź�','FontName','����','fontsize',12);
    p.B1 = uicontrol('Parent',p.p1,'Style','push','String','����',...
        'Position',[20,5,45,25],'fontsize',12,'Callback',@cscx_sound,'FontName','����');
    p.E1 = uicontrol('Parent',p.p1,'Style','edit','String',strcat(num2str(round(min(t))),'~',num2str(round(max(t)))),...
        'Position',[490,5,70,25],'FontName','Times New Roman','fontsize',12,'Callback',{@cscx_p1,p});
    
    %ͼ2����Ƶ���ź�
    Y = fft(x,NFFT);
    n1 = round(f_end/Fs*NFFT);
    f1 = Fs*(0:n1-1)/NFFT;
    P1 = abs(Y/NFFT);
    axes(p.axes2);
    P2 = P1(1:n1);
    plot(f1,P2,'k')
    axis tight
    set(gca,'FontName','Times New Roman','fontsize',12);
    xlabel('Ƶ��f [Hz]','FontName','����','fontsize',12);title('Ƶ���ź�','FontName','����','fontsize',12);
    set(h.p1,'UserData',f1);set(h.p2,'UserData',P1(1:n1));
    p.E3 = uicontrol('Parent',p.p2,'Style','edit','String',strcat(num2str(round(min(f1))),'~',num2str(round(max(f1)))),...
        'Position',[490,5,70,25],'FontName','Times New Roman','fontsize',12,'Callback',{@cscx_p3,p});
    
    % Ѱ������ͼ��Ƶ��
    [~,IP2]=max(P2);
    maxP2=round(f1(IP2),2);
    [Psk,ISk]=max(Sk(1:end));
    maxSk=round(alphaF(ISk+1),2);
    [~,locs] = findpeaks(Sk,'MinPeakProminence',0.1*Psk);
    ac0=alphaF(locs+1);
    ac00=ac0(ac0>1.1);
    ac1=ac00(1);
    ac=[ac1 ac1*2 ac1*3 ac1*4 ac1*5];
    
    %4�������
%     Nthw =30;%ƽ������
    Nthw =max(fix(0.27*a_end*t(end)),10);%ƽ������
    thv=0.75;
    Nthv = fix(thv*Nthw);%�ص���
    level=0.9;%����ȼ�
%     X=0.33;%����ϵ�����������Ҹ�X��
    X=max(round(50/(a_end*t(end)),2),0.01);%����ϵ�����������Ҹ�X��
    set(V.p5,'String',num2str(Nthw));
    set(V.p6,'String',num2str(thv*100));
    set(V.p7,'String',num2str(level*100));
    set(V.p8,'String',num2str(X*100));
    
    
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
    
    
    %�������Ͷ�Ӧ��ֵ
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
    thn=th(mn);%��������ֵ��Ӧ��ֵ
    
    pp=(m./thn);%��ֵ����ֵ��
    ppp=round(geomean(pp),2);%����ƽ����ֵ��
    
    
    %ͼ3����AWES
    axes(p.axes3);
    plot(alphaF(2:end),Sk(1:end),'k','linewidth',0.75,'HandleVisibility','off')
    axis tight
    set(gca,'FontName','Times New Roman','fontsize',12);
    ylim([-inf,1.2*max(Sk)]);
    title('����Ӧ��Ȩ������AWES','FontName','����','fontsize',12);xlabel('ѭ��Ƶ�ʦ� [Hz]','FontName','����','fontsize',12);
    hold on
    [~,Iac1]=min(abs(alphaF(2:end)-ac1));%ac1����
    plot(alphaF(Iac1+1),Sk(Iac1),'ro','LineWidth',1.5,'MarkerSize',8)%�Ʋ���Ƶ
    plot(alphaF(2:end),th,'r-.','linewidth',1.5,'HandleVisibility','off')%��ֵ����
    lgd=legend([num2str(ac1) 'Hz']);
    lgd.FontName='Times New Roman';
    lgd.FontSize=14;
    legend('boxoff')
    hold off
    p.EES = uicontrol('Parent',p.p3,'Style','edit','String',strcat(num2str(round(min(alphaF))),'~',num2str(round(max(alphaF)))),...
        'Position',[490,5,70,25],'FontName','Times New Roman','fontsize',12,'Callback',{@cscx_EES,p});
    
    %ͼ4���ı���Ϣ
    set(P.edit1,'String',num2str(ppp));
    set(P.edit2,'String',num2str(maxP2));
    set(P.edit3,'String',num2str(maxSk));
    if ppp<1
        P.text0= uicontrol('Parent',p.p4,'Style','text','String','δ��⵽ˮ��Ŀ��','Position',[5 208 555 20],'fontsize',14,'FontName','����');
        set(P.edit4,'String','/');
    else
        P.text0= uicontrol('Parent',p.p4,'Style','text','String','��⵽ˮ��Ŀ��','Position',[5 208 555 20],'fontsize',14,'FontName','����','ForegroundColor','r');
        set(P.edit4,'String',num2str(round(ac1*60)));
    end
end
end