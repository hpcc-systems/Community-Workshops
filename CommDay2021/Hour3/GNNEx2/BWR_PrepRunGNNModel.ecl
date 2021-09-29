#OPTION('OutputLimit',100)
IMPORT $;
IMPORT ML_Core;
IMPORT Python3 AS Python;
IMPORT $.^ AS GNN;
IMPORT GNN.Tensor;
IMPORT GNN.GNNI;
IMPORT GNN.Internal AS int;
IMPORT GNN.Internal.Types AS iTypes;
IMPORT GNN.Utils;
IMPORT GNN.Types;
IMPORT Std.System.Thorlib;

t_Tensor     := Tensor.R4.t_Tensor;
TensData     := Tensor.R4.TensData;
FuncLayerDef := Types.FuncLayerDef;

//View raw data coming in:
// Sentence/Weights is directly related - slice evenly when testing!

SentTrain := $.File_Sentence.File; //159571 Sentences each with 100 possible words, padded with leading zeros
W8Train   := $.File_Weights.File;  //Marks whether sentences are toxic or not. 7 classes, reduce to binary (toxic or not)
Words     := $.File_Word.File; //20000 record DCT with numeric word vectors
// OUTPUT(COUNT(Sentence),NAMED('SentCount'));
// OUTPUT(COUNT(Words),NAMED('WordCnt'));


// Start by sequencing sentence and word:
// The word vector in the sentence dataset relates directly to 
// the record number in the word dataset 
ML_Core.AppendSeqId(SentTrain, id, seqSentTrain); //Add a sequential ID
ML_Core.AppendSeqId(W8Train, id, seqW8Train);     //Add a sequential ID
ML_Core.AppendSeqId(Words, id, seqWord);

// OUTPUT(seqSent,NAMED('SentSeq'));
// OUTPUT(seqWord,NAMED('WordSeq'));


//***PROJECT NOTES***//
/* 
Input to MakeTensor: Tensor.R4.TensData(Indexes and Value) 

Need Indexes that looks like this:
**[sentence.recid, WordNum, VectorNum]**;

Value in TensData is the actual vector value 
in the Word Dataset (20000 records X 100 vectors per word)
   
Each sentence record has 100 possible words
Each word has 100 vectors
   
Tensor Shape (Make Tensors): [0, SentenceNum(1..n), WordNum(1-100), VectorNum(1-100)]
Sent = Full COUNT of Sentence dataset (159571)

Words = 100 (fixed/padded for each sentence)
Vectors = 100 (fixed for each word)
*/

//To get actual word vector, convert sentence data to a SET, and then
//it should be easier to index into the set:
seqSetSentRec := RECORD
 UNSIGNED8 id;
 SET OF REAL4 WordSet;
END;

seqSetWordRec := RECORD
 UNSIGNED8 id;
 SET OF REAL4 VecSet;
END;

seqSetSentRec SetSentXfrm(seqSentTrain Le) := TRANSFORM
SELF.ID := Le.ID;
SELF.WordSet := [Le.W1,Le.W2,Le.W3,Le.W4,LE.W5,Le.W6,Le.W7,Le.W8,Le.W9,Le.W10,
                 Le.W11,Le.W12,Le.W13,Le.W14,LE.W15,Le.W16,Le.W17,Le.W18,Le.W19,Le.W20,
                 Le.W21,Le.W22,Le.W23,Le.W24,LE.W25,Le.W26,Le.W27,Le.W28,Le.W29,Le.W30,
                 Le.W31,Le.W32,Le.W33,Le.W34,LE.W35,Le.W36,Le.W37,Le.W38,Le.W39,Le.W40,
                 Le.W41,Le.W42,Le.W43,Le.W44,LE.W45,Le.W46,Le.W47,Le.W48,Le.W49,Le.W50,
                 Le.W51,Le.W52,Le.W53,Le.W54,LE.W55,Le.W56,Le.W57,Le.W58,Le.W59,Le.W60,
                 Le.W61,Le.W62,Le.W63,Le.W64,LE.W65,Le.W66,Le.W67,Le.W68,Le.W69,Le.W70,
                 Le.W71,Le.W72,Le.W73,Le.W74,LE.W75,Le.W76,Le.W77,Le.W78,Le.W79,Le.W80,
                 Le.W81,Le.W82,Le.W83,Le.W84,LE.W85,Le.W86,Le.W87,Le.W88,Le.W89,Le.W90,								 
                 Le.W91,Le.W92,Le.W93,Le.W94,LE.W95,Le.W96,Le.W97,Le.W98,Le.W99,Le.W100];
