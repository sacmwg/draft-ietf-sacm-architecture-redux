TARGETS_DRAFTS := draft-ietf-sacm-arch
TARGETS_TAGS := 
draft-ietf-sacm-arch-00.md: draft-ietf-sacm-arch.md
	sed -e 's/draft-ietf-sacm-arch-latest/draft-ietf-sacm-arch-00/g' -e 's/draft-ietf-sacm-architecture-latest/draft-ietf-sacm-architecture-00/g' -e 's/draft-ietf-sacm-architecture-latest/draft-ietf-sacm-architecture-00/g' $< >$@
