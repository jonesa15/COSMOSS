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
% 
% XYZ      = ConstuctBetaSheet(4,1,[0,0,4.75],[0,0,0]);
% Structure = GetAmideI_CON_XYZ_betasheet(XYZ);

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

% permute and Reshape XYZ
R_1 = reshape(XYZ,[],3,3);
R = permute(R_1,[1,3,2]);

% draw molecule
hF = figure;
hold on
   
    %% draw atoms    
    Carbon_Pos   = R(:,:,1);
    Oxygen_Pos   = R(:,:,2);
    Nitrogen_Pos = R(:,:,3);

    plot3(Rot_Center(:,1)  ,Rot_Center(:,2)  ,Rot_Center(:,3)  ,'LineStyle','none','Marker','d','MarkerFaceColor','w')
    plot3(Carbon_Pos(:,1)  ,Carbon_Pos(:,2)  ,Carbon_Pos(:,3)  ,'LineStyle','none','Marker','o','MarkerFaceColor','k','MarkerSize',10)
    plot3(Oxygen_Pos(:,1)  ,Oxygen_Pos(:,2)  ,Oxygen_Pos(:,3)  ,'LineStyle','none','Marker','o','MarkerFaceColor','r','MarkerSize',10)
    plot3(Nitrogen_Pos(:,1),Nitrogen_Pos(:,2),Nitrogen_Pos(:,3),'LineStyle','none','Marker','o','MarkerFaceColor','b','MarkerSize',10)

    %% draws bonds
    % Chain
        Conn1 = Connectivity(R(:,:,1),'BondLength',3.5);
        gplot3(Conn1, R(:,:,1));
    % C=O bond
        Conn2 = Connectivity([R(:,:,1);R(:,:,2)],'BondLength',1.6);
        gplot3(Conn2, [R(:,:,1);R(:,:,2)]);
    % C-N bond
        Conn2 = Connectivity([R(:,:,1);R(:,:,3)],'BondLength',1.6);
        gplot3(Conn2, [R(:,:,1);R(:,:,3)]);
        
%     %% draw transition dipoles
%     TDV_Scale = 0.1;
%     Rot_mu_S = TDV_Scale .* Rot_mu; % Scale TDV vector in plot
%     
%     quiver3(Rot_Center(:,1),Rot_Center(:,2),Rot_Center(:,3),...
%             Rot_mu_S(:,1),Rot_mu_S(:,2),Rot_mu_S(:,3),0,...
%             'LineWidth',2,...
%             'Color',[255,128,0]./256);
% 
%     %% draw Raman tensor using plot_Raman
%     RT_scale = 0.5;
%     N_mesh   = 20;
%     RamanM   = Structure.alpha_matrix;
% 
%     for i = 1: Num_Modes
%         Raman  = squeeze(RamanM(i,:,:));
%         Center = Rot_Center(i,:);
%         plot_Raman(Raman,Center,RT_scale,N_mesh)
%     end

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
xlabel('X')
ylabel('Y')