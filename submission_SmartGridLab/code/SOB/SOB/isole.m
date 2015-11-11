function [isolated_nodes] = isole(M,nb_nodes,source_node)

% - M = Connectivity matrix of the network: if node i is connected to node j then M(i,j) = 1 and M(j,i) = 1
% - nb_nodes = number of nodes of the network
% - source_node = List of nodes considered as energy "sources". Each nodes
% have to be connected to the source nodes.

C=source_node;
isolated_nodes=1:nb_nodes;
isolated_nodes(source_node)=0;
Liste = [];
while ~isempty(C),
    for i=1:length(C),
        D = [];
        D = find(M(C(i),:)==1);
        M(C(i),:)=0;
        M(:,C(i))=0;
        isolated_nodes(D)=0; 
        Liste = unique([Liste D]);
    end
    C = Liste;
    Liste = [];
end
isolated_nodes = nonzeros(isolated_nodes);