END; 


seqSetWordRec SetWordXfrm(SeqWord LE) := TRANSFORM
SELF.ID := Le.ID;
SELF.VecSet := [Le.V1,Le.V2,Le.V3,Le.V4,LE.V5,Le.V6,Le.V7,Le.V8,Le.V9,Le.V10,
                 Le.V11,Le.V12,Le.V13,Le.V14,LE.V15,Le.V16,Le.V17,Le.V18,Le.V19,Le.V20,
                 Le.V21,Le.V22,Le.V23,Le.V24,LE.V25,Le.V26,Le.V27,Le.V28,Le.V29,Le.V30,
                 Le.V31,Le.V32,Le.V33,Le.V34,LE.V35,Le.V36,Le.V37,Le.V38,Le.V39,Le.V40,
                 Le.V41,Le.V42,Le.V43,Le.V44,LE.V45,Le.V46,Le.V47,Le.V48,Le.V49,Le.V50,
                 Le.V51,Le.V52,Le.V53,Le.V54,LE.V55,Le.V56,Le.V57,Le.V58,Le.V59,Le.V60,
                 Le.V61,Le.V62,Le.V63,Le.V64,LE.V65,Le.V66,Le.V67,Le.V68,Le.V69,Le.V70,
                 Le.V71,Le.V72,Le.V73,Le.V74,LE.V75,Le.V76,Le.V77,Le.V78,Le.V79,Le.V80,
                 Le.V81,Le.V82,Le.V83,Le.V84,LE.V85,Le.V86,Le.V87,Le.V88,Le.V89,Le.V90,								 
                 Le.V91,Le.V92,Le.V93,Le.V94,LE.V95,Le.V96,Le.V97,Le.V98,Le.V99,Le.V100];
END; 
//Begin processing Independent Variables here (Train)
// ******************Set Number of Training Records Here***************
// Syncronize number with Weights-Line 191
seqSetSent := PROJECT(seqSentTrain[1..10000],SetSentXfrm(LEFT)); //from ML_Core.AppendSeqId 

OUTPUT(COUNT(seqSetSent),NAMED('TrainIn'));

seqSetWord := PROJECT(seqWord,SetWordXfrm(LEFT));
// OUTPUT(seqSetWord,NAMED('WordIdSet'));

//Next, create a Tensor of shape [0,100,100]: recid,wordNumber,VecNumber
WordCnt  := 100; 
VectorCnt:= 100;
BCount   := WordCnt * VectorCnt;

//independent "X" TRAINING Data

TensData makeTensTrainXDat(seqSetSent Le, INTEGER cnt) := TRANSFORM
  VCnt         := (cnt - 1) % (VectorCnt) + 1;
  WCnt         := ((cnt - 1) DIV VectorCnt) % (VectorCnt) + 1 ;
  SELF.indexes := [Le.id, Le.WordSet[WCnt],WCnt, VCnt];//Le.WordSet[WCnt] only temp to get vector value later
  SELF.value   := cnt;//temp number only - will have to get actual vector value later
END;														 

tensDatX0 := NORMALIZE(seqSetSent, BCount, makeTensTrainXDat(LEFT, COUNTER));
// OUTPUT(tensDatX0,NAMED('StartTensStructure')); //Zeros are normal due to the amount of padding in the first few records

//First, set up null (zero) values:

TensZeroValues := PROJECT(tensDatX0,TRANSFORM(TensData,
                                              SELF.Value := IF(LEFT.Indexes[2]=0,0,LEFT.Value),
                                              SELF := LEFT));
// OUTPUT(TensZeroValues,NAMED('ZeroValSet'));
																							
// Now get the real vector value from the Words dataset
// Need to JOIN TensZeroValues with seqSetWord to get the real value.
// Zero Values get ignored (do not get JOINed below)

TensData ExtractVector(TensData Le,seqSetWord Ri) := TRANSFORM
SELF.Value := Ri.VecSet[Le.indexes[4]]; //VCnt
SELF := Le;
END;

GetVecvalues := JOIN(TensZeroValues,seqSetWord, LEFT.Indexes[2]=RIGHT.ID,
                     ExtractVector(LEFT,RIGHT),LEFT OUTER,LOOKUP);
										 
// OUTPUT(GetVecValues,NAMED('WordVecValues'));

//Finally, restore the word tensor sequencing:
//throw out the second index, no longer needed

