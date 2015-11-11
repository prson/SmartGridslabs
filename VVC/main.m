clc
clear
Line = xlsread('Test_matrix','Line');
Bus = xlsread('Test_matrix','Bus');
Param = xlsread('Test_matrix','Parametres');
Imax = xlsread('Test_matrix','I_max');
NO = [8;10;12;13;17];
location = [12 13];
Source_nodes = [2;3;11];
MC = zeros(max(Bus(:,1)),1);
for i=1:length(Bus(:,1)),
    MC(Bus(i,1),1) = i;
end
VVC_student_work(location,MC,Bus,Line,NO,Imax, Param, Source_nodes);
