TARGETS_DRAFTS := draft-ietf-sacm-arch
TARGETS_TAGS := 
draft-ietf-sacm-arch-00.xml: draft-ietf-sacm-arch.xml
	sed -e 's/draft-ietf-sacm-arch-latest/draft-ietf-sacm-arch-00/g' -e 's/draft-ietf-sacm-arch-latest/draft-ietf-sacm-arch-00/g' -e 's/draft-ietf-sacm-arch-latest/draft-ietf-sacm-arch-00/g' -e 's/draft-ietf-sacm-arch-latest/draft-ietf-sacm-arch-00/g' $< >$@
