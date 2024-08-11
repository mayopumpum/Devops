#include "s21_cat.h"

void init_opt(struct get_opt *opt) {
  opt->b = 0;
  opt->e = 0;
  opt->n = 0;
  opt->s = 0;
  opt->t = 0;
  opt->v = 0;
}

int check_flag_str(char *flag, int *flag_error,
                   struct get_opt *opt) {  // проверка полного флага с --

  if (strcmp(flag, "--number-nonblank") == 0) {
    opt->b = 1;
  } else if (strcmp(flag, "--number") == 0) {
    opt->n = 1;
  } else if (strcmp(flag, "--squeeze-blank") == 0) {
    opt->s = 1;
  } else {
    *flag_error = 1;
  }
  return *flag_error;
}

int check_flag(int argc, char **argv, struct get_opt *opt,
               int *flag_error) {  // проверка флага
  for (int i = 1; i < argc; i++) {
    if (argv[i][0] == '-' && argv[i][1] == '-') {
      *flag_error = check_flag_str(argv[i], flag_error, opt);
    }
    if (argv[i][0] == '-' && argv[i][1] != '-' && (strlen(argv[i]) > 1)) {
      for (size_t j = 1; j < strlen(argv[i]); j++) {
        if (argv[i][j] == 'b') {
          opt->b = 1;
        } else if (argv[i][1] == 'e') {
          opt->e = 1;
          opt->v = 1;
        } else if (argv[i][1] == 'n') {
          opt->n = 1;
        } else if (argv[i][1] == 's') {
          opt->s = 1;
        } else if (argv[i][1] == 't') {
          opt->t = 1;
          opt->v = 1;
        } else if (argv[i][1] == 'v') {
          opt->v = 1;
        } else if (argv[i][1] == 'E') {
          opt->e = 1;
        } else if (argv[i][1] == 'T') {
          opt->t = 1;
        } else {
          *flag_error = 1;
          break;
        }
      }
    }
  }
  if (opt->b && opt->n) opt->n = 0;
  return *flag_error;
}

void print_number_line(int *count) {
  printf("%6d\t", *count);
  *count += 1;
}

void non_print_symbols(char *print_char) {
  if ((*print_char >= 0 && *print_char < 9) ||
      (*print_char > 10 && *print_char < 32)) {
    printf("^");
    *print_char += 64;
  } else if (*print_char == 127) {
    printf("^");
    *print_char -= 64;
  }
}

void print_file(FILE *f_in, struct get_opt *opt, int *count) {
  char print_char;
  char tmp_char = '\n';
  int repeat_count = 0;

  while ((print_char = fgetc(f_in)) != EOF) {
    if (opt->s && print_char == '\n' && tmp_char == '\n') {
      repeat_count += 1;
      if (repeat_count > 1) {
        continue;
      }
    } else {
      repeat_count = 0;
    }
    if (tmp_char == '\n' && ((opt->b && print_char != '\n') || opt->n)) {
      print_number_line(count);
    }
    if (opt->t && print_char == '\t') {
      printf("^");
      print_char = 'I';
    }
    if (opt->e && print_char == '\n') {
      printf("$");
    }
    if (opt->v) {
      non_print_symbols(&print_char);
    }
    printf("%c", print_char);
    tmp_char = print_char;
  }
}

void open_file(char **argv, struct get_opt *opt, int *count) {
  int i = 1;

  for (; argv[i]; i++) {
    if (argv[i][0] == '-') {
      continue;
    }
    FILE *f_in = NULL;
    if ((f_in = fopen(argv[i], "r")) != NULL) {
      print_file(f_in, opt, count);
    } else {
      fprintf(stderr, "%s: No such file or directory\n", argv[i]);
    }
    if (f_in != NULL) fclose(f_in);
  }
}

int main(int argc, char **argv) {
  int flag_error = 0;
  int count = 1;
  struct get_opt opt;
  init_opt(&opt);

  if (argc > 1) {
    check_flag(argc, argv, &opt, &flag_error);
    if (flag_error == 0) {
      open_file(argv, &opt, &count);
    } else {
      fprintf(stderr, "Eror_flag\n");
    }
  } else {
    fprintf(stderr, "Not enough arguments\n");
  }
  return 0;
}
