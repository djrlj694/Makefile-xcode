# main.mk
# Copyright © 2019 Synthelytics LLC. All rights reserved.
#
# ==============================================================================
# PROGRAM: main.mk
# AUTHORS: Robert L. Jones
# COMPANY: Synthelytics LLC
# VERSION: 1.0.0
# CREATED: 07MAR2019
# REVISED: 10MAR2019
# ==============================================================================

# ==============================================================================
# Internal Constants
#
# An internal constant represents a variable that is intended to:
#
# 1. Have a fixed value;
# 2. Be set within a makefile (i.e., the "Makefile" itself or an "include"-ed
# ".mk" file).
#
# Because its value does not intended to change, its right-hand side is "simply"
# expanded -- # i.e., any variables thererin are immediately evaluated, and the
# resulting text is saved as final the value. As such, it is defined using the
# ":=" assignment operator. By convention, internal constants use uppercase
# words, separated by dashes.
# ==============================================================================

# ------------------------------------------------------------------------------
# Commands
# ------------------------------------------------------------------------------

MKDIR := mkdir -p

# ------------------------------------------------------------------------------
# Debugging & Error Capture
# ------------------------------------------------------------------------------

STATUS_RESULT = $(call result,$(DONE))
TEST_RESULT = $(call result,$(PASSED))

VARIABLES_TO_SHOW = EMAIL_REGEX MAKEFILE MAKEFILE_DIR MAKEFILE_LIST PACKAGE PREFIX PROJECT PWD USER

# ------------------------------------------------------------------------------
# Files
# ------------------------------------------------------------------------------

#LOG = $(shell mktemp /tmp/log.XXXXXXXXXX)
#LOG = `mktemp /tmp/log.XXXXXXXXXX`
#LOG = $(shell mktemp -t /tmp make.log.XXXXXXXXXX)
#LOG = $(shell mktemp)
#LOG = /tmp/make.$$$$.log
LOG := make.log

# ------------------------------------------------------------------------------
# Settings
# ------------------------------------------------------------------------------

SHELL := bash

# ------------------------------------------------------------------------------
# Special Characters
# ------------------------------------------------------------------------------

EMPTY :=
SPACE := $(EMPTY) $(EMPTY)

# ------------------------------------------------------------------------------
# STDOUT format settings
# ------------------------------------------------------------------------------

