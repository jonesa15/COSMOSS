function hF=Plot1D(hAx,OneD_Data,GUI_Inputs)
%% PlotOneDSFG
%  
% Given the Stuctural infomation that generated by GetAmideI.m this
% function can plot the molecule and its' amide I modes.
% 
% ------- Version log -----------------------------------------------------
%
% Ver. 1.2  140922  Substitute GUI read-in with Input parser
% 
% Ver. 1.1  140717  Add Frequency axis GUI read in part
% 
% Ver. 1.0  140605  Start Log.
% 
% ------------------------------------------------------------------------
% Copyright Jia-Jung Ho, 2014

%% Debug
% clear all
% varargin = {'LineShape','KK'};
% 
% Structure_Data = GetAcid;
% OneDSFG = OneDSFG_Main(Structure_Data);

%% Inputs parser
GUI_Inputs_C      = fieldnames(GUI_Inputs);
GUI_Inputs_C(:,2) = struct2cell(GUI_Inputs);
GUI_Inputs_C      = GUI_Inputs_C';

INPUT = inputParser;
INPUT.KeepUnmatched = 1;

% Default values
defaultPlotStick    = 1;
defaultPlotNorm     = 0;
% defaultF_Min        = 1600;
% defaultF_Max        = 1800;
defaultLineWidth    = 5;
defaultSignal_Type  = 'Hetero';
defaultLineShape    = 'L';
defaultPlotCursor   = 0;
defaultIntegralArea = 0;
defaultFreqRange    = 1650:1750;

% add Optional inputs / Parameters
addOptional(INPUT,'PlotStick'   ,defaultPlotStick);
addOptional(INPUT,'PlotNorm'    ,defaultPlotNorm);
% addOptional(INPUT,'F_Min'       ,defaultF_Min);
% addOptional(INPUT,'F_Max'       ,defaultF_Max);
addOptional(INPUT,'LineWidth'   ,defaultLineWidth);
addOptional(INPUT,'Signal_Type' ,defaultSignal_Type);
addOptional(INPUT,'LineShape'   ,defaultLineShape);
addOptional(INPUT,'PlotCursor'  ,defaultPlotCursor);
addOptional(INPUT,'IntegralArea',defaultIntegralArea);
addOptional(INPUT,'FreqRange'   ,defaultFreqRange);

parse(INPUT,GUI_Inputs_C{:});

% Re-assign variable names
PlotStick    = INPUT.Results.PlotStick;
PlotNorm     = INPUT.Results.PlotNorm;
% F_Min        = INPUT.Results.F_Min;
% F_Max        = INPUT.Results.F_Max;
LineWidth    = INPUT.Results.LineWidth;
Signal_Type  = INPUT.Results.Signal_Type;
LineShape    = INPUT.Results.LineShape;
PlotCursor   = INPUT.Results.PlotCursor;
IntegralArea = INPUT.Results.IntegralArea;
FreqRange    = INPUT.Results.FreqRange;

%% Determine spectrum type  
%Num_Modes = OneD_Data.Num_Modes;

switch OneD_Data.SpecType
    case 'FTIR'
        Signal_Type = 'Hetero'; % self heterodyne!!
    case 'SFG'
end

Response1D  = OneD_Data.Response1D;
Res_Freq    = OneD_Data.freq_OneD;

%% Make figure
cla(hAx)
axes(hAx)

hold on
% Get Frequency axis range 
N_Grid = length(FreqRange);

% plot baseline
line([FreqRange(1);FreqRange(end)],[0;0],'Color',[1,0,0])

% spec_array1 = bsxfun(@times,ones(Num_Modes,length(spec_range)),spec_range);
% spec_array2 = bsxfun(@minus,spec_array1,Res_Freq);
spec_array = (1:N_Grid) - ceil(N_Grid/2);

switch LineShape 
    case 'G' % Gaussian
        LineShape = 1i*exp(-(spec_array.^2)./(LineWidth^2));
        %CVL = bsxfun(@times,LineShape,Response1D); 
        %CVL_Total = sum(CVL,1);
    case 'L' % Lorentzain 
        LineWidth = LineWidth/2;
        LineShape = spec_array./((spec_array.^2)+(LineWidth^2)) + 1i*LineWidth./(spec_array.^2+LineWidth^2);
        %CVL = bsxfun(@times,LineShape,Response1D); 
        %CVL_Total = sum(CVL,1);
    case 'KK' % K-K use K-K relation to generate Re part
        LineWidth = LineWidth/2;
        Im = (1/pi)*(LineWidth)./(spec_array.^2+(LineWidth)^2);
        Re = kkimbook2(FreqRange,Im,1);
        LineShape = Im+Re;
        %CVL_Total = 1i*Im_Total + Re;       
end

CVL_Total = conv(Response1D,LineShape,'same');

switch Signal_Type
    case 'Hetero' % heterodyne
        PlotY = imag(CVL_Total);
        Stick = Response1D;
        Signal_Type_Title = 'Hetero';
    case 'Homo' % homodyne
        PlotY = abs(CVL_Total).^2;
        Stick = Response1D.^2;
        Signal_Type_Title = 'Homo';
end

if PlotNorm
    PlotY = PlotY./max(abs(PlotY(:)));
    Stick = Stick./max(abs(Stick(:)));
else
    Stick = Stick.*(max(abs(PlotY(:)))/max(abs(Stick(:))));
end


if eq(PlotStick,1)
    line([Res_Freq;Res_Freq],[zeros(1,N_Grid);Stick']);
    %plot(Res_1DSFG_Freq,Response1DSFG,'rx')
end

plot(FreqRange,PlotY,'-','LineWidth',2)
hold off

%% figure setting 
hAx.Units = 'normalized'; % use normalized scale
hF = hAx.Parent;
hF.Units = 'normalized'; % use normalized scale

hAx.FontSize = 14;
hAx.XLim = [FreqRange(1),FreqRange(end)];
hAx.XLabel.String = 'cm^{-1}';

if PlotCursor
    % Call pointer
    S.fh = hF;
    S.ax = hAx;
    Pointer_N(S) % use normalized scale
else
    FilesName     = OneD_Data.FilesName;
    FilesName_Reg = regexprep(FilesName,'\_','\\_');
    Coupling      = OneD_Data.CouplingType;
    Coupling_Reg  = regexprep(Coupling,'\_','\\_');
    Title_String  = [Signal_Type_Title,'-',OneD_Data.SpecType,' ',FilesName_Reg,', Coupling:',Coupling_Reg];
    title(Title_String,'FontSize',16);    
end

if IntegralArea
    % integrate the curve area
    Area = trapz(FreqRange,abs(PlotY));
    uicontrol(hF,...
              'style','text',...
              'Position',[100,100,100,25],...
              'String',['IA = ' num2str(Area)],...
              'FontSize',14);

    % StickSum = sum(Stick);
    % Title = [Signal_Type_Title, ', IA: ' num2str(Area), ',  Stick sum: ', num2str(StickSum)];
    % title(Title,'FontSize',16);
end

