#ifndef SRC_GREP_S21_GREP_H_
#define SRC_GREP_S21_GREP_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct get_opt {
  int b;
  int e;
  int n;
  int s;
  int t;
  int v;
};

int check_flag_str(char *flag, int *flag_error, struct get_opt *opt);
int check_flag(int argc, char **argv, struct get_opt *opt, int *flag_error);
void print_number_line(int *count);
void non_print_symbols(char *print_char);
void print_file(FILE *f_in, struct get_opt *opt, int *count);
void open_file(char **argv, struct get_opt *opt, int *count);

#endif  // SRC_GREP_S21_GREP_H_