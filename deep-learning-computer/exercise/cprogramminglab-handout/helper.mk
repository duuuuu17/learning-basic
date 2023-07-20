SUBMIT_MESSAGE =
SUBMIT_MESSAGE += "I affirm that I have complied with this course's academic"
SUBMIT_MESSAGE += "integrity policy as defined at"
SUBMIT_MESSAGE += "https://www.cs.cmu.edu/~213/academicintegrity.html [y/N]: "

# Set course/lab variables
include .labname.mk

#####################################################################
# Validate variables
#####################################################################

ifndef COURSECODE
  $(error COURSECODE is not set)
endif
ifndef HANDIN_FILES
  $(error HANDIN_FILES is not set)
endif
ifndef FORMAT_FILES
  $(error FORMAT_FILES is not set)
endif

# Detect if we should submit separately
ifdef LAB_CHECKPOINT
  ifdef LAB_FINAL
    SUBMIT_SEPARATE = 1
  else
    $(error LAB_CHECKPOINT set, but not LAB_FINAL)
  endif
else
  ifdef LAB_FINAL
    $(error LAB_FINAL set, but not LAB_CHECKPOINT)
  endif
  ifndef LAB
    $(error LAB is not set)
  endif
endif

# Check handin parameters
ifdef HANDIN_TAR
  HANDIN_FILE = $(HANDIN_TAR)
else
  ifneq ($(words $(HANDIN_FILES)),1)
    $(error HANDIN_TAR not set, and HANDIN_FILES has more than one file)
  endif
  HANDIN_FILE = $(HANDIN_FILES)
endif

#####################################################################
# Rules to create and verify handin files
#####################################################################

ifdef HANDIN_TAR

$(HANDIN_TAR): $(HANDIN_FILES)
	tar cvf $@ $^

.PHONY: handin
handin: $(HANDIN_TAR)

else

.PHONY: handin
handin:
	@echo "There is no handin tar. Submit \"$(HANDIN_FILE)' directly."

endif

#####################################################################
# Rules to submit to Autolab
#####################################################################

ifdef SUBMIT_SEPARATE

.PHONY: submit
submit:
	@echo "Please use one of the following:"
	@echo "  make submit-checkpoint"
	@echo "  make submit-final"
	@exit 1

.PHONY: submit-checkpoint
submit-checkpoint: $(HANDIN_FILE)
	@echo
	@echo "================================================="
	@echo "Submitting to CHECKPOINT ($(LAB_CHECKPOINT))"
	@echo "================================================="
	@echo
	@echo -n $(SUBMIT_MESSAGE) | fold -s -w 76
	@read -n 1 && echo && echo $$REPLY | grep -iq "^y"
	@autolab submit $(COURSECODE):$(LAB_CHECKPOINT) $<

.PHONY: submit-final
submit-final: $(HANDIN_FILE)
	@echo
	@echo "================================================="
	@echo "Submitting to FINAL ($(LAB_FINAL))"
	@echo "================================================="
	@echo
	@echo -n $(SUBMIT_MESSAGE) | fold -s -w 76
	@read -n 1 && echo && echo $$REPLY | grep -iq "^y"
	@autolab submit $(COURSECODE):$(LAB_FINAL) $<

else

.PHONY: submit
submit: $(HANDIN_FILE)
	@echo -n $(SUBMIT_MESSAGE) | fold -s -w 76
	@read -n 1 && echo && echo $$REPLY | grep -iq "^y"
	@autolab submit $(COURSECODE):$(LAB) $<

endif

#####################################################################
# Rules to check code formatting
#####################################################################

CLANG_FORMAT ?= clang-format

.PHONY: format
format: $(FORMAT_FILES)
	$(CLANG_FORMAT) -style=file -i $(FORMAT_FILES)

.PHONY: check-format
check-format: .format-checked

.format-checked: $(FORMAT_FILES)
	CLANG_FORMAT=$(CLANG_FORMAT) LC_ALL=C ./check-format $^
	@touch .format-checked

#####################################################################
# Rules to verify executability of scripts
#####################################################################
# This is to catch and provide immediate help for the common mistake
# of unpacking the handout tarball on a Windows box, thus stripping
# all the executable bits, and then uploading all the files to a
# cluster machine one by one.

HANDOUT_SCRIPTS += check-format

.PHONY: check-scripts
check-scripts:
	@for script in $(HANDOUT_SCRIPTS); do				\
	  if [ ! -x "$$script" ]; then					\
	    scripts_nox="$$scripts_nox$$script ";			\
	  fi;								\
	done;								\
	if [ -n "$$scripts_nox" ]; then					\
	  if [ -d .git ]; then						\
	    thiscmd="these commands";					\
	  else								\
	    thiscmd="this command";					\
	  fi;								\
	  printf '%s\n'							\
	    "*** error: scripts without execute bit: $$scripts_nox"	\
	    "*** To fix this error, run $$thiscmd:"			\
	    "  chmod +x $$scripts_nox";					\
	  if [ "$$thiscmd" = "these commands" ]; then			\
	    printf '%s\n'						\
	      "  git commit -m 'Restore execute bit' -- $$scripts_nox"	\
	      "  git push";						\
	  fi;								\
	  exit 1;							\
	fi

all: check-scripts
format: check-scripts
