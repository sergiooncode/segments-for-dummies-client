SHELL := /bin/bash
COVERAGE := env/bin/coverage
COVERAGE_OPTS := --rcfile=coverage.cfg
PYLINT := env/bin/flake8
JSLINT := env/bin/eslint --ext .es6 interface_app/static/app/.
SCSSLINT := bundle exec scss-lint

ifeq ($(wildcard .env.local), .env.local)  # If .env.local exists
  LOCAL_ENV := env `cat .env .env.local | egrep -v '^\#' | xargs`
else
  LOCAL_ENV := env `cat .env | egrep -v '^\#' | xargs`
endif

help:
	cat README.md

env:
	virtualenv -p `which python2.7` env

clean: 
	rm -rf env

docs-deps:
	env/bin/pip install -Ur requirements/docs.txt $(PIP_OPTS)

dev-deps: deps
	env/bin/pip install -Ur requirements/dev.txt $(PIP_OPTS)

docker-deps: env
	wget https://github.com/hashicorp/envconsul/releases/download/v0.5.0/envconsul_0.5.0_linux_amd64.tar.gz
	tar -zxvf envconsul_0.5.0_linux_amd64.tar.gz && mv envconsul_0.5.0_linux_amd64/envconsul env/bin/envconsul
	rm -rf envconsul_0.5.0_linux_amd64
	rm envconsul_0.5.0_linux_amd64.tar.gz
	env/bin/pip install -Ur requirements/setuptools.txt
	env/bin/pip install -Ur requirements/base.txt $(PIP_OPTS)
	env/bin/pip install ipython
	env/bin/pip install bpython
	env/bin/nodeenv -v -n 0.10.38 --requirements=requirements/node-docker.txt --prebuilt --force env  # JS deps

deps: env
	env/bin/pip install -Ur requirements/setuptools.txt
	env/bin/pip install -Ur requirements/base.txt $(PIP_OPTS)
	env/bin/nodeenv -v -n 0.10.38 --requirements=requirements/node.txt --prebuilt --force env  # JS deps
	source env/bin/activate && env/bin/bower install  # JS deps
	bundle install  # Ruby deps

js-test:
	env/bin/karma start --single-run

js-test-watch:
	env/bin/karma start --browsers Chrome

scss-test:
	bundle exec scss-lint

unittest:
	$(LOCAL_ENV) env/bin/python manage.py test

test: lint js-test clean-static unittest

lint-verbose:
	$(PYLINT) --show-source --show-pep8
	$(JSLINT)
	$(SCSSLINT)

lint:
	$(PYLINT)
	$(JSLINT)
	$(SCSSLINT)

clean-coverage:
	rm -rf .coverage coverage.xml htmlcov/

coverage: clean-coverage
	$(LOCAL_ENV) $(COVERAGE) run $(COVERAGE_OPTS) manage.py test
	$(COVERAGE) report $(COVERAGE_OPTS)

coverage-html: coverage
	$(COVERAGE) html $(COVERAGE_OPTS)

coverage-xml: coverage
	$(COVERAGE) xml $(COVERAGE_OPTS)

start: env
	env/bin/honcho start -e .env,.env.local

start-web: env clean-static
	$(LOCAL_ENV) env/bin/python manage.py runserver 0.0.0.0:8000

start-tasks: env
	$(LOCAL_ENV) env/bin/celery -A carey worker -l info

start-rabbit: env
	$(LOCAL_ENV) rabbitmq-server

db:
	dropdb --if-exists carey && createdb carey && ./manage migrate
	echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'admin')" | ./manage shell

docs:
	env/bin/sassdoc interface/static/stylesheets/**/*.scss
	env/bin/mkdocs build --clean
	env/bin/mkdocs gh-deploy -vvv

xfinity-scan-request-processor:
	source env/bin/activate && DJANGO_SETTINGS_MODULE=carey.settings PYTHONPATH=. env/bin/boarding-pass-request-processor boarding_pass_handlers.xfinity_scrape_request_handler

screenshots-request-processor:
	source env/bin/activate && DJANGO_SETTINGS_MODULE=carey.settings PYTHONPATH=. env/bin/boarding-pass-request-processor boarding_pass_handlers.screenshots_request_handler

paid-search-scan-request-processor:
	source env/bin/activate && DJANGO_SETTINGS_MODULE=carey.settings PYTHONPATH=. env/bin/boarding-pass-request-processor boarding_pass_handlers.paidsearch_request_handler

docker-build:
	docker build -t 192.168.150.5:5000/lfo/carey .

docker-push:
	docker push 192.168.150.5:5000/lfo/carey

qa-tunnel:
	ssh -N -D localhost:5555 deploy@sv-qtools01


.PHONY: clean clean-static help deps start js-test js-test-watch scss-test unittest docs dev-deps xfinity-scan-request-processor-local xfinity-scan-request-processor screenshots-request-processor paid-search-scan-request-processor
