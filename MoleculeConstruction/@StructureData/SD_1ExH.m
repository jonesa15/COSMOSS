function obj_1ExH = SD_1ExH(obj_SD)
%% OneExcitonH generation method of StructureData class
%  
% Given StructureData, this script deal with both the diagonal (LocFreq)
% and off-diagonal (Beta) elements of a one Exciton Hamiltonian using the
% GUI_Inputs.
% Copyright Jia-Jung Ho, 2013-2020

%% GUI Inputs parser
GUI_Inputs = obj_SD.GUI_Inputs;

% Turn Output from Read GUI to cell array
GUI_Inputs_C      = fieldnames(GUI_Inputs);
GUI_Inputs_C(:,2) = struct2cell(GUI_Inputs);
GUI_Inputs_C      = GUI_Inputs_C';

INPUT = inputParser;
INPUT.KeepUnmatched = true;

defaultNLFreq       = 1716;
defaultAnharm       = 20;
defaultLFreq        = 1604;
defaultL_Index      = '';
defaultLocFreqType  = 1;
defaultCouplingType = 'TDC';
defaultBeta_NN      = 0.8; % 0.8 cm-1 according to Lauren's PNAS paper (doi/10.1073/pnas.1117704109); that originate from Min Cho's paper (doi:10.1063/1.1997151)

addOptional(INPUT,'NLFreq'      ,defaultNLFreq         );
addOptional(INPUT,'Anharm'      ,defaultAnharm         );
addOptional(INPUT,'LFreq'       ,defaultLFreq          );
addOptional(INPUT,'L_Index'     ,defaultL_Index        );
addOptional(INPUT,'LocFreqType' ,defaultLocFreqType    );
addOptional(INPUT,'CouplingType',defaultCouplingType   );
addOptional(INPUT,'Beta_NN'     ,defaultBeta_NN        );

parse(INPUT,GUI_Inputs_C{:});

% Reassign Variable names
NLFreq       = INPUT.Results.NLFreq;
Anharm       = INPUT.Results.Anharm;
LFreq        = INPUT.Results.LFreq;
L_Index      = INPUT.Results.L_Index;
LocFreqType  = INPUT.Results.LocFreqType;
CouplingType = INPUT.Results.CouplingType;
Beta_NN      = INPUT.Results.Beta_NN;

%% Update Anharmonicity
obj_1ExH           = SD_Copy(obj_SD);
obj_1ExH.LocAnharm = ones(obj_SD.Nmodes,1).*Anharm;

%% Deal with local mode frequencies and their labeling
LocFreq = ones(obj_SD.Nmodes,1).*NLFreq;

% Apply Jansen map if needed
if strcmp(LocFreqType,'Jensen Map')
    [~,dF_Jansen] = Coupling_Jansen(obj_SD);
    LocFreq = LocFreq + dF_Jansen;
end

% Apply isotope labeling
if ~isempty(L_Index)
    LocFreq(L_Index) = LFreq;  
end

obj_1ExH.LocFreq = LocFreq;

%% Generate Off-Diagonal Elements (Beta)
obj_1ExH.Beta = Coupling(obj_1ExH,CouplingType,Beta_NN);




