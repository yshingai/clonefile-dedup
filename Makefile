DIR ?= .

all:

shell:

install:
	pipenv run install

index:
	read -p "index: $(DIR) ?" y
	rm -i clonefile-index.sqlite
	pipenv run index $(DIR)

verify:
	pipenv run verify

dedup:
	pipenv run dedup


