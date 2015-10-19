function exists=isolatedNodeExistsInBuses(isolatedNodes,Bus)
    exists=false;
    for i=1:size(isolatedNodes,1)
        if (sum(Bus(:,1)==isolatedNodes(i,1))>0)
            exists=true;
            break;
        end
    end
end