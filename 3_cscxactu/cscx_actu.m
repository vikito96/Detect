function cscx_actu()
%CSCX——ACTU plots the UI of the detect of actual signals.

%版本：v1.0,编写：2023.3.8,作者：童威棋
close all;

%主界面
set(0,'Units','pixels');
H.fig = figure('Name','水下目标探测识别系统','toolbar','figure','menubar','none','numbertitle','off','unit','pixels','position',[0 0 1400 600],'visible','on','Color','w');
movegui(H.fig,'center');

%画图界面
H.Rpanel =prepanel(H.fig,[245 10 1145 580]);
lp=565;hp=282;ld1=[5,575];hd1=[293,5];
%坐标轴尺寸：lp长度，hp高度，ld1长度边界，hd1高度边界
[P.p1,P.axes1]=preplot(H.Rpanel,[ld1(1),hd1(1),lp,hp],'时间 [s]','时域信号');
[P.p2,P.axes2]=preplot(H.Rpanel,[ld1(2),hd1(1),lp,hp],'频率f [Hz]','频域信号');
[P.p3,P.axes3]=preplot(H.Rpanel,[ld1(1),hd1(2),lp,hp],'循环频率α [Hz]','自适应加权包络谱AWES');
P.p4=prepanel(H.Rpanel,[ld1(2),hd1(2),lp,hp],'title','目标识别','BackgroundColor',[0.94 0.94 0.94]);

%计算参数界面
H.p1=prepanel(H.fig,[10 410 225 180],'title','计算参数');
lt=200;le=205;ht=20;he=20;ld2=[0,10];hd2=25;head=130;
%文本框尺寸：lt,le长度，ht,he高度，ld2长度边界，hd2高度边界，head头部高度差
V.t1=pretext(H.p1,[ld2(1),head,lt,ht],'数据时长（S）','text');
V.p1 =pretext(H.p1,[ld2(2),head-hd2,le,he],10,'edit');
V.t2=pretext(H.p1,[ld2(1),head-2*hd2,lt,ht],'最大循环频率α（Hz）','text');
V.p2 =pretext(H.p1,[ld2(2),head-3*hd2,le,he],15,'edit');
V.t3=pretext(H.p1,[ld2(1),head-4*hd2,lt,ht],'最大连续频率f（Hz）','text');
V.p3 =pretext(H.p1,[ld2(2),head-5*hd2,le,he],1000,'edit');

%计算按钮
H.p2=prepanel(H.fig,[10 365 225 40]);
V.B1 = uicontrol('parent',H.p2,'Style','push','BackgroundColor','y','String','选择文件并计算','Units','pixels','Position',[5 5 215 30],'fontsize',14,'FontName','黑体');

%检测参数界面
H.p3=prepanel(H.fig,[10 80 225 230],'title','检测参数');
head2=180;%头部高度差
V.t5=pretext(H.p3,[ld2(1),head2,lt,ht],'检测窗长','text');
V.p5 =pretext(H.p3,[ld2(2),head2-hd2,le,he],[],'edit');
V.t6=pretext(H.p3,[ld2(1),head2-2*hd2,lt,ht],'检测窗重叠率（%）','text');
V.p6 =pretext(H.p3,[ld2(2),head2-3*hd2,le,he],[],'edit');
V.t7=pretext(H.p3,[ld2(2),head2-4*hd2,le,he],'检测窗幅值系数（%）','text');
V.p7 =pretext(H.p3,[ld2(2),head2-5*hd2,le,he],[],'edit');
V.t8=pretext(H.p3,[ld2(2),head2-6*hd2,le,he],'检测带宽系数（%）','text');
V.p8 =pretext(H.p3,[ld2(2),head2-7*hd2,le,he],[],'edit');

%重新检测按钮
H.p4=prepanel(H.fig,[10 35 225 40]);
V.B2 = uicontrol('parent',H.p4,'Style','push','String','重新检测','Units','pixels','Position',[5 5 215 30],'fontsize',14,'FontName','黑体');

%目标识别界面
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

%回调设置
set(V.B1,'Callback',{@cscx_comp,V,P,H});
set(V.B2,'Enable','off');

%主菜单
hm = uimenu('Parent',H.fig,'Label','功能');
uimenu('Parent',hm,'Label','返回','Callback','close;cscx_main');
uimenu('Parent',hm,'Label','恢复','Callback','cscx_actu');
uimenu('Parent',hm,'Label','关闭','Callback','close(gcbf)');
end

function P=prepanel(parent,position,varargin)
%PREPANEL creates panels with the specific format.
%输入:parent:面板的父对象（对象句柄），position:位置数组（[1*4]）
%可选输入:title:面板标题（[]），BackgroundColor:背景色（'w'）
%输出:P:面板句柄

p = inputParser;
addRequired(p,'parent');
addRequired(p,'position');
addParameter(p,'title',[]);
addParameter(p,'BackgroundColor','w');
parse(p,parent,position,varargin{:});

P= uipanel('Parent',p.Results.parent,'Units','pixels','Position',p.Results.position);
set(P,'title',p.Results.title,'fontsize',14,'FontName','黑体')
set(P,'BackgroundColor',p.Results.BackgroundColor)
end

function [P,ax1]=preplot(parent,position,xla,tit)
%PREPLOT creates axes and its panels with the specific format.
%输入:parent:面板的父对象（对象句柄），position:位置数组（[1*4]），xla:x轴标签（str），tit:面板标题（str），
%输出:P:面板句柄，ax1:坐标轴句柄

P= uipanel('Parent',parent,'Units','pixels','Position',position,'BackgroundColor','w');
ax1 = axes('parent',P,'Position',[0.1 0.18 0.85 0.7],'XTick',[],'Ytick',[]);
xlabel(xla,'FontName','黑体');title(tit,'FontName','黑体');
end

function P= pretext(parent,position,str,style)
%PRETEXT creates textboxs or editboxs  with the specific format.
%输入:parent:面板的父对象（对象句柄），position:位置数组（[1*4]），str:文本（str），style:类型（'text'/'edit'），
%输出:P:文本框句柄

P=uicontrol('parent',parent,'Style',style,'string',str,'Units','pixels','Position',position,'fontsize',12,'BackgroundColor','w','FontName','黑体');
end