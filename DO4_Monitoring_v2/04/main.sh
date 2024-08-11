#!/bin/bash

codes=(200 201 400 401 403 404 500 501 502 503)
methods=(GET POST PUT PATCH DELETE)
pages=("/index.php" "/news.php" "/comment.php" "/topic.php")
paths=("" "/news" "/shop" "/forum")
agents=("Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer" "Microsoft Edge" "Crawler and bot" "Library and net tool")

function ip {
    echo $(($RANDOM % 256)).$(($RANDOM % 256)).$(($RANDOM % 256)).$(($RANDOM % 255))
}

function code {
    echo ${codes[$RANDOM % ${#codes[*]}]}
}

function method {
    echo ${methods[$RANDOM % ${#methods[*]}]}
}

function page {
    echo ${paths[$RANDOM % ${#paths[*]}]}${pages[$RANDOM % ${#pages[*]}]}
}

function agent {
    echo ${agents[$RANDOM % ${#agents[*]}]}
}

function generate {
    num=$((100 + $RANDOM % 901))
    date_start=`date -d "2021-02-01 12:00:00" "+%s"`
    for (( i=0; i<$num; i++ )); do
        date_start=$(( $date_start + 180 ))
        date_print=`date --date @$date_start`
        date=`echo $date_print | awk '{printf "%s/%s/%s:%s %s00\n", $2, $3, $4, $5, $6}'`
        echo -ne "$(ip) - - [$date] "
        echo \"$(method) $(page) HTTP/1.1\" $(code) $(($RANDOM + 100)) \"-\" \"$(agent)\"
    done
}

for (( day=1; day<6; day++ )); do
    generate $day > result_day$day.log
done

# Ответ сервера 2xx – Успешные коды ответа сервера (200 — 226)
    # 200 OK — Успешный запрос
    # 201 Created - Запрос на создание ресурса успешен
# Ответ сервера 4xx — Ошибка клиента (400 — 499)
    # 400 Bad Request — Плохой запрос. Из—за синтаксической ошибки запрос не был понят сервером.
    # 401 Unauthorized — Не авторизован. Ресурс требует идентификации пользователя.
    # 403 Forbidden — Запрещено. Сервер отказал в доступе к запрошенному ресурсу ввиду ограничений.
    # 404 Not Found — Не найдено. Сервер не нашел запрошенный ресурс по указанному адресу.
# Ответ сервера 5xx — Ошибка сервера (500 — 526)
    # 500 Internal Server Error — Внутренняя ошибка сервера. Любая внутренняя ошибка на стороне сервера не подпадающая под остальные ошибки из категории 5хх.
    # 501 Not Implemented — Не реализовано. Сервер не поддерживает, необходимых для обработки запроса, возможностей.
    # 502 Bad Gateway — Плохой шлюз. Сервер, работающий в качестве прокси или шлюза, получил сообщение о неудачное в промежуточной операции.
    # 503 Service Unavailable — Сервис недоступен. Сервер не в состоянии обрабатывать запросы клиентов по техническим причинам.