###############################
# Common defaults/definitions #
###############################

comma := ,

# Checks two given strings for equality.
eq = $(if $(or $(1),$(2)),$(and $(findstring $(1),$(2)),\
                                $(findstring $(2),$(1))),1)

# Recursively lists all files in the given directory with the given pattern.
rwildcard = $(strip $(wildcard $(1)$(2))\
                    $(foreach d,$(wildcard $(1)*),$(call rwildcard,$(d)/,$(2))))




######################
# Project parameters #
######################

IMAGE_NAME := $(strip $(shell grep 'IMAGE_NAME=' .env | cut -d '=' -f2))

RELEASE_BRANCH := release
MAINLINE_BRANCH := main
CURRENT_BRANCH := $(strip $(if $(call eq,$(CI),),\
	$(shell git branch | grep \* | cut -d ' ' -f2),$(github.ref_name)))

VERSION ?= $(strip $(shell grep -m1 'version: ' pubspec.yaml | cut -d ' ' -f2))
FLUTTER_VER ?= $(strip \
	$(shell grep -m1 'FLUTTER_VER: ' .github/workflows/ci.yml | cut -d':' -f2 \
                                                              | tr -d'"'))




###########
# Aliases #
###########

build: flutter.build


clean: clean.flutter


deps: flutter.pub


docs: docs.dart


fmt: flutter.fmt


gen: flutter.gen


lint: flutter.analyze


run: flutter.run


test: test.unit




####################
# Flutter commands #
####################

# Lint Flutter Dart sources with dartanalyzer.
#
# Usage:
#	make flutter.analyze [dockerized=(no|yes)]

flutter.analyze:
ifeq ($(wildcard lib/domain/model/*.g.dart),)
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
#	make flutter.build [( [platform=apk] [split-per-abi=(no|yes)]
#	                    | platform=(appbundle|web|linux|macos|windows|ios) )]
#	                   [dart-env=<VAR1>=<VAL1>[,<VAR2>=<VAL2>...]]
#	                   [dockerized=(no|yes)]

flutter.build:
ifeq ($(wildcard lib/domain/model/*.g.dart),)
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
			                   split-per-abi=$(split-per-abi) dockerized=no
endif
else
# TODO: `--split-debug-info` should be used on any non-Web platform.
#       1) macOS/iOS `--split-debug-info` can be tracked here:
#          https://github.com/getsentry/sentry-dart/issues/444
#       2) Linux/Windows `--split-debug-info` can be tracked here:
#          https://github.com/getsentry/sentry-dart/issues/433
	flutter build $(or $(platform),apk) --release \
		$(if $(call eq,$(platform),web),--web-renderer html --source-maps,) \
		$(if $(call eq,$(or $(platform),apk),apk),\
		    --split-debug-info=symbols \
		    $(if $(call eq,$(split-per-abi),yes),--split-per-abi,), \
		) \
		$(if $(call eq,$(platform),appbundle),--split-debug-info=symbols,) \
		$(if $(call eq,$(platform),ios),--no-codesign,) \
		$(if $(call eq,$(dart-env),),,--dart-define=$(dart-env))
endif


# Clean all Flutter dependencies and generated files.
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


# Run `build_runner` Flutter tool to generate project Dart sources.
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
ifeq ($(wildcard lib/domain/model/*.g.dart),)
	@make flutter.gen overwrite=yes dockerized=$(dockerized)
endif
	flutter run $(if $(call eq,$(debug),no),--release,) \
		$(if $(call eq,$(device),),,-d $(device)) \
		$(if $(call eq,$(dart-env),),,--dart-define=$(dart-env))


# Show project version from Flutter's Pub manifest.
#
# Usage:
#	make flutter.version

flutter.version:
	@printf "$(VERSION)"




####################
# Testing commands #
####################

# Run Flutter unit tests.
#
# Usage:
#	make test.unit [dockerized=(no|yes)]

test.unit:
ifeq ($(wildcard lib/domain/model/*.g.dart),)
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
ifeq ($(wildcard lib/domain/model/*.g.dart),)
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

clean.flutter: flutter.clean




######################
# Copyright commands #
######################

# Populate project sources with copyright notice.
#
# Usage:
#	make copyright [check=(no|yes)]

copyright:
	docker run --rm -v "$(PWD)":/src -w /src \
		ghcr.io/google/addlicense \
			-f NOTICE $(if $(call eq,$(check),yes),-check,-v) \
			$(foreach pat,\
				$(shell grep -v '#' .gitignore | sed 's/^\///' | grep '\S'),\
					-ignore '$(pat)') \
			$(call rwildcard,,*.dart) \
			$(call rwildcard,,*.graphql) \
			$(call rwildcard,,*.kt) \
			web/index.html \
			Dockerfile




###################
# Docker commands #
###################

docker-env = $(strip $(if $(call eq,$(minikube),yes),\
	$(subst export,,$(shell minikube docker-env | cut -d '\#' -f1)),))

# Build project Docker image.
#
# Usage:
#	make docker.build [image=(<empty>|review|artifacts)]
#	                  [tag=(dev|<tag>)]
#	                  [no-cache=(no|yes)]
#	                  [minikube=(no|yes)]

docker-build-image-name = $(IMAGE_NAME)$(if $(call eq,$(image),),,/$(image))
docker-build-dir = .
ifeq ($(image),artifacts)
docker-build-dir = docker/artifacts
endif

docker.build:
ifeq ($(image),artifacts)
ifeq ($(wildcard doc/api),)
	@make docs.dart clean=no open=no dockerized=$(dockerized)
endif
	@rm -rf docker/artifacts/rootfs/docs/dart
	@mkdir -p docker/artifacts/rootfs/docs/dart/
	cp -rf doc/api/* docker/artifacts/rootfs/docs/dart/
else
ifeq ($(wildcard build/web),)
	@make flutter.build platform=web dart-env='$(dart-env)' \
	                    dockerized=$(dockerized)
endif
endif
	$(docker-env) \
	docker build --network=host --force-rm \
		$(if $(call eq,$(no-cache),yes),--no-cache --pull,) \
		-t $(docker-build-image-name):$(or $(tag),dev) $(docker-build-dir)/


# Pull project Docker images from Container Registry.
#
# Usage:
#	make docker.pull [image=(<empty>|review|artifacts)]
#	                 [tags=(dev|@all|<t1>[,<t2>...])]
#	                 [minikube=(no|yes)]

docker-pull-image-name = $(IMAGE_NAME)$(if $(call eq,$(image),),,/$(image))
docker-pull-tags = $(or $(tags),dev)

docker.pull:
ifeq ($(docker-pull-tags),@all)
	$(docker-env) \
	docker pull $(docker-pull-image-name) --all-tags
else
	$(foreach tag,$(subst $(comma), ,$(docker-pull-tags)),\
		$(call docker.pull.do,$(tag)))
endif
define docker.pull.do
	$(eval tag := $(strip $(1)))
	$(docker-env) \
	docker pull $(docker-pull-image-name):$(tag)
endef


# Push project Docker images to Container Registry.
#
# Usage:
#	make docker.push [image=(<empty>|review|artifacts)]
#	                 [tags=(dev|<t1>[,<t2>...])]
#	                 [minikube=(no|yes)]

docker-push-image-name = $(IMAGE_NAME)$(if $(call eq,$(image),),,/$(image))

docker.push:
	$(foreach tag,$(subst $(comma), ,$(or $(tags),dev)),\
		$(call docker.push.do,$(tag)))
define docker.push.do
	$(eval tag := $(strip $(1)))
	$(docker-env) \
	docker push $(docker-push-image-name):$(tag)
endef


# Tag project Docker image with the given tags.
#
# Usage:
#	make docker.tag [image=(<empty>|review|artifacts)]
#	                [of=(dev|<of-tag>)] [tags=(dev|<with-t1>[,<with-t2>...])]
#	                [as=(<empty>|review|artifacts)]
#	                [minikube=(no|yes)]

docker-tag-image-name = $(IMAGE_NAME)$(if $(call eq,$(image),),,/$(image))
docker-tag-as-image-name = $(strip $(if $(call eq,$(as),),\
	$(docker-tag-image-name),$(IMAGE_NAME)/$(as)))

docker.tag:
	$(foreach tag,$(subst $(comma), ,$(or $(tags),dev)),\
		$(call docker.tag.do,$(or $(of),dev),$(tag)))
define docker.tag.do
	$(eval from := $(strip $(1)))
	$(eval to := $(strip $(2)))
	$(docker-env) \
	docker tag $(docker-tag-image-name):$(from) \
	           $(docker-tag-as-image-name):$(to)
endef


# Save project Docker images into a tarball file.
#
# Usage:
#	make docker.tar [image=(<empty>|review|artifacts)]
#	                [tags=(dev|<t1>[,<t2>...])]
#	                [minikube=(no|yes)]

docker-tar-image-name = $(IMAGE_NAME)$(if $(call eq,$(image),),,/$(image))
docker-tar-dir = .cache/docker/$(docker-tar-image-name)
docker-tar-tags = $(or $(tags),dev)

docker.tar:
	@mkdir -p $(docker-tar-dir)/
	$(docker-env) \
	docker save -o $(docker-tar-dir)/$(subst $(comma),_,$(docker-tar-tags)).tar\
		$(foreach tag,$(subst $(comma), ,$(docker-tar-tags)),\
			$(docker-tar-image-name):$(tag))


# Load project Docker images from a tarball file.
#
# Usage:
#	make docker.untar [image=(<empty>|review|artifacts)]
#	                  [tags=(dev|<t1>[,<t2>...])]
#	                  [minikube=(no|yes)]

docker-untar-image-name = $(IMAGE_NAME)$(if $(call eq,$(image),),,/$(image))
docker-untar-dir = .cache/docker/$(docker-untar-image-name)

docker.untar:
	$(docker-env) \
	docker load -i $(docker-untar-dir)/$(subst $(comma),_,$(or $(tags),dev)).tar




###################
# GitHub commands #
###################

# Prepare release notes for GitHub release.
#
# Usage:
#	make github.release.notes [VERSION=<proj-version>]
#	     [project-url=(https://github.com/team113/messenger|<github-project-url>)]

github-proj-url = $(strip $(or $(project-url),\
	https://github.com/SleepySquash/nekoui.dart))

github.release.notes:
	@echo "$(strip \
		[Changelog]($(github-proj-url)/blob/v$(VERSION)/CHANGELOG.md#$(shell \
			sed -n '/^## \[$(VERSION)\]/{\
				s/^## \[\(.*\)\][^0-9]*\([0-9].*\)/\1-\2/;\
				s/[^0-9a-z-]*//g;\
				p;\
			}' CHANGELOG.md)) | \
		[Milestone]($(github-proj-url)/milestone/$(shell \
			sed -n '/^## \[$(VERSION)\]/,/Milestone/{\
				s/.*milestone.\([0-9]*\).*/\1/p;\
			}' CHANGELOG.md)) | \
		[Repository]($(github-proj-url)/tree/v$(VERSION)))"




################
# Git commands #
################

# Release project version (merge to release branch and apply version tag).
#
# Usage:
#	make git.release [VERSION=<proj-ver>]

git.release:
ifneq ($(CURRENT_BRANCH),$(MAINLINE_BRANCH))
	@echo "--> Current branch is not '$(MAINLINE_BRANCH)'" && false
endif
	git fetch origin --tags $(RELEASE_BRANCH):$(RELEASE_BRANCH)
ifeq ($(shell git rev-parse v$(VERSION) >/dev/null 2>&1 && echo "ok"),ok)
	@echo "--> Tag v$(VERSION) already exists" && false
endif
	git fetch . $(MAINLINE_BRANCH):$(RELEASE_BRANCH)
	git tag v$(VERSION) $(RELEASE_BRANCH)
	git push origin $(RELEASE_BRANCH)
	git push --tags origin $(RELEASE_BRANCH)




##################
# .PHONY section #
##################

.PHONY: build clean deps docs fmt gen lint run test \
        clean.flutter \
        copyright \
        docs.dart \
        flutter.analyze flutter.clean flutter.build flutter.fmt flutter.gen \
            flutter.pub flutter.run \
        test.unit
