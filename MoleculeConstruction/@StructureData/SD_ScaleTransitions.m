function obj_S = SD_ScaleTransitions(obj,Scaling)
obj_S = SD_Copy(obj);

obj_S.LocMu    = Scaling.*obj.LocMu;
obj_S.LocAlpha = Scaling.*obj.LocAlpha;
