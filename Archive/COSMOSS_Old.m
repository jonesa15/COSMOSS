function varargout = COSMOSS_Old(varargin)
% COSMOSS MATLAB code for COSMOSS.fig
%      COSMOSS, by itself, creates a new COSMOSS or raises the existing
%      singleton*.
%
%      H = COSMOSS returns the handle to a new COSMOSS or the handle to
%      the existing singleton*.
%
%      COSMOSS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COSMOSS.M with the given input arguments.
%
%      COSMOSS('Property','Value',...) creates a new COSMOSS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before COSMOSS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to COSMOSS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help COSMOSS

% Last Modified by GUIDE v2.5 01-Oct-2014 15:09:19

% check if path is added otherwise, initailize the path
if ~eq(exist('TwoDSFG_Main','file'),2)
    Initialization
end

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @COSMOSS_OpeningFcn, ...
                   'gui_OutputFcn',  @COSMOSS_OutputFcn, ...
                   'gui_LayoutFcn',  @GUI_Base_COSMOSS, ...
                   'gui_Callback',   []);
               

if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

function hCOSMOSS = GUI_Base_COSMOSS(Singleton)
% this function create base figure. To utilize the original GUI building
% mechanism of Matlab and avoid Matlab default way to export GUI element 
% handles, this function only create the base layer with no GUI elements.
% Aftter calling "gui_mainfcn" we will call "GUI_COSMOSS" to build GUI
% elements.

% Create base figure
hCOSMOSS = figure;

hCOSMOSS.Units            = 'Pixels';
hCOSMOSS.Position         = [2 406 560 600];
hCOSMOSS.Name             = 'COSMOSS';
hCOSMOSS.ToolBar          = 'none';
hCOSMOSS.MenuBar          = 'none';
hCOSMOSS.NumberTitle      = 'off';
hCOSMOSS.IntegerHandle    = 'off';
hCOSMOSS.Tag              = 'hMain'; % tag to distinguish type of GUI
hCOSMOSS.HandleVisibility = 'Callback';

gui_Options.syscolorfig = 1;
setappdata(hCOSMOSS,'GUIDEOptions',gui_Options);

disp('Creating COSMOSS GUI Using GUI Layout Toolbox!')
disp('...')

function COSMOSS_OpeningFcn(hCOSMOSS, eventdata, GUI_data, varargin)
% This function has no output args, see OutputFcn.
% hCOSMOSS   handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% GUIdata    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to COSMOSS (see VARARGIN)

%- Check if GUI Layout Tool box exist ------------------------------------
T = ver;
UseLayoutToolBox = any(strcmp(cellstr(char(T.Name)), 'GUI Layout Toolbox'));

if UseLayoutToolBox
    hGUIs = GUI_COSMOSS(hCOSMOSS);
else
    disp('Please install GUI Layout toolbox...')
    return
end
% ------------------------------------------------------------------------   

% Prep necessary data to be export
GUI_data.hCOSMOSS = hCOSMOSS; 
GUI_data.hGUIs    = hGUIs; % export GUI handles to handles

% initiate the vaue for spectral calculation function to tell if need to recalculate 
Refresh.FTIR    = 0;
Refresh.OneDSFG = 0;
Refresh.TwoDIR  = 0;
Refresh.TwoDSFG = 0;
GUI_data.Refresh  = Refresh ; 

guidata(hCOSMOSS, GUI_data);

function varargout = COSMOSS_OutputFcn(hCOSMOSS, eventdata, GUI_data) 
% varargout  cell array for returning output args (see VARARGOUT);
% hCOSMOSS    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% GUIdata    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = hCOSMOSS;

function Export_Handle_Callback(hObject, eventdata, GUI_data)
% export handles back to work space
assignin('base', 'Data_COSMOSS', GUI_data)
disp('Updated GUI Data_COSMOSS exported!')
%^ GUI Setup ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



%% helper functions -------------------------------------------------------
function onListSelection(hObject, eventdata, GUI_data)
StructModel           = get(GUI_data.hGUIs.StructListBox,'Value');
[fhModel,ModelList,~] = StructureModel(StructModel);

hModel = feval(fhModel,'COSMOSS',GUI_data.hCOSMOSS);
disp(['COSMOSS using model ' ModelList{StructModel}])

% Pass hCOSMOSS to the fig file of each sub-GUIs so they can always access
% COSMOSS if needed
hModel.UserData = GUI_data.hCOSMOSS;

GUI_data.hModel = hModel;
guidata(hObject,GUI_data)

function UpdateCalculation(hObject, eventdata, GUI_data)
% if Refresh > 1 then recalculate 
Refresh = GUI_data.Refresh;

