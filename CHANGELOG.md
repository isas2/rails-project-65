# Доска объявлений

## 0.2.0 (29.08.2024)

* Можно удалить тесты в test/models, всё равно там ничего нет

* https://ror.zabedu.ru/profile - выдаёт 500ю без логина, должно быть флэш сообщение и редирект на главную

* При клике на архивацию должен быть конфирм, как для любого опасного действия (в админке и в профиле пользователя)

  - исправлено

* Please review the problems below: - нет перевода при возникновении ошибок валидации в формах

  - было исправлено в предыдущем коммите, которого не было на проде

* Картинки объявлений на главной растягиваются, если они по соотношению сторон не подходят в рамку. Нужно добавить css правило для них, посмотри в эталон

  - Add new file stylesheets/custom.css and create new css class;
  - Add import to application.bootstrap.scss: '@import "custom"';
  - Run 'yarn run build:css' to recompile the CSS assets;
  - Now you can see custom-class in builds/application.css alongside with bootstrap css.

## 0.1.0 (27.08.2024)

Первый тестовый релиз приложения