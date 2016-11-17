function E3 = EPolar3(O_Sum,O_Vi,O_Pump1)
%EPOLAR3
%    E3 = EPOLAR3(O_PUMP1,O_SUM,O_VI)

%    This function was generated by the Symbolic Math Toolbox version 5.10.
%    01-Dec-2013 08:13:59

t2 = cos(O_Sum);
t3 = cos(O_Vi);
t4 = cos(O_Pump1);
t5 = sin(O_Pump1);
t6 = sin(O_Vi);
t7 = sin(O_Sum);
E3 = [t2.*t3.*t4,t2.*t3.*t5,t2.*t4.*t6,t2.*t5.*t6,t3.*t4.*t7,t3.*t5.*t7,t4.*t6.*t7,t5.*t6.*t7];
