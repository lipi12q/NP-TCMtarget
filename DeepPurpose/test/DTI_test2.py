# --coding:utf-8--
# @Time : 2022/7/16 12:52
# @File : DTI_test2.py
# @Software: PyCharm
from DeepPurpose import DTI as models
from DeepPurpose.utils import *
from DeepPurpose.dataset import *
import pandas as pd
SAVE_PATH = "D:/Py/DeepPurpose-master/data/BindingDB_PubChem.tsv"
bd_data = pd.read_csv(SAVE_PATH, sep = '\t', error_bad_lines=False)
X_drug, X_target, y  = process_BindingDB(SAVE_PATH,
					 y = 'Kd',
					 binary = False,
					 convert_to_log = True)

# Type in the encoding names for drug/protein.
drug_encoding, target_encoding = 'CNN', 'Transformer'

# Data processing, here we select cold protein split setup.
train, val, test = data_process(X_drug, X_target, y,
                                drug_encoding, target_encoding,
                                split_method='cold_protein',
                                frac=[0.7,0.1,0.2])

# Generate new model using default parameters; also allow model tuning via input parameters.
config = generate_config(drug_encoding, target_encoding, transformer_n_layer_target = 8)
MODEL_PATH_DIR = "D:/Py/DeepPurpose-master/DeepPurpose/test/result"
net = models.model_pretrained(MODEL_PATH_DIR)
X_repurpose, drug_name, drug_cid = load_broad_repurposing_hub(SAVE_PATH)
target, target_name = load_SARS_CoV_Protease_3CL()

_ = models.repurpose(X_repurpose, target, net, drug_name, target_name)

# Virtual screening using the trained model or pre-trained model
X_repurpose, drug_name, target, target_name = ['CCCCCCCOc1cccc(c1)C([O-])=O', ...], ['16007391', ...], ['MLARRKPVLPALTINPTIAEGPSPTSEGASEANLVDLQKKLEEL...', ...], ['P36896', 'P00374']

_ = models.virtual_screening(X_repurpose, target, net, drug_name, target_name)