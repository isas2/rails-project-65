# Доска объявлений

## 0.4.0 (04.09.2024)

* https://github.com/isas2/rails-project-65/blob/9867714eeda94eaa5758f6f611322210156f342e/app/controllers/web/application_controller.rb#L12-L18 - не оставляй закомментированный код, пожалуйста

* https://github.com/isas2/rails-project-65/blob/9867714eeda94eaa5758f6f611322210156f342e/app/controllers/web/application_controller.rb#L20 - а зачем ты это так высоко вынес, если это нужно только в одном конкретном контроллере?

* https://github.com/isas2/rails-project-65/blob/9867714eeda94eaa5758f6f611322210156f342e/app/controllers/web/application_controller.rb#L7-L8 - вот это тоже отлично ляжет в AuthConcern

  ```
  module AuthConcern
    def self.included(base)
      base.helper_method :current_user
      base.helper_method :user_signed_in
    end
  end
  ```
  - Спасибо! Так гораздо лучше.

* https://github.com/isas2/rails-project-65/blob/9867714eeda94eaa5758f6f611322210156f342e/app/controllers/web/auth_controller.rb - хорошо бы добавить флэш сообщения об успешном/неуспешном входе. На выход можно тоже. Пользователям удобно, когда они явно видят, что что-то произошло при нажатии на кнопку

* https://github.com/isas2/rails-project-65/blob/9867714eeda94eaa5758f6f611322210156f342e/app/controllers/web/auth_controller.rb#L11-L13 - получается довольно сложно. Во-первых, можно не проверять, изменились ли атрибуты, update/save сам разберётся, можешь в консоли проверить. Во-вторых, можно проще

  ```
  user = User.find_or_initialize_by(github_uid: auth['uid'])
  user.name = auth.info['name'] || auth.info['nickname']
  user.email = auth.info['email']
  user.save
  ```

* https://github.com/isas2/rails-project-65/blob/9867714eeda94eaa5758f6f611322210156f342e/CHANGELOG.md?plain=1#L8 - purge_later - это дефолт, его можно не указывать. Проблема в delete_all на has_many :bulletins, так мы напрямую удаляем всё из БД без участия модели и выполнения колбэков. Решение - dependent: :destroy, который сам всё за тебя сделает. delete_all используют, если есть явные проблемы с производительностью, и тогда удаление всех дочерних сущностей обрабатывают вручную

  - Надо будет побольше почитать на эту тему
  - Файлы теперь удаляются )

* https://github.com/isas2/rails-project-65/blob/9867714eeda94eaa5758f6f611322210156f342e/CHANGELOG.md?plain=1#L18 - идея в том, чтобы реализовать это всё через одиночный роут и отдельный ProfilesController (c экшном show). Здесь как раз тот случай, когда не нужен айдишник

  1. Метод отображает список объявлений, и находится в соответствующем ему контроллере
  2. От профиля у него только одна ссылка /profile, если её переименовать например в /my_bulletins, то всё встаёт на свои места, - это явно не профиль
  3. Получается, что в выделенный ProfilesController ему по текущему ТЗ пока рано. На эту страницу нужно что-то ещё добавлять.

* https://github.com/isas2/rails-project-65/blob/9867714eeda94eaa5758f6f611322210156f342e/CHANGELOG.md?plain=1#L33 - можно, уже ответила на это

* https://github.com/isas2/rails-project-65/blob/9867714eeda94eaa5758f6f611322210156f342e/CHANGELOG.md?plain=1#L42 - ты приводишь примеры из базовых контроллеров, от которых наследуется всё остальное. В них before_action неизбежны, с этим приходится мириться. Я не хочу ещё раз спор по кругу поднимать, когда-нибудь к тебе придёт осознание того, что чем меньше before_action в проекте, тем проще с ним работать

