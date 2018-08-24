TARGETS_DRAFTS := draft-ietf-sacm-architecture
TARGETS_TAGS := 
draft-ietf-sacm-architecture-00.txt: draft-ietf-sacm-architecture.txt
	sed -e 's/draft-ietf-sacm-architecture-latest/draft-ietf-sacm-architecture-00/g' -e 's/draft-ietf-sacm-architecture-latest/draft-ietf-sacm-architecture-00/g' -e 's/draft-ietf-sacm-architecture-latest/draft-ietf-sacm-architecture-00/g' $< >$@