Refresh.FTIR    = Refresh.FTIR    + 1;
Refresh.OneDSFG = Refresh.OneDSFG + 1;
Refresh.TwoDIR  = Refresh.TwoDIR  + 1;
Refresh.TwoDSFG = Refresh.TwoDSFG + 1;

% % debug
% disp('----------------------------')
% disp(['FTIR  Refresh #: ',num2str(GUI_data.Refresh.FTIR)])
% disp(['SFG   Refresh #: ',num2str(GUI_data.Refresh.OneDSFG)])
% disp(['2DIR  Refresh #: ',num2str(GUI_data.Refresh.TwoDIR)])
% disp(['2DSFG Refresh #: ',num2str(GUI_data.Refresh.TwoDSFG)])
% disp('----------------------------')
% % debug

GUI_data.Refresh = Refresh;
guidata(GUI_data.hCOSMOSS,GUI_data);

function Toggle_Fig_Save_Callback(hObject,eventdata,handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1

button_state = get(hObject,'Value');

if button_state
	set(handles.hGUIs.PlotCursor,'Value',0)
end

function Toggle_Fig_DataCursor_Callback(hObject,eventdata,handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1

button_state = get(hObject,'Value');

if button_state
	set(handles.hGUIs.SaveFig,'Value',0)
end

% helper functions --------------------------------------------------------



%% Spectral calculation functions -----------------------------------------
function FTIR_Callback(hObject, eventdata, GUI_data)
% update the laser seeting tab
hGUIs = GUI_data.hGUIs;
hGUIs.LaserSetting.SelectedTab = hGUIs.Tab_1D;
GUI_Inputs = ParseGUI_Main(hGUIs);

%% Main
FTIR = OneD_Iteration(@FTIR_Main,GUI_data);

hF = figure;
hAx = axes('Parent',hF);
Plot1D(hAx,FTIR,GUI_Inputs);

%% Update FTIR data into guidata 
GUI_data.FTIR = FTIR;
GUI_data.Refresh.FTIR = 0;
guidata(hObject,GUI_data)

function SFG_Callback(hObject, eventdata, GUI_data)
% update the laser seeting tab
hGUIs = GUI_data.hGUIs;
hGUIs.LaserSetting.SelectedTab = hGUIs.Tab_1D;
GUI_Inputs = ParseGUI_Main(hGUIs);

%% Main
OneDSFG = OneD_Iteration(@OneDSFG_Main,GUI_data);

hF = figure;
hAx = axes('Parent',hF);
Plot1D(hAx,OneDSFG,GUI_Inputs);

%% Update share data
GUI_data.OneDSFG = OneDSFG;
GUI_data.Refresh.OneDSFG = 0;
guidata(hObject,GUI_data);

function TwoDIR_Callback(hObject, eventdata, GUI_data)
%% Read GUI
hGUIs = GUI_data.hGUIs;
GUI_Inputs = ParseGUI_Main(hGUIs);
RefreshTag = GUI_data.Refresh.TwoDIR;
Structure  = GUI_data.Structure;

% check if TwoData exisit, if not force recalculate
if and(~isfield(GUI_data,'TwoDIR'),eq(RefreshTag,0))
    RefreshTag = 1;
end

% bring the corresponding Laser setting panel into focus
hGUIs.LaserSetting.SelectedTab = hGUIs.Tab_2D;

%% Main
if RefreshTag
    % Recalculate TwoD data
    disp('Recalculating 2DIR using the updated GUI inputs...')
    GUI_data.Refresh.TwoDIR = 0; % reset the refreshtag
    
    h2DFunc = @TwoDIR_Main_Sparse;
    [SpectraGrid,Response] = TwoD_Iteration(h2DFunc,GUI_data,GUI_Inputs,hGUIs);
else
    % Reuse TwoD data
    disp('Reuse previous 2DIR sticks to update figure...')
    Response    = GUI_data.TwoDIR;
    SpectraGrid = GUI_data.TwoDIR.SpectraGrid;
end
    
%% Conv2D linshape and make figure
if strcmp(eventdata.Source,'External')
    hF_final  = eventdata.hF;
    hAx_final = eventdata.hAx;
else
    hF_final = figure;
    hAx_final = axes('Parent',hF_final);
end
CVL = Conv2D(SpectraGrid,GUI_Inputs);
CVL.FilesName = Structure.FilesName; % pass filesname for figure title

SpecType = Response.SpecType;
Plot2D(hAx_final,CVL,GUI_Inputs,SpecType);

%% update TwoDIR_Response into guidata
TwoDIR             = Response;
TwoDIR.SpectraGrid = SpectraGrid;
TwoDIR.CVL         = CVL;
TwoDIR.SpecType   = '2DIR';

GUI_data.TwoDIR = TwoDIR;
guidata(hObject,GUI_data);

function TwoDSFG_Callback(hObject, eventdata, GUI_data)
%% Read GUI
hGUIs = GUI_data.hGUIs;
GUI_Inputs = ParseGUI_Main(hGUIs);
RefreshTag = GUI_data.Refresh.TwoDSFG;
Structure  = GUI_data.Structure;

% check if TwoData exisit, if not force recalculate
if and(~isfield(GUI_data,'TwoDSFG'),eq(RefreshTag,0))
    RefreshTag = 1;
end

% bring the corresponding Laser setting panel into focus
hGUIs.LaserSetting.SelectedTab = hGUIs.Tab_2D;

%% Main
if RefreshTag
    % Recalculate TwoD data
    disp('Recalculating 2DSFG using the updated GUI inputs...')
    GUI_data.Refresh.TwoDSFG = 0; % reset the refreshtag

    h2DFunc = @TwoDSFG_Main_Sparse;
    [SpectraGrid,Response] = TwoD_Iteration(h2DFunc,GUI_data,GUI_Inputs,hGUIs);
else
    % Reuse TwoD data
    disp('Reuse previous 2DSFG sticks to update figure...')
    Response    = GUI_data.TwoDSFG;
    SpectraGrid = GUI_data.TwoDSFG.SpectraGrid;
end

%% Covolution and make figure
if strcmp(eventdata.Source,'External')
    hF_final  = eventdata.hF;
    hAx_final = eventdata.hAx;
else
    hF_final = figure;
    hAx_final = axes('Parent',hF_final);
end

CVL = Conv2D(SpectraGrid,GUI_Inputs);
CVL.FilesName = Structure.FilesName; % pass filesname for figure title

SpecType = Response.SpecType;
Plot2D(hAx_final,CVL,GUI_Inputs,SpecType);

%% update TwoDSFG_Response into guidata
TwoDSFG             = Response;
TwoDSFG.SpectraGrid = SpectraGrid;
TwoDSFG.CVL         = CVL;
TwoDSFG.SpecType    = '2DSFG';

GUI_data.TwoDSFG = TwoDSFG;
guidata(hObject,GUI_data);

function AR_SFG_Callback(hObject, eventdata, GUI_data)
SFG_AR_BNO055(GUI_data)

% Spectral calculation functions ------------------------------------------



%% Analysis Tools ---------------------------------------------------------
function HCut_Callback(hObject, eventdata, GUI_data)
%% Main
GUI_Inputs = ParseGUI_Main(GUI_data.hGUIs);

SpecType = GUI_data.hGUIs.AnalysisTools.SelectedTab.Title;
switch SpecType
    case '2DIR'
        Cut_F     = GUI_Inputs.HCut_2DIR;
        TwoD_Data = GUI_data.TwoDIR;
    case '2DSFG'
        Cut_F     = GUI_Inputs.HCut_2DSFG;
        TwoD_Data = GUI_data.TwoDSFG;
    otherwise
        disp('Spectra Type not supported')
end

hF_HCut = H_Cut(Cut_F,GUI_Inputs,TwoD_Data);

HCut.hF_HCut = hF_HCut;

%% Update share data
GUI_data.HCut = HCut;
guidata(hObject,GUI_data);

function DiagCut_Callback(hObject, eventdata, GUI_data)
%% Main
GUI_Inputs = ParseGUI_Main(GUI_data.hGUIs);

SpecType = GUI_data.hGUIs.AnalysisTools.SelectedTab.Title;
switch SpecType
    case '2DIR'
        TwoD_Data = GUI_data.TwoDIR;
    case '2DSFG'
        TwoD_Data = GUI_data.TwoDSFG;
    otherwise
        disp('Spectra Type not supported')
end

hF_DiagCut = Diag_Cut(GUI_Inputs,TwoD_Data);

DiagCut.hF_DiagCut = hF_DiagCut;

%% Update share data
GUI_data.DiagCut = DiagCut;
guidata(hObject,GUI_data);

function TransitionStrength_Callback(hObject, eventdata, GUI_data)
%% Main
GUI_Inputs = ParseGUI_Main(GUI_data.hGUIs);

SpecType = GUI_data.hGUIs.AnalysisTools.SelectedTab.Title;
switch SpecType
    case '2DIR'
        H  = GUI_data.TwoDIR.H;
        TV = GUI_data.TwoDIR.Mu;
    case '2DSFG'
        H  = GUI_data.TwoDSFG.H;
        switch GUI_Inputs.TS_Type
            case 1
                TV = GUI_data.TwoDSFG.Mu;
            case 2
                TV = GUI_data.TwoDSFG.Alpha;
        end
    otherwise
        disp('Spectra Type not supported')
end

Transition_Strength(H,TV)

% Analysis Tools ---------------------------------------------------------

