function cscx_main()
clc
close all
addpath('3_cscxactu');
addpath('4_cscxtool');
set(0,'Units','pixels');
h=figure('Name','ˮ��Ŀ��̽��ʶ��ϵͳ ','menubar','none','numbertitle','off','unit','pixels','position',[0 0 1182 555],'visible','off');
movegui(h,'center');
set(h,'visible','on'); 
pic=imread('����.png');
AxesBg=axes('units','pixels','pos',[0 0 1182 555]); % ��������ͼ���axes
set(AxesBg,'visible','off');  
uistack(AxesBg,'down');                             % ���ڵײ�
axes(AxesBg);
imshow(pic);                                    %��ʾͼ��
uicontrol('parent',h,'Style','push','string','ʵ�ʴ���','Units','pixels','FontName','����','BackgroundColor','w','Position',[360 100 150 50],'fontsize',20,'foregroundcolor','k','callback','close;cscx_actu');
uicontrol('parent',h,'Style','push','string','�˳�','Units','pixels','FontName','����','BackgroundColor','w','Position',[660 100 150 50],'fontsize',20,'foregroundcolor','k','callback','close');
end