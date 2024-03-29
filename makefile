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

# you will see every target in help if there is a ## comment 2 lines before the target
help:
		@printf "Available targets:\n\n"
		@printf "to add an entry you need to add ## as comment before the target \n\n"
		@awk '/^[a-zA-Z\-_0-9%:\\]+/ { \
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
# uncomment to see entries 
# $(info $(ALLMAKEFILES))
ALLMAKEFILES := $(wildcard tasks/*/*)



# Convert each Makefile path into unique target name 
VERSION_TARGETS := $(ALLMAKEFILES:%=VERSION-%)

# Debug print
# $(info $(ALLMAKEFILES))
# $(info $(VERSION_TARGETS))


# Convert each Makefile path into unique target name to call e.g. version
VERSION_TARGETS := $(ALLMAKEFILES:%=version-%)

# Debug print

# $(info $(VERSION_TARGETS))

##  Default target
all/version: $(VERSION_TARGETS)
		@echo "Makefiles processed "

##  Rule to process each Makefile

$(VERSION_TARGETS):
# move to each dir -C $(dir $@)
# use each makefile -f $(notdir $@)
# as all targets are namespaced we can call 'version' from each makefile  $(subst .,,$(suffix $(notdir $(@:install-%=%))))
		@echo "Calling Makefile in $(dir $(@:version-%=%))"
		@echo ""
		$(MAKE) -C $(dir $(@:version-%=%)) -f $(notdir $(@:version-%=%)) $(subst .,,$(suffix $(notdir $(@:install-%=%))))/version --no-print-directory 
		@echo ""


.PHONY: help

## rendiering of subsequent help screens comes from https://docs.cloudposse.com/reference/best-practices/make-best-practices/#help-target

default: help