+++
date = "2018-01-07T15:40:09+05:00"
title = "Реализация RESTful API в Yii2"
tags = ["yii","php"]
aliases = ["/post/yii2-rest"]
+++

Yii2 из коробки предоставляет удобный фреймворк для построения REST API вашего сервиса. Ниже я опишу как быстро начать его использовать.

## Предварительная настройка

Для начала работы достаточно [базового шаблона](https://github.com/yiisoft/yii2-app-basic) Yii2. Создание проекта и настройку виртуального хоста я описывать не буду и перейду сразу к настройке REST.

После скачивания проекта настроим компоненту `user` в файле `web.php`. Добавим туда следующие строки:

```php
'enableSession' => false,
'loginUrl' => null,
```

Первая строка отключает сохранение состояния пользователя на сервере: одно из требований архитектуры REST.

Вторая строка отключает перенаправление на страницу входа после неудачной аутентификации.

В `User.php` добавим следующий код:

```php
public static function getAll()
{
   $result = [];

   foreach (self::$users as $user) {
       $result[] = [
           'id' => $user['id'],
           'username' => $user['username'],
       ];
   }

   return $result;
}
```

## Создание контроллера

Мы не используем базу данных в нашем примере и создание контроллера займет чуть больше времени, чем в случае использования AR-моделей.

В папке `controllers` создадим файл `UserController.php` со следующим содержимым:

```php
<?php
namespace app\controllers;

use yii\rest\Controller;
use app\models\User;

class UserController extends Controller
{
    public function actionIndex()
    {
        return User::getAll();
    }

    /**
     * @inheritdoc
     */
    protected function verbs()
    {
        return [
            'index' => ['GET', 'HEAD'],
        ];
    }
}

```

Как видно из примера, мы наследуем свой класс от `yii\rest\Controller`. Данный класс реализует поддержку сериализации и представления массивов в форматах XML и JSON перед отправкой ответа. Дополнительно можно задать параметры аутентификации и ограничить количесто запросов к API.

Метод `verbs` позволяет задать типы запросов, которые принимает каждое из действий контроллера.

Чтобы контроллер заработал, нужно отредактировать настройки компоненты `urlManager` в файле `web.php`:

```php
'rules' => [
    ['class' => 'yii\rest\UrlRule', 'controller' => 'user'],
],
```

Протестируем работу API, используя curl:

```
$ curl -i -H "Accept:application/json" "http://yii2-rest.dev/users"
$ curl -i -H "Accept:application/xml" "http://yii2-rest.dev/users"
```

> Вместо yii2-rest.dev нужно указать имя вашего хоста.

## Аутентификация

> При реализации любого из методов аутентификации в продакшене не забывайте об использовании https для предотвращения атаки типа "человек посередине"

Yii2 поддерживает [несколько](http://www.yiiframework.com/doc-2.0/guide-rest-authentication.html) типов аутентификации. Реализуем __HTTP Basic Auth__.

В `UserContoller.php` добавим следующие строки:

```php
public function behaviors()
{
    $behaviors = parent::behaviors();
    $behaviors['authenticator'] = [
        'class' => HttpBasicAuth::className(),
    ];

    return $behaviors;
}
```

Не забываем перед объявлением класса прописать:

```php
use yii\filters\auth\HttpBasicAuth;
```

Чтобы все заработало, модель пользователя должна реализовывать метод `findIdentityByAccessToken`. Если вы используете базовый шаблон Yii2, то он уже реализован и ничего менять не нужно.

Проверям работу механизма аутентификации:

```php
$ curl -i -H "Accept:application/json" "http://yii2-rest.dev/users"
```

Выполнение кода выше должно вернуть ошибку с кодом 401.

Пробуем авторизоваться, используя HTTP Basic Auth:

```php
$ curl -i -H "Accept:application/json" "http://yii2-task_manager.dev/users" -H "Authorization: Basic MTAwLXRva2VuOg=="
```

Должен вернуться полный список пользователей в json-ответе.

## Заключение

Я описал лишь один из вариантов реализации REST в Yii2. Без рассмотрения остались множество других тем, таких как версионирование, ограничение числа запросов и обработка ошибок. Многое из этого описано в [документации](http://www.yiiframework.com/doc-2.0/guide-rest-quick-start.html).


