% function [Config_found] = SOB(Line, Bus,Param)
clear all
clc


Line = xlsread('Test_matrix','Line');
Bus = xlsread('Test_matrix','Bus');
Param = xlsread('Test_matrix','Parametres');
Imax = xlsread('Test_matrix','I_max');

% Bus(1,2)=1.1773;
% Line([8;10;12;13;17],3:4) = Inf;
[bus_sol,P_loss,I_lignes_pu,iter] = lf(Line,Bus,Param);
Voltage = bus_sol(:,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%                          SOB : Sequential opening branch    %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Objective of SOB: decreasing power losses in a given network by finding
% another radial configuration using the remotely controlled switches.

% To do: compute the SOB algorithm as a function called OSB. The inputs
% will be Line, Bus, Param and Imax matrices that are described bellow and
% the ouput is the Configuration found.

% Inputs
% Line : based on the Pi model
%            d        R       X=lw      a
%       -------------[]------mmm-------------
%            |                          |
%          -----                      -----  Cw/2
%          -----                      -----
%            |                          |
% 
% - Column 1 : Departure node
% - Column 2 : Arriving node
% - Column 3 : R (pu)
% - Column 4 : X(pu)
% - Column 5 : Cw/2 (pu)


% Bus
%   - Column 1 : Number of node
%   - Column 2 : Initial voltage at the nodes
%   - Column 3 : Initial voltage phase angle regarding reference node (slack bus)
%   - Column 4 : Active power generated (en pu)
%   - Column 5 : Reactive power generated (en pu)
%   - Column 6 : Active power consummed (en pu)
%   - Column 7 : Reactive power consummed (en pu)
%   - Column 8 : not used here (zeros)
%   - Column 9 : not used here (zeros)
%   - Column 10 : Type of node (1 for slack, 2 for PV and 3 for PQ)

% Param
% Param(1) = base voltage (in kV) for the real distribution network
% Param(2) = power base (in MW) for the real distribution network
% Param(3) = base volatge (in V) for the PREDIS network
% Param(4) = power base (in kW) for the PREDIS network
% Param(5) = minimal admissible voltage (in pu)
% Param(6) = maximal admissible voltage (in pu)

% Imax = maximal admissible currents of lines

% Outputs
% Config_trouvee = Optimal configuration found that minimizes power losses
% 
removeLine=true;
Line_final=Line;
I_lignes_pu_temp=I_lignes_pu;
count=1;
numOfLines=sum(Line(:,3)~=Inf)
numberOfNodes=size(Bus,1);

while(numOfLines>numberOfNodes-1)
% while(numOfLines>numberOfNodes+1 && count)
    isolated=true;
    index=0;
    count1=0;
     while(isolated)
        if(min(I_lignes_pu_temp)==Inf)
            disp('Infinity loop');
            index=0;
            break;
        end
        [m,index]=min(I_lignes_pu_temp);
        index
        Line_temp=Line_final;
        Line_temp(index,3:4) = Inf;
        M=formConnectivityMatrix(Line_temp,Bus)
        indexes=Bus(:,1);
        sourceNodes=indexes(Bus(:,10)==1);
        isolatedNodes=isole(M,numberOfNodes,sourceNodes)
        if(isolatedNodeExistsInBuses(isolatedNodes,Bus)==true || Line(index,3)==0 )
            isolated=true
            I_lignes_pu_temp(index,1)=Inf;
        else
            isolated=false;
            break;
        end
        count1=count1+1;
     end
    
    if(index==0)
        disp('No more removal of lines can be achieved without isolation.');
        break;
    end
    disp('Index Removed:');
    disp(index);
    removedIndexes(count,1)=index;
    Line_final(index,3:4) = Inf;
    M=formConnectivityMatrix(Line_final,Bus);
    indexes=Bus(:,1);
    sourceNodes=indexes(Bus(:,10)==1);
    [bus_sol,P_loss,I_lignes_pu,iter] = lf(Line_final,Bus,Param);
    I_lignes_pu_temp=I_lignes_pu
    I_lignes_pu_temp(I_lignes_pu_temp==0)=Inf;
    numOfLines=sum(Line(:,3)~=Inf);
    count=count+1;
end
removedIndexes
Line_final



