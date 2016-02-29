function GUI = GUI_Plot_Modes(fig)
%% Pre-setting
Version = '1.0.2';

%% Add base layout
MainLayout = uix.VBoxFlex(...
    'Parent',fig,...
    'Spacing',1,...
    'Padding',3);

ModeListPanel = uix.BoxPanel( ...
    'Parent',MainLayout,...
    'Title','Mode List','FontSize',14);

PlotPanel = uix.BoxPanel( ...
    'Parent',MainLayout,...
    'Title','Plotting selection','FontSize',14);

% buttom
ButtonBox = uix.HBox('Parent',MainLayout,...
                     'Padding', 1, 'Spacing', 1);

set(MainLayout,'Heights',[-1,150,30])

%% ModeListPanel
ModeList = [0,0,0];
cnames  = {'Index','Freq.','Norm 1D','Norm 2D','Mu Int','Norm[A]','S_Z 1D','S_Z 2D', 'Mu z', 'A zz', 'A p1', 'A p2', 'A p3'};
cformat = {'short', 'bank',   'bank',   'bank',  'bank',   'bank', 'short', 'short','short','short','short','short','short'};
cwidth  = {     40,     50,       60,       60,      50,       50,      70,      70,     70,     70,     70,     70,     70};

% cformat = {'short','bank' ,'short'   ,'short' ,'short' ,'short'  ,'short','short'};
% cwidth  = {     40,     50,'auto'    ,'auto'  ,'auto'  ,'auto'   ,'auto' ,'auto' };

ModeListLayout = uix.VBox('Parent',ModeListPanel,...
                           'Padding', 3, 'Spacing', 3);

hT = uitable('Parent', ModeListLayout, ...
             'Data', ModeList,...
             'ColumnName',cnames,...
             'ColumnFormat',cformat,...
             'ColumnWidth',cwidth,...
             'tag','ModeList',...
             'CellSelectionCallback',@(hObject,eventdata)Plot_Modes('uitable_CellSelectionCallback',hObject,eventdata,guidata(hObject)));

SortIndBox = uix.HBox('Parent',ModeListLayout,...
                       'Padding', 1, 'Spacing', 1);

    uicontrol('Parent',SortIndBox,...
              'Style','text',...
              'String','Sort by column: ',...
              'HorizontalAlignment','left',...
              'units', 'normalized',...
              'fontunits', 'point', 'fontsize', 14);
    uicontrol('Parent',SortIndBox,...
              'Style','popup',...
              'String',cnames,...
              'Value',3,...
              'tag','SortInd',...
              'HorizontalAlignment','left',...
              'units', 'normalized',...
              'fontunits', 'point', 'fontsize', 14);
    uicontrol('Parent', SortIndBox, ...
              'String', 'Sort',...
              'fontunits', 'point', 'fontsize', 14,...
              'Callback',@(hObject,eventdata)Plot_Modes('uitable_SortCallback',hObject,eventdata,guidata(hObject)));
    uicontrol('Parent', SortIndBox, ...
              'String', 'Refresh',...
              'fontunits', 'point', 'fontsize', 14,...
              'Callback',@(hObject,eventdata)Plot_Modes('Update_Modes',hObject,eventdata,guidata(hObject)));
 
    set(SortIndBox,'Widths',[120,-1,80,80])        
    
set(ModeListLayout,'Heights',[-1,25])
         
