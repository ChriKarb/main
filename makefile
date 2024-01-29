# Makefile



## uses some best practise from
# https://docs.cloudposse.com/reference/best-practices/make-best-practices/#help-target
# - we use namespaces in makefiles : component/command
# - we use submakefiels for each component : Makefile.component

## 
# we add env variables only by using make
#

## we use some general commitments
# we have the following lifecycle command we use
# install 
# needs
# 

## common env 

DRY_RUN ?= false
WORKLOAD_VERSION ?= v1.5.1
CLUSTER ?= minikube 


# First lets include other Makefiles we want to use

-include tasks/*/Makefile.*

## This help screen
help:
		@printf "Available targets:\n\n"
		@awk '/^[a-zA-Z\-\_0-9%:\\]+/ { \
			helpMessage = match(lastLine, /^## (.*)/); \
			if (helpMessage) { \
				helpCommand = $$1; \
				helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
				gsub("\\\\", "", helpCommand); \
				gsub(":+$$", "", helpCommand); \
				printf "  \x1b[32;01m%-35s\x1b[0m %s\n", helpCommand, helpMessage; \
			} \
        } \
        { lastLine = $$0 }' $(MAKEFILE_LIST) | sort -u
		@printf "\n"

# Parent Makefile

## Find all Makefiles in the specified subfolder
ALLMAKEFILES := $(wildcard tasks/*/*)

##  Default target
all/install: $(ALLMAKEFILES)

##  Rule to process each Makefile
$(ALLMAKEFILES):
# move to each dir -C $(dir $@)
# use each makefile -f $(notdir $@)
# as all are namespaced call install from each makefile  $(subst .,,$(suffix $@))/install
		$(MAKE) -C $(dir $@) -f $(notdir $@) $(subst .,,$(suffix $@))/install



.PHONY: help

## rendiering of subsequent help screens comes from https://docs.cloudposse.com/reference/best-practices/make-best-practices/#help-target

default: help