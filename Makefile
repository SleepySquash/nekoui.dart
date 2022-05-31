###############################
# Common defaults/definitions #
###############################

comma := ,

# Checks two given strings for equality.
eq = $(if $(or $(1),$(2)),$(and $(findstring $(1),$(2)),\
                                $(findstring $(2),$(1))),1)
# Makes given string usable in URL.
# Analogue of slugify() function from GitLab:
# https://gitlab.com/gitlab-org/gitlab-foss/blob/master/lib/gitlab/utils.rb
slugify = $(strip $(shell echo $(2) | tr [:upper:] [:lower:] \
                                    | tr -c [:alnum:] - \
                                    | cut -c 1-$(1) \
                                    | sed -e 's/^-*//' -e 's/-*$$//'))




######################
# Project parameters #
######################

VERSION ?= $(strip $(shell grep -m1 'version: ' pubspec.yaml | cut -d ' ' -f2))
FLUTTER_VER ?= $(strip $(shell grep -m1 'FLUTTER_VER: ' .gitlab-ci.yml \
                               | cut -d ':' -f2 | cut -d "'" -f2))

SENTRY_AUTH_TOKEN ?= $(strip $(shell grep 'SENTRY_AUTH_TOKEN=' .env | cut -d '=' -f2))
SENTRY_PROJECT ?= $(strip $(shell grep 'SENTRY_PROJECT=' .env | cut -d '=' -f2))
SENTRY_ORG ?= $(strip $(shell grep 'SENTRY_ORG=' .env | cut -d '=' -f2))
SENTRY_URL ?= $(strip $(shell grep 'SENTRY_URL=' .env | cut -d '=' -f2))




###########
# Aliases #
###########

build: flutter.build


clean: clean.e2e clean.flutter


deps: flutter.pub


docs: docs.dart


e2e: test.e2e


fmt: flutter.fmt


gen: flutter.gen


lint: flutter.analyze


run: flutter.run


serve: flutter.serve


test: test.unit




####################
# Flutter commands #
####################

# Lint Flutter Dart sources with dartanalyzer.
#
# Usage:
#	make flutter.analyze [dockerized=(no|yes)]

