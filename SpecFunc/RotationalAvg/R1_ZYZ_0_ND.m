function R1_ZYZ = R1_ZYZ_0_ND(Phi,Psi,Theta)
%R1_ZYZ_0_ND
%    R1_ZYZ = R1_ZYZ_0_ND(PHI,PSI,THETA)
%    size(R1_ZYZ_0_ND) = [NG,3,3]

%    This function was generated by the Symbolic Math Toolbox version 7.1.
%    10-Nov-2016 14:47:39

t2 = cos(Psi);
t3 = sin(Phi);
t4 = cos(Phi);
t5 = cos(Theta);
t6 = sin(Psi);
t7 = sin(Theta);
R1_ZYZ = reshape([-t3.*t6+t2.*t4.*t5,t4.*t6+t2.*t3.*t5,-t2.*t7,-t2.*t3-t4.*t5.*t6,t2.*t4-t3.*t5.*t6,t6.*t7,t4.*t7,t3.*t7,t5],[],3,3);