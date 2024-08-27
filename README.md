# Доска объявлений

### Hexlet tests and linter status:
[![Actions Status](https://github.com/isas2/rails-project-65/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/isas2/rails-project-65/actions)
[![CI](https://github.com/isas2/rails-project-65/actions/workflows/lint-test.yml/badge.svg)](https://github.com/isas2/rails-project-65/actions)

### Развёрнутое приложение (но это не точно)
[https://ror.zabedu.ru/](https://ror.zabedu.ru/).

### Описание

Доска объявлений - приложение, написанное на Ruby on Rails. Включает все стандартные функции для быстрого начала работы c приложением.

Основные возможности:

* Аутентификация пользователей через Github;
* Публикация и редактирование объявлений зарегистрированными пользователями блога;
* Выбор категории объявления при публикации;
* Прикрепление изображений к объявлениям;
* Модерация объявлений перед публикацией;
* Удобный поиск и постраничный доступ;
* Авторизация доступа пользователей;
* Выделенный раздел для администрирования категорий и объявлений.

### Установка зависимостей

```sh
make setup
```

### Запуск тестов

```sh
make test
```

### Запуск проверки синтаксиса

```sh
make lint
make lint-fix
```

### Лицензия

[MIT License](https://opensource.org/licenses/MIT).
