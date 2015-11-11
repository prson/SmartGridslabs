
% the H matrix is [V2 V3 V5 Q12 Q13]

%  fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options)

% fun is defined taking in H as the input and computes the square of the
% reactive power
% the initial condition is set for the optimization to be performed
x0=[1 1 1 0 0];

% A and b is set to null matrix since there is no criteria as A*x ? b
A=[];
b=[];

% Aeq and beq is set to null matrix since there is no criteria as Aeq*x =
% beq
Aeq=[];
beq=[];

% Lower and upper bounds for the bus voltages are set to 10 percent
% boundary
lb=[0.95 0.95 0.95 -Inf -Inf];
ub=[1.05 1.05 1.05 Inf Inf];

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
Bus
upd_Bus=[h(4) h(5)]
OLTC_lf(upd_Bus,Line,Noeuds_source,Param,Imax,MC,Consigne_regleur)


