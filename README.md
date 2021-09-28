# Community-Workshops
ECL course material for community workshops. The training cluster address utilized during the workshop is: http://52.52.151.87:8010/.

# Client installation prerequisites
1. Download and install the latest ECL IDE version available from https://hpccsystems.com/download#HPCC-Platform. For detailed information on how to setup the ECL IDE, please watch this instructional video: https://www.youtube.com/watch?v=TT7rCcyWTAo
2. Download and install the latest git version available from https://git-scm.com/downloads
3. Install the required Machine Learning bundles using the ecl command line interface with administrator rights from your clienttools/bin folder (for further details, please visit: https://hpccsystems.com/download/free-modules/machine-learning-library):

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
**Note I**:  Alternatively, by using your GitHub credentials, you can try the code examples directly via GitPod: https://gitpod.io/#https://github.com/hpcc-systems/Community-Workshops

**Sample datasets can be downloaded from the following locations:**

- Hour1 (Clustering): http://geosampa.prefeitura.sp.gov.br/PaginasPublicas/_SBC.aspx (Cadastro > IPTU > IPTU_2019)

- Hour2 (Linear Regression): https://learn.lexisnexis.com/Activity/1102# (OnlineProperty) 

- Hour2 (Logistic Regression): https://archive.ics.uci.edu/ml/datasets/bank+marketing (bank-additional-full.csv) 

- Hour3 (GNN): https://learn.lexisnexis.com/Activity/2553# (GNNTutorial)

- Hour3 (Gradient Boosted Forest): https://learn.lexisnexis.com/Activity/1102# (OnlineProperty)  

**Note II**:  These datasets are already sprayed and available in the training cluster utilized during the workshops and are listed here only for future reference.
