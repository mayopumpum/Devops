CC = gcc
CFLAGS =-Wall -Wextra -Werror -std=c11
ALL_PATHS = *.c *.h 

.PHONY: s21_grep clean

s21_grep:
	$(CC) $(CFLAGS) s21_grep.c -o s21_grep

style:
	@ echo
	@ echo "*** STYLE ***"
	cp ../../materials/linters/.clang-format .clang-format
	clang-format -n $(ALL_PATHS)
	@ echo
	@ echo "*** CHECK ***"
	cppcheck --enable=all --suppress=missingIncludeSystem $(ALL_PATHS)

leaks:
	./test_leak_grep.sh

test:
	./test_func_grep.sh

clean:
	rm s21_grep