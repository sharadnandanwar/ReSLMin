function [model] = multiTrain(label, X, options)
% [model] = multiTrain(label, X, options)
% Learn a model for multilabel classification using
% Structural Neighborhood based classification approach
% INPUT:
%   label   = Label matrix for nodes with rows
%             corresponding to nodes and columns to classes
%             a value of 1 indicates that node belongs to a
%             class, 0 otherwise. For nodes in test set all
%             entries in corresponding row are 0.
%   X       = Adjacency Matrix of the graph to learn from
%   options = Structure containing parameters
% OUTPUT:
%   model   = Learned model for multilabel classificaiton
%
% Author: Sharad Nandanwar

    model = {};
    model.nClass = size(label,2);
    ovaSVM = {};
    logitParam = {};
    
    N = size(X,1);
    l = size(label,2);
    disp(strcat('Number of Nodes : ', num2str(N)));
    disp(strcat('Number of Classes: ',num2str(l)));
    
    Test = find(sum(label,2)==0);
    Train = find(sum(label,2)>0);
    
	degree = sum(X,2);
	Dinv = spdiags(1./degree,0,N,N);
	count = log2(1+max(hist(degree,1:max(degree)),1)');

	M = X*spdiags(count(degree),0,N,N);
	M = spdiags(1./sum(M,2),0,N,N)*M;

	R = zeros(l,N);
	depth = 100;
	C = label';
	for i=0:1:depth
		R = R + C;
		C = C * (1-i/depth) * M;
	end

    parfor i=1:model.nClass
    	pos = Train(find(label(Train,i)==1));
    	neg = Train(find(label(Train,i)==0));
	    target = label(:,i);
	    target(neg)=-1;
	    
	    propLabels = [];
	    propLabels(1,:) = R(i,:);
	    orl = R;
	    orl(i,:)=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	    

%		For datasets where number of links to target class of node is greater compared
%		to other classes. (Wikipedia and Amazon in our experiments)
	    propLabels(2,:) = sum(orl,1);
	    
%		For datasets like cora and pubmed in our case where collective count of links
%       to other classes may outnumber links to the target class.
%	    propLabels(2,:) = max(orl,[],1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		Normalize to remove effect of degree
		colnorm = sum(propLabels,1);
		invColnorm = 1./colnorm;
		invColnorm(colnorm==0) = 0;
		propLabels = propLabels * spdiags(invColnorm',0,N,N);

%		Clamp original labels for already labeled nodes
	    propLabels(1,find(target==1))=1;
	    propLabels(2,find(target==1))=0;
	    propLabels(2,find(target==-1))=1;
	    propLabels(1,find(target==-1))=0;
	    
	    ovaSVM{i} = binaryTrain(X, full(target), propLabels, options);

	    [decVal] = binaryPredict(X, ovaSVM{i});
	
	    target(target==-1)=0;
	    [logitParam{i}] = glmfit(decVal(Train), full(target(Train)), 'binomial', 'link', 'logit');
    end

    model.ovaSVM = ovaSVM;
    model.logitParam = logitParam;

end