RealTens := PROJECT(GetVecValues,TRANSFORM(TensData,
                                           SELF.Indexes := [LEFT.Indexes[1],LEFT.Indexes[3],LEFT.Indexes[4]],
                                           SELF := LEFT)):PERSIST('~GNNEx2::TensData::Persist');
																					 
// OUTPUT(RealTens,NAMED('FinalTensData'));	

																			 
//and make the training tensors

tensTrain := Tensor.R4.MakeTensor([0, 100, 100], RealTens);
// OUTPUT(tensTrain,,'~JEFF::TensTrainData',NAMED('TrainIndTens'));
// OUTPUT(tensTrain,NAMED('Tensors'));

//Now let's do the Y dependent data
//Each Sentence is either toxic or not, so we need to
//create a set of tensors with RecID and a value of 1 or 0 for each sentence record.

//dependent ("Y') Training Data:
// Create a tensor of shape:
// [0, 1] 
// and use Utils.ToOneHot() to change that to a one hot encoded tensor of shape [0, numClasses].  
// That is because for neural networks, class variables need to be converted to [isClass0, isClass1, isClass2, …].
// See Tests ClassificationTest.ecl for an example.

TensData makeTensTrainYDat(seqW8Train W8s, INTEGER cnt) := TRANSFORM
  SELF.indexes := [W8s.id, 1];//first element is RECID
  SELF.value   := IF(W8s.W1='1',1,0);
END;
myYtensTrainData := NORMALIZE(seqW8Train[1..10000], 1, makeTensTrainYDat(LEFT, COUNTER));
OUTPUT(COUNT(myYtensTrainData),NAMED('YTrainIn'));

yTrainHot := Utils.ToOneHot(myYtensTrainData, 2);//2 states is toxic, not toxic
//create Y (dependent) training data HERE:
ytrain := Tensor.R4.MakeTensor([0,2], yTrainHot); //Needs to be from yTrainHot

// OUTPUT(yTrain,NAMED('TrainDepTens'));


//Now let's create a TEST set - same logic as Train, different data input

//y data... First, resequence sample - MUST BE SAME INDEXING AS INDEPENDENT TEST SAMPLE !!!

RenumW8Test := PROJECT(seqW8Train[10001..12500],TRANSFORM(RECORDOF(seqW8Train),
                                                            SELF.ID := COUNTER,
                                                            SELF    := LEFT ));
OUTPUT(COUNT(RenumW8Test),NAMED('TestYIn'));

TensData makeTensTestYDat(RenumW8Test W8s, INTEGER cnt) := TRANSFORM
  SELF.indexes := [W8s.id, 1];//first element is RECID
  SELF.value   := IF(W8s.W1='1',1,0);
END;
myYtensTestData := NORMALIZE(RenumW8Test, 1, makeTensTrainYDat(LEFT, COUNTER));
OUTPUT(myYTensTestData,NAMED('DepTestData'));

yTestHot := Utils.ToOneHot(myYtensTestData, 2);//2 states is toxic, not toxic

yTest := Tensor.R4.MakeTensor([0,2], yTestHot); //Needs to be from yTrainHot
OUTPUT(yTest,NAMED('TrainDepTens'));


//********************************************************************
//Begin processing Independent Variables here (Test)
seqSetSentTest := PROJECT(seqSentTrain[10001..12500],SetSentXfrm(LEFT));
OUTPUT(COUNT(seqSetSentTest),NAMED('TestXIn'));

RenumSentTest := PROJECT(seqSetSentTest,TRANSFORM(RECORDOF(seqSetSentTest),
                                                  SELF.ID := COUNTER,
                                                  SELF    := LEFT ));
//independent "X" TEST Data

TensData makeTensTestXDat(RenumSentTest Le, INTEGER cnt) := TRANSFORM
  VCnt         := (cnt - 1) % (VectorCnt) + 1;
  WCnt         := ((cnt - 1) DIV VectorCnt) % (VectorCnt) + 1 ;
  SELF.indexes := [Le.id, Le.WordSet[WCnt],WCnt, VCnt];//Le.WordSet[WCnt] only temp to get vector value later
  SELF.value   := cnt;//test only - will have to get actual vector value here
END;														 

tensDatX1 := NORMALIZE(RenumSentTest, BCount, makeTensTestXDat(LEFT, COUNTER));
// OUTPUT(tensDatX0,NAMED('StartTensStructure')); //Zeros are normal due to the amount of padding in the first few records