%% PlotPanel
PlotPanelLayout = uix.VBox('Parent',PlotPanel,...
                           'Padding', 3, 'Spacing', 3);
                
    LocModeBox = uix.HBox('Parent',PlotPanelLayout,...
                        'Padding', 1, 'Spacing', 1);
        uicontrol('Parent',LocModeBox,...
                  'Style','checkbox',...
                  'String','Plot local modes, index:',...
                  'Value',1,...
                  'Tag','Plot_Loc',...
                  'HorizontalAlignment','left',...
                  'units', 'normalized',...
                  'fontunits', 'point', 'fontsize', 14);
        uicontrol('Parent',LocModeBox,...
                  'Style','edit',...
                  'Tag','Loc_Ind',...
                  'String','',...
                  'HorizontalAlignment','left',...
                  'units', 'normalized',...
                  'fontunits', 'point', 'fontsize', 14);
    set(LocModeBox,'Widths',[200,-1])
    
    ExModeBox = uix.HBox('Parent',PlotPanelLayout,...
                        'Padding', 1, 'Spacing', 1);
        uicontrol('Parent',ExModeBox,...
                  'Style','checkbox',...
                  'String','Plot exciton modes, index:',...
                  'Value',1,...
                  'Tag','Plot_Ex',...
                  'HorizontalAlignment','left',...
                  'units', 'normalized',...
                  'fontunits', 'point', 'fontsize', 14);
        uicontrol('Parent',ExModeBox,...
                  'Style','edit',...
                  'Tag','Ex_Ind',...
                  'String','',...
                  'HorizontalAlignment','left',...
                  'units', 'normalized',...
                  'fontunits', 'point', 'fontsize', 14);
    set(ExModeBox,'Widths',[200,-1])      

    ModeScaleBox = uix.HBox('Parent',PlotPanelLayout,...
                            'Padding', 1, 'Spacing', 1);
        uicontrol('Parent',ModeScaleBox,...
                  'Style','checkbox',...
                  'String','TDV,',...
                  'Value',1,...
                  'Tag','Plot_TDV',...
                  'HorizontalAlignment','left',...
                  'units', 'normalized',...
                  'fontunits', 'point', 'fontsize', 14);     
        uicontrol('Parent',ModeScaleBox,...
                  'Style','text',...
                  'String','Scale:',...
                  'HorizontalAlignment','left',...
                  'units', 'normalized',...
                  'fontunits', 'point', 'fontsize', 14);     
        uicontrol('Parent',ModeScaleBox,...
                  'Style','edit',...
                  'String','1',...
                  'tag','Scale_TDV',...
                  'HorizontalAlignment','left',...
                  'units', 'normalized',...
                  'fontunits', 'point', 'fontsize', 14);
        uix.Empty('Parent',ModeScaleBox)
        uicontrol('Parent',ModeScaleBox,...
                  'Style','checkbox',...
                  'String','Raman,',...
                  'Value',1,...
                  'Tag','Plot_Raman',...
                  'HorizontalAlignment','left',...
                  'units', 'normalized',...
                  'fontunits', 'point', 'fontsize', 14);     
        uicontrol('Parent',ModeScaleBox,...
                  'Style','text',...
                  'String','Scale:',...
                  'HorizontalAlignment','left',...
                  'units', 'normalized',...
                  'fontunits', 'point', 'fontsize', 14);     
        uicontrol('Parent',ModeScaleBox,...
                  'Style','edit',...
                  'String','1',...
                  'tag','Scale_Raman',...
                  'HorizontalAlignment','left',...
                  'units', 'normalized',...
                  'fontunits', 'point', 'fontsize', 14);
    set(ModeScaleBox,'Widths',[60,60,60,-1,80,60,60])

    uicontrol('Parent',PlotPanelLayout,...
              'Style','checkbox',...
              'String','Normalize modes for direction comparison,',...
              'Value',1,...
              'Tag','Normalize',...
              'HorizontalAlignment','left',...
              'units', 'normalized',...
              'fontunits', 'point', 'fontsize', 14);
                 
    EigenVecBox = uix.HBox('Parent',PlotPanelLayout,...
                        'Padding', 1, 'Spacing', 1);
        uicontrol('Parent',EigenVecBox,...
                  'Style','checkbox',...
                  'String','Plot mixing coefficients for exciton mode #:',...
                  'Value',1,...
                  'Tag','Plot_EigenVec',...
                  'HorizontalAlignment','left',...
                  'units', 'normalized',...
                  'fontunits', 'point', 'fontsize', 14);
        uicontrol('Parent',EigenVecBox,...
                  'Style','edit',...
                  'Tag','EigneVec_Ind',...
                  'String','',...
                  'HorizontalAlignment','left',...
                  'units', 'normalized',...
                  'fontunits', 'point', 'fontsize', 14);
    set(EigenVecBox,'Widths',[300,-1])
          
set(PlotPanelLayout,'Heights',[-1,-1,-1,-1,-1])

%% Button Box
uicontrol('Parent', ButtonBox, ...
          'String', 'Plot selected modes',...
          'fontunits', 'point', 'fontsize', 14,...
          'Callback',@(hObject,eventdata)Plot_Modes('Update_Figure',hObject,eventdata,guidata(hObject)));

uicontrol('Parent', ButtonBox, ...
          'String', 'Export handles',...
          'fontunits', 'point', 'fontsize', 14,...
          'Callback',@(hObject,eventdata)Plot_Modes('Export_Handle_Callback',hObject,eventdata,guidata(hObject)));
        
uicontrol('Parent',ButtonBox,...
          'Style','text',...
          'String',['Plot_Mode Version: v',Version],...
          'HorizontalAlignment','Center',...
          'units', 'normalized',...
          'fontunits', 'point', 'fontsize', 14);        
%% output handles
GUI = guihandles(fig);