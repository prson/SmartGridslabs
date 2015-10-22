% function [exitflag,Final_voltage,P_sol,x_solution,Current] = VVC_student(location,MC,Bus,Line,NO,Imax, Param, Source_nodes)

% Objective : find the optimal settings of transformers and the minimal reative power
% of producers injection/absorption that respect technical constraints

% Inputs : 

% location : connection node of DGs
% MC : MC(i) = gives the index of the bus matrix where informations of node
% number i are. For example, in the PREDIS network, MC(5) = 4 that means
% that the informations about node 5 are in line number 4 of matrix line.
% This is because node 4 does not exist.
% Bus : Bus matrix (cf description in SOB)
% Line: Line matrix (cf description in SOB)
% NO : Vector containing the lines that are open
% Imax : Maximal admissible current in lines (in A)
% Param : Parameters (cf description in SOB)
% Source_nodes : 


% Outups : 

% exitflag : convergency information (if exitflag is -2 then their is no convergency )
% Final_voltage : Final voltage at every nodes corresponding to the
% settings found by the algorithm
% P_sol : Final power losses
% x_solution : solution vectors
% Current : Final currents in each lines corresponding to the
% settings found by the algorithm

%% To remove when creating the function
clear all
clc

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
%%