* https://github.com/isas2/rails-project-65/blob/9867714eeda94eaa5758f6f611322210156f342e/CHANGELOG.md?plain=1#L54 - тогда надо им пользоваться. Тоже вариант, на самом деле, хотя мне он нравится меньше. У меня претензия была в том, что метод есть, но им не пользуются

* https://github.com/isas2/rails-project-65/blob/9867714eeda94eaa5758f6f611322210156f342e/CHANGELOG.md?plain=1#L58 - у тебя часть методов просто проверяют наличие пользователя, то есть по сути занимаются аутентификацией. Правильнее вынести это в отдельный метод authenticate_user и вызывать его из контроллера до проверки авторизации (там, где она останется нужна). Тогда ты разведёшь две истории - пользователь не залогинен и залогиненному пользователю не хватает прав. Можешь оставить так

  - Лирическое отступление! НЕ читать, если нет времени или настроения...
  - В одной книге по PHP было примерно такое объяснение границ:
  - Аутентификация - проверка подлинности, в нашем случае юзера. Самая простейшая аутентификация, может состоять из:
    1. юзер передаёт логин и пароль;
    2. мы сравниваем с сохранёнными значениями;
    3. session[:user_id] = user.id
    - на этом аутентификация завершена, т.к. мы уже поняли кто к нам обращается;
  - Авторизация - определение прав на доступ к чему-либо
  - Чтобы определить границы этих понятий можно максимально упростить условия... Пусть нет никакой Админки, нет личных постов или объявлений; просто часть ресурсов открыта всем, а часть только зарегистрированным юзерам.
  - Т.е. юзер открывает страницу, а мы просто смотрим зарегистирован ли он:
    - Он вводит опять логин/пароль? - НЕТ
    - Мы далаем повторно проверку его данных по БД? - НЕТ
    - Мы создаём ему сессию? - НЕТ
  - Значит аутентификации тут однозначно НЕТ, мы выполняем логику по определению прав его доступа, в нашем случае эта логика: зарегистрирован он или нет. И это уже чистая авторизация, и не важно что мы там внутри проверяем.
    - В книге также был пример, проверка является ли текущий день вторником будет авторизацией, если она в данном месте определяет доступ к чему-либо.

  - Однако, теория это не всегда хорошо, и реальность навязывает свои методы
  - before_action :authenticate_user! из device проверяет и вынуждает юзера аутентифицироваться? Т.е. это она своей проверкой в контроллере тащит на себя кусочек одеяла авторизации, разрушая строгое разграничение. Почему? Так удобнее. И если это то что нужно, то и надо использовать device и его методы.

* https://github.com/isas2/rails-project-65/blob/9867714eeda94eaa5758f6f611322210156f342e/CHANGELOG.md?plain=1#L78 - а он и не должен логинить, он же только редиректит на callback, в котором происходит логин
  
  - вопрос был немного в другом, если сделать 'assert signed_in?' то тест завалится, т.е. 'check github auth' явно не пройден

## 0.3.0 (03.09.2024)

* https://github.com/isas2/rails-project-65/blob/d2b81179fcd6798e948f4da54a701996b27bb48e/app/models/user.rb#L6 - а ты пробовал из консоли удалить пользователя, у которого есть объявления с картинками?

  - Попробовал, пользователь удаляется;
  - Если вопрос в удалении файлов, то добавил 'dependent: :purge_later', но похоже, что это не решает проблему;
  - Это какое-то больное место у RoR и единого решения нет? Потому что в решениях "кто в лес, кто по дрова"...
  - Есть рекомендации?

* https://github.com/isas2/rails-project-65/blob/d2b81179fcd6798e948f4da54a701996b27bb48e/config/routes.rb#L7 - show нет, ограничь роуты, пожалуйста

  - Исправлено;

