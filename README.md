# Community-Workshops
ECL course material for community workshops

# Client installation pre-requisites
1. Download and install the latest ECL IDE version availble from https://hpccsystems.com/download#HPCC-Platform. For detailed information on how to setup the ECL IDE, please watch this instructional video: https://www.youtube.com/watch?v=TT7rCcyWTAo
2. Download and install the latest git version available from https://git-scm.com/downloads
3. Install the required Machine Learning bundles using the ecl command line interface with administrator rights from your clienttools/bin folder:

```
ecl bundle install https://github.com/hpcc-systems/ML_Core.git
ecl bundle install https://github.com/hpcc-systems/PBblas.git
ecl bundle install https://github.com/hpcc-systems/KMeans.git
ecl bundle install https://github.com/hpcc-systems/dbscan.git
ecl bundle install https://github.com/hpcc-systems/LinearRegression.git
ecl bundle install https://github.com/hpcc-systems/LogisticRegression.git
ecl bundle install https://github.com/hpcc-systems/GNN.git
ecl bundle install https://github.com/hpcc-systems/LearningTrees.git
```
**Note I**:  Alternatively, you can try the code examples directly by using GitPod: https://gitpod.io/#https://github.com/hpcc-systems/Community-Workshops

**Sample dataset´s can be downloaded from the following locations**

Hour1: http://geosampa.prefeitura.sp.gov.br/PaginasPublicas/_SBC.aspx (Clustering)

Hour2: https://learn.lexisnexis.com/Activity/1102#  (Linear Regression)

Hour2: https://archive.ics.uci.edu/ml/datasets/bank+marketing  (Logistic Regression)

Hour3: https://learn.lexisnexis.com/Activity/2553# (GNN)

Hour3: https://learn.lexisnexis.com/Activity/1102#  (Linear Regression)

**Note II**:  These dataset´s are already sprayed and available in the training cluster utilized during the workshops and are listed here only for future reference.
