function [pred] = binaryPredict(data, model)
% [pred] = binaryPredict(data, model)
% Performs prediction using supplied model for binary
% classification problem obtained using ReSLMin.
% INPUT:
%   data    = data instance matrix with each row corresponding
%             to an instance
%   model   = model learned
% OUTPUT:
%   pred    = predicted decision values for all nodes
%
% Author: Sharad Nandanwar

    w = model.w;
    b = model.b;

    pred = data*w + b;

end
