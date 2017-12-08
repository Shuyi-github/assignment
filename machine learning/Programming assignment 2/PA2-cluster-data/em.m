function  [Miu,Px] = em(X, K_or_centroids)  
    threshold = 0.00001;  
    [N, D] = size(X);  
         K = K_or_centroids;  
        Rn_index = randperm(N);  
        center = X(Rn_index(1:K), :); 
    % initial values  
    [Miu pPi Sigma] = init_params();     
    Lold = -inf; 
      
    % EM Algorithm  
    while true  
        % Estimation Step  
        Px = calculate_prob();  
   
        pGamma = Px .* repmat(pPi, N, 1);  
        pGamma = pGamma ./ repmat(sum(pGamma, 2), 1, K); 
        % Maximization Step          
        Nk = sum(pGamma, 1); 
        % update pMiu  
        Miu = diag(1./Nk) * pGamma' * X; 
        pPi = Nk/N;  
           
        for kk = 1:K   
            Xshift = X-repmat(Miu(kk, :), N, 1);  
            Sigma(:, :, kk) = (Xshift' *(diag(pGamma(:, kk)) * Xshift)) / Nk(kk);  
        end  
   
        % check for convergence  
        L = sum(log(Px*pPi'));  
        if L-Lold < threshold  
            break;  
        end  
        Lold = L;  
    end  
   
    % Function Definition  
      
    function [pMiu pPi pSigma] = init_params()  
        pMiu = center;   
        pPi = zeros(1, K);   
        pSigma = zeros(D, D, K); 
   
        distmat = repmat(sum(X.*X, 2), 1, K) + repmat(sum(pMiu.*pMiu, 2)', N, 1) - 2*X*pMiu';  
        [~, labels] = min(distmat, [], 2);%Return the minimum from each row  
   
        for k=1:K  
            Xk = X(labels == k, :);  
            pPi(k) = size(Xk, 1)/N;  
            pSigma(:, :, k) = cov(Xk);  
        end  
    end  
   
    function Px = calculate_prob()   
        %Gaussian posterior probability   
       Px = zeros(N, K);  
        for k = 1:K  
            Xshift = X-repmat(Miu(k, :), N, 1); 
            inv_pSigma = inv(Sigma(:, :, k));  
            tmp = sum((Xshift*inv_pSigma) .* Xshift, 2);  
            coef = (2*pi)^(-D/2) * sqrt(det(inv_pSigma));  
            Px(:, k) = coef * exp(-0.5*tmp);  
        end  
    end  
end  