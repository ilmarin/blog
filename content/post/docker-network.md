+++
title = "Как связать два docker-контейнера"
date = 2018-02-27T15:54:49+05:00
author = "Илья Маринин"
description = "Как связать два docker-контейнера в одну сеть при помощи docker network"
tags = ["docker"]
+++

Порой при разработке возникает необходимость связать два ранее не связанных контейнера в одну сеть, чтобы быстро что-то протестировать. При этом не хочется писать новые файлы конфигурации.

Для этого в docker есть функционал по работе с сетью &mdash; `docker network`.

Например, из контейнера app мы хотим получить доступ к контейнеру service по имени, чтобы осуществить вызов API.

Пишем:

```bash
$ docker network create -d bridge api
$ docker network connect --alias app api 53
$ docker network connect --alias service api 4с
```

Первая команда создает новую сеть. Вторая и третья команды по очереди добавляют в нее существующие контейнеры. Параметр `alias` задает имя контейнера по которому к нему можно будет легко обратиться.

Теперь мы можем войти, например, в контейнер app и вызывать по http api контейнера service.

Подробнее про `docker network` можно прочесть [здесь](https://docs.docker.com/network/).