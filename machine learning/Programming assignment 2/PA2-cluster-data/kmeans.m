
function [center, DAL,movement,predict] = kmeans(F, K)

center = F( ceil(rand(K,1)*size(F,1)) ,:);              % Cluster Centers
DAL   = zeros(size(F,1),K+2);                          % Distances and Labels
move = 0.005;
bool = true;
predict = F; 

%for n = 1:KMI
while(bool)
        
   for i = 1:size(F,1)                                 % size = 200
      for j = 1:K                                      
        DAL(i,j) = norm(F(i,:) - center(j,:));      
      end
      [Distance, label] = min(DAL(i,1:K));                % 1:K are Distance from Cluster Centers 1:K 
      DAL(i,K+1) = label;                                 % K+1 is Cluster Label
      predict(i,3) = label;
      DAL(i,K+2) = Distance;                           % K+2 is Minimum Distance
   end
   oldcenter = center;
   for i = 1:K
      A = (DAL(:,K+1) == i);                           % Cluster K Points
      center(i,:) = mean(F(A,:));                       % New Cluster Centers
      if sum(isnan(center(:))) ~= 0                     
          NC = find(isnan(center(:,1)) == 1);            
         for Ind = 1:size(NC,1)
         center(NC(Ind),:) = F(randi(size(F,1)),:);
         end
      end
   end
    movement= abs(center-oldcenter);
    for i=1:K
        if (movement(i,:) <= move & i == K)
            bool = false;
        else if movement(i,:) ~= 0
            break
            end
        end     
    end
    %bool = false;
%end
end
end