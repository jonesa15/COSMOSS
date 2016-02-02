function hF = Plot_Betasheet_AmideI(Structure,varargin)
%% PlotXYZfiles
%  
% Given the Stuctural infomation that generated by GetAmideI.m this
% function can plot the molecule and its' amide I modes.
% 
% ------- Version log -----------------------------------------------------
% 
% Ver. 1.4  140605  Readuce the process for reading XYZ data
% 
% Ver. 1.3  131107  Add imput "Rot_Mat" to rotate molecue as user assigned
%                   This is the correction follow by v1.2 of
%                   OneDSFG_AmideI.m
% 
% Ver. 1.2  130930  Move gplot3 from Molecular_Plot to here to accomodate
%                   the update of molecular_plot
% 
% Ver. 1.1  130814  Bug in atom position index fixed 
% 
% Ver. 1.0  130729  Isolated from TwoDSFG_Simulation
% 
% ------------------------------------------------------------------------
% Copyright Jia-Jung Ho, 2013

%% Debug
% clear all 
% SheetType = 'Anti';
% % SheetType = 'Para';
% N_Residue= 10;
% N_Strand = 3;
% TransV = [0,0,4];
% TwistV = [0,0,0];
% 
% Phi_D = 0;
% Psi_D = 0;
% Theta_D = 0;
% NLFreq = 1644;
% Anharm = 12;
% 
% BB        = ConstuctBetaSheet(SheetType,N_Residue,N_Strand,TransV,TwistV);
% Structure = GetAmideI(BB.Num_Atoms,...
%                       BB.XYZ,...
%                       BB.AtomName,...
%                       BB.FilesName,...
%                       'Phi_D',Phi_D,...
%                       'Psi_D',Psi_D,...
%                       'Theta_D',Theta_D,...
%                       'NLFreq',NLFreq,...
%                       'Anharm',Anharm);

%% Input parser
% INPUT = inputParser;
% INPUT.KeepUnmatched = 1;
% 
% % Default values
% default_hF = 'New';
% 
% % Add optional inputs to inputparser object
% addOptional(INPUT,'hF',default_hF);
% 
% parse(INPUT,varargin{:});
% 
% hF = INPUT.Results.hF  ;


%% Main

% Rotate molecule and transition dipole 
XYZ        = Structure.XYZ;
Rot_Center = Structure.center;

hF = figure;
hold on
   
%% draw atoms   
Carbon_Pos   = XYZ(Structure.AtomSerNo(:,1),:);
Oxygen_Pos   = XYZ(Structure.AtomSerNo(:,2),:);
Nitrogen_Pos = XYZ(Structure.AtomSerNo(:,3),:);
% CarbonA_Pos  = XYZ(Structure.AtomSerNo(:,4),:);

plot3(Rot_Center(:,1)  ,Rot_Center(:,2)  ,Rot_Center(:,3)  ,'LineStyle','none','Marker','d','MarkerFaceColor','w')
plot3(Carbon_Pos(:,1)  ,Carbon_Pos(:,2)  ,Carbon_Pos(:,3)  ,'LineStyle','none','Marker','o','MarkerFaceColor','k','MarkerSize',10)
plot3(Oxygen_Pos(:,1)  ,Oxygen_Pos(:,2)  ,Oxygen_Pos(:,3)  ,'LineStyle','none','Marker','o','MarkerFaceColor','r','MarkerSize',10)
plot3(Nitrogen_Pos(:,1),Nitrogen_Pos(:,2),Nitrogen_Pos(:,3),'LineStyle','none','Marker','o','MarkerFaceColor','b','MarkerSize',10)
%     plot3(CarbonA_Pos(:,1) ,CarbonA_Pos(:,2) ,CarbonA_Pos(:,3) ,'LineStyle','none','Marker','o','MarkerFaceColor','k','MarkerSize',10)

% C terminus H/O atoms
C_Ind_H = Structure.Ind_H;
C_Ind_O = Structure.Ind_O;

C_H_Pos = XYZ(C_Ind_H,:);
C_O_Pos = XYZ(C_Ind_O,:);
plot3(C_H_Pos(:,1),C_H_Pos(:,2),C_H_Pos(:,3),'LineStyle','none','Marker','o','MarkerFaceColor','w','MarkerSize',10)
plot3(C_O_Pos(:,1),C_O_Pos(:,2),C_O_Pos(:,3),'LineStyle','none','Marker','o','MarkerFaceColor','r','MarkerSize',10)

%% draws bonds
% Chain
    Conn0 = Connectivity(Carbon_Pos,'BondLength',3.5);
    gplot3(Conn0, Carbon_Pos);
% C=O bond
    C_O_XYZ = [Carbon_Pos;Oxygen_Pos];
    Conn1 = Connectivity(C_O_XYZ,'BondLength',1.6);
    gplot3(Conn1,C_O_XYZ,'LineWidth',2,'Color',[0,0,0]);
% C-N bond
    C_N_XYZ = [Carbon_Pos;Nitrogen_Pos];
    Conn2 = Connectivity(C_N_XYZ,'BondLength',1.6);
    gplot3(Conn2,C_N_XYZ,'LineWidth',1,'Color',[0,0,0]);