//First, set up null (zero) values:

TensZeroValuesX1 := PROJECT(tensDatX1,TRANSFORM(TensData,
                                                SELF.Value := IF(LEFT.Indexes[2]=0,0,LEFT.Value),
                                                SELF := LEFT));
// Need to JOIN TensZeroValuesX1 with seqSetWord to get the real value.

TensData ExtractTestVector(TensData Le,seqSetWord Ri) := TRANSFORM
SELF.Value := Ri.VecSet[Le.indexes[4]]; //VCnt
SELF := Le;
END;


GetTestVecvalues := JOIN(TensZeroValuesX1,seqSetWord, LEFT.Indexes[2]=RIGHT.ID,
                         ExtractTestVector(LEFT,RIGHT),LEFT OUTER,LOOKUP);
										 
// OUTPUT(GetVecValues,NAMED('WordVecValues'));

//Finally, restore the word tensor sequencing:
//throw out the second index, no longer needed
RealTestTens := PROJECT(GetTestVecValues,
                        TRANSFORM(TensData,
                                  SELF.Indexes := [LEFT.Indexes[1],LEFT.Indexes[3],LEFT.Indexes[4]],
                                  SELF := LEFT)):PERSIST('~GNNEx2::TestData::Persist');
																					 
tensTest := Tensor.R4.MakeTensor([0, 100, 100], RealTestTens);

OUTPUT(tensTest,NAMED('IndTESTTensors'));

// !******************************************************************************
//Ready to call the GNN/RNN model
//Let's test now:

ldef := DATASET([
        {'d1', '''layers.Input(shape=(100,100))''', []},  // Regression Input
        {'d2', '''layers.Bidirectional(layers.LSTM(units=100, return_sequences=True,recurrent_dropout=0.2))''', ['d1']}, // Regression Hidden 1
        {'d3', '''layers.GlobalMaxPooling1D()''', ['d2']},   // Regression Hidden 2
        {'d4', '''layers.Dense(units=100, activation='relu')''', ['d3']}, // Regression Output
        {'d5', '''layers.Dropout(rate=0.2)''', ['d4']}, // Classification Input
        {'output', '''layers.Dense(2, activation="sigmoid")''',['d5']}
      ], // Classification Output
    FuncLayerDef);

compileDef := '''compile(loss='binary_crossentropy',
                  optimizer='adam',
                  metrics=['accuracy'])
								   ''';
                   
s := GNNI.GetSession();

// DefineModel is dependent on the Session
//   ldef contains the Python definition for each Keras layer
//   compileDef contains the Keras compile statement.
mod := GNNI.DefineFuncModel(s, ldef, ['d1'], ['output'], compileDef);

// GetWeights returns the initialized weights that have been synchronized across all nodes.
wts := GNNI.GetWeights(mod);

OUTPUT(wts, NAMED('InitWeights'),ALL);


// Fit trains the models, given training X and Y data.  BatchSize is not the Keras batchSize,
// but defines how many records are processed on each node before synchronizing the weights

mod2 := GNNI.Fit(mod, tensTrain, Ytrain, batchSize := 10, numEpochs := 10, learningRateReduction := 0.3);
OUTPUT(mod2, NAMED('mod2'));

// GetLoss returns the average loss for the final training epoch
losses := GNNI.GetLoss(mod2);

// EvaluateMod computes the loss, as well as any other metrics that were defined in the Keras
// compile line.
OUTPUT(losses,NAMED('AvgLoss'));
// EvaluateMod computes the loss, as well as any other metrics that were defined in the Keras
// compile line.
metrics := GNNI.EvaluateMod(mod2, Tenstest, ytest);

OUTPUT(metrics, NAMED('metrics_5000_2000'));


// Predict computes the neural network output given a set of inputs.
preds := GNNI.Predict(mod2, Tenstest);

// Note that the Tensor is a packed structure of Tensor slices.  GetData()
// extracts the data into a sparse cell-based form -- each record represents
// one Tensor cell.  See Tensor.R4.TensData.
// testYDat := Tensor.R4.GetData(yTest);
// predDat  := Tensor.R4.GetData(preds);

// OUTPUT(SORT(testYDat, indexes), ALL, NAMED('testDat'));
OUTPUT(preds, NAMED('predictions'));
// predDatClass := Utils.Probabilities2Class(predDat);
// OUTPUT(SORT(predDatClass, indexes), ALL, NAMED('predDat'));

																					 