* https://github.com/isas2/rails-project-65/blob/d2b81179fcd6798e948f4da54a701996b27bb48e/config/routes.rb#L22 - мы стараемся пользоваться ресурсными роутами. Это отличный пример singular resource https://guides.rubyonrails.org/routing.html#singular-resources
 
  - Статью прочитал, мне непонятно в чём вопрос и что конкретно от меня требуется;
  - У меня profile работает только с текущим юзером, ID не передаётся и не используется.

* https://github.com/isas2/rails-project-65/blob/d2b81179fcd6798e948f4da54a701996b27bb48e/app/controllers/web/auth_controller.rb#L7 - если пользователь сменит имя на гитхабе после регистрации в твоём приложении, то не сможет больше залогиниться. Ну и неплохо бы какой-то флэш о том, что юзверь успешно вошёл. Или не вошёл.

  - Да, про это я не подумал. Добавил поле github_uid
  - Обнаружил и другую проблему, оказывается поле name на github может быть пустое (nil), например юзер isas21;

* https://github.com/isas2/rails-project-65/blob/d2b81179fcd6798e948f4da54a701996b27bb48e/app/controllers/application_controller.rb - всё, что тут находится, нужно на уровне Web. Скорее всего, вторым неймспейсом будет Аpi, и вот там всё это не понадобится

  - Перенёс;
  - Мы же ещё API не рисовали и нет понимания отличий аутентификации и авторизации для него.

* https://github.com/isas2/rails-project-65/blob/d2b81179fcd6798e948f4da54a701996b27bb48e/app/controllers/application_controller.rb#L12 - так внезапно может быть 404я (если пользователя удалили). А должен быть просто пустой current_user. И было бы здорово вынести всё, что относится в аутентификации пользователя в отдельный модуль, чтобы держать всю логику вместе. Там же будет удобно выделить метод sign_in, в котором ты складываешь айдишник в сессию, и sign_out. Посмотри на AuthConcern в домашке acl, там отличный пример

  - Немного почитал про Concerns, судя по описанию - это миксины для rails. Учитывая что helper_method там писать нельзя, то код у меня получился какой-то "убогий".

* https://github.com/isas2/rails-project-65/blob/d2b81179fcd6798e948f4da54a701996b27bb48e/app/controllers/web/bulletins_controller.rb#L9 - а зачем тут includes? Ты же не отображаешь никаких данных пользователя или категории. То же самое для всех остальных экшнов, где он есть

* https://github.com/isas2/rails-project-65/blob/d2b81179fcd6798e948f4da54a701996b27bb48e/app/controllers/web/bulletins_controller.rb#L20 - методы с бэнгом рэйзят ошибку, если переход состояния не получился, это вызовет 500ю, а это нехорошо. Правильные проверять, возможен ли переход, и выводить флэш-сообщение в случае ошибки. Это касается всех методов, где есть transition, в том числе в админке

* https://github.com/isas2/rails-project-65/blob/d2b81179fcd6798e948f4da54a701996b27bb48e/app/controllers/web/bulletins_controller.rb#L61 - я уже писала о том, что лучше явно в каждом экшне определять переменные. Тут ты ещё и авторизацию прячешь в метод, название которого её не предполагает. Это очень неявно. В итоге, чтобы узнать, что происходит в show (а в нём пусто вообще) мне надо проверить все before_action, выбрать нужные, увидеть там название метода set_bulletin и пойти почитать его, удивиться найденной там авторизации. Ладно, здесь мало кода и это реально. Но я ещё раз говорю тебе, что это неверная идея, и это не рефакторинг, а усложнение понимания кода на ровном месте. Ну и противоречие семантике - авторизация в методе с название set_bulletin

  - С авторизацией полностью согласен, в методе set_bulletin ей не место, кстати это не я придумал, в лекции такое было ));
  - По before_action приведу пару примеров из приложения, того ради которого я здесь (на выходных смотрел, решил поделиться):
    - https://github.com/ManageIQ/manageiq-api/blob/master/app/controllers/api/base_controller.rb
    - https://github.com/ManageIQ/manageiq-ui-classic/blob/master/app/controllers/application_controller.rb
    - так что мне с before_action лучше сразу дружить.

