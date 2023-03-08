function cscx_main()
%CSCX_MAIN is 是the main function of the software and it plots the main interface.

%版本：v1.0,编写：2023.3.8,作者：童威棋

close all
addpath('3_cscxactu');
addpath('4_cscxtool');
set(0,'Units','pixels');
H=figure('Name','水下目标探测识别系统 ','menubar','none','numbertitle','off','unit','pixels','position',[0 0 1182 555],'visible','off');
movegui(H,'center');
set(H,'visible','on'); 
pic=imread('封面.png');
axesBg=axes('units','pixels','pos',[0 0 1182 555]); % 建立背景图像的axes
set(axesBg,'visible','off');  
uistack(axesBg,'down');                             % 置于底层
axes(axesBg);
imshow(pic);                                    %显示图像
uicontrol('parent',H,'Style','push','string','开始探测','Units','pixels','FontName','黑体','BackgroundColor','w','Position',[360 100 150 50],'fontsize',20,'foregroundcolor','k','callback','close;cscx_actu');
uicontrol('parent',H,'Style','push','string','退出','Units','pixels','FontName','黑体','BackgroundColor','w','Position',[660 100 150 50],'fontsize',20,'foregroundcolor','k','callback','close');
end
