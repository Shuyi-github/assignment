function [clustCent,data2cluster] = meanShift(dataPts,bandWidth)

[numPts,numDim] = size(dataPts);
data=dataPts';
numClust = 0;
bandSq = bandWidth^2;
initPtInds = 1:numPts;
maxPos = max(data,[],2); 
minPos = min(data,[],2); 
boundBox = maxPos-minPos; 
sizeSpace = norm(boundBox); 
Thresh = 1e-3*bandWidth; 
clustCent = []; 
beenVisited= false(1,numPts); 
numInitPts = numPts; 
clusterVotes = zeros(1,numPts,'uint16'); 
clustMembsCell = [];
kmean = @(x,d) gaussfun(x,d,bandWidth);


while numInitPts
    tempInd = ceil( (numInitPts-1e-6)*rand); 
    stInd = initPtInds(tempInd); 
    myMean = data(:,stInd);  
    myMembers = [];                          
    thisClusterVotes = zeros(1,numPts,'uint16'); 

    while true %loop untill convergence
        sqDistToAll = sum(bsxfun(@minus,myMean,data).^2); 
        inInds = find(sqDistToAll < bandSq); 
        thisClusterVotes(inInds) = thisClusterVotes(inInds)+1; 
        myOldMean = myMean; 
        myMean = kmean(data(:,inInds),sqrt(sqDistToAll(inInds)));
        myMembers = [myMembers inInds]; 
        beenVisited(myMembers) = true; 
        
        if norm(myMean-myOldMean) < Thresh
            mergeWith = 0;
            for cN = 1:numClust
                distToOther = norm(myMean-clustCent(:,cN)); 
                if distToOther < bandWidth/2 
                    mergeWith = cN;
                    break;
                end
            end
            
            if mergeWith > 0 
                nc = numel(myMembers); 
                no = numel(clustMembsCell{mergeWith}); 
                nw = [nc;no]/(nc+no); 
                clustMembsCell{mergeWith} = unique([clustMembsCell{mergeWith},myMembers]);    
                clustCent(:,mergeWith) = myMean*nw(1) + myOldMean*nw(2);
                clusterVotes(mergeWith,:) = clusterVotes(mergeWith,:) + thisClusterVotes;   
            else 
                numClust = numClust+1; 
                clustCent(:,numClust) = myMean; 
                clustMembsCell{numClust} = myMembers; 
                clusterVotes(numClust,:) = thisClusterVotes; 
            end

            break;
        end

    end
    
    initPtInds = find(~beenVisited); 
    numInitPts = length(initPtInds); 
end

[~,data2cluster] = max(clusterVotes,[],1); 

end
function out = gaussfun(x,d,bandWidth)


     ns = 1000; 
     xs = linspace(0,bandWidth,ns+1); 
     kfun = exp(-(xs.^2)/(2*bandWidth^2));
    w = kfun(round(d/bandWidth*ns)+1);
    w = w/sum(w); 
    out = sum( bsxfun(@times, x, w ), 2 );
end