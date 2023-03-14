function cscx_comp(hObject,~,V,P,H)
%CSCX_COMP caculates Spectral Correlation based on the Short-Time-Fourier-Transform (STFT) and plot the result.
%输入:V,P,H:控件句柄

%版本：v1.0,编写：2023.3.8,作者：童威棋

if (get(hObject,'Value') == 1)
    %% 选择文件及输入
    [filename,pathname]=uigetfile({'*.wav';'*.mp3';'*.txt'},'选择测试音频文件');
    if isequal(filename,0)||isequal(pathname,0)
        errordlg('没有选中文件！','出错');
        return;
    end
    dot_index = strfind(filename,'.');
    filekind = filename(dot_index+1:end);

    if (strcmp(filekind,'mp3')||strcmp(filekind,'wav'))==1
        [data,Fs]=audioread(strcat(pathname,filename));
        L=str2double(get(V.p1,'string'))*Fs;%处理数据点数；循环频率分辨率：Fs/L
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
        L=str2double(get(V.p1,'string'))*Fs;%处理数据点数；循环频率分辨率：Fs/L
        NFFT = 2^nextpow2(L);% 频谱分析中的FFT点数；FFT频率分辨率：Fs/NFFT
        if (L>length(x))
            errordlg('超出数据文件长度！','出错');string
        else
            x1 = x(1:L);t = t(1:L);
        end
    end
    x=x1-mean(x1);%去均值（可以根据需要选择）

    %% 循环平稳计算
    Nw = 128;% 循环平稳分析——窗长（Fs/(2*f_end2)<Nw≤L）;df ~ 1.5*Fs/Nw
    a_end=round(str2double(get(V.p2,'string')));% 循环平稳分析——α截止值
    opt.coh = 1;% compute sepctral coherence? (yes=1, no=0)
    [SF,alphaF,~,~] = Fast_SC(x,Nw,a_end,Fs,opt);

    %% 自适应加权计算
    YY = fft(SF');
    k = kurtosis(abs(YY));%切片傅里叶峭度(AW)
    k=k./repmat(max(k,[],2),1,length(k));%归一化
    Sk=mean(abs((SF(:,2:end).*(repmat(k(1,:)',1,size(SF,2)-1))).^2));%自适应加权包络谱（AWES）
    
    %% 阈值检测和画图
    %图1，画时域信号
    axes(P.axes1);
    plot(t,x,'k');
    axis tight
    ylim([-1.2*max(abs(x)),1.2*max(abs(x))]);
    set(gca,'FontName','Times New Roman','fontsize',12);
    xlabel('时间 [s]','FontName','黑体','fontsize',12);title('时域信号','FontName','黑体','fontsize',12);
    P.B1 = uicontrol('Parent',P.p1,'Style','push','String','播放','Position',[20,5,45,25],'fontsize',12,'FontName','黑体');
    P.E1 = uicontrol('Parent',P.p1,'Style','edit','String',strcat(num2str(round(min(t))),'~',num2str(round(max(t)))),'Position',[490,5,70,25],'FontName','Times New Roman','fontsize',12);

    %图2，画频域信号
    f_end =round(str2double(get(V.p3,'string')));%频谱分析中连续频率截止范围
    Y = fft(x,NFFT);
    n1 = round(f_end/Fs*NFFT);
    f1 = Fs*(0:n1-1)/NFFT;
    P1 = abs(Y/NFFT);
    axes(P.axes2);
    P2 = P1(1:n1);
    plot(f1,P2,'k')
    axis tight
    ylim([-inf,1.2*max(P2)]);
    set(gca,'FontName','Times New Roman','fontsize',12);
    xlabel('频率f [Hz]','FontName','黑体','fontsize',12);title('频域信号','FontName','黑体','fontsize',12);
    set(H.p1,'UserData',f1);set(H.p2,'UserData',P1(1:n1));
    P.E3 = uicontrol('Parent',P.p2,'Style','edit','String',strcat(num2str(round(min(f1))),'~',num2str(round(max(f1)))),'Position',[490,5,70,25],'FontName','Times New Roman','fontsize',12);

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
    axes(P.axes3);
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
    P.EES = uicontrol('Parent',P.p3,'Style','edit','String',strcat(num2str(round(min(alphaF))),'~',num2str(round(max(alphaF)))),...
        'Position',[490,5,70,25],'FontName','Times New Roman','fontsize',12);  

    %图4，文本信息
    set(P.edit1,'String',num2str(ppp));
    set(P.edit2,'String',num2str(maxP2));
    set(P.edit3,'String',num2str(maxSk));
    if ppp<1
        P.text0= uicontrol('Parent',P.p4,'Style','text','String','未检测到水下目标','Position',[5 208 555 20],'fontsize',14,'FontName','黑体');
        set(P.edit4,'String','/');
    else
        P.text0= uicontrol('Parent',P.p4,'Style','text','String','检测到水下目标','Position',[5 208 555 20],'fontsize',14,'FontName','黑体','ForegroundColor','r');
        set(P.edit4,'String',num2str(round(ac1*60)));
    end

    %传递参数和回调设置
    P.p3.UserData=struct('th',th);
    set(P.B1,'Callback',{@cscx_sound,x,Fs});%播放按钮
    set(P.E1,'Callback',{@cscx_p1,P,t,x});%时间范围
    set(P.E3,'Callback',{@cscx_p3,P,f1,P2});%频率范围
    set(V.B2,'Enable','on','Callback',{@cscx_re,V,P,alphaF,Sk,ac,t,a_end});%重新检测按钮
    set(P.EES,'Callback',{@cscx_EES,P,alphaF,Sk,ac1});%循环频率范围
end
end