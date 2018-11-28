# Centromere_synteny_project walksthrough 123
# How to identify genome-wide synteny with LASTZ alignment

This is the walkstrough how to identifiy genome-wide synteny markers based on LASTZ alignment.
I used it to identify the syntenic markers for O. saiva (rice) and O. brachyantha, they diverged each other 15 million years ago. 


Step1：Mask the repeat sequences for both genomes and chromosomes.

RepeatMasker -pa 40 -nolow -norna -gff -xmall -lib custom.TE.lib_for_rice.fa AAChr1.txt
RepeatMasker -pa 40 -nolow -norna -gff -xmall -lib custom.TE.lib_for_FF.fa FFChr1.txt


Step2: Alignment using LASTZ and Chain/Net

lastz AAChr1.txt FFChr1.txt K=2200 L=6000 Y=3400 E=30 H=0 O=400 T=1 --format=axt --out=chr01.axt
axtChain -linearGap=medium chr01.axt AAChr1.txt FFChr1.txt chr01.axt.chain
chainPreNet chr01.axt.chain AAChr1.txt.sizes FFChr1.txt.sizes chr01.chain.filter
chainNet chr01.chain.filter -minSpace=1 AAChr1.txt.sizes FFChr1.txt.sizes chr1.chain.filter.tnet chr1.chain.filter.qnet
netSyntenic chr1.chain.filter.tnet chr1.chain.filter.tnet.synnet
netToAxt chr1.chain.filter.tnet.synnet chr1.chain.filter.tnet.synnet chr01.chain.filter AAChr1.txt FFChr1.txt chr1.chain.filter.tnet.synnet.axt
axtSort chr1.chain.filter.tnet.synnet.axt chr1.chain.filter.tnet.synnet.Sort.axt
axtToMaf chr1.chain.filter.tnet.synnet.axt AAChr1.txt.sizes FFChr1.txt.sizes -tPrefix=target. -qPrefix=query. chr1.chain.filter.tnet.synnet.axt.maf


Step 3: Get syntenic markers 

perl Maf2rawsynteny.pl chr1.chain.filter.tnet.synnet.axt.maf target.AAChr1 query.FFChr1
perl Get_synteny.pl -i chr1.chain.filter.tnet.synnet.axt.maf -n 0 -m 3 -t target.AAChr1 -q query.FFChr1 -o syn.final.out
