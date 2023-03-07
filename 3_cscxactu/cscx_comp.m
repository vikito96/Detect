function cscx_comp(hObject,~,v,p,h)
global nfft   Fs L x Nv Nw ;
global f_end2 alphaF SUM1F;
global t f1 P2 n_x;
global ac1 th  Sk P V;
global a_end ac
if (get(hObject,'Value') == 1)
    %% 输入
    [filename,pathname]=uigetfile({'*.wav';'*.mp3';'*.txt'},'选择测试音频文件');
    if isequal(filename,0)||isequal(pathname,0)
        errordlg('没有选中文件！','出错');
        return;
    end
    dot_index = strfind(filename,'.');
    filekind = filename(dot_index+1:end);
    
    f_end =round(str2double(get(v.p3,'string')));%频谱分析中连续频率截止范围
    f_end2=f_end;%SCD中连续频率截止范围
    
    if (strcmp(filekind,'mp3')||strcmp(filekind,'wav'))==1
        [data,Fs]=audioread(strcat(pathname,filename));
        L=str2double(get(v.p1,'string'))*Fs+1;%处理数据点数；循环频率分辨率：Fs/L   60000x76801 (34.3GB)
        NFFT = 2^nextpow2(L);% 频谱分析中的FFT点数；FFT频率分辨率：Fs/NFFT
        if (L>length(data))
            errordlg('超出数据文件长度！','出错');
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
        L=str2double(get(v.p1,'string'))*Fs+1;%处理数据点数；循环频率分辨率：Fs/L   60000x76801 (34.3GB)
        NFFT = 2^nextpow2(L);% 频谱分析中的FFT点数；FFT频率分辨率：Fs/NFFT
        if (L>length(x))
            errordlg('超出数据文件长度！','出错');string
        else
            x1 = x(1:L);t = t(1:L);
        end
    end
    x=x1-mean(x1);%去均值（可以根据需要选择）
    %% 循环平稳计算
    % Nw = 2048*128;  % 循环平稳分析——窗长（Fs/f_end2<Nw≤L）
    Nw= max(min(2^nextpow2(round(Fs/0.1)-1),L),round(Fs/f_end2));
    NwF = 128;  % 循环平稳分析——窗长（Fs/(2*f_end2)<Nw≤L）;df ~ 1.5*Fs/Nw
    Nv = fix(2/3*Nw);	 % 循环平稳分析——重叠设置
    nfft =Nw;		 % 循环平稳分析——SCD中的FFT点数；SCD频率分辨率：Fs/nfft
    a_end=round(str2double(get(v.p2,'string')));            % 循环平稳分析——α截止值
    
    opt.coh = 1;            % compute sepctral coherence? (yes=1, no=0)
    [SF,alphaF,~,~] = Fast_SC(x,NwF,a_end,Fs,opt);
    SUM_CF=abs(SF(:,1:end));
    SUM_CF=sum(SUM_CF);
    SUM1F=SUM_CF/sum(SUM_CF);
    %% 自适应加权计算
    YY = fft(SF');
    k = kurtosis(abs(YY));%切片傅里叶峭度(AW)
    k=k./repmat(max(k,[],2),1,length(k));%归一化
    Sk=mean(abs((SF(:,2:end).*(repmat(k(1,:)',1,size(SF,2)-1))).^2));%自适应加权包络谱（AWES）
    %% 阈值检测和画图
    
    %图1，画时域信号
    n_x = min(L,Fs);
    axes(p.axes1);
    plot(t,x,'k');
    axis tight
    set(gca,'FontName','Times New Roman','fontsize',12);
    xlabel('时间 [s]','FontName','黑体','fontsize',12);title('时域信号','FontName','黑体','fontsize',12);
    p.B1 = uicontrol('Parent',p.p1,'Style','push','String','播放',...
        'Position',[20,5,45,25],'fontsize',12,'Callback',@cscx_sound,'FontName','黑体');
    p.E1 = uicontrol('Parent',p.p1,'Style','edit','String',strcat(num2str(round(min(t))),'~',num2str(round(max(t)))),...
        'Position',[490,5,70,25],'FontName','Times New Roman','fontsize',12,'Callback',{@cscx_p1,p});
    
    %图2，画频域信号
    Y = fft(x,NFFT);
    n1 = round(f_end/Fs*NFFT);
    f1 = Fs*(0:n1-1)/NFFT;
    P1 = abs(Y/NFFT);
    axes(p.axes2);
    P2 = P1(1:n1);
    plot(f1,P2,'k')
    axis tight
    set(gca,'FontName','Times New Roman','fontsize',12);
    xlabel('频率f [Hz]','FontName','黑体','fontsize',12);title('频域信号','FontName','黑体','fontsize',12);
    set(h.p1,'UserData',f1);set(h.p2,'UserData',P1(1:n1));
    p.E3 = uicontrol('Parent',p.p2,'Style','edit','String',strcat(num2str(round(min(f1))),'~',num2str(round(max(f1)))),...
        'Position',[490,5,70,25],'FontName','Times New Roman','fontsize',12,'Callback',{@cscx_p3,p});
    
    % 寻峰参数和检测频带
    [~,IP2]=max(P2);
    maxP2=round(f1(IP2),2);
    [Psk,ISk]=max(Sk(1:end));
    maxSk=round(alphaF(ISk+1),2);
    [~,locs] = findpeaks(Sk,'MinPeakProminence',0.1*Psk);
    ac0=alphaF(locs+1);
    ac00=ac0(ac0>1.1);
    ac1=ac00(1);
    ac=[ac1 ac1*2 ac1*3 ac1*4 ac1*5];
    
    %4大经验参数
%     Nthw =30;%平滑窗长
    Nthw =max(fix(0.27*a_end*t(end)),10);%平滑窗长
    thv=0.75;
    Nthv = fix(thv*Nthw);%重叠率
    level=0.9;%排序等级
%     X=0.33;%带宽系数（中心左右各X）
    X=max(round(50/(a_end*t(end)),2),0.01);%带宽系数（中心左右各X）
    set(V.p5,'String',num2str(Nthw));
    set(V.p6,'String',num2str(thv*100));
    set(V.p7,'String',num2str(level*100));
    set(V.p8,'String',num2str(X*100));
    
    
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
    axes(p.axes3);
    plot(alphaF(2:end),Sk(1:end),'k','linewidth',0.75,'HandleVisibility','off')
    axis tight
    set(gca,'FontName','Times New Roman','fontsize',12);
    ylim([-inf,1.2*max(Sk)]);
    title('自适应加权包络谱AWES','FontName','黑体','fontsize',12);xlabel('循环频率α [Hz]','FontName','黑体','fontsize',12);
    hold on
    [~,Iac1]=min(abs(alphaF(2:end)-ac1));%ac1索引
    plot(alphaF(Iac1+1),Sk(Iac1),'ro','LineWidth',1.5,'MarkerSize',8)%推测轴频
    plot(alphaF(2:end),th,'r-.','linewidth',1.5,'HandleVisibility','off')%阈值曲线
    lgd=legend([num2str(ac1) 'Hz']);
    lgd.FontName='Times New Roman';
    lgd.FontSize=14;
    legend('boxoff')
    hold off
    p.EES = uicontrol('Parent',p.p3,'Style','edit','String',strcat(num2str(round(min(alphaF))),'~',num2str(round(max(alphaF)))),...
        'Position',[490,5,70,25],'FontName','Times New Roman','fontsize',12,'Callback',{@cscx_EES,p});
    
    %图4，文本信息
    set(P.edit1,'String',num2str(ppp));
    set(P.edit2,'String',num2str(maxP2));
    set(P.edit3,'String',num2str(maxSk));
    if ppp<1
        P.text0= uicontrol('Parent',p.p4,'Style','text','String','未检测到水下目标','Position',[5 208 555 20],'fontsize',14,'FontName','黑体');
        set(P.edit4,'String','/');
    else
        P.text0= uicontrol('Parent',p.p4,'Style','text','String','检测到水下目标','Position',[5 208 555 20],'fontsize',14,'FontName','黑体','ForegroundColor','r');
        set(P.edit4,'String',num2str(round(ac1*60)));
    end
end
end