# Note to self: the LOB parsed corpora didn't handle parantheses correctly and included the raw parentheses in there as terminal nodes. They had to be sedded out as -LRB- / -RRB-
# There's still an extra right paranthesis hiding out in LOB-J somewhere...

PPCME2= /home/gunnar/Projects/corpora/PPCME2-lemmatized
PPCEME= /home/gunnar/Projects/corpora/PPCHE/PPCHE/PENN-CORPORA/PPCEME-RELEASE-3
PPCMBE= /home/gunnar/Projects/corpora/PPCHE/PPCHE/PENN-CORPORA/PPCMBE2-RELEASE-1

LOB=/home/gunnar/Projects/corpora/LOB-PTB
FLOB=/home/gunnar/Projects/corpora/FLOB-PTB
CLOB=/home/gunnar/Projects/corpora/CLOB-PTB
TOBE= be|is|was|were|are|'m|'re|m|re|am|s|'s|been#this is a pain...
LOB_PAT = (/^.*$$/=vbg [!< /^.*$$/ & > (VBG >+(VP) (VP $$ (/VB./=bep < /($(TOBE))/=bef)))])
#LOB_PAT = (/^.*$$/=vbg [!< /^.*$$/ & > (VBG >+(VP) (VP $$ /VB./=bep))])

TREGEX= /home/gunnar/Documents/corpus-tools/stanford-tregex-4.0.0/stanford-tregex.jar
TOUT= tregex/

tregfiles-ppche= ppcme2-prog.txt ppceme-prog.txt ppcmbe-prog.txt
tregfiles-lob= lob-prog.txt flob-prog.txt clob-prog.txt
tregnames-ppche= $(addprefix $(TOUT),$(tregfiles-ppche))
tregnames-lob= $(addprefix $(TOUT),$(tregfiles-lob))

all: csv-ppche csv-lob

csv-ppche: $(tregnames-ppche)
	python3 makecsv.py $^

csv-lob: $(tregnames-lob)
	python3 makecsv-lob.py $^

$(TOUT)ppcme2-prog.txt: raw $(PPCME2)
	java -cp $(TREGEX) edu.stanford.nlp.trees.tregex.TregexPattern -s -f -h "vag" -h "be" -e "psd" "(/^.*$$/=vag [!< /^.*$$/ & >+(VAG) (VAG $$ /BE./=be)])" $(PPCME2) > $@

$(TOUT)ppceme-prog.txt: raw $(PPCEME)
	java -cp $(TREGEX) edu.stanford.nlp.trees.tregex.TregexPattern -s -f -h "vag" -h "be" -e "psd" "(/^.*$$/=vag [!< /^.*$$/ & >+(VAG) (VAG $$ /BE./=be)])" $(PPCEME) > $@

$(TOUT)ppcmbe-prog.txt: raw $(PPCMBE)
	java -cp $(TREGEX) edu.stanford.nlp.trees.tregex.TregexPattern -s -f -h "vag" -h "be" -e "psd" "(/^.*$$/=vag [!< /^.*$$/ & >+(VAG) (VAG $$ /BE./=be)])" $(PPCMBE) > $@

$(TOUT)lob-prog.txt: raw $(LOBF)
	java -cp $(TREGEX) edu.stanford.nlp.trees.tregex.TregexPattern -s -f -h "vbg" -h "bep" -h "bef" -e "stp" "$(LOB_PAT)" $(LOB) > $@

$(TOUT)flob-prog.txt: raw $(FLOB)
	java -cp $(TREGEX) edu.stanford.nlp.trees.tregex.TregexPattern -s -f -h "vbg" -h "bep" -h "bef" -e "stp" "$(LOB_PAT)" $(FLOB) > $@

$(TOUT)clob-prog.txt: raw $(CLOB)
	java -cp $(TREGEX) edu.stanford.nlp.trees.tregex.TregexPattern -s -f -h "vbg" -h "bep" -h "bef" -e "stp" "$(LOB_PAT)" $(CLOB) > $@

# %.txt: $(LOB)/%.TXT.stp
# 	java -cp $(TREGEX) edu.stanford.nlp.trees.tregex.TregexPattern -s -f -h "vbg" -h "bep" -h "bef" -e "stp" "$(LOB_PAT)" $^ > $@

raw:
	mkdir -p $(TOUT)

clean:
	rm -f *.csv raw/*
