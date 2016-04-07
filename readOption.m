function [options] = readOption(fn)
% [options] = readOption( fn )
% Read options from given input file.
% INPUT:
%   fn    = url of file containing options
% OUTPUT:
%   options = structure containing required parameters
%             containing {maxIter, wpos, k, lamda}
%
% Author: Sharad Nandanwar
    

	options = {};
	options.maxIter = 2000;
	options.wpos = -1;
	options.k = 10000;
	options.lamda = 2^-6;
	
	data = importdata(fn);
	for i=1:size(data.data,1)
		fieldName = char(data.rowheaders(i));
		switch fieldName
		  case 'log2lamda'
			  options.lamda = 2^data.data(i);
		  case 'maxIter'
			  options.maxIter = data.data(i);
		  case 'wPos'
			  options.wpos = data.data(i);
		  case 'batchSize'
			  options.k = data.data(i);
		  otherwise
			  disp('Error reading options from file') 
		end
	end
end
