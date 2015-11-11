function [exitflag,Tension_finale,P_sol,x_solution,Courant] = VVC_algorithm(Bus, Line, NO, Imax, Param, Noeuds_source,Tableau_conso,Connection_node,Tableau_prod,location)
    
MC = zeros(max(Bus(:,1)),1);
for i=1:length(Bus(:,1)),
    MC(Bus(i,1),1) = i;
end

Bus(MC([9;5;11;13;6;12;2;7;8]),6:7) = Tableau_conso;
if Connection_node(1) == 0,
    Connection_node(1) = 10;
end
if Connection_node(2) == 0,
    Connection_node(2) = 9;
end

Bus([MC(14);MC(7);MC(Connection_node(1));MC(Connection_node(2));MC(5)],4:5) = Tableau_prod;

[exitflag,Tension_finale,P_sol,x_solution,Courant] = VVC_student(location,MC,Bus,Line,NO,Imax, Param, Noeuds_source);
