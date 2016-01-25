function GUI = GUI_Plot_Modes(fig)
%% Add base layout
MainLayout = uix.VBoxFlex(...
    'Parent',fig,...
    'Spacing',1,...
    'Padding',5);

ModeListPanel = uix.BoxPanel( ...
    'Parent',MainLayout,...
    'Title','Mode List','FontSize',14);

PlotPanel = uix.BoxPanel( ...
    'Parent',MainLayout,...
    'Title','Plotting selection','FontSize',14);

% buttom
uicontrol('Parent', MainLayout, ...
          'String', 'Plot selected modes',...
          'fontunits', 'point', 'fontsize', 14,...
          'Callback',@(hObject,eventdata)Plot_Modes('Update_Figure',hObject,eventdata,guidata(hObject)));

uicontrol('Parent', MainLayout, ...
          'String', 'Export handles',...
          'fontunits', 'point', 'fontsize', 14,...
          'Callback',@(hObject,eventdata)Plot_Modes('Export_Handle_Callback',hObject,eventdata,guidata(hObject)));

      
set(MainLayout,'Heights',[-1,100,25,25])

%% ModeListPanel
ModeList = [0,0,0];
cnames  = {'Index','Freq.','Mu Int','Mu Z' ,'Alpha ZZ'};
cformat = {'short','bank' ,'short' ,'short','short'   };

ModeListLayout = uix.VBox('Parent',ModeListPanel,...
                           'Padding', 3, 'Spacing', 3);

hT = uitable('Parent', ModeListLayout, ...
             'Data', ModeList,...
             'ColumnName',cnames,...
             'ColumnFormat',cformat,...
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
              'tag','SortInd',...
              'HorizontalAlignment','left',...
              'units', 'normalized',...
              'fontunits', 'point', 'fontsize', 14);
    uicontrol('Parent', SortIndBox, ...
              'String', 'Sort',...
              'fontunits', 'point', 'fontsize', 14,...
              'Callback',@(hObject,eventdata)Plot_Modes('uitable_SortCallback',hObject,eventdata,guidata(hObject)));

    set(SortIndBox,'Widths',[150,-1,80])        
    
set(ModeListLayout,'Heights',[-1,25])
         
%% PlotPanel
PlotPanelLayout = uix.VBox('Parent',PlotPanel,...
                           'Padding', 3, 'Spacing', 3);

    IndexBox = uix.HBox('Parent',PlotPanelLayout,...
                        'Padding', 1, 'Spacing', 1);
        uicontrol('Parent',IndexBox,...
                  'Style','text',...
                  'String','Mode indexes:',...
                  'HorizontalAlignment','left',...
                  'units', 'normalized',...
                  'fontunits', 'point', 'fontsize', 14);
        uicontrol('Parent',IndexBox,...
                  'Style','edit',...
                  'Tag','Mode_Ind',...
                  'String','',...
                  'HorizontalAlignment','left',...
                  'units', 'normalized',...
                  'fontunits', 'point', 'fontsize', 14);
    set(IndexBox,'Widths',[100,-1])
        
    ModeTypeBox = uix.HBox('Parent',PlotPanelLayout,...
                           'Padding', 1, 'Spacing', 1);
        uicontrol('Parent',ModeTypeBox,...
                  'Style','text',...
                  'String','Mode type:',...
                  'HorizontalAlignment','left',...
                  'units', 'normalized',...
                  'fontunits', 'point', 'fontsize', 14);             
        uicontrol('Parent',ModeTypeBox,...
                  'Style','popup',...
                  'String',{'Local Mode','Exciton Mode'},...
                  'Value',2,...
                  'tag','Mode_Type',...
                  'HorizontalAlignment','left',...
                  'units', 'normalized',...
                  'fontunits', 'point', 'fontsize', 14);
      set(ModeTypeBox,'Widths',[100,-1])
     
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
          
set(PlotPanelLayout,'Heights',[-1,-1,-1])
    
%% output handles
GUI = guihandles(fig);