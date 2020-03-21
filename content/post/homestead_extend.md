+++
title = "Добавление новых php-расширений в Homestead"
date = 2020-03-21T17:19:07+03:00
author = "Илья Маринин"
description = "Процесс добавления новых расширений в Homestead"
tags = ["homestead","php","laravel","symfony"]
+++

[Homestead](https://laravel.com/docs/6.x/homestead) &mdash; это набор конфигов от [Laravel](https://laravel.com/) виртуальной машины на базе [Vagrant](https://www.vagrantup.com/).

Новичкам иногда сложно сходу добавить новый функционал в виртуальную машину на базе Homestead.

Для примера дан простой набор шагов по добавлению php-расширения [APCu](https://www.php.net/manual/ru/book.apcu.php) в Homestead. Оно используется, например, в [Symfony](https://symfony.com/).

## Настраиваем Homestead

Находим в папке с Homestead файл `after.sh` и добавляем нужные строки:

```bash
#Install APCu
sudo apt-get -y \
    -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confold" \
    install php-apcu
```

## Пересобираем виртуальную машину

В терминале в папке с Homestead выполянем:

```bash
$ vagrant destroy
$ vagrant up --provision
```

## Проверяем результат

Там же выполняем:

```bash
$ vagrant ssh
```

Внутри виртуальной машины выполняем:

```bash
$ php -m | grep apcu
```

Мы должны увидеть в выводе `apcu`.

Аналогичным образом можно установить остальные недостающие расширения.