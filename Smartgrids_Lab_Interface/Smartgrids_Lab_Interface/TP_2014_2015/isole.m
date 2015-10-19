function [pts_isoles] = isole(M,nb_noeuds,neoud_source)

% M = Matrice de connectivité du réseau. 
% C'est à dire si le noeud i est connecté au noeud j alors M(i,j) = 1 et M(j,i) = 1
% nb_noeuds = nombre de noeud de ton réseau
% noeud_source = Liste des noeuds qui représentent les "sources" d'énergie

C=neoud_source;
pts_isoles=1:nb_noeuds;
pts_isoles(neoud_source)=0;
Liste = [];
while ~isempty(C),
    for i=1:length(C),
        D = [];
        D = find(M(C(i),:)==1);
        M(C(i),:)=0;
        M(:,C(i))=0;
        pts_isoles(D)=0; 
        Liste = unique([Liste D]);
    end
    C = Liste;
    Liste = [];
end
pts_isoles = nonzeros(pts_isoles);