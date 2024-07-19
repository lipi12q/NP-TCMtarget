# --coding:utf-8--
# @Time : 2022/7/18 1:25
# @File : DTI_DB.py
# @Software: PyCharm
from DeepPurpose import DTI as models
from DeepPurpose.utils import *
from DeepPurpose.dataset import *
import pandas as pd
from DeepPurpose import DTI as models
from DeepPurpose.utils import *
from DeepPurpose.dataset import *
import pandas as pd
from DeepPurpose import utils, DTI, dataset
X_drug, X_target, y = dataset.read_file_training_dataset_drug_target_pairs('D:/Py/DeepPurpose-master/toy_data/dti.txt')
drug_encoding, target_encoding = 'CNN', 'CNN'

# Data processing, here we select cold protein split setup.
train, val, test = data_process(X_drug, X_target, y,
                                drug_encoding, target_encoding,
                                split_method='cold_protein',
                                frac=[0.7,0.1,0.2])

# Generate new model using default parameters; also allow model tuning via input parameters.
config = generate_config(drug_encoding, target_encoding, transformer_n_layer_target = 8)
net = models.model_initialize(**config)
net.train(train, val, test)







SAVE_PATH = "D:/Py/DeepPurpose-master/data/db_unique_dt.csv"
bd_data = pd.read_csv(SAVE_PATH, sep = ',', error_bad_lines=False)
X_drug, X_target, y  = process_BindingDB(df=bd_data,
					 y = 'Kd',
					 binary = False,
					 convert_to_log = True)