flutter.analyze:
ifeq ($(wildcard lib/provider/hive/*.g.dart),)
	@make flutter.gen overwrite=yes dockerized=$(dockerized)
endif
ifeq ($(dockerized),yes)
	docker run --rm --network=host -v "$(PWD)":/app -w /app \
	           -v "$(HOME)/.pub-cache":/usr/local/flutter/.pub-cache \
		ghcr.io/instrumentisto/flutter:$(FLUTTER_VER) \
			make flutter.analyze dockerized=no
else
	flutter analyze
endif


# Build Flutter project from sources.
#
# Usage:
#	make flutter.build [platform=(apk|web|linux|macos|windows)]
#	                   [dart-env=<VAR1>=<VAL1>[,<VAR2>=<VAL2>...]]
#	                   [dockerized=(no|yes)]

flutter.build:
ifeq ($(wildcard lib/provider/hive/*.g.dart),)
	@make flutter.gen overwrite=yes dockerized=$(dockerized)
endif
ifeq ($(dockerized),yes)
ifeq ($(platform),macos)
	$(error Dockerized macOS build is not supported)
else ifeq ($(platform),windows)
	$(error Dockerized Windows build is not supported)
else
	docker run --rm --network=host -v "$(PWD)":/app -w /app \
	           -v "$(HOME)/.pub-cache":/usr/local/flutter/.pub-cache \
		ghcr.io/instrumentisto/flutter:$(FLUTTER_VER) \
			make flutter.build platform=$(platform) dart-env='$(dart-env)' \
			                   dockerized=no
endif
else
# TODO: `--split-debug-info` should be used on any non-Web platform.
#       1) macOS/iOS `--split-debug-info` can be tracked here:
#          https://github.com/getsentry/sentry-dart/issues/444
#       2) Linux/Windows `--split-debug-info` can be tracked here:
#          https://github.com/getsentry/sentry-dart/issues/433
	flutter build $(or $(platform),apk) --release \
		$(if $(call eq,$(platform),web),--web-renderer html --source-maps,) \
		$(if $(call eq,$(or $(platform),apk),apk),--split-debug-info=symbols,) \
		$(if $(call eq,$(dart-env),),,--dart-define=$(dart-env))
endif


# Clean all the Flutter dependencies and generated files.
#
# Usage:
#	make flutter.clean [dockerized=(no|yes)]

flutter.clean:
ifeq ($(dockerized),yes)
	docker run --rm --network=host -v "$(PWD)":/app -w /app \
		ghcr.io/instrumentisto/flutter:$(FLUTTER_VER) \
			make flutter.clean dockerized=no
else
	flutter clean
	rm -rf .cache/pub/ doc/ \
	       lib/api/backend/*.dart \
	       lib/api/backend/*.g.dart \
	       lib/api/backend/*.graphql.dart \
	       lib/domain/model/*.g.dart
endif


# Format Flutter Dart sources with dartfmt.
#
# Usage:
#	make flutter.fmt [check=(no|yes)] [dockerized=(no|yes)]

flutter.fmt:
ifeq ($(dockerized),yes)
	docker run --rm --network=host -v "$(PWD)":/app -w /app \
		ghcr.io/instrumentisto/flutter:$(FLUTTER_VER) \
			make flutter.fmt check=$(check) dockerized=no
else
	flutter format $(if $(call eq,$(check),yes),-n --set-exit-if-changed,) .
endif


# Run `build_runner` Flutter tool to generate project Dart code.
#
# Usage:
#	make flutter.gen [overwrite=(yes|no)] [dockerized=(no|yes)]

flutter.gen:
ifeq ($(dockerized),yes)
	docker run --rm --network=host -v "$(PWD)":/app -w /app \
	           -v "$(HOME)/.pub-cache":/usr/local/flutter/.pub-cache \
		ghcr.io/instrumentisto/flutter:$(FLUTTER_VER) \
			make flutter.gen overwrite=$(overwrite) dockerized=no
else
	flutter pub run build_runner build \
		$(if $(call eq,$(overwrite),no),,--delete-conflicting-outputs)
endif


# Resolve Flutter project dependencies.
#
# Usage:
#	make flutter.pub [cmd=(get|<pub-cmd>)] [dockerized=(no|yes)]

flutter.pub:
ifeq ($(dockerized),yes)
	docker run --rm --network=host -v "$(PWD)":/app -w /app \
	           -v "$(HOME)/.pub-cache":/usr/local/flutter/.pub-cache \
		ghcr.io/instrumentisto/flutter:$(FLUTTER_VER) \
			make flutter.pub cmd='$(cmd)' dockerized=no
else
	flutter pub $(or $(cmd),get)
endif


# Run built project on an attached device or in an emulator.
#
# Usage:
#	make flutter.run [debug=(yes|no)]
#	                 [device=(<device-id>|linux|macos|windows|chrome)]
#	                 [dart-env=<VAR1>=<VAL1>[,<VAR2>=<VAL2>...]]

flutter.run:
ifeq ($(wildcard lib/provider/hive/*.g.dart),)
	@make flutter.gen overwrite=yes dockerized=$(dockerized)
endif
	flutter run $(if $(call eq,$(debug),no),--release,) \
		$(if $(call eq,$(device),),,-d $(device)) \
		$(if $(call eq,$(dart-env),),,--dart-define=$(dart-env))


# Set up Docker Compose development environment and start the application.
#
# Usage:
#	make flutter.serve [debug=(yes|no)]
#	                   [device=(<device-id>|linux|macos|windows|chrome)]
#	                   [dart-env=<VAR1>=<VAL1>[,<VAR2>=<VAL2>...]]

flutter.serve:
	make docker.up background=yes log=no
	make flutter.run debug=$(debug) device=$(device) dart-env='$(dart-env)'


# Show project version from Flutter's Pub manifest.
#
# Usage:
#	make flutter.version

flutter.version:
	@printf "$(VERSION)"





####################
# Testing commands #
####################

# Run Flutter E2E tests.
#
# Usage:
#	make test.e2e [( [start-app=no]
#	               | start-app=yes [TAG=(dev|<docker-tag>)]
#	                               [no-cache=(no|yes)]
#	                               [pull=(no|yes)] )]
#	              [device=(chrome|web-server|macos|linux|windows|<device-id>)]
#	              [dockerized=(no|yes)]
#	              [gen=(no|yes)]

test.e2e:
ifeq ($(if $(call eq,$(gen),yes),,$(wildcard test/e2e/*.g.dart)),)
	@make flutter.gen overwrite=yes dockerized=$(dockerized)
endif
ifeq ($(start-app),yes)
	@make docker.up TAG=$(TAG) no-cache=$(no-cache) pull=$(pull) \
	                background=yes log=no
	while ! timeout 1 bash -c "echo > /dev/tcp/localhost/4444"; do sleep 1; done
	docker logs -f socmob-webdriver-chrome &
endif
ifeq ($(dockerized),yes)
	docker run --rm -v "$(PWD)":/app -w /app \
	           --network=container:socmob-mobile \
	           -v "$(HOME)/.pub-cache":/usr/local/flutter/.pub-cache \
		ghcr.io/instrumentisto/flutter:$(FLUTTER_VER) \
			make test.e2e dockerized=no start-app=no gen=no device=$(device)
else
	flutter drive --headless -d $(or $(device),chrome) \
		--web-renderer html --web-port 50000 \
		--driver=test_driver/integration_test_driver.dart \
		--target=test/e2e/suite.dart
endif
ifeq ($(start-app),yes)
	@make docker.down
endif


# Run Flutter unit tests.
#
# Usage:
#	make test.unit [dockerized=(no|yes)]

test.unit:
ifeq ($(wildcard lib/provider/hive/*.g.dart),)
	@make flutter.gen overwrite=yes dockerized=$(dockerized)
endif
ifeq ($(dockerized),yes)
	docker run --rm -v "$(PWD)":/app -w /app \
	           -v "$(HOME)/.pub-cache":/usr/local/flutter/.pub-cache \
		ghcr.io/instrumentisto/flutter:$(FLUTTER_VER) \
			make test.unit dockerized=no
else
	flutter test
endif




##########################
# Documentation commands #
##########################

# Generate project documentation of Dart sources.
#
# Usage:
#	make docs.dart [( [dockerized=no] [open=(no|yes)]
#	                | dockerized=yes )]
#	               [clean=(no|yes)]

docs.dart:
ifeq ($(wildcard lib/provider/hive/*.g.dart),)
	@make flutter.gen overwrite=yes dockerized=$(dockerized)
endif
ifeq ($(clean),yes)
	rm -rf doc/api
endif
ifeq ($(dockerized),yes)
	docker run --rm -v "$(PWD)":/app -w /app \
	           -v "$(HOME)/.pub-cache":/usr/local/flutter/.pub-cache \
		ghcr.io/instrumentisto/flutter:$(FLUTTER_VER) \
			make docs.dart open=no dockerized=no clean=no
else
	flutter pub run dartdoc
ifeq ($(open),yes)
	flutter pub global run dhttpd --path doc/api
endif
endif




#####################
# Cleaning commands #
#####################

# Clean E2E tests generated cache.
#
# Usage:
#	make clean.e2e

clean.e2e:
	rm -rf .dart_tool/build/generated/nekoui/integration_test \
	       test/e2e/gherkin/reports/


clean.flutter: flutter.clean




###################
# Sentry commands #
###################

# Upload source maps and debug symbols to Sentry.
#
# Usage:
#	make sentry.upload [token=<SENTRY_AUTH_TOKEN>]
#	                   [project=<SENTRY_PROJECT_NAME>]
#	                   [org=<SENTRY_ORG_NAME>]
#	                   [url=<SENTRY_URL>] [dockerized=(no|yes)]

sentry-auth-token = $(or $(token),$(SENTRY_AUTH_TOKEN))
sentry-project = $(or $(project),$(SENTRY_PROJECT))
sentry-org = $(or $(org),$(SENTRY_ORG))
sentry-url = $(or $(url),$(SENTRY_URL))

sentry.upload:
ifeq ($(sentry-auth-token),)
	$(error Sentry API authorization token must be specified via `token` argument)
endif
ifeq ($(sentry-project),)
	$(error Sentry project name must be specified via `project` argument)
endif
ifeq ($(sentry-org),)
	$(error Sentry organization name must be specified via `org` argument)
endif
ifeq ($(sentry-url),)
	$(error Sentry URL must be specified via `url` argument)
endif
ifeq ($(dockerized),yes)
	docker run --rm -v "$(PWD)":/app -w /app \
		-v "$(HOME)/.pub-cache":/root/.pub-cache \
		ghcr.io/instrumentisto/flutter:$(FLUTTER_VER) \
			make sentry.upload dockerized=no token=$(token) \
			                   project=$(project) org=$(org)
else
	SENTRY_AUTH_TOKEN=$(sentry-auth-token) \
	SENTRY_PROJECT=$(sentry-project) \
	SENTRY_ORG=$(sentry-org) \
	SENTRY_URL=$(sentry-url) \
	flutter packages pub run sentry_dart_plugin
endif





##################
# .PHONY section #
##################

.PHONY: build clean deps docs down e2e fmt gen lint run serve test up \
        clean.e2e clean.flutter clean.yarn \
        docs.dart \
        flutter.analyze flutter.clean flutter.build flutter.fmt flutter.gen \
        	flutter.pub flutter.run flutter.serve flutter.version \
        docker.auth docker.build docker.down docker.pull docker.push \
        	docker.tag docker.tar docker.untar docker.up \
        git.release git.squash \
        gitlab.release.notes \
        helm helm.build helm.dep helm.down helm.lint helm.list helm.up \
        	helm.discover.sftp \
        minikube.boot \
        sentry.upload \
        test.e2e test.unit \
        yarn yarn.clean
