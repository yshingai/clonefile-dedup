DIR ?= .

all:
	@cat Makefile | grep '^[a-zA-Z].*:' --color | sed -e 's/^/make /' -e 's/:$$//' | grep ' .*$$' --color

shell:

install:
	sudo port install python37 poetry
	sudo port select --set virtualenv virtualenv313
	sudo port select --set python3 python313
	#poetry run install


poetry:
	pyenv local 3.7.17
	poetry config virtualenvs.in-project true
	poetry update

index:
	read -p "index: $(DIR) ?" y
	rm -f clonefile-index.sqlite
	LC_ALL=ja_JP.UTF-8 poetry run python clonefile-index.py $(DIR) 2>&1 | tee index.log

verify:
	LC_ALL=ja_JP.UTF-8 poetry run python clonefile-verify.py 2>&1 | tee verify.log

dedup:
	LC_ALL=ja_JP.UTF-8 poetry run python clonefile-dedup.py 2>&1 | tee dedup.log


