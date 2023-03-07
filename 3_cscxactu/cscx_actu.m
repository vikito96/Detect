function cscx_actu()
clc
close all;
global P V

set(0,'Units','pixels');
Ssize = get(0,'Screensize');
H.fig = figure('Name','水下目标探测识别系统','toolbar','figure',...
        'menubar','none','numbertitle','off','unit','pixels','position',...
        [(Ssize(3)-1400)/2 (Ssize(4)-600)/2 1400 600],'visible','on','Color','w');

H.Rpanel = uipanel('Parent',H.fig,'Units','pixels','Position',[245 10 1145 580],'FontName','黑体','BackgroundColor','w');

P.p1 = uipanel('Parent',H.Rpanel,'Units','pixels','Position',[5 293 565 282],'BackgroundColor','w');
P.axes1 = axes('parent',P.p1,'Position',[0.1 0.18 0.85 0.7],'XTick',[],'Ytick',[]);
xlabel('时间 [s]','FontName','黑体');title('时域信号','FontName','黑体');
P.p2 = uipanel('Parent',H.Rpanel,'Units','pixels','Position',[575 293 565 282],'BackgroundColor','w');
P.axes2 = axes('parent',P.p2,'Position',[0.1 0.18 0.85 0.7],'XTick',[],'Ytick',[]);
xlabel('频率f [Hz]','FontName','黑体');title('频域信号','FontName','黑体');
P.p3 = uipanel('Parent',H.Rpanel,'Units','pixels','Position',[5 5 565 283],'BackgroundColor','w');
P.axes3 = axes('parent',P.p3,'Position',[0.1 0.18 0.85 0.7],'XTick',[],'Ytick',[]);
title('自适应加权包络谱AWES','FontName','黑体');xlabel('循环频率α [Hz]','FontName','黑体');
P.p4 = uipanel('Parent',H.Rpanel,'Units','pixels','Position',[575 5 565 283],'title','目标识别','fontsize',14,'FontName','黑体');

H.p1 = uipanel('Parent',H.fig,'Units','pixels','Position',[10 410 225 180],'FontName','黑体','BackgroundColor','w','title','计算参数','fontsize',14,'FontName','黑体');
uicontrol('parent',H.p1,'Style','text','string','数据时长（S）','Units','pixels','Position',...
             [0 130 225 20],'fontsize',12,'BackgroundColor','w','FontName','黑体');
V.p1 = uicontrol('parent',H.p1,'Style','edit','string',10,'Units','pixels','Position',...
             [10 105 205 20],'fontsize',12,'BackgroundColor','w','FontName','黑体');
uicontrol('parent',H.p1,'Style','text','string','最大循环频率α（Hz）','Units','pixels','Position',...
             [0 80 225 20],'fontsize',12,'BackgroundColor','w','FontName','黑体');
V.p2 = uicontrol('parent',H.p1,'Style','edit','string',15,'Units','pixels','Position',...
             [10 55 205 20],'fontsize',12,'BackgroundColor','w','FontName','黑体');
uicontrol('parent',H.p1,'Style','text','string','最大连续频率f（Hz）','Units','pixels','Position',...
             [0 30 225 20],'fontsize',12,'BackgroundColor','w','FontName','黑体');
V.p3 = uicontrol('parent',H.p1,'Style','edit','string',1000,'Units','pixels','Position',...
             [10 5 205 20],'fontsize',12,'BackgroundColor','w','FontName','黑体');


H.p2 = uipanel('Parent',H.fig,'Units','pixels','Position',[10 365 225 40],'BackgroundColor','w');
V.B = uicontrol('parent',H.p2,'Style','push','BackgroundColor','y','String','选择文件并计算','Units','pixels','Position',... 
             [5 5 215 30],'fontsize',14,'Callback',{@cscx_comp,V,P,H},'FontName','黑体');
         
H.p3 = uipanel('Parent',H.fig,'Units','pixels','Position',[10 80 225 230],'BackgroundColor','w','title','检测参数','fontsize',14,'FontName','黑体');
uicontrol('parent',H.p3,'Style','text','string','检测窗长','Units','pixels','Position',...
             [0 180 200 20],'fontsize',12,'BackgroundColor','w','FontName','黑体');
V.p5 = uicontrol('parent',H.p3,'Style','edit','string',[],'Units','pixels','Position',...
             [10 155 205 20],'fontsize',12,'BackgroundColor','w','FontName','黑体');
uicontrol('parent',H.p3,'Style','text','string','检测窗重叠率（%）','Units','pixels','Position',...
             [0 130 200 20],'fontsize',12,'BackgroundColor','w','FontName','黑体');
