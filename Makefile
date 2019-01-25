FOLDERS = if-down.d if-pre-up.d if-up.d
DEST=/etc/network

all: $(foreach f, $(FOLDERS), link-file-$(f))


link-file-%: %
	@ln -snf $(CURDIR)/$</netns $(DEST)/$</netns
