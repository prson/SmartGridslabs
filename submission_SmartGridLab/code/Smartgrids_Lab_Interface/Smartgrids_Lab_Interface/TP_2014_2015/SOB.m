function [Config] = SOB(Line, Bus,Param)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%                  SOB : Sequential opening branch    %%%%%%%%%%%
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
% Param(3) = base voltage (in V) for the PREDIS network
% Param(4) = power base (in kW) for the PREDIS network
% Param(5) = minimal admissible voltage (in pu)
% Param(6) = maximal admissible voltage (in pu)

% Imax = maximal admissible currents of lines

% Outputs
% Config_trouvee = Optimal configuration found that minimizes power losses
Line(:,4) = 10^-10;


radial=0;
M=connectmatrix(Line,Bus);
nb_nodes=size(Bus,1);
source_node=13;
    
%     % Load flow
    [bus_sol,P_loss,I_lignes_pu,iter] = lf(Line,Bus,Param);
%     Voltage = bus_sol(:,2);
%    
    % Sort the currents
    I=[(1:length(Line))', I_lignes_pu];
    I_sort=sortrows(I,2);
    
k=0;Config = [];
while radial==0
    k=k+1;
    if I_sort(k,2)~=0    
        a=I_sort(k,1);
        if a~=1 && a~=2 && a~=3 % we check not to open the transformers
            Linetemp=Line; % We create a temp value only to check if the new configuration creates an isolated node
            Linetemp(a,3:4)=Inf;
            Mtemp=connectmatrix(Linetemp,Bus);
            isolated_nodes = isole(Mtemp,nb_nodes,source_node);
            if length(isolated_nodes) == 1,
                Line=Linetemp;
                M=Mtemp;

                L=size(find(Line(:,3)~=Inf),1);

                if nb_nodes==L+1
                    radial=1; % Network is radial and the code exits
                    Config = [Config ;a];
                else
                    [bus_sol,P_loss,I_lignes_pu,iter] = lf(Line,Bus,Param); % load flow
                    Voltage = bus_sol(:,2);
                    I=[(1:length(Line))', I_lignes_pu];
                    I_sort=sortrows(I,2); % sorting the currents
                    k=0; % to check again from the first line
                    Config = [Config ;a];
                end    
            end
        end
    end    
end
   
    


