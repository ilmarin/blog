+++
date = "2017-11-18T20:59:11+05:00"
title = "Основы PHP_CodeSniffer"
tags = ["php"]
aliases = ["/post/php_code_sniffer"]
+++

В некоторых компаниях есть большая база долгоиграющих и постоянно изменяющихся проектов. Без неусыпного контроля база кода рискует превратиться в месиво из малочитаемых файлов. Вручную проверять код на соответствие стандартам занятие достаточно утомительное. Быстро появляется потребность в атоматизации процесса.

[PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer) - это инструмент для проверки кода на соответствие принятым соглашениям и (в некоторых случаях) автоматического его исправления после проверки.

## Установка и запуск

В самом простом случае можно выполнить такой код в папке с исходниками проекта:

```bash
$ curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
$ php phpcs.phar -h

$ curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar
$ php phpcbf.phar -h
```

Так же поддерживается установка через composer. Далее будет рассматриваться именно этот вариант.

Пропишем в composer.json следующий код:

```json
{
    "require-dev": {
        "squizlabs/php_codesniffer": "3.*"
    }
}
```

После обновления composer пробуем выполнить

```bash
$ ./vendor/bin/phpcs -h
$ ./vendor/bin/phpcbf -h
```

Первый скрипт проверяет код на соответствие стандартам и выдает отчет. Второй - исправляет, то что можно исправить автоматически.

Чтобы посмотреть перечень доступных стандартов, можно выполнить

```bash
$ ./vendor/bin/phpcs -i
```

Для вывода списка проверок интересующего стандарта (в данном случае PSR-2) выполняем:

```bash
$ ./vendor/bin/phpcs --standard=PSR2 -e
```

## Проверка кода

К примеру, при кодировании мы хотим следовать стандарту [PSR-2](http://www.php-fig.org/psr/psr-2/).

Выполняем в консоли:

```bash
$ ./vendor/bin/phpcs --standard=PSR2 -p ./
```

Данная команда проверит все файлы проекта на соответствие PSR-2. Все файлы нам не нужны, поэтому некоторые мы можем смело исключить:

```bash
$ ./vendor/bin/phpcs --standard=PSR2 -p --ignore=*/vendor/*,*/tests/*,*.css,*.js ./
```

В примере выше я исключил папки с тестами проекта, а так же третьесторонние модули и файлы js-скриптов и стилей css (PHP_CodeSniffer знает некоторые проверки для css и js-файлов тоже).

Если до первого запуска скрипта код никаким стандартам не соответствовал, то в логе нас ждет большая куча сообщений.

Быстро исправить некоторые простые вещи поможет выполнение следующего кода:

```bash
$ ./vendor/bin/phpcbf --standard=PSR2 -p --ignore=*/vendor/*,*/tests/*,*.css,*.js ./
```

Затем можно снова вызвать `phpcs` и доправить остальные замечания вручную.

## Что дальше?

В идеале PHP_CodeSniffer должен запускаться с определенной периодичностью. Желательно перед сдачей кода в master-ветку проекта. Оставим этот вопрос за пределами данной заметки.

Если в вашей компании есть свой ни на что не похожий code-style, то здесь вам поможет [написание собственного набора правил](https://github.com/squizlabs/PHP_CodeSniffer/wiki/Annotated-ruleset.xml) в формате xml.

В данном файле можно описать какие проверки следует выполнять, с какими параметрами запускать скрипты PHP_CodeSniffer и прочее.

После написания собственного набора правил, подключить его можно просто:

```bash
$ ./vendor/bin/phpcs --standard=path_to_my_ruleset/ruleset.xml
```

Желаю успеха в борьбе с беспорядком в коде!
