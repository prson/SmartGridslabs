function M=formConnectivityMatrix(Line, Bus)

% Inputs:
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

numberOfNodes=max(Bus(:,1));
M=zeros(numberOfNodes,numberOfNodes);
for i=1:numberOfNodes
    for j=1:numberOfNodes
        if(i~=j)
            for k=1:size(Line,1)
                if((Line(k,1)==i && Line(k,2)==j) || (Line(k,1)==j && Line(k,2)==i))
                    if((Line(k,3)~=Inf && Line(k,4)~=Inf))
                        M(i,j)=1; 
                    end
                   break;
                end
            end
        end
    end
end


% for i=1:size(Line,1)
%     M(Line(i,1),Line(i,2))=1;
%     M(Line(i,2),Line(i,1))=1;
% end

% - nb_nodes = number of nodes of the network
% - source_node = List of nodes considered as energy "sources". Each nodes
% have to be connected to the source nodes.