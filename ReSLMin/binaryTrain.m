function [model] = binaryTrain(graph, Y, R, options )
% [model] = binaryTrain(graph, Y, R, options)
% Learn a model for binary classification using
% Regularized Structural Loss Min. approach
% INPUT:
%   graph   = data instances to learn from
%   Y       = Label vector (tr x 1) for nodes with containing 1
%             if node belongs to class, -1 if it does not
%	R       = relaxed labels for nodes
%   options = Structure containing parameters
% OUTPUT:
%   model   = Learned model for classificaiton
%
% Author: Sharad Nandanwar

lamda = options.lamda;
k = options.k;
maxIter = options.maxIter;

N = size(graph,1);
Train = find(abs(Y)>0);
NTr = length(Train);

if(size(Y,1)~=N)
    disp('Error: Number of elements in X and Y must same\nSee pegasos usage for further help');
    return;
end

weight = zeros(size(Y));

wpos = options.wpos;
if(wpos==-1)
	wpos = (sum(Y==-1)/sum(Y==1));
end
wneg = 1;

w = rand(size(graph,2),1);
b = 0;

Tolerance=1e-6;

for t = 1:maxIter
    if(mod(t,500) == 0)
        disp(['iteration # ',num2str(t), '/', num2str(maxIter)]);
    end
    
    w_old = w;
    pred = graph*w + b - eps;
    err = [1-pred 1+pred]';
    err(err<0) = 0;
    err(err>0) = 1;
    X = R.*err;
    empLossWt = wpos*X(1,:) - wneg*X(2,:);

    idx = randperm(N,k);
    etat = (1-t/maxIter);
    w = (1 - etat*lamda)*w + (etat/NTr)*(k/N)*graph(idx,:)'*empLossWt(idx)';
    b = b + (etat/NTr)*(k/N)*sum(empLossWt(idx));
end

if(t<maxIter)
    disp(['weight vector converged in ',num2str(t),' iterations.']);
else
    disp(['weight vector not converged in ',num2str(maxIter),' iterations.']);
end

pred = graph*w;
pred = pred + b;
Tr = sum(sign(pred(Train))==Y(Train));
F = NTr - Tr;
TrainAccuracy = full(100*Tr/(Tr+F));

disp(['Pegasos Accuracy on Training set = ',num2str(TrainAccuracy),'%']);

model = {};
model.w = w;
model.b = b;

end

