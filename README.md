# Centromere_synteny_project walksthrough
# How to identify genome-wide synteny with LASTZ alignment

This is the walkstrough how to identifiy genome-wide synteny markers based on LASTZ alignment.
I used it to identify the syntenic markers for O. saiva (rice) and O. brachyantha, they diverged each other 15 million years ago. 


Step1：Mask the repeat sequences for both genomes and chromosomes.

RepeatMasker -pa 40 -nolow -norna -gff -xmall -lib custom.TE.lib_for_rice.fa AAChr1.txt
RepeatMasker -pa 40 -nolow -norna -gff -xmall -lib custom.TE.lib_for_FF.fa FFChr1.txt

Step2: Alignment using LASTZ

lastz AAChr1.txt FFChr1.txt K=2200 L=6000 Y=3400 E=30 H=0 O=400 T=1 --format=axt --out=chr01.axt

axtChain -linearGap=medium chr01.axt AAChr1.txt FFChr1.txt chr01.axt.chain
