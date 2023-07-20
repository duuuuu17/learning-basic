#
# Makefile for cprogramminglab
#

CC = clang
CLANG_FORMAT = clang-format

CFLAGS = -std=c99 -Og -g -Wall -Wextra -Wpedantic -Wconversion
CFLAGS += -Wstrict-prototypes -Wwrite-strings -Werror

# Targets to compile
HANDIN_TAR = cprogramminglab-handin.tar
FILES = qtest $(HANDIN_TAR)

.PHONY: all
all: $(FILES)

# List header dependencies
qtest.o: harness.h queue.h report.h console.h
harness.o: harness.h
console.o: report.h console.h
report.o: report.h
queue.o: harness.h queue.h

# Compile object files
%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

# Compile qtest binaries
qtest: qtest.o report.o console.o harness.o queue.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

# Compile certain targets with ASan and UBSan
ASAN_TARGETS = qtest
$(ASAN_TARGETS): CFLAGS += -fsanitize=address,undefined
$(ASAN_TARGETS): LDFLAGS += -fsanitize=address,undefined $(LLVM_RSRC_DIR)

.PHONY: test
test: qtest driver.py
	chmod +x driver.py
	./driver.py

.PHONY: clean
clean:
	rm -rf $(FILES)
	rm -rf *.o *~ *.pyc *.dSYM
	(cd traces; rm -f *~)

# Include rules for submit, format, etc
FORMAT_FILES = queue.c queue.h
HANDIN_FILES = queue.c queue.h .clang-format
include helper.mk
