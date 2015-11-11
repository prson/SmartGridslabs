function [exitflag,Final_voltage,P_sol,x_solution,Current] = VVC_student(location,MC,Bus,Line,NO,Imax, Param, Source_nodes)

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
% clear all
% clc

% the H matrix is [V(source nodes) Q(locations)]
% the H matrix is [V2 V3 V5 Q12 Q13]

%  fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options)

% fun is defined taking in H as the input and computes the square of the
% reactive power

% the initial condition is set for the optimization to be performed
% x0=[1 1 1 0 0];
x0=[ones(1,size(Source_nodes,1)) zeros(1,size(location,2))];

% A and b is set to null matrix since there is no criteria as A*x <> b
A=[];
b=[];

% Aeq and beq is set to null matrix since there is no criteria as Aeq*x =
% beq
Aeq=[];
beq=[];

% Lower and upper bounds for the bus voltages are set to 10 percent
% boundary, there are no boundaries for reactive power induction by the
% buses
lb=[0.95*ones(1,size(Source_nodes,1)) -Inf*ones(1,size(location,2))];
ub=[1.05*ones(1,size(Source_nodes,1)) Inf*ones(1,size(location,2))];

% funcNonLin=@createNonLinIneq;
nonLinfunc=@(x) createNonLinIneq(x,Bus,Line,Source_nodes,Param,Imax,MC,location);
options = optimoptions(@fmincon,'Algorithm','sqp','Display','off');

[x_solution,~,exitflag]= fmincon(@fun,x0,A,b,Aeq,beq,lb,ub,nonLinfunc,options)
[Final_voltage, Current]=OLTC_lf(Bus,Line,Source_nodes,Param,Imax,MC,x_solution(1:length(Source_nodes)))
P_sol=[0];
x_solution=x_solution';

