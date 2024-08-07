+++
date = "2017-04-16T11:19:59+05:00"
title = "Закончилось место на сервере"
tags = ["bash"]
aliases = ["/post/cannot-create-temp"]
+++

Начал замечать странности в поведении динамических сайтов на своем сервере. Залогинился и увидел, что перестало работать автодополнение команд. bash ругался таким текстом:

__cannot create temp file for here-document: No space left on device__

Первым делом решил посмотреть какие папки сколько места занимают. Перейдя в корневой раздел, выполнил:

```bash
$ sudo du -h --max-depth=1 ./
```

Папка tmp не разрослась и в целом все в пределах нормы.

В итоге выполнил

```bash
$ sudo apt-get autoremove -y
```

Оказалось, что лишних зависимостей в сумме набежало почти на гигабайт.

На всякий случай выполнил

```bash
$ sudo crontab -e
```

и прописал там

```bash
0 3 * * * /usr/bin/apt-get autoremove -y >> /var/www/cron.log
```

Теперь лишние зависимости будут оперативно удаляться.

__UPD:__

Спустя некоторое время место опять закончилось. Оказывается старые версии ядра и заголовки удалились не до конца. Помогли следующие скрипты [отсюда](https://askubuntu.com/questions/2793/how-do-i-remove-old-kernel-versions-to-clean-up-the-boot-menu):

```bash
dpkg --list | grep 'linux-image' | awk '{ print $2 }' | sort -V | sed -n '/'"$(uname -r | sed "s/\([0-9.-]*\)-\([^0-9]\+\)/\1/")"'/q;p' | xargs sudo apt-get -y purge
dpkg --list | grep 'linux-headers' | awk '{ print $2 }' | sort -V | sed -n '/'"$(uname -r | sed "s/\([0-9.-]*\)-\([^0-9]\+\)/\1/")"'/q;p' | xargs sudo apt-get -y purge
```

Здесь учитывается текущая версия ядра, так что лишнего удалить не получится.
