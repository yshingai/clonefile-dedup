DIR ?= .

all:
	@cat Makefile | grep '^[a-zA-Z].*:' --color | sed -e 's/^/make /' -e 's/:$$//' | grep ' .*$$' --color

shell:

install:
	case $$OSTYPE ;	\
		linux-gnu) \
			pyenv local 3.7.17 \
			;; \
		darwin*) \
			sudo port install python37 poetry \
			sudo port select --set virtualenv virtualenv313 \
			sudo port select --set python3 python313 \
			;; \
		*) \
			;; \
	esac
	#poetry run install


pyenv:
	type -p pyenv ; if [ $$? -ne 0 ]; then \
		curl -fsSL https://pyenv.run | bash ; \
	fi; \

poetry:
	type -p poetry ; if [ $$? -ne 0 ]; then \
		curl -sSL https://install.python-poetry.org | python3 -; \
	fi;
	case $$OSTYPE in \
		linux-gnu) \
			pyenv install 3.7.17; \
			pyenv local 3.7.17; \
			;; \
	esac
	poetry config virtualenvs.in-project true
	poetry update

index:
	read -p "index: $(DIR) ?" y
	rm -f clonefile-index.sqlite
	LC_ALL=ja_JP.UTF-8 time poetry run python clonefile-index.py $(DIR) 2>&1 | tee index.log

verify:
	LC_ALL=ja_JP.UTF-8 time poetry run python clonefile-verify.py 2>&1 | tee verify.log

dedup:
	LC_ALL=ja_JP.UTF-8 time poetry run python clonefile-dedup.py 2>&1 | tee dedup.log


