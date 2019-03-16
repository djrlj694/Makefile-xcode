# git.mk
# Copyright © 2019 Synthelytics LLC. All rights reserved.
#
# ==============================================================================
# PROGRAM: git.mk
# AUTHORS: Robert L. Jones
# COMPANY: Synthelytics LLC
# VERSION: 1.1.0
# CREATED: 04FEB2019
# REVISED: 16MAR2019
#
# NOTES:
#   For more info on terminology, style conventions, or source references, see
#   the file ".make/README.md".
# ==============================================================================

# ==============================================================================
# Phony Targets
# ==============================================================================

# ------------------------------------------------------------------------------
# Prerequisite phony targets for the "clean" target
# ------------------------------------------------------------------------------

.PHONY: clean-git

## clean-git: Completes all git cleanup activities.
clean-git: | $(LOG)
	@printf "Removing git setup..."
	@rm -rf .git .gitignore >$(LOG) 2>&1; \
	$(status_result)

# ------------------------------------------------------------------------------
# Prerequisite phony targets for the "init" target
# ------------------------------------------------------------------------------

.PHONY: init-git

## init-git: Completes all initial git setup activities.
ifeq ($(COOKIECUTTER),)
init-git: .gitignore .git | $(LOG)
else
init-git: .git | $(LOG)
endif
	@printf "Committing the initial project to the master branch..."
	@git checkout -b master >$(LOG) 2>&1; \
	git add . >>$(LOG) 2>&1; \
	git commit -m "Initial project setup" >>$(LOG) 2>&1; \
	$(status_result)
	@printf "Syncing the initial project with the origin..."
	@git remote add origin $(ORIGIN_URL) >$(LOG) 2>&1; \
	git push -u origin master >$(LOG) 2>&1; \
	$(status_result)

# ==============================================================================
# Directory Targets
# ==============================================================================

## .git: Makes a git repository.
.git: | $(LOG)
	@printf "Initializing git repository..."
	@git init >$(LOG) 2>&1; \
	$(status_result)

# ==============================================================================
# File Targets
# ==============================================================================

## .gitignore: Makes a .gitignore file.
.gitignore: .gitignore.download

# Makes a special empty file for marking that a directory tree has been generated.
%/.gitkeep:
	@printf "Making directory tree for marker file $(target_var)..."
	@printf "Making marker file $(target_var) and its directory tree..."
	@mkdir -p $(@D); $(status_result)
	@printf "Making marker file $(target_var)..."
	@touch $@; $(status_result)
endif

# ==============================================================================
# Intermediate Targets
# ==============================================================================

.INTERMEDIATE: .gitignore.download

# ==============================================================================
# Second Expansion Targets
# ==============================================================================

.SECONDEXPANSION:
# Make a directory tree.
#$(PREFIX)/%.gitkeep: $$(@D)/.gitkeep | $$(@D)/.
