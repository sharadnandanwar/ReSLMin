function [hammingScore microF1 macroF1] = ReSLMin_Run ( dataFile, optionsFile, m, n)
% [hammingScore microF1 macroF1] = ReSLMin_Run ( dataFile )
% Run and Evaluate performance of SNBC.
% INPUT:
%   dataFile    = url of .mat file
%   optionsFile = url of file containing options
%   m,n         : use m out of n partitions for training model and rest
%                 for testing
% OUTPUT:
%   hammingScore = Hamming Score
%   microF1      = Micro-F1 Score
%   macroF1      = Macro-F1 Score
%
% e.g. [hs mic mac] = ReSLMin_Run('Datasets/cora.mat', 'Datasets/cora.options', 1, 10)
%
% Author: Sharad Nandanwar
    
    path(strcat(pwd,'/ReSLMin'),path);
    eval(['load ' dataFile]);

    disp('Randomly sampling nodes from graph for training...');
    [Test Train] = StratifiedRandom(label, m, n);
    disp('Sampling over...');

    %% Set options structure, containing parameters for SGD learning
    options = readOption(optionsFile);

    disp('Training model...');
    %% Train
    trainLabel = label;
    trainLabel(Test,:) = 0;
    model = multiTrain(trainLabel, graph, options);
    disp('Training over...');
    disp('Getting predictions for test nodes...');

    %% Predict
    score = multiPredict(graph(Test, :), model);

	%%Evaluation
    testLabel = label(Test,:);
    disp('Evaluating performance...');
    %% Evaluate Performace
    [hammingScore microF1 macroF1] = Evaluate(score, testLabel);

end
