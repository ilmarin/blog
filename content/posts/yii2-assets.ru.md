+++
date = "2017-02-24T15:29:39+05:00"
title = "Неочевидные моменты при работе с assets в Yii2"
tags = ["yii","php"]
aliases = ["/post/yii2-assets"]
+++

Недавно пришлось настраивать сжатие ассетов Yii2 на одном из проектов. Для этого во фреймворке предусмотрен удобный cli-интерфейс. Работа с ним вкратце описана в [документации](http://www.yiiframework.com/doc-2.0/guide-structure-assets.html#combining-compressing-assets).

Ниже перечислен ряд моментов, которые для меня оказались не очевидны.

## Advanced-шаблон и алиас @app

В проекте я использую [advanced-шаблон](https://github.com/yiisoft/yii2-app-advanced). Он позволяет разделять проект на три части:

* Для пользователя (frontend)
* Для администраторов и контент-менеджеров (backend)
* Для работы с cli-интерфейсом приложения (console)

Для каждой из частей проекта так же предусмотрены алиасы `@frontend`, `@backend` и `@console` соответственно.

Однако у моих ассетов во frontend-части в свойстве `sourcePath` был прописан алиас `@app` вместо `@frontend`.

В этом не было ничего страшного до тех пор, пока не стало нужно выполнить минификацию ресурсов с помощью предоставляемого фреймворком инструментария.

Как выяснилось, алиас `@app` для консоли в случае с advanced-шаблоном указывает на алиас `@console` и ассеты пытались распаковаться туда, что и сбивало с толку инструмент. Тот случай, когда неплохо бы лишний раз читать [доки](https://github.com/yiisoft/yii2-app-advanced/blob/master/docs/guide/structure-path-aliases.md). :)

**Вывод:** в случае использования advanced-шаблона, нужно проверить, что ассеты, расположенные во frontend/assets используют в `sourcePath` алиас `@frontend` вместо `@app`. Аналогично и для backend-части приложения.

## Ошибка file_put_contents

Функция file_put_contents падает с ошибкой в случае несуществующего пути до папки.

**Вывод:** следует проверять, что все пути к папкам в конфиге сжатия ассетов верные.

## Невозможность доступа к baseUrl ассета после минификации

На заре создания проекта я хранил всю frontend-статику в папке assets. Путь до папки с финальными ассетами я получал комбинацией:

```php
$asset = frontend\assets\AppAsset::register($this);
echo $asset->baseUrl;
```

Оказалось, это плохая практика. После сжатия свойство `baseUrl` у ассетов зануляется и картинки, шрифты и прочие вещи, которые до этого прекрасно отображались, перестают работать в production-окружении (в dev-окружении все в порядке).

Пришлось вынести папки со шрифтами и картинками в публичную часть сайта, а относительные пути в css переделать на абсолютные.

**Вывод:** в assets лучше хранить только то, что будем сжимать. Остальное выносить в публичную часть. К тому же так лишний раз не копируются большие объемы данных.

## Не все расширения фреймворка совместимы с инструментом сжатия ассетов

Об этом прямо указывается в [документации](http://www.yiiframework.com/doc-2.0/guide-structure-assets.html#combining-compressing-assets) в желтой сноске в конце параграфа *An Example*, но я помучался с этой ошибкой.

Выглядит это так: ассеты прекрасно сжимаются, но на странице подключаются дважды (минифицированная версия и еще раз несовместимые ассеты из отдельной папки).

В итоге эти расширения пришлось исключить из минификации, а подключаются они на странице отдельно как и раньше, что, конечно же, увеличивает число запросов к серверу.

**Вывод:** иметь в виду эту особенность при работе с расширениями использующими динамическое задание параметров ассетов в методе `init()`.
