function E4 = EPolar4(O_Pr,O_Pu1,O_Pu2,O_Sig)
%EPOLAR4
%    E4 = EPOLAR4(O_PR,O_PU1,O_PU2,O_SIG)

%    This function was generated by the Symbolic Math Toolbox version 7.1.
%    16-Nov-2016 18:37:46

t2 = cos(O_Pr);
t3 = cos(O_Pu2);
t4 = cos(O_Sig);
t5 = cos(O_Pu1);
t6 = sin(O_Pu1);
t7 = sin(O_Pu2);
t8 = sin(O_Pr);
t9 = sin(O_Sig);
E4 = [t2.*t3.*t4.*t5,t2.*t3.*t4.*t6,t2.*t4.*t5.*t7,t2.*t4.*t6.*t7,t3.*t4.*t5.*t8,t3.*t4.*t6.*t8,t4.*t5.*t7.*t8,t4.*t6.*t7.*t8,t2.*t3.*t5.*t9,t2.*t3.*t6.*t9,t2.*t5.*t7.*t9,t2.*t6.*t7.*t9,t3.*t5.*t8.*t9,t3.*t6.*t8.*t9,t5.*t7.*t8.*t9,t6.*t7.*t8.*t9];
