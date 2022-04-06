# Post-process the Data
In this directory, we provide the code for post-processing the data, which can help reader to efficiently extract regularization data or hard samples.

Before running the command, one should redirect to the current directory:
```
cd ./CSA-Grammatical-Error-Correction/utils
```


## extract same data
One can extract the same data from two parallel datasets by running the `intersection.py` code with the following command:
```
python intersection.py src_file1 trg_file1 src_file2 trg_file2 save_src save_trg 
``` 

## extract hard data
One can extract the hard data from two parallel datasets by running the `extract_hard_data.py` code with the following command:
```
python extract_hard_data.py src_file1 trg_file1 src_file2 trg_file2 save_src save_trg 
``` 
`NOTICE`: the `file1` must be the outputs by model and `file2` must be the original parallel datasets .

## extract different data
One can extract the different data from two parallel datasets by running the `A_sub_B.py` code with the following command:
```
python A_sub_B.py src_file1 trg_file1 src_file2 trg_file2 save_src save_trg 
```
`NOTICE`: the `file1` must be the outputs by model and `file2` must be the original parallel datasets .

Otherwise, if one want compare the source and target from parallel data to extract the different pairs, `simpleDiffer.py` is a better choice.
```
python simpleDiffer.py src_file trg_file save_src save_trg
```