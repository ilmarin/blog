+++
date = "2017-07-01T13:41:35+05:00"
title = "Установка Selenium Server на Ubuntu 16.04"
author = "Илья Маринин"
description = "Установка Selenium Server на Ubuntu 16.04"

+++

Для разработки простых сайтов часто написание модульных и функциональных тестов становится излишним. Иногда нужно просто удостовериться, что с точки зрения конечного пользователя все работает корректно: кнопки кликаются, всплывающие окна появляются, индикаторы меняют состояние, клиентская валидация срабатывает как нужно, а скрипт не валится с ошибкой при отправке формы. Функциональные тесты такой уверенности не дают, так как не умеют тестировать js-код, а тестировать форму в сотый раз руками занятие неблагодарное (особенно когда у нас много важной клиентской логики). Самую критичную и часто используемую логику сайта лучше дополнительно протестировать с помощью приемочных тестов.

Как мы знаем, для php существует [Codeception](http://codeception.com), который прекрасно интегрируются с таким чудесным инструментом как [Selenium](http://www.seleniumhq.org/).

В данной заметке я опишу, как установить и запустить Selenium Server на свой машине для облегчения разработки и запуска приемочных тестов.

Чтобы не отвелкаться на дополнительные инструкции примем за основу, что все необходимое окружение (веб-сервер, php, composer, jdk) уже установлено, а в самом composer.json проекта прописана зависимость от "codeception/codeception". Тестировать проект будем в Chrome (желательно обновиться до последней версии браузера).

Установка недостающего ПО
-------------------------

1. Первым делом удостоверимся, что установлены необходимые расширения php: `sudo apt-get install php-curl php-dom php-mbstring`;
2. Скачиваем последнюю версию Selenium Server [здесь](http://www.seleniumhq.org/download/) и копируем в удобную для себя папку;
3. Забираем последнюю версию ChromeDriver [тут](https://sites.google.com/a/chromium.org/chromedriver/downloads) и распаковываем в папку с Selenium Server;

Запуск
-------------------------

В accceptance.suite.yml прописываем необходимые параметры примерно так:

```
class_name: AcceptanceTester
modules:
    enabled:
        - WebDriver:
            url: https://test.dev
            host: 127.0.0.1
            browser: chrome
```
Запускаем сервер Selenium: 
```
java -Dwebdriver.chrome.driver=<selenium_server_dir>/chromedriver -jar <selenium_server_dir>/selenium-server-standalone-3.4.0.jar
```

 **selenium_server_dir** следует заменить на путь до папки с Selenium Server.

Идем в папку проекта и выполняем что-то вроде `vendor/bin/codecept run` . Данная команда попытается выполнить модульные, функциональные, а затем и приемочные тесты. В последнем случае откроется браузер Chrome в котором Selenium будет умело имитировать действия пользователя.

[Здесь](http://codeception.com/docs/modules/WebDriver) представлен API модуля WebDriver для Codeception, который можно использовать для написания собственных приемочных тестов.


