function [Test Train] = StratifiedRandom (label, m, n)
% [Test Train] = StratifiedRandom (label, m, n)
% Create a Train and Test split using stratified random sampling.
% INPUT:
%   label    = label matrix
%   m,n         : use m out of n partitions for training model and rest
%                 for testing
% OUTPUT:
%   Test  = Indices of test pattern
%   Train = Indices of train pattern
%
% Author: Sharad Nandanwar
    

	partition = {};

	nCount = size(label,1);
	nLabel = size(label,2);

	Ci = sum(label,1);
	Cj = [];
	Cij = [];
	for j = 1:n
		partition{j}.index = [];
		Cj(j,1) = ceil(nCount*j/n) - ceil(nCount*(j-1)/n);
		Cij(j,:) = ceil(Ci*j/n) - ceil(Ci*(j-1)/n); 
	end

	seen = [];

	while (length(seen) < nCount)

		MIN = min(Ci);
		selectedLabel = find(Ci==MIN);
		if(length(selectedLabel) > 1)
			selectedLabel = selectedLabel(randi(length(selectedLabel), 1));
		end
	
		for j = setdiff(find(label(:,selectedLabel)), seen)'

			MAX = max(Cij(:,selectedLabel));
			selectedPartition = find(Cij(:,selectedLabel) == MAX);
			if(length(selectedPartition) > 1)
				MAX1 = max(Cj.*(Cij(:,selectedLabel) == MAX));
				selectedPartition = find(Cj.*(Cij(:,selectedLabel) == MAX) == MAX1);
				if(length(selectedPartition)>1)
					selectedPartition = selectedPartition(randi(length(selectedPartition), 1));
				end
			end

			partition{selectedPartition}.index = [partition{selectedPartition}.index ; j];

			Ci(find(label(j,:))) = Ci(find(label(j,:))) - 1;
			Cij(selectedPartition, find(label(j,:))) = Cij(selectedPartition, find(label(j,:))) - 1;
			Cj(selectedPartition) = Cj(selectedPartition) - 1;
		
			seen = [seen j];
		end
		Ci(selectedLabel) = inf;
	end

	Train=[];
	for i=1:m
		Train = [Train; partition{i}.index];
	end

	Test=[];
	for i=m+1:n
		Test = [Test; partition{i}.index];
	end

end
