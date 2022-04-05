import torch
from fairseq.models.bart import BARTModel

import sys
import os

model_dir = sys.argv[1]
input_text = sys.argv[2]
output_dir = sys.argv[3]
databin_dir = sys.argv[4]
output_path = os.path.join(output_dir, "hyp.txt")


bart = BARTModel.from_pretrained(
    model_dir,
    checkpoint_file='checkpoint_best.pt',
    data_name_or_path=databin_dir
)

bart.cuda()
bart.eval()
bart.half()
count = 1
bsz = 64
with open(input_text) as source, open(output_path, 'w') as fout:
    sline = source.readline().strip()
    slines = [sline]
    for sline in source:
        if count % bsz == 0:
            with torch.no_grad():
                hypotheses_batch = bart.sample(slines, beam=1)

            for hypothesis in hypotheses_batch:
                fout.write(hypothesis + '\n')
                fout.flush()
            slines = []

        slines.append(sline.strip())
        count += 1
    if slines != []:
        hypotheses_batch = bart.sample(slines, beam=1)
        for hypothesis in hypotheses_batch:
            fout.write(hypothesis + '\n')
            fout.flush()
print("fin")