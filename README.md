# Dorado HAC Basecalling and Methylation Calling Pipeline

Pipeline for Oxford Nanopore HAC basecalling, move table generation, and direct methylation calling using Dorado modified-base models.

---

# Overview

This workflow processes Oxford Nanopore `.pod5` raw signal files using Dorado HAC models to generate:

* HAC basecalled aligned BAM files
* Move-table enabled BAM files
* Direct methylation calls (5mC and 5hmC)
* Sorted and indexed BAM outputs suitable for downstream methylation analysis

The workflow consists of two sequential scripts:

| Step | Script                           | Purpose                                            |
| ---- | -------------------------------- | -------------------------------------------------- |
| 1    | `run_dorado_batch_hac_bases.sh`  | HAC basecalling + move table generation            |
| 2    | `run_dorado_batch_hac_methyl.sh` | HAC methylation calling using modified-base models |

`run_dorado_batch_hac_bases.sh` generates move-table enabled BAM outputs suitable for downstream methylation-only workflows, while `run_dorado_batch_hac_methyl.sh` performs direct HAC methylation calling using Dorado modified-base models.---

# Repository Structure

```text
dorado-hac-methylation-pipeline/
│
├── README.md
│
├── scripts/
│   ├── run_dorado_batch_hac_bases.sh
│   └── run_dorado_batch_hac_methyl.sh
│
├── reference.fasta
│
├── reference.fasta.fai
│
└── .gitignore
```

---

# Required Input Files

The workflow requires:

* `.pod5` files
* Reference FASTA
* FASTA index (`.fai`)

Example:

```text
project/
├── pod5_files/
│   ├── sample1.pod5
│   └── sample2.pod5
├── reference.fasta
├── reference.fasta.fai
```

---

# Dorado Models Used

## HAC Basecalling Model

```text
dna_r10.4.1_e8.2_400bps_hac@v5.2.0
```

---

## Methylation Calling Model

```text
dna_r10.4.1_e8.2_400bps_hac@v5.2.0_5mCG_5hmCG@v3
```

---

# Workflow

## Step 1 — HAC Basecalling and Move Table Generation

Edit the following variables inside:

```text
run_dorado_batch_hac_bases.sh
```

Set:

```bash
POD5_DIR=
OUTPUT_DIR=
REFERENCE=
DORADO=
```

Run:

```bash
chmod +x scripts/run_dorado_batch_hac_bases.sh

bash scripts/run_dorado_batch_hac_bases.sh
```

Expected outputs:

```text
dorado_hac_only_base_movefiles/
├── sample_sorted.bam
└── sample_sorted.bam.bai
```

---

## Step 2 — HAC Methylation Calling

Edit the following variables inside:

```text
run_dorado_batch_hac_methyl.sh
```

Set:

```bash
POD5_DIR=
OUTPUT_DIR=
REFERENCE=
DORADO=
```

Run:

```bash
chmod +x scripts/run_dorado_batch_hac_methyl.sh

bash scripts/run_dorado_batch_hac_methyl.sh
```

Expected outputs:

```text
dorado_hac_methylation/
├── sample_methylation.bam
└── sample_methylation.bam.bai
```

---

# Verifying Methylation Tags

Inspect BAM contents:

```bash
samtools view sample_methylation.bam | head
```

Successful methylation calling produces tags such as:

```text
MM:Z:
ML:B:C
```

---

# Verifying Outputs

List BAM files:

```bash
ls -lh dorado_hac_only_base_movefiles/

ls -lh dorado_hac_methylation/
```

Check BAM statistics:

```bash
samtools flagstat sample_methylation.bam
```

Count reads:

```bash
samtools view -c sample_methylation.bam
```

---

# Documentation

Detailed documentation is available in:

```text
docs/Dorado_HAC_Methylation_Pipeline_Documentation.md
```



