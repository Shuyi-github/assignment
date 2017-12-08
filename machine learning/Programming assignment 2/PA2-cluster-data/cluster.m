clear;
load('cluster_data.mat');
A_X=dataA_X(1,:);
A_Y=dataA_X(2,:);
B_X=dataB_X(1,:);
B_Y=dataB_X(2,:);
C_X=dataC_X(1,:); 
C_Y=dataC_X(2,:);
% figure;
% hold on;
% plot(A_X,A_Y,'r.');
% plot(B_X,B_Y,'b.');
% plot(C_X,C_Y,'k.');
% hold off;
num=0
k=4;

[row,col]=size(dataA_X);

[center, DAL,m, pre]=kmeans((dataC_X)',k);
figure;
hold on;
for i=1:k
    plot(center(i,1),center(i,2),'k.')
end
for i=1:200
    %plot(dataA_X(1,i),dataA_X(2,i),'b.')
    switch pre(i,3)
        case 1
        plot(pre(i,1),pre(i,2),'m.')
        case 2
        plot(pre(i,1),pre(i,2),'r.')
        case 3
        plot(pre(i,1),pre(i,2),'b.')
        case 4
        plot(pre(i,1),pre(i,2),'g.')
    end
   
end
title('kmeans')
hold off;

pred = (dataB_X)';
[mean,p_for_GMM]=em((dataB_X)',k);


    [max,idx] =  max(p_for_GMM,[],2 );
    pred(:,3)=idx;


figure;
hold on;
for i=1:k
    plot(mean(i,1),mean(i,2),'k.')
end
for i=1:200
    switch pred(i,3)
        case 1
        plot(pred(i,1),pred(i,2),'m.')
        case 2
        plot(pred(i,1),pred(i,2),'r.')
        case 3
        plot(pred(i,1),pred(i,2),'b.')
        case 4
        plot(pred(i,1),pred(i,2),'g.')
    end
   
end
title('em')
hold off;

[clustCent,data2cluster]=meanShift((dataA_X)',3.2);
 F= (dataA_X)';
 F(:,3)=(data2cluster)';
figure;
hold on;
for i=1:k
    plot(clustCent(1,i),clustCent(2,i),'k.')
end
for i=1:200
    switch F(i,3)
        case 1
        plot(F(i,1),F(i,2),'m.')
        case 2
        plot(F(i,1),F(i,2),'r.')
        case 3
        plot(F(i,1),F(i,2),'b.')
        case 4
        plot(F(i,1),F(i,2),'g.')
    end
   
end
title('meanshift')
hold off;