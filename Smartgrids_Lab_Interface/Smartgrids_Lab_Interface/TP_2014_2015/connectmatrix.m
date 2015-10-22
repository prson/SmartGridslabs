function M=connectmatrix(Line,Bus)

    M=zeros(size(Bus,1)); % first we create an empty connectivity matrix
    for iter=1:length(Line) % here we check which are the lines that connects two nodes and we supply the number of the nodes 
        if Line(iter,3)~= Inf,
            i=Line(iter,1);
            j=Line(iter,2);
            M(i,j)=1;
            M(j,i)=1;
        end
    end
end