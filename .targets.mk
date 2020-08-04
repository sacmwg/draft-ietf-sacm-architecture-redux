TARGETS_DRAFTS := draft-ietf-sacm-arch
TARGETS_TAGS := 
draft-ietf-sacm-arch-00.txt: draft-ietf-sacm-arch.txt
	sed -e 's/draft-ietf-sacm-arch-latest/draft-ietf-sacm-arch-00/g' -e 's/draft-ietf-sacm-arch-latest/draft-ietf-sacm-arch-00/g' -e 's/draft-ietf-sacm-arch-latest/draft-ietf-sacm-arch-00/g' $< >$@