* https://github.com/isas2/rails-project-65/blob/d2b81179fcd6798e948f4da54a701996b27bb48e/app/controllers/web/admin/categories_controller.rb#L40 - restrict_with_exception вызывает конкретную ошибку, о всех остальных желательно бы узнать в сентри всё же

  - Исправлено

* оhttps://github.com/isas2/rails-project-65/blob/d2b81179fcd6798e948f4da54a701996b27bb48e/app/policies/bulletin_policy.rb#L11 - ты же им не пользуешься нигде, зачем он?

  - Убрал, но не согласен
  - Метод нужен для целостности картины при поддержки приложения, заходишь в полиси и понятны все политики, увидеть метод index? с true проще, чем тратить время на поиск и потом понять что его нет;  

* https://github.com/isas2/rails-project-65/blob/d2b81179fcd6798e948f4da54a701996b27bb48e/app/policies/bulletin_policy.rb - вообще здесь у тебя смешаны два процесса, аутентификация и авторизация. Аутентификация - это проверка логина, авторизация - проверка прав пользователя. И полиси предназначены для второго. Разделение этих процессов упрощает жизнь и позволяет выводить разные ошибки для разных случаев

  - Посмотрел... Вроде бы каждый метод и КАЖДОЕ условие в них предназначены только для определения правомочности доступа, т.е. для авторизации. Для аутентификации ничего не вижу.

* https://github.com/isas2/rails-project-65/blob/d2b81179fcd6798e948f4da54a701996b27bb48e/app/views/web/bulletins/_form.html.slim#L1 - мне кажется, я уже писала в прошлом проекте о том, что нежелательно использовать instance variables в партиалах. Тем более, что при вызове партиала ты делаешь всё правильно и передаёшь её в локальную переменную. То же самое для формы категорий

  - Исправлено

* https://github.com/isas2/rails-project-65/blob/d2b81179fcd6798e948f4da54a701996b27bb48e/app/views/web/bulletins/profile.html.slim#L38 - так ты пытаешься реализовать ещё одну стейт-машину, а она у тебя уже есть в модели и она чётко знает, когда переходы возможны. У aasm есть метод, который умеет это проверять. То же самое в админской вьюхе

  - Если речь о методах 'may_*', то да, с ними логичнее

* https://github.com/isas2/rails-project-65/blob/d2b81179fcd6798e948f4da54a701996b27bb48e/test/controllers/web/auth_controller_test.rb - теста на логаут не хватает

  - Добавил
  - Я правильно понимаю, что указанный в Вашем задании тест нерабочий, т.к. нет OmniAuth.config.mock_auth...:
    ```
    test 'check github auth' do
      post auth_request_path('github')
      assert_response :redirect
    end
    ```
    Он проходит проверку на редирект, но не проходит на 'assert signed_in?'

* https://github.com/isas2/rails-project-65/blob/d2b81179fcd6798e948f4da54a701996b27bb48e/test/controllers/web/bulletins_controller_test.rb#L47 - вот так удобно проверять все изменения атрибутов пачкой

  ```
  updated = Bulletin.find_by(@attrs.except(:image))
  assert_equal(@bulletin.id, updated.id)
  ```
  - По моему это сравнение двух полей ID (2 == 2?), а не объектов. Т.е если ему скормить два объекта разных типов с одинаковыми ID, он скажет что равны, т.к. будет сравнивать сами ID;
  - Мне в данном тесте нужно проверить, что значение изменилось на указанное, а не их равенство. Если хотя бы один атрибут установлен верно, то другие можно не проверять, если была ошибка, то изменений не будет совсем. 

* https://github.com/isas2/rails-project-65/blob/d2b81179fcd6798e948f4da54a701996b27bb48e/test/controllers/web/bulletins_controller_test.rb - теста на profile не хватает


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