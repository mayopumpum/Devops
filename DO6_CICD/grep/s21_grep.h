#ifndef SRC_GREP_S21_GREP_H_
#define SRC_GREP_S21_GREP_H_

#include <regex.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFFER_SIZE 512
#define SIZE 1024

struct get_opt {
  int e;
  int i;
  int v;
  int c;
  int l;
  int n;
  int h;
  int s;
  int f;
  int o;
};

void init_opt(struct get_opt *opt);
int file_size(FILE *f_input);
void flag_f(char *f_name, int *count, int *flag_error, char **search_string);
int check_flag(int argc, char **argv, struct get_opt *opt, int *flag_error,
               char **search_string, int *count);
void search(FILE *f_input, struct get_opt *opt, char **sample, char *file_name,
            int file_amount, int count);
void open_file(char **argv, struct get_opt *opt, char **sample, int *count);

#endif  // SRC_GREP_S21_GREP_H_