V.p6 = uicontrol('parent',H.p3,'Style','edit','string',[],'Units','pixels','Position',...
             [10 105 205 20],'fontsize',12,'BackgroundColor','w','FontName','黑体');
uicontrol('parent',H.p3,'Style','text','string','检测窗幅值系数（%）','Units','pixels','Position',...
             [0 80 200 20],'fontsize',12,'BackgroundColor','w','FontName','黑体');
V.p7 = uicontrol('parent',H.p3,'Style','edit','string',[],'Units','pixels','Position',...
             [10 55 205 20],'fontsize',12,'BackgroundColor','w','FontName','黑体');
uicontrol('parent',H.p3,'Style','text','string','检测带宽系数（%）','Units','pixels','Position',...
             [0 30 200 20],'fontsize',12,'BackgroundColor','w','FontName','黑体');         
V.p8 = uicontrol('parent',H.p3,'Style','edit','string',[],'Units','pixels','Position',...
             [10 5 205 20],'fontsize',12,'BackgroundColor','w','FontName','黑体');

H.p4 = uipanel('Parent',H.fig,'Units','pixels','Position',[10 35 225 40],'BackgroundColor','w');
V.C = uicontrol('parent',H.p4,'Style','push','String','重新检测','Units','pixels','Position',...
             [5 5 215 30],'fontsize',14,'Callback',{@cscx_re,V,P,H},'FontName','黑体');

Hm = uimenu('Parent',H.fig,'Label','功能');
uimenu('Parent',Hm,...
       'Label','返回',...
       'Callback','close;cscx_main');
uimenu('Parent',Hm,...
       'Label','恢复',...
       'Callback','cscx_actu');
uimenu('Parent',Hm,...
       'Label','关闭',...
       'Callback','close(gcbf)');
   
   P.text1= uicontrol('Parent',P.p4,'Style','text','String','平均阈值比ART:','Position',[5 178 280 20],'fontsize',12,'FontName','黑体','HorizontalAlignment','right');
   P.edit1= uicontrol('Parent',P.p4,'Style','edit','String',[],'Position',[290 178 100 20],'fontsize',12,'FontName','黑体','Enable','inactive','BackgroundColor','k','ForegroundColor','w');
   P.text2= uicontrol('Parent',P.p4,'Style','text','String','频谱最大值对应频率:','Position',[5 148 280 20],'fontsize',12,'FontName','黑体','HorizontalAlignment','right');
   P.edit2= uicontrol('Parent',P.p4,'Style','edit','String',[],'Position',[290 148 100 20],'fontsize',12,'FontName','黑体','Enable','inactive','BackgroundColor','k','ForegroundColor','w');
   P.text21= uicontrol('Parent',P.p4,'Style','text','String','Hz','Position',[395 148 175 20],'fontsize',12,'FontName','黑体','HorizontalAlignment','left');
   P.text3= uicontrol('Parent',P.p4,'Style','text','String','包络谱最大值对应频率:','Position',[5 118 280 20],'fontsize',12,'FontName','黑体','HorizontalAlignment','right');
   P.edit3= uicontrol('Parent',P.p4,'Style','edit','String',[],'Position',[290 118 100 20],'fontsize',12,'FontName','黑体','Enable','inactive','BackgroundColor','k','ForegroundColor','w');
   P.text31= uicontrol('Parent',P.p4,'Style','text','String','Hz','Position',[395 118 175 20],'fontsize',12,'FontName','黑体','HorizontalAlignment','left');
   P.text4= uicontrol('Parent',P.p4,'Style','text','String','推测转速:','Position',[5 88 280 20],'fontsize',12,'FontName','黑体','HorizontalAlignment','right');
   P.text41= uicontrol('Parent',P.p4,'Style','text','String','r/min','Position',[395 88 175 20],'fontsize',12,'FontName','黑体','HorizontalAlignment','left');
   P.edit4= uicontrol('Parent',P.p4,'Style','edit','String',[],'Position',[290 88 100 20],'fontsize',12,'FontName','黑体','Enable','inactive','BackgroundColor','k','ForegroundColor','w');
   P.p5= uipanel('Parent',P.p4,'Units','pixels','Position',[5 5 555 60],'title','备注','fontsize',14,'FontName','黑体');
   str2=['ART>1推测目标可能存在' newline 'ART越大目标存在可能性越大'];
   P.text5= uicontrol('Parent',P.p5,'Style','text','String',str2,'Position',[0 0 555 40],'fontsize',12,'FontName','黑体','ForegroundColor','b');
end
