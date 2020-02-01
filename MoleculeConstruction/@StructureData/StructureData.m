classdef StructureData < handle
   properties % Minimum propertiess
       % Bare minimum properties that is needed for all the SD method 
       % start to work
       XYZ      % size = [NAtoms,3]
       AtomName % size = {NAtoms,1} 
   end
   
   properties % Full properties
       LocCenter       % size = [Nmodes,3]
       LocFreq         % size = [Nmodes,1]
       LocAnharm       % size = [Nmodes,1]
       LocMu           % size = [Nmodes,3]
       LocAlpha        % size = [Nmodes,9]
       OneExH          % size = [Nmodes+1,Nmodes+1], one exciton Hamiltonian
       Beta            % size = [Nmodes,Nmodes], coupling matrix
       
       hPlotFunc       % function handle of the model specific drawing function 
       GUI_Inputs      % GUI_Inputs that include the figure options. This is necessary for excuting the hPlotFunc
       
       FilesName       % name for figure drawing and identification
       Children        % this property is only used by Comb2 to draw subsystem
       Extra           % all the model dependent properties can be saved in here
   end
   
   properties % Get properties
       % These properties will be calculated when quaried
       Nmodes       % # of local modes
       NAtoms       % # of atoms
       NStucture    % # of structures, this is only require when load PDB file with multiple snapshots
       LocAlphaM    % Raman tensors in Matrix form, use for visual inspection only
       CoM          % Center of Mass, as a reference point of common origin in a coordinate system
   end
   
   properties % Set Properties
       % These properties will be automatically update when the dependent
       % peoperty is assigned. But is is free to be change later.
       Scaled_LocMu    % for comb2 concentration scaling that only applys on the MuAlphaGen
       Scaled_LocAlpha % for comb2 concentration scaling that only applys on the MuAlphaGen
   end
    
   methods % Get methods
      function Nmodes = get.Nmodes(obj)
           Nmodes = size(obj.LocFreq,1);
      end
      function NAtoms = get.NAtoms(obj)
           NAtoms = size(obj.XYZ,1);
      end
      function NStucture = get.NStucture(obj)
           NStucture = size(obj.XYZ,3);
      end       
      function locAlphaM = get.LocAlphaM(obj)
           % Vector version
           % [Aixx Aixy Aixz Aiyx Aiyy Aiyz Aizx Aizy Aizz] , size =[Mode_Num X 9]
           % 
           % Matrix representation
           % D3  --> D2
           % ^ [ Aixx Aixy Aixz ] 
           % | [ Aiyx Aiyy Aiyz ]
           % | [ Aizx Aizy Aizz ]
           locAlphaM = reshape(obj.LocAlpha,[],3,3);
      end      
      function CoM = get.CoM(obj)
           AP   = SD_AtomicProperties(obj);
           Mass = AP.Mass;
           CoM  = sum(bsxfun(@times,obj.XYZ,Mass),1)./sum(Mass);
      end 
   end
   
   methods % Set methods
       % Automatically copy the non-scaled value to the scaled properties
       % when the value fisrt being assigned
       function set.LocMu(obj,Value)
          obj.LocMu = Value;
          obj.Scaled_LocMu = Value;
       end
       function set.LocAlpha(obj,Value)
          obj.LocAlpha = Value;
          obj.Scaled_LocAlpha = Value;
      end 
   end
   
   methods % Other methods defined as a separated function
      AP          = SD_AtomicProperties(obj)
      obj_T       = SD_Trans(obj,V)
      obj_R       = SD_Rot(obj,R)
      obj_comb2   = SD_Comb2(obj1,obj2)
      Dihedral    = SD_PeptideDihedral(obj)
      obj_S       = SD_ScaleTransitions(obj,Scaling)
      obj_New     = SD_Copy(obj)
      obj_TN      = SD_TransN(obj,V,N)
      obj_Framed  = SD_SetFrame(obj,Center_Ind,Z_Ind,XZ_Ind)
      Obj_AmideI  = SD_GetAmideI(obj)
      obj_SD_1ExH = SD_1ExH(obj_SD)
      hF          = SD_Draw(obj_SD,varargin)
   end

end