%     % N-CA bond
%         N_CA_XYZ = [Nitrogen_Pos;CarbonA_Pos];
%         Conn3 = Connectivity(N_CA_XYZ,'BondLength',1.6);
%         gplot3(Conn3,N_CA_XYZ);
%     % CA-C bond
%         N_CA_XYZ = [CarbonA_Pos;Carbon_Pos];
%         Conn3 = Connectivity(N_CA_XYZ,'BondLength',1.6);
%         gplot3(Conn3,N_CA_XYZ);
        
%% Draw rotated molecular frame
Mol_Frame_scale = 5;
Mol_Frame_Rot = Mol_Frame_scale.*Structure.Mol_Frame_Rot;
Mol_Frame_Orig = Mol_Frame_scale.*Structure.Mol_Frame_Orig;
COA = [0,0,-10];

% Original Axis
% X
quiver3(COA(1)        ,COA(2)        ,COA(3),...
        Mol_Frame_Orig(1,1),Mol_Frame_Orig(2,1),Mol_Frame_Orig(3,1),0,...
        'LineWidth',2,...
        'LineStyle','--',...
        'Color',[1,0,0]);  
% Y
quiver3(COA(1)        ,COA(2)        ,COA(3),...
        Mol_Frame_Orig(1,2),Mol_Frame_Orig(2,2),Mol_Frame_Orig(3,2),0,...
        'LineWidth',2,...
        'LineStyle','--',...
        'Color',[0,1,0]);  
% Z    
quiver3(COA(1)        ,COA(2)        ,COA(3),...
        Mol_Frame_Orig(1,3),Mol_Frame_Orig(2,3),Mol_Frame_Orig(3,3),0,...
        'LineWidth',2,...
        'LineStyle','--',...
        'Color',[0,0,1]); 
    
% Rotated Axis
% X
quiver3(COA(1)        ,COA(2)        ,COA(3),...
        Mol_Frame_Rot(1,1),Mol_Frame_Rot(2,1),Mol_Frame_Rot(3,1),0,...
        'LineWidth',2,...
        'Color',[1,0,0]);
% Y
quiver3(COA(1)        ,COA(2)        ,COA(3),...
        Mol_Frame_Rot(1,2),Mol_Frame_Rot(2,2),Mol_Frame_Rot(3,2),0,...
        'LineWidth',2,...
        'Color',[0,1,0]);
% Z
quiver3(COA(1)        ,COA(2)        ,COA(3),...
        Mol_Frame_Rot(1,3),Mol_Frame_Rot(2,3),Mol_Frame_Rot(3,3),0,...
        'LineWidth',2,...
        'Color',[0,0,1]);
   
    
    %% Draw molecular frame on each modes
    % since I suppressed the Mol_Frame output from
    % GetAmideI_CON_XYZ_betasheet, I suppress this part accordingly. 
%     Mol_Frame_scale = 0.5;
%     Mol_Frame_all = Mol_Frame_scale.* Structure.Mol_Frame;
%     
%         % X
%         quiver3(Rot_Center(:,1)     ,Rot_Center(:,2)     ,Rot_Center(:,3),...
%                 Mol_Frame_all(:,1,1),Mol_Frame_all(:,2,1),Mol_Frame_all(:,3,1),0,...
%                 'LineWidth',2,...
%                 'Color',[1,0,0]);
%         % Y
%         quiver3(Rot_Center(:,1)     ,Rot_Center(:,2)     ,Rot_Center(:,3),...
%                 Mol_Frame_all(:,1,2),Mol_Frame_all(:,2,2),Mol_Frame_all(:,3,2),0,...
%                 'LineWidth',2,...
%                 'Color',[0,1,0]);
%         % Z
%         quiver3(Rot_Center(:,1)     ,Rot_Center(:,2)     ,Rot_Center(:,3),...
%                 Mol_Frame_all(:,1,3),Mol_Frame_all(:,2,3),Mol_Frame_all(:,3,3),0,...
%                 'LineWidth',2,...
%                 'Color',[0,0,1]);
    
hold off

%% figure setting
axis image;
rotate3d on
grid on
box on
view([0,0])
xlabel('X')
ylabel('Y')

% title
FilesName     = Structure.FilesName;
FilesName_Reg = regexprep(FilesName,'\_','\\_');
TransV_String = sprintf('T: %1.2f, %1.2f, %1.2f; ' ,Structure.TransV(1),Structure.TransV(2),Structure.TransV(3));
TwistV_String = sprintf('Tw: %3.0f, %3.0f, %3.0f; ',Structure.TwistV(1),Structure.TwistV(2),Structure.TwistV(3));
RotV_String   = sprintf('R: %3.0f, %3.0f, %3.0f; ' ,Structure.RotV(1),Structure.RotV(2),Structure.RotV(3));
Title_String  = {[FilesName_Reg, ', ', TransV_String], [TwistV_String, RotV_String]};
title(Title_String,'FontSize',14); 