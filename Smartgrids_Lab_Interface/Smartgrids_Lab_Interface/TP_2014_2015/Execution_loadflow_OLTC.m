function [Tension,Courant, Pertes,Consigne_regleur] = Execution_loadflow_OLTC(Bus, Line, NO, Imax, Param, Noeuds_source,Tableau_conso_t,Connection_node,Tableau_prod_t)

MC = zeros(max(Bus(:,1)),1);
for i=1:length(Bus(:,1)),
    MC(Bus(i,1),1) = i;
end

Bus(MC([9;5;11;13;6;12;2;7;8]),6:7) = Tableau_conso_t;
if Connection_node(1) == 0,
    Connection_node(1) = 10;
end
if Connection_node(2) == 0,
    Connection_node(2) = 9;
end
Bus([MC(14);MC(7);MC(Connection_node(1));MC(Connection_node(2));MC(5)],4:5) = Tableau_prod_t;

%% LF
Consigne_regleur = [1;1;1];
indicateur_convergence = 0;


Line(NO,:) = [];
bus_test = Bus(2:end,:);
line_test = Line(4:end,:);
Matrice_incidence = zeros(size(bus_test,1),size(bus_test,1));
for i=1:size(line_test,1),
    Matrice_incidence(line_test(i,1),line_test(i,2)) = 1;
    Matrice_incidence(line_test(i,2),line_test(i,1)) = 1;
end

compteur = 0;
Flag_stop = 0;
eps = 10^-10;
U_min = [0.95;0.95;0.95];
U_max = [1.05;1.05;1.05];
    
