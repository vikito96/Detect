function cscx_actu()
clc
close all;
global P V

set(0,'Units','pixels');
Ssize = get(0,'Screensize');

% H.fig = dialog('WindowStyle','normal',...
%                 'Resize','on',...
%                 'Name','CSCX',...
%                 'Units','pixels',...
%                 'Position',[(Ssize(3)-1000)/2 (Ssize(4)-600)/2 1000
%                 600]); 
H.fig = figure('Name','ˮ��Ŀ��̽��ʶ��ϵͳ','toolbar','figure',...
        'menubar','none','numbertitle','off','unit','pixels','position',...
        [(Ssize(3)-1400)/2 (Ssize(4)-600)/2 1400 600],'visible','on','Color','w');

H.Rpanel = uipanel('Parent',H.fig,'Units','pixels','Position',[245 10 1145 580],'FontName','����','BackgroundColor','w');

P.p1 = uipanel('Parent',H.Rpanel,'Units','pixels','Position',[5 293 565 282],'BackgroundColor','w');
P.axes1 = axes('parent',P.p1,'Position',[0.1 0.18 0.85 0.7],'XTick',[],'Ytick',[]);
xlabel('ʱ�� [s]','FontName','����');title('ʱ���ź�','FontName','����');
%xlabel('ʱ�� [s]');title('ʱ���ź�');
P.p2 = uipanel('Parent',H.Rpanel,'Units','pixels','Position',[575 293 565 282],'BackgroundColor','w');
P.axes2 = axes('parent',P.p2,'Position',[0.1 0.18 0.85 0.7],'XTick',[],'Ytick',[]);
xlabel('Ƶ��f [Hz]','FontName','����');title('Ƶ���ź�','FontName','����');
%xlabel('ѭ��Ƶ�ʦ� [Hz]'),ylabel('Ƶ��f [Hz]');title('3-Dѭ�������');
P.p3 = uipanel('Parent',H.Rpanel,'Units','pixels','Position',[5 5 565 283],'BackgroundColor','w');
P.axes3 = axes('parent',P.p3,'Position',[0.1 0.18 0.85 0.7],'XTick',[],'Ytick',[]);
title('����Ӧ��Ȩ������AWES','FontName','����');xlabel('ѭ��Ƶ�ʦ� [Hz]','FontName','����');
%xlabel('Ƶ��f [Hz]');title('Ƶ���ź�');
P.p4 = uipanel('Parent',H.Rpanel,'Units','pixels','Position',[575 5 565 283],'title','Ŀ��ʶ��','fontsize',14,'FontName','����');
% P.axes4 = axes('parent',P.p4,'Position',[0.15 0.18 0.75 0.7]);
%title('��ǿ������EES');xlabel('ѭ��Ƶ�ʦ� [Hz]');ylabel('ƽ�������');

H.p1 = uipanel('Parent',H.fig,'Units','pixels','Position',[10 410 225 180],'FontName','����','BackgroundColor','w','title','�������','fontsize',14,'FontName','����');
% uicontrol('parent',H.p1,'Style','text','string','��������','Units','pixels','Position',...
%              [0 200 130 25],'fontsize',15,'BackgroundColor','w','FontName','����');
uicontrol('parent',H.p1,'Style','text','string','����ʱ����S��','Units','pixels','Position',...
             [0 130 225 20],'fontsize',12,'BackgroundColor','w','FontName','����');
V.p1 = uicontrol('parent',H.p1,'Style','edit','string',10,'Units','pixels','Position',...
             [10 105 205 20],'fontsize',12,'BackgroundColor','w','FontName','����');
uicontrol('parent',H.p1,'Style','text','string','���ѭ��Ƶ�ʦ���Hz��','Units','pixels','Position',...
             [0 80 225 20],'fontsize',12,'BackgroundColor','w','FontName','����');
V.p2 = uicontrol('parent',H.p1,'Style','edit','string',15,'Units','pixels','Position',...
             [10 55 205 20],'fontsize',12,'BackgroundColor','w','FontName','����');
uicontrol('parent',H.p1,'Style','text','string','�������Ƶ��f��Hz��','Units','pixels','Position',...
             [0 30 225 20],'fontsize',12,'BackgroundColor','w','FontName','����');
V.p3 = uicontrol('parent',H.p1,'Style','edit','string',1000,'Units','pixels','Position',...
             [10 5 205 20],'fontsize',12,'BackgroundColor','w','FontName','����');
% uicontrol('parent',H.p1,'Style','text','string','����Ƶ�ʷֱ���df��Hz��','Units','pixels','Position',...
%              [0 30 200 20],'fontsize',12,'BackgroundColor','w','FontName','����');
% V.p4 = uicontrol('parent',H.p1,'Style','edit','string',0.1,'Units','pixels','Position',...
%              [10 5 205 20],'fontsize',12,'BackgroundColor','w','FontName','����');
%P.axes4 = axes('parent',H.p1,'Units','pixels','Position',[175 2000 30 50];


H.p2 = uipanel('Parent',H.fig,'Units','pixels','Position',[10 365 225 40],'BackgroundColor','w');
V.B = uicontrol('parent',H.p2,'Style','push','BackgroundColor','y','String','ѡ���ļ�������','Units','pixels','Position',... 
             [5 5 215 30],'fontsize',14,'Callback',{@cscx_comp,V,P,H},'FontName','����');
         
H.p3 = uipanel('Parent',H.fig,'Units','pixels','Position',[10 80 225 230],'BackgroundColor','w','title','������','fontsize',14,'FontName','����');
% uicontrol('parent',H.p3,'Style','text','string','�߼����ã�','Units','pixels','Position',...
%              [0 150 130 25],'fontsize',14,'BackgroundColor','w');
uicontrol('parent',H.p3,'Style','text','string','��ⴰ��','Units','pixels','Position',...
             [0 180 200 20],'fontsize',12,'BackgroundColor','w','FontName','����');
V.p5 = uicontrol('parent',H.p3,'Style','edit','string',[],'Units','pixels','Position',...
             [10 155 205 20],'fontsize',12,'BackgroundColor','w','FontName','����');
uicontrol('parent',H.p3,'Style','text','string','��ⴰ�ص��ʣ�%��','Units','pixels','Position',...
             [0 130 200 20],'fontsize',12,'BackgroundColor','w','FontName','����');
V.p6 = uicontrol('parent',H.p3,'Style','edit','string',[],'Units','pixels','Position',...
             [10 105 205 20],'fontsize',12,'BackgroundColor','w','FontName','����');
uicontrol('parent',H.p3,'Style','text','string','��ⴰ��ֵϵ����%��','Units','pixels','Position',...
             [0 80 200 20],'fontsize',12,'BackgroundColor','w','FontName','����');
V.p7 = uicontrol('parent',H.p3,'Style','edit','string',[],'Units','pixels','Position',...
             [10 55 205 20],'fontsize',12,'BackgroundColor','w','FontName','����');
uicontrol('parent',H.p3,'Style','text','string','������ϵ����%��','Units','pixels','Position',...
             [0 30 200 20],'fontsize',12,'BackgroundColor','w','FontName','����');         
V.p8 = uicontrol('parent',H.p3,'Style','edit','string',[],'Units','pixels','Position',...
             [10 5 205 20],'fontsize',12,'BackgroundColor','w','FontName','����');
         
% f1 = getframe(H.fig,[10 85 225 40]);
H.p4 = uipanel('Parent',H.fig,'Units','pixels','Position',[10 35 225 40],'BackgroundColor','w');
V.C = uicontrol('parent',H.p4,'Style','push','String','���¼��','Units','pixels','Position',...
             [5 5 215 30],'fontsize',14,'Callback',{@cscx_re,V,P,H},'FontName','����');

Hm = uimenu('Parent',H.fig,'Label','����');
uimenu('Parent',Hm,...
       'Label','����',...
       'Callback','close;cscx_main');
uimenu('Parent',Hm,...
       'Label','�ָ�',...
       'Callback','cscx_actu');
uimenu('Parent',Hm,...
       'Label','�ر�',...
       'Callback','close(gcbf)');
   
   P.text1= uicontrol('Parent',P.p4,'Style','text','String','ƽ����ֵ��ART:','Position',[5 178 280 20],'fontsize',12,'FontName','����','HorizontalAlignment','right');
   P.edit1= uicontrol('Parent',P.p4,'Style','edit','String',[],'Position',[290 178 100 20],'fontsize',12,'FontName','����','Enable','inactive','BackgroundColor','k','ForegroundColor','w');
   P.text2= uicontrol('Parent',P.p4,'Style','text','String','Ƶ�����ֵ��ӦƵ��:','Position',[5 148 280 20],'fontsize',12,'FontName','����','HorizontalAlignment','right');
   P.edit2= uicontrol('Parent',P.p4,'Style','edit','String',[],'Position',[290 148 100 20],'fontsize',12,'FontName','����','Enable','inactive','BackgroundColor','k','ForegroundColor','w');
   P.text21= uicontrol('Parent',P.p4,'Style','text','String','Hz','Position',[395 148 175 20],'fontsize',12,'FontName','����','HorizontalAlignment','left');
   P.text3= uicontrol('Parent',P.p4,'Style','text','String','���������ֵ��ӦƵ��:','Position',[5 118 280 20],'fontsize',12,'FontName','����','HorizontalAlignment','right');
   P.edit3= uicontrol('Parent',P.p4,'Style','edit','String',[],'Position',[290 118 100 20],'fontsize',12,'FontName','����','Enable','inactive','BackgroundColor','k','ForegroundColor','w');
   P.text31= uicontrol('Parent',P.p4,'Style','text','String','Hz','Position',[395 118 175 20],'fontsize',12,'FontName','����','HorizontalAlignment','left');
   P.text4= uicontrol('Parent',P.p4,'Style','text','String','�Ʋ�ת��:','Position',[5 88 280 20],'fontsize',12,'FontName','����','HorizontalAlignment','right');
   P.text41= uicontrol('Parent',P.p4,'Style','text','String','r/min','Position',[395 88 175 20],'fontsize',12,'FontName','����','HorizontalAlignment','left');
   P.edit4= uicontrol('Parent',P.p4,'Style','edit','String',[],'Position',[290 88 100 20],'fontsize',12,'FontName','����','Enable','inactive','BackgroundColor','k','ForegroundColor','w');
   P.p5= uipanel('Parent',P.p4,'Units','pixels','Position',[5 5 555 60],'title','��ע','fontsize',14,'FontName','����');
   str2=['ART>1�Ʋ�Ŀ����ܴ���' newline 'ARTԽ��Ŀ����ڿ�����Խ��'];
   P.text5= uicontrol('Parent',P.p5,'Style','text','String',str2,'Position',[0 0 555 40],'fontsize',12,'FontName','����','ForegroundColor','b');
end