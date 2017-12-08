clear;
% read the image and view it
img = imread('images/117054.jpg');
k=4;
h=1;
% extract features (stepsize = 7)
[X, L] = getfeatures(img, 7);
% XX = [X(1:2,:) ; X(3:4,:)/10];
% downscale the coordinate features (see part (b))
% run kmeans -- this is the MATLAB version. You have to write your own!
XX = X(1:2,:);
[center, DAL,movement,predict] = kmeans(XX', k);
% make a segmentation image from the labels
segm = labels2segm(DAL(:,3), L);
figure;
subplot(1,3,1); imagesc(img); axis image;
subplot(1,3,2); imagesc(segm); axis image;
% color the segmentation image
csegm = colorsegm(segm, img);
subplot(1,3,3); imagesc(csegm); axis image

[Miu,Px] = em(XX', k);
 [max,idx] =  max(Px,[],2 );
pred(:,1)=idx;
% make a segmentation image from the labels
segm = labels2segm(pred(:,1), L);
figure;
subplot(1,3,1); imagesc(img); axis image;
subplot(1,3,2); imagesc(segm); axis image;
% color the segmentation image
csegm = colorsegm(segm, img);
subplot(1,3,3); imagesc(csegm); axis image

[clustCent,data2cluster] = meanShift(XX', h);
 F(:,1)=(data2cluster)';
% make a segmentation image from the labels
segm = labels2segm(F(:,1), L);
figure;
subplot(1,3,1); imagesc(img); axis image;
subplot(1,3,2); imagesc(segm); axis image;
% color the segmentation image
csegm = colorsegm(segm, img);
subplot(1,3,3); imagesc(csegm); axis image