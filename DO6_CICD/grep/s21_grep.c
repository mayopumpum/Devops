#include "s21_grep.h"

void init_opt(struct get_opt *opt) {
  opt->e = 0;
  opt->i = 0;
  opt->v = 0;
  opt->c = 0;
  opt->l = 0;
  opt->n = 0;
  opt->h = 0;
  opt->s = 0;
  opt->f = 0;
  opt->o = 0;
}

int file_size(FILE *f_input) {
  fseek(f_input, 0, SEEK_END);
  int size = ftell(f_input);
  fseek(f_input, 0, SEEK_SET);
  return size;
}

void flag_f(char *f_name, int *count, int *flag_error, char **search_string) {
  FILE *f_inp = fopen(f_name, "r*");
  if (f_inp != NULL) {
    long len = file_size(f_inp);
    while (fgets(search_string[*count], len, f_inp) != NULL) {
      int tmp_len = strlen(search_string[*count]);
      int str_len =
          search_string[*count][tmp_len - 1] == '\n' ? tmp_len : tmp_len + 1;
      search_string[*count][str_len - 1] = '\0';
      *count += 1;
    }
  } else
    *flag_error = 1;
  if (f_inp != NULL) {
    fclose(f_inp);
  }
}

int check_flag(int argc, char **argv, struct get_opt *opt, int *flag_error,
               char **search_string, int *count) {  //проверка флага
  for (int i = 1; i < argc; i++) {
    if (argv[i][0] == '-') {
      for (size_t j = 1; j < strlen(argv[i]); j++) {
        if (argv[i][j] == 'e') {
          if (argv[i][j + 1]) {
            opt->e = 1;
            snprintf(search_string[*count], BUFFER_SIZE, "%s", &argv[i][j + 1]);
            *count += 1;
            memset(argv[i], '\0', strlen(argv[i]));
          } else if (argv[i + 1] && argv[i + 1][0] != '-') {
            opt->e = 1;
            snprintf(search_string[*count], BUFFER_SIZE, "%s", argv[i + 1]);
            memset(argv[i + 1], '\0', strlen(argv[i + 1]));
            *count += 1;
          } else {
            *flag_error = 1;  //ошибка шаблона
            break;
          }
        } else if (argv[i][j] == 'i') {
          opt->i = 1;
        } else if (argv[i][j] == 'v') {
          opt->v = 1;
        } else if (argv[i][j] == 'c') {
          opt->c = 1;
        } else if (argv[i][j] == 'l') {
          opt->l = 1;
        } else if (argv[i][j] == 'n') {
          opt->n = 1;
        } else if (argv[i][j] == 'h') {
          opt->h = 1;
        } else if (argv[i][j] == 's') {
          opt->s = 1;
        } else if (argv[i][j] == 'f') {
          if (argv[i][j + 1]) {
            opt->f = 1;
            flag_f(&argv[i][j + 1], count, flag_error, search_string);
            memset(argv[i], '\0', strlen(argv[i]));
          } else if (argv[i + 1] && argv[i + 1][0] != '-') {
            opt->f = 1;
            flag_f(argv[i + 1], count, flag_error, search_string);
            memset(argv[i + 1], '\0', strlen(argv[i + 1]));
          } else {
            *flag_error = 1;
            break;
          }
        } else if (argv[i][j] == 'o') {
          opt->o = 1;
        } else {
          *flag_error = 1;
          break;
        }
      }
      memset(argv[i], '\0', strlen(argv[i]));  //затираем аргумент
    }
  }
  return *flag_error;
}

void search(FILE *f_input, struct get_opt *opt, char **sample, char *file_name,
            int file_amount, int count) {
  regex_t REGEX;
  regmatch_t pmatch[1];
  int regflag = REG_EXTENDED;
  char num_str[12] = {0};
  int line_number = 1, line_amount = 0;
  int filesize = file_size(f_input);
  char *text_in_file = calloc(filesize + 1, sizeof(char));
  char *f_name = calloc(strlen(file_name) + 2, sizeof(char));
  char pattern[100] = {0};
  if (!(opt->h) && file_amount > 1) {
    strcpy(f_name, file_name);
    f_name[strlen(file_name)] = ':';
  }
  if (opt->i) {
    regflag = REG_ICASE;
  }
  strcat(pattern, sample[0]);
  for (int i = 1; i < count; i++) {
    strcat(pattern, "|");
    strcat(pattern, sample[i]);
  }
  regcomp(&REGEX, pattern, regflag);
  while (fgets(text_in_file, filesize, f_input) != NULL) {
    int res = (regexec(&REGEX, text_in_file, 1, pmatch, 0) == 0);
    if (opt->v) {
      res = !res;
    }
    if (res) {
      line_amount += 1;
      if (strchr(text_in_file, '\n') == NULL) {
        strcat(text_in_file, "\n");
      }
      if (opt->l) {
        break;
      }
      if (!opt->c) {
        if (opt->n && opt->v && !opt->h && opt->o) {
          continue;
        }
        if (opt->n) {
          sprintf(num_str, "%d:", line_number);
        }
        printf("%s%s", f_name, num_str);
        if (opt->o) {
          char *current_str = text_in_file;
          int j = 0;
          while (regexec(&REGEX, current_str, 1, pmatch, 0) == 0) {
            if (opt->n && j > 0) {
              printf("%s%d:", f_name, line_number);
            }
            for (int i = pmatch[0].rm_so; i < pmatch[0].rm_eo; i++) {
              printf("%c", current_str[i]);
            }
            printf("\n");
            current_str += pmatch[0].rm_eo;
            j += 1;
          }
        } else {
          printf("%s", text_in_file);
        }
      }
    }
    line_number += 1;
  }
  if (opt->c && !(opt->l)) {
    printf("%s%d\n", f_name, line_amount);
  }
  if (opt->l && line_amount > 0) {
    printf("%s\n", file_name);
  }
  free(text_in_file);
  free(f_name);
  regfree(&REGEX);
}

void open_file(char **argv, struct get_opt *opt, char **sample, int *count) {
  int i = 1, j = 1, file_amount = 0;
  for (; argv[j]; j++) {
    if (argv[j][0] != '\0') {
      file_amount += 1;
    }
  }
  for (; argv[i]; i++) {
    if (argv[i][0] == '\0') {
      continue;
    }
    FILE *f_input = NULL;
    if ((f_input = fopen(argv[i], "r")) != NULL) {
      search(f_input, opt, sample, argv[i], file_amount, *count);
    } else {
      if (!opt->s)
        fprintf(stderr, "grep: %s: No such file or directory\n", argv[i]);
    }
    if (f_input != NULL) {
      fclose(f_input);
    }
  }
}

int main(int argc, char **argv) {
  int flag_error = 0, count = 0;
  ;
  char **search_string;
  search_string = (char **)malloc(SIZE * sizeof(char *));
  for (int i = 0; i < SIZE; i++) {
    search_string[i] = (char *)malloc(BUFFER_SIZE * sizeof(char));
  }
  struct get_opt opt;
  init_opt(&opt);

  if (argc > 2) {
    check_flag(argc, argv, &opt, &flag_error, search_string, &count);
    if (flag_error == 0) {
      if (!opt.e &&
          !opt.f) {  //поиском становится первый аргумент не являющийся флагом
        for (int i = 1; i < argc; i++) {
          if (argv[i][0] != '\0') {
            snprintf(search_string[0], BUFFER_SIZE, "%s", argv[i]);
            memset(argv[i], '\0', strlen(argv[i]));
            break;
          }
        }
      }
      open_file(argv, &opt, search_string, &count);
    } else {
      fprintf(stderr, "Eror_flag\n");
    }
  } else {
    fprintf(stderr, "Not enough arguments\n");
  }
  for (int i = 0; i < SIZE; i++) {
    free(search_string[i]);
  }
  free(search_string);
  return 0;
}