function Plot2DSFG(CVL,GUI_Inputs)

%% Inputs parser
GUI_Inputs_C      = fieldnames(GUI_Inputs);
GUI_Inputs_C(:,2) = struct2cell(GUI_Inputs);
GUI_Inputs_C      = GUI_Inputs_C';

INPUT = inputParser;
INPUT.KeepUnmatched = 1;

% Default values
defaultFreqRange   = 1600:1800;
defaultNum_Contour = 20;
defaultPlotCursor  = 0;

% add Optional inputs / Parameters
addOptional(INPUT,'FreqRange'  ,defaultFreqRange);
addOptional(INPUT,'Num_Contour',defaultNum_Contour);
addOptional(INPUT,'PlotCursor' ,defaultPlotCursor);

parse(INPUT,GUI_Inputs_C{:});

% Re-assign variable names
FreqRange   = INPUT.Results.FreqRange;
Num_Contour = INPUT.Results.Num_Contour;
PlotCursor  = INPUT.Results.PlotCursor;

%% Main
hF = figure;
CVLRS = -1.*real(CVL.selected);

contour(FreqRange,FreqRange,CVLRS,Num_Contour,'LineWidth',2)

% Normalization
% CVLRSN = CVLRS ./max(abs(CVLRS(:)));
% contour(GUI_Inputs.FreqRange,GUI_Inputs.FreqRange,CVLRSN,GUI_Inputs.Num_Contour,'LineWidth',2)

% Plot diagonal line
hold on; plot(FreqRange,FreqRange); hold off

% figure setting 
hF.Units = 'normalized'; % use normalized scale
hAx = hF.CurrentAxes;
hAx.DataAspectRatio = [1,1,1];
hAx.FontSize = 14;
hAx.XLabel.String = 'Probe (cm^{-1})';
hAx.YLabel.String = 'Pump (cm^{-1})';

colorbar
colormap('jet')
Amp = max(abs(caxis));
caxis([-Amp Amp])
% % Set colorbar
% MAP = custom_cmap(Num_Contour);
% colormap(MAP)

if PlotCursor
    % Call pointer
    S.fh = hF;
    S.ax = hAx;
    Pointer_N(S) % use normalized scale
else
    Title = ['2DSFG'];
    title(Title,'FontSize',16);    
end