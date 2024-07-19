# --coding:utf-8--
# @Time : 2022/9/12 9:53
# @File : Predict.py
# @Software: PyCharm
import os
import re
import numpy as np
import pandas as pd
from DeepPurpose import DTI as models
from DeepPurpose import utils, dataset
from DeepPurpose.dataset import *





effective_target = pd.read_csv("./R_DATA/target.csv",index_col=0)
target_seq = pd.read_csv("./DeepPurpose/data/human_seq_all.csv",index_col=0)
col_index = [r for r in list(effective_target) if re.search("Target.name",r)]
effective_target = effective_target[col_index]
effective_target = effective_target.dropna()
effective_target = effective_target.drop_duplicates()
effective_target = effective_target.loc[:,col_index]
drug = py_data
drug = drug.iloc[:, 0]
drug = drug.dropna()
drug = list(drug)

t_index = []
for col in list(effective_target):
    m_t = effective_target[col]
    t_i = []
    for i in list(target_seq["Gene.names"]):
        b = i in list(m_t)
        t_i.append(b)
    t_index.append(t_i)

path = 'DrugBank_CNN_model'
net = models.model_pretrained(path_dir = path)
drug_encoding, target_encoding = 'CNN', 'CNN'

y_predict_result = pd.DataFrame()
for index in t_index:
    target_seq_1 = target_seq[index]
    #target_seq_1 = target_seq_1.drop_duplicates(subset="Gene.names",keep='first')
    target_seq_1.columns = ["target", "seq"]
    seq = target_seq_1['seq']
    tar = target_seq_1["target"]

    tar_1 = [tar]*len(drug)
    tar_1 = np.array(tar_1)
    tar_1 = tar_1.ravel(order = "F")

    t1 = [seq] * len(drug)
    t1 = np.array(t1)
    t1 = t1.ravel(order='F')
    d1 = list(drug) * len(seq)
    y = [-1] * len(d1)

    X_pred_1 = utils.data_process(d1, t1, y,
                                  drug_encoding, target_encoding,
                                  split_method='no_split')

    y_pred = net.predict(X_pred_1)
    y_preed_1 = pd.DataFrame(zip(y_pred,d1,tar_1), columns=['Binding_score',"SMILES","target_names"])
    #y_screen = y_preed_1[y_preed_1['pvalue'] >= 0.5]
    y_screen = y_preed_1.sort_values(by="Binding_score", ascending=False)
    y_predict_result = pd.concat([y_predict_result,y_screen],axis=1)



