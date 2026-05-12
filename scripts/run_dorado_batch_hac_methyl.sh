#!/bin/bash
set -e

POD5_DIR="/Volumes/Amishi_SSD/bio_data/6Feb/pod5_files"

OUTPUT_DIR="dorado_hac_methylation"

REFERENCE="/Volumes/Amishi_SSD/bio_data/6Feb/dorado_outputs_corrupted_now/reference.fasta"

DORADO="/Volumes/Amishi_SSD/bio_data/6Feb/dorado-1.3.1-osx-arm64/bin/dorado"

# Basecalling model
BASE_MODEL="dna_r10.4.1_e8.2_400bps_hac@v5.2.0"

# Methylation model
METHYL_MODEL="dna_r10.4.1_e8.2_400bps_hac@v5.2.0_5mCG_5hmCG@v3"

mkdir -p "$OUTPUT_DIR"

for pod5 in "$POD5_DIR"/*.pod5; do

    [ -e "$pod5" ] || continue

    name=$(basename "$pod5" .pod5)

    echo "Processing: $name"

    "$DORADO" basecaller \
        "$BASE_MODEL" \
        "$pod5" \
        --reference "$REFERENCE" \
        --modified-bases-models "$METHYL_MODEL" \
        --min-qscore 9 \
        --device metal \
        --emit-moves \
    | samtools sort -o "$OUTPUT_DIR/${name}_methylation.bam"

    # Index BAM
    samtools index "$OUTPUT_DIR/${name}_methylation.bam"

    # Check methylation tags
    MM_CHECK=$(samtools view "$OUTPUT_DIR/${name}_methylation.bam" | head -5 | grep -c "MM:Z:" || true)

    if [ "$MM_CHECK" -gt 0 ]; then
        echo "✓ Methylation tags confirmed for $name"
    else
        echo "WARNING: MM/ML tags not found for $name"
    fi

    echo "✓ Finished: $name"

done

echo "All files processed."