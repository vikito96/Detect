function cscx_main()
%CSCX_MAIN is ��the main function of the software and it plots the main interface.

%�汾��v1.0,��д��2023.3.8,���ߣ�ͯ����

close all
addpath('3_cscxactu');
addpath('4_cscxtool');
set(0,'Units','pixels');
H=figure('Name','ˮ��Ŀ��̽��ʶ��ϵͳ ','menubar','none','numbertitle','off','unit','pixels','position',[0 0 1182 555],'visible','off');
movegui(H,'center');
set(H,'visible','on'); 
pic=imread('����.png');
axesBg=axes('units','pixels','pos',[0 0 1182 555]); % ��������ͼ���axes
set(axesBg,'visible','off');  
uistack(axesBg,'down');                             % ���ڵײ�
axes(axesBg);
imshow(pic);                                    %��ʾͼ��
uicontrol('parent',H,'Style','push','string','��ʼ̽��','Units','pixels','FontName','����','BackgroundColor','w','Position',[360 100 150 50],'fontsize',20,'foregroundcolor','k','callback','close;cscx_actu');
uicontrol('parent',H,'Style','push','string','�˳�','Units','pixels','FontName','����','BackgroundColor','w','Position',[660 100 150 50],'fontsize',20,'foregroundcolor','k','callback','close');
end
