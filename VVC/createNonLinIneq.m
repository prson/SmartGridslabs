function A=createNonLinIneq(x)

Line = xlsread('Test_matrix','Line')
Bus = xlsread('Test_matrix','Bus')
Param = xlsread('Test_matrix','Parametres');
Imax = xlsread('Test_matrix','I_max');
NO = [8;10;12;13;17];
location = [12 13];
Source_nodes = [2;3;11];
MC = zeros(max(Bus(:,1)),1);
for i=1:length(Bus(:,1)),
    MC(Bus(i,1),1) = i;
end

Line(NO,4)=[];
Line(NO,5)=[];
Bus(M(12),5)=h(4);
Bus(M(13),5)=h(5);
[Volt, Current]=OLTC_lf(Bus,Line,Noeuds_source,Param,Imax,MC,x(size(Source_nodes,1):end));

A=((Volt-1).^2)-0.0025;
end