+++
title = "Установка пустого пароля для root-пользователя в MySQL 5.7"
author = "Илья Маринин"
date = "2017-03-02T21:34:25+05:00"
description = "Для локальной разработки с MySQL очень удобно использовать пустой пароль root-пользователя. Раньше его можно было задать пустым сразу при установке и спокойно работать. Начиная с версии MySQL 5.7 поведение изменилось."

+++
Для локальной разработки с MySQL очень удобно использовать пустой пароль root-пользователя. Раньше его можно было задать пустым сразу при установке и спокойно работать. Начиная с версии MySQL 5.7 поведение изменилось.

Теперь, если при установке указывается пустой пароль пользователя root, то изменяется схема подключения для него с TCP/IP на локальный socket. Сделано это, как не трудно догадаться, в целях безопасности.

Выражается, например, в том, что команды вроде

```bash
$ mysql -uroot
```

отказываются работать. Нужно использовать для этого `sudo`. В том числе через `sudo` нужно запускать MySQL Workbench, что быстро надоедает.

## Решение

Открываем консоль и пишем:

```bash
$ sudo mysql -uroot

mysql> ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY ''; 
mysql> flush privileges;
mysql> quit

```

Теперь можно спокойно соединяться с сервером MySQL, используя текущего пользователя:

```bash
$ mysql -uroot
```