RESET := \033[0m
BOLD := \033[1m
DIM := \033[2m

FG_CYAN := \033[0;36m
FG_GREEN := \033[0;32m
FG_RED := \033[0;31m
FG_YELLOW := \033[1;33m

# ------------------------------------------------------------------------------
# Help strings
# ------------------------------------------------------------------------------

PACKAGE_ARG := $(FG_CYAN)<package>$(RESET)
PREFIX_ARG := $(FG_CYAN)<prefix>$(RESET)
TARGET_ARG := $(FG_CYAN)<target>$(RESET)
USER_ARG := $(FG_CYAN)<user>$(RESET)

MAKE_ARGS := [PACKAGE=$(PACKAGE_ARG)] [PREFIX=$(PREFIX_ARG)] [USER=$(USER_ARG)]

# ------------------------------------------------------------------------------
# Result strings
# ------------------------------------------------------------------------------

DONE := $(FG_GREEN)done$(RESET).\n
FAILED := $(FG_RED)failed$(RESET).\n
IGNORE := $(FG_YELLOW)ignore$(RESET).\n
PASSED := $(FG_GREEN)passed$(RESET).\n

# ==============================================================================
# Internal Variables
#
# An internal variable represents a variable that is intended to:
#
# 1. Have a value that depends on other variables, shell commands, etc. in its
#    definition;
# 2. Be set within a makefile (i.e., the "Makefile" itself or an "include"-ed
#    ".mk" file).
#
# Typically, its right-hand side is recursively expanded -- i.e.,
# right-hand side evaluation is deferred until the variable is used. As such, it
# is defined using the "=" assignment operator. By convention, internal
# variables are lowercase words, separated by underscores.
# ==============================================================================

# ------------------------------------------------------------------------------
# Accounts
# ------------------------------------------------------------------------------

#USER = $(shell whoami)

# ------------------------------------------------------------------------------
# Command Output
# ------------------------------------------------------------------------------

COOKIECUTTER = $(shell which cookiecutter)

# ------------------------------------------------------------------------------
# Debugging & Error Capture
# ------------------------------------------------------------------------------

STATUS_RESULT = $(call result,$(DONE))
TEST_RESULT = $(call result,$(PASSED))

# ------------------------------------------------------------------------------
# Directories
# ------------------------------------------------------------------------------

PREFIX = $(PWD)
SUBDIR = $(shell basename $(@D))

# ------------------------------------------------------------------------------
# Files
# ------------------------------------------------------------------------------

FILE = $(basename $@)

# ------------------------------------------------------------------------------
# Sed Commands
# ------------------------------------------------------------------------------

PROJECT_CMD = $(call sed-cmd,project_name,$(PROJECT))
EMAIL_CMD = $(call sed-cmd,email,$(EMAIL))
GITHUB_USER_CMD = $(call sed-cmd,github_user,$(GITHUB_USER))
TRAVIS_USER_CMD = $(call sed-cmd,travis_user,$(TRAVIS_USER))

# ------------------------------------------------------------------------------
# Help strings
# ------------------------------------------------------------------------------

target_help = $(FG_CYAN)%-17s$(RESET) %s

# ------------------------------------------------------------------------------
# Path strings
# ------------------------------------------------------------------------------

DIR_VAR = $(FG_CYAN)$(@D)$(RESET)
###FILE_VAR = $(FG_CYAN)$(FILE)$(RESET) # RLJ: Commented out. 23FEEB2019, RRLJ
FILE_VAR = $(FG_CYAN)$(@F)$(RESET)
SUBDIR_VAR = $(FG_CYAN)$(SUBDIR)$(RESET)

TARGET_VAR = $(FG_CYAN)$@$(RESET)

# ==============================================================================
# Macros
#
# A macro is a convenient way of defining a multi-line variable. Although the
# terms "macro" and "variable" are uused interchangeably in the GNU "make"
# manual, "macro" here will mean a variable that is defined using the "define"
# directive, not one that is defined using an asignment operator. By convention,
# macros are written in lowercase, and their words are separated by underscores.
# ==============================================================================

define usage_help

Usage:
  make = make $(TARGET_ARG) $(MAKE_ARGS)

Targets:

endef
export usage_help

define update-file
	@sed -f $< $@ > $@.tmp
	@mv $@.tmp $@
endef

# ==============================================================================
# User-Defined Functions
#
# A user-defined function is a variable or macro that includes one or more
# temporary variables ($1, $2, etc.) in its definition. By convention, user-
# defined function names use lowercase words separated by dashes.  For more
# info, see:
# 1. https://www.gnu.org/software/make/manual/html_node/Call-Function.html
# 2. https://www.oreilly.com/openbook/make3/book/ch11.pdf
# 3. https://www.oreilly.com/openbook/make3/book/ch04.pdf
# ==============================================================================

# $(call result,formatted-string)
# Prints success string, $(DONE) or $(PASSED), if the most recent return code
# value equals 0; otherwise, print $(FAILED) and the associated error message.
define result
	([ $$? -eq 0 ] && printf "$1") || \
	(printf "$(FAILED)\n" && cat $(LOG) && echo)
endef

# $(call sed-cmd,template-var,replacement)
# Generates a sed command for replacing Cookiecutter template variables with
# appropriate values.
define sed-cmd
	's/{{ cookiecutter.$1 }}/$2/g'
endef

# ==============================================================================
# Phony Targets
#
# A phony target is a convenient name for a set of commands to be executed when
# an explicit request is made.  Its commands won't run if a file of the same
# name exists.  Two reasons to use a phony target are:
#
# 1. To avoid a conflict with a file of the same name;
# 2. To improve performance.
# ==============================================================================

# ------------------------------------------------------------------------------
# Main phony targets
# ------------------------------------------------------------------------------

.PHONY: help log

## help: Shows usage documentation.
help:
	@printf "$$usage_help"
#	@cat $(MAKEFILE_LIST) | \
#	egrep '^[a-zA-Z_-]+:.*?##' | \
#	sed -e 's/:.* ##/: ##/' | sort -d | \
#	awk 'BEGIN {FS = ":.*?## "}; {printf "  $(target_help)\n", $$1, $$2}'
	@cat $(MAKEFILE_LIST) | \
	egrep '^## [a-zA-Z_-]+: ' | sed -e 's/## //' | sort -d | \
	awk 'BEGIN {FS = ": "}; {printf "  $(target_help)\n", $$1, $$2}'
	@echo ""

## log: Shows the most recently generated log for a specified release.
log:
	@echo
	#@set -e; \
	#LOG==$$(ls -l $(LOGS_DIR)/* | head -1); \
	#printf "Showing the most recent log: $(LOG_FILE)\n"; \
	#echo; \
	#cat $$LOG
	printf "Showing the most recent log: $(LOG_FILE)\n"
	@echo
	@cat $(LOG_FILE)

# ------------------------------------------------------------------------------
# Prerequisite phony targets for the "debug" target
# ------------------------------------------------------------------------------

.PHONY: debug-dirs-ll debug-dirs-tree debug-vars-all debug-vars-some

## debug-dirs-ll: Shows the contents of directories in a "long listing" format.
debug-dirs-ll:
	ls -alR $(PREFIX)

## debug-dirs-tree: Shows the contents of directories in a tree-like format.
debug-dirs-tree:
	tree -a $(PREFIX)

## debug-vars-all: Shows all Makefile variables (i.e., built-in and custom).
debug-vars-all:
	@echo
	$(foreach v, $(.VARIABLES), $(info $(v) = $($(v))))

## debug-vars-some: Shows only a few custom Makefile variables.
debug-vars-some:
	@echo
	$(foreach v, $(VARIABLES_TO_SHOW), $(info $(v) = $($(v))))

# ==============================================================================
# Directory Targets
# ==============================================================================

# Makes a directory tree.
%/.: | $(LOG)
	@printf "Making directory tree $(DIR_VAR)..."
	@mkdir -p $(@D) >$(LOG) 2>&1; \
	$(STATUS_RESULT)

# ==============================================================================
# File Targets
# ==============================================================================

# Downloads a file.
# https://stackoverflow.com/questions/32672222/how-to-download-a-file-only-if-more-recently-changed-in-makefile
%.download: | $(LOG) 
#	$(eval FILE = $(basename $@))
	@printf "Downloading file $(FILE_VAR)..."
	@curl -s -S -L -f $(FILE_URL)/$(FILE) -z $(FILE) -o $@ >$(LOG) 2>&1; \
	mv -n $@ $(FILE) >>$(LOG) 2>&1; \
	$(STATUS_RESULT)

# Makes a special empty file for marking that a directory tree has been generated.
#%/.gitkeep:
#	@printf "Making directory tree for marker file $(TARGET_VAR)..."
#	@printf "Making marker file $(TARGET_VAR) and its directory tree..."
#	@mkdir -p $(@D); $(STATUS_RESULT)
#	@printf "Making marker file $(TARGET_VAR)..."
#	@touch $@; $(STATUS_RESULT)

# ==============================================================================
# Intermediate Targets
#
# An intermediate target corresponds to a file that is needed on the way from a
# source file to a target file.  It typically is a temporary file that is needed
# only once to generate the target after the source changed.  The "make" command
# automatically removes files that are identified as intermediate targets.  In
# other words, such files that did not exist before a "make" run executed do not
# exist after a "make" run.
# ==============================================================================

.INTERMEDIATE: $(LOG)

# Makes a temporary file capturring a shell command error.
$(LOG):
	@touch $@

# ==============================================================================
# Second Expansion Targets
# ==============================================================================

.SECONDEXPANSION:
#$(PREFIX)/%.dummy: $$(@D)/.dummy | $$(@D)/. ## Make a directory tree.