while indicateur_convergence ~= 1,
    compteur=compteur+1; 
    if compteur > 1,
        % Identification des contraintes de tension
        Under_voltage = find(Tension < 0.95);
        Over_voltage = find(Tension > 1.05);
        Depart_underV = [];Depart_overV = [];
       % Depart auquel apparaissent les contraintes
       for j_dep = 1:length(Under_voltage),
           for i_str = 1: size(Matrice_parcours_graphe,2),
               if ~isempty(find(Matrice_parcours_graphe{i_str}==Under_voltage(j_dep))),
                   Depart_underV (j_dep) = i_str;
                   break
               end
           end
       end
       Depart_underV = unique(Depart_underV);

       for j_dep = 1:length(Over_voltage),
           for i_str = 1: size(Matrice_parcours_graphe,2),
               if ~isempty(find(Matrice_parcours_graphe{i_str}==Over_voltage(j_dep))),
                   Depart_overV (j_dep) = i_str;
                   break
               end
           end
       end
       Depart_overV = unique(Depart_overV);    
       
       if isempty(Depart_underV) && isempty(Depart_overV),
           % Si aucune contrainte
           indicateur_convergence = 0;
           Flag_stop = 1;
           break   
       elseif compteur == 2 && ~isempty(intersect(Depart_underV,Depart_overV)),
           % S'il y a à la fois des surtensions et soustensions sur un même
           % départ
           indicateur_convergence = 0;
           Flag_stop = -1;
           break
       elseif compteur == 2,
           % On peut tenter de régler : on met les OLTC au max (resp au min) 
           Consigne_regleur_before = Consigne_regleur;
           Consigne_regleur(Depart_underV) = 1.05;
           Consigne_regleur(Depart_overV) = 0.95;     
       elseif compteur == 3 && (~isempty(intersect(Depart_overV_b,Depart_overV)) ||  ~isempty(intersect(Depart_underV_b,Depart_underV)))
               % Même en mettant le régleur du depart avec des surtensions
               % à 0.95 et/ou le régleur du départ avec des sous-tensions à
               % 1.05, les contraintes ne sont pas respectées.
               indicateur_convergence = 0;
               Flag_stop = -1;
               break 
       elseif compteur > 2,
           % si les réglages sont trop forts, alors on rajuste par dichotomie
           if ~isempty(intersect(Depart_underV,Depart_overV)),
               % S'il y a à la fois des surtensions et sous-tensions
               indicateur_convergence = 0;
               Flag_stop = -1;
               break             
           elseif sum(abs(Consigne_regleur-Consigne_regleur_before)) < eps,
               % Critère d'arrêt
               indicateur_convergence = 0;
               break
           else
               Consigne_regleur_sauv = Consigne_regleur;
               % Sous-tension
               if ~isempty(Depart_underV),             
                   U_min(Depart_underV) = Consigne_regleur(Depart_underV);
                   if Consigne_regleur(Depart_underV) < Consigne_regleur_before(Depart_underV),                   
                       Consigne_regleur(Depart_underV) = (Consigne_regleur_before(Depart_underV)-Consigne_regleur(Depart_underV))/2+Consigne_regleur(Depart_underV);
                   else
                       Consigne_regleur(Depart_underV) = (U_max(Depart_underV)-Consigne_regleur(Depart_underV))/2+Consigne_regleur(Depart_underV);
                   end
               end
               % Sur-tension
               if ~isempty(Depart_overV),               
                   U_max(Depart_overV) = Consigne_regleur(Depart_overV);
                   if Consigne_regleur(Depart_overV) > Consigne_regleur_before(Depart_overV),
                       Consigne_regleur(Depart_overV) = (Consigne_regleur(Depart_overV)-Consigne_regleur_before(Depart_overV))/2+Consigne_regleur_before(Depart_overV);
                   else
                       Consigne_regleur(Depart_overV) = (Consigne_regleur(Depart_overV)-U_min(Depart_overV))/2+U_min(Depart_overV);                   
                   end
                   Consigne_regleur_before = Consigne_regleur_sauv;
               end
           end
       end
       Depart_overV_b = Depart_overV;
       Depart_underV_b = Depart_underV;
    end

    Indice_lignes = 1:1:size(Line,1)+length(NO);
    Courant = zeros(size(Line(:,1),1)+length(NO),1);
    Tension = zeros(size(Bus(:,1),1),1);
    Pertes = 0;

    for i_depart = 1:size(Noeuds_source),
        point_depart = Noeuds_source(i_depart);
        point_etude = point_depart;
        Voisin = find(Matrice_incidence(point_depart,:)==1);

        if ~isempty(Voisin),
            for i=1:length(Voisin), 
                Liste_voisin{i,1}(1) = point_etude;
                Liste_voisin{i,1}(2) = Voisin(i);
            end

            Nb_liste_stop = 0;
            while sum(Nb_liste_stop) ~= size(Liste_voisin,1),
                Nb_voisin = length(Liste_voisin);
                cont=0;
                for i=1:Nb_voisin,
                    point_etude = Liste_voisin{i,1}(end);
                    Voisin = find(Matrice_incidence(point_etude,:)==1);
                    Voisin = setdiff(Voisin,Liste_voisin{i,1});
                    if isempty(Voisin),
                        Nb_liste_stop(i) = 1;
                        cont=cont+1;
                        Liste_voisin_1{cont,1} = [Liste_voisin{i,1}];
                    end
                    for j=1:length(Voisin), 
                        Nb_liste_stop(i) = 0;
                        cont=cont+1;
                        Liste_voisin_1{cont,1} = [Liste_voisin{i,1} Voisin(j)];
                    end  
                end 
                Liste_voisin=Liste_voisin_1;
                clear Liste_voisin_1
            end


            Liste_noeuds = [];
            for i=1:size(Liste_voisin,1)
                Liste_noeuds = [Liste_noeuds Liste_voisin{i}];
            end
            Liste_noeuds = unique(Liste_noeuds);
            Matrice_parcours_graphe{i_depart} = Liste_noeuds;


            Bus_depart = Bus(MC(Liste_noeuds),:);
            GG = zeros(max(Bus_depart(:,1)),1);
            for i=1:length(Bus_depart(:,1)),
                GG(Bus_depart(i,1),1) = i;
            end

            Line_depart = [];Indice_courant = [];
            for i = 1:size(Line,1),
                if length(intersect([Line(i,1);Line(i,2)],Liste_noeuds)) == 2,
                    Line_depart = [Line_depart;Line(i,:)];
                    Indice_courant = [Indice_courant;Indice_lignes(i)];         
                end
            end
            Bus_depart(GG(point_depart),10) = 1;
            Bus_depart(GG(point_depart),2)=Consigne_regleur(i_depart);
            [bus_sol,P_loss,I_lignes_pu,iter] = lf(Line_depart,Bus_depart,Param) ;
            Tension(MC(Liste_noeuds)) = bus_sol(:,2);
            Courant(Indice_courant) = I_lignes_pu;
            Pertes = Pertes+P_loss;

        %     Liste_finale_nds = [Liste_finale_nds;Liste_noeuds];
            clear Liste_voisin
        else
            Tension(MC(point_depart)) = Consigne_regleur(i_depart); % A finir
            % Mettre la bonne tension
        end
    end
    % Liste_finale_nds = sort(Liste_finale_nds);
    Tension(1) = 1;
    Pertes = Pertes/sum(Bus(:,6))*100;

    Ibase_RD = Param(2)*10^6/(sqrt(3)*Param(1)*1000);
    Imax_pu = Imax/Ibase_RD;
    Courant = Courant./Imax_pu*100;
end