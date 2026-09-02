# Makefile for COS284 Assembly Practical 1

ASM      = yasm
ASMFLAGS = -f elf64 -g dwarf2
LINKER   = ld
TARGETS  = task1 task2 task3 task4 task5
SOURCES  = $(TARGETS:=.asm)

.PHONY: all clean run-all zip

all: $(TARGETS)

task%: task%.o
	$(LINKER) -o $@ $^

task%.o: task%.asm
	$(ASM) $(ASMFLAGS) -o $@ $<

run%: task%
	./$<

run-all: $(TARGETS)
	@for t in $(TARGETS); do \
		echo "=== Running $$t ==="; \
		./$$t; \
		echo; \
	done

# Create submission zip
zip: clean
	zip u25004141.zip $(SOURCES)

clean:
	rm -f $(TARGETS) u25004141.zip