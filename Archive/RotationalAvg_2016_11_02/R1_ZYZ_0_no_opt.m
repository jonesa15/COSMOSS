function R1_ZYZ = R1_ZYZ_0_no_opt(Phi,Psi,Theta)
%R1_ZYZ_0_NO_OPT
%    R1_ZYZ = R1_ZYZ_0_NO_OPT(PHI,PSI,THETA)

%    This function was generated by the Symbolic Math Toolbox version 7.1.
%    10-Nov-2016 14:47:37

R1_ZYZ = reshape([-sin(Phi).*sin(Psi)+cos(Phi).*cos(Psi).*cos(Theta),cos(Phi).*sin(Psi)+cos(Psi).*cos(Theta).*sin(Phi),-cos(Psi).*sin(Theta),-cos(Psi).*sin(Phi)-cos(Phi).*cos(Theta).*sin(Psi),cos(Phi).*cos(Psi)-cos(Theta).*sin(Phi).*sin(Psi),sin(Psi).*sin(Theta),cos(Phi).*sin(Theta),sin(Phi).*sin(Theta),cos(Theta)],[3,3]);