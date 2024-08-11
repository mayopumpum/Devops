CC = gcc
CFLAGS =-Wall -Wextra -Werror -std=c11
ALL_PATHS = *.c *.h 

.PHONY: s21_cat clean

s21_cat:
	$(CC) $(CFLAGS) s21_cat.c -o s21_cat

style:
	@ echo
	@ echo "*** STYLE ***"
	cp ../../materials/linters/.clang-format .clang-format
	clang-format -n $(ALL_PATHS)
	@ echo
	@ echo "*** CHECK ***"
	cppcheck --enable=all --suppress=missingIncludeSystem $(ALL_PATHS)

leaks:
	./test_leak_cat.sh

test:
	./test_func_cat.sh

clean:
	rm s21_cat
