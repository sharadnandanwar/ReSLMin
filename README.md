<h3>ReSLMin: Regularized Structural Loss Minimization for within network classification</h3>

<h5>Usage:</h5>
<tt>[hammingScore microF1 macroF1] = ReSLMin_Run ( dataFile, optionsFile, m, n)</tt><br/>
Run and Evaluate performance of ReSLMin.

<h6>INPUT:</h6>
<tt> &nbsp; &nbsp; &nbsp;dataFile &nbsp; &nbsp; = &nbsp;url of .mat file</tt><br/>
<tt> &nbsp; &nbsp; &nbsp;optionsFile &nbsp; = &nbsp;url of file containing options</tt><br/>
<tt> &nbsp; &nbsp; &nbsp;m, n &nbsp; &nbsp; &nbsp; : &nbsp;use m out of n partitions for training model and rest for testing</tt><br/>

<h6>OUTPUT:</h6>
<tt> &nbsp; &nbsp; &nbsp;hammingScore = Hamming Score</tt><br/>
<tt> &nbsp; &nbsp; &nbsp;microF1 &nbsp; &nbsp; &nbsp;= Micro-F1 Score</tt><br/>
<tt> &nbsp; &nbsp; &nbsp;macroF1 &nbsp; &nbsp; &nbsp;= Macro-F1 Score</tt><br/>

<h6>Example:</h6>
<tt> [hs mic mac] = ReSLMin_Run('Datasets/cora.mat', 'Datasets/cora.options', 1, 10)</tt>

<h6><bold><tt>Author: Sharad Nandanwar</tt></bold></h6>
