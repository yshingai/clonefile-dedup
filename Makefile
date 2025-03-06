DIR ?= .

all:
	@cat Makefile | grep '^[a-zA-Z].*:' --color | sed -e 's/^/make /' -e 's/:$$//' | grep ' .*$$' --color

shell:

install:
	sudo port install python37 poetry
	sudo port select --set virtualenv virtualenv313
	sudo port select --set python3 python313
	#poetry run install


index:
	read -p "index: $(DIR) ?" y
	rm -i clonefile-index.sqlite
	poetry run python clonefile-index.py $(DIR)

verify:
	poetry run python clonefile-verify.py

dedup:
	poetry run python clonefile-dedup.py


