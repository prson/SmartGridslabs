function [C,Ceq]=createNonLinIneq(x,Bus,Line,Source_nodes,Param,Imax,MC,location)

% Line = xlsread('Test_matrix','Line')
% Bus = xlsread('Test_matrix','Bus')
% Param = xlsread('Test_matrix','Parametres');
% Imax = xlsread('Test_matrix','I_max');
NO = [8;10;12;13;17];
% Source_nodes = [2;3;11];
% MC = zeros(max(Bus(:,1)),1);
% % for i=1:length(Bus(:,1)),
% %     MC(Bus(i,1),1) = i;
% % end
% MC
NO=sort(NO,1,'descend');
% Line(NO,3)
% Line(NO,4)
Line(NO,:)=[];
Imax(NO)=[];

% % for i=1:size(NO,1)
% % %     NO(i,1);
% %     Line(NO(i,1),3);
% %     Line(NO(i,1),:)=[];
% %     Imax(NO(i,1),:)=[];
% % %     Line(NO(i,1),:)=[];
% % end
% Line(NO,4)=[];
% Line(NO,5)=[];
Bus(MC(location),5)=x(4:end);
% Bus(MC(13),5)=x(5);
% Bus
% Line
% Source_nodes
% Param
% Imax
% MC
% x(1:size(Source_nodes,1))
[Volt, ~]=OLTC_lf(Bus,Line,Source_nodes,Param,Imax,MC,x(1:length(Source_nodes)));

C=((Volt-1).^2)-0.0025;
Ceq=[];
end