# Ruby Telegram Bot boilerplate
![Ruby and Telegram](https://hsto.org/files/914/1c2/d17/9141c2d17d074b8d8758a955f7fd575a.png)

## UPD (20.06.2016)
I've created an awesome list of resources related to bots (from tutorials and SDKs to the events and people). Be sure to [check it out](https://github.com/BotCube/awesome-bots)!

[Awesome bots list](https://github.com/BotCube/awesome-bots)

If you want to use Webhooks API instead of long-polling, be able to save state and create more scalable and powerful bot read the article below.

[Full guide on creating statefull Telegram bot](https://botcube.co/blog/2017/02/04/full-guide-on-creating-telegram-bot-with-rails.html)

## Features
* Ability to save some data to a local database (Postgres by default)
* Automatic logging of received and sent message
* Easy internationalization using i18n gem
* Already created class for creating [custom keyboards](https://core.telegram.org/bots#keyboards)
* Database logging
* Separate classes for all the functional, so it's very easy to customize something

## Usage

### Defining responses

Use the `on` method in `message_responder.rb` like in the example below:

```ruby
def respond
  on /^\/start/ do
    answer_with_greeting_message
  end

  on /^\/command (.+)/ do |arg| #supports up to two arguments but it is easily extendable
    # do your stuff
  end
end
```

### Running the bot
For the first you need to install gems required to start a bot:

```sh
bundle install
```

Then you need to create `secrets.yml` where your bot unique token will be stored and `database.yml` where database credentials will be stored. I've already created samples for you, so you can easily do:

```sh
cp config/database.yml.sample config/database.yml
cp config/secrets.yml.sample config/secrets.yml
```

Then you need to fill your [Telegram bot unique token](https://core.telegram.org/bots#botfather) to the `secrets.yml` file and your database credentials to `database.yml`.

After this you need to create and migrate your database:

```sh
rake db:create db:migrate
```

Great! Now you can easily start your bot just by running this command:

```sh
bin/bot
```

## Directory layout

### Source

```sh
└── ruby-telegram-bot-boilerplate
    ├── bin                              # executables folder
    │   └── bot                          # main executable file
    ├── config                           # folder with configs
    │   ├── database.yml.sample          # sample database configuration
    │   ├── secrets.yml.sample           # sample credentials file
    │   └── locales.yml                  # file with i18n locales
    ├── db                               # database related stuff
    │   └── migrate                      # migrations
    │       └── 001_create_users.rb      # migration for creating table 'users'
    ├── lib                              # helper libs folder
    │   ├── app_configurator.rb          # class for application configuration
    │   ├── database_connector.rb        # class for connecting to database
    │   ├── message_responder.rb         # main class for responding to message
    │   ├── message_sender.rb            # simple class just for message sending
    │   └── reply_markup_formatter.rb    # class for creating custom keyboards
    ├── models                           # database models folder
    │   └── user.rb                      # active record User model
    ├── Gemfile                          # Gemfile
    ├── Gemfile.lock                     # Gemfile.lock
    ├── README.md                        # Readme file
    └── Rakefile                         # Rakefile with tasks for database management
```

Some more specific info you can also find [here](https://github.com/atipugin/telegram-bot-ruby).

## Contributing

If you have some proposals how to improve this boilerplate feel free to open issues and send pull requests!

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## GRSU API Doc

### Общая информация

Приложение стучится к api по http, но api может и https.

Для английского языка lang должен быть en_GB.

### Получение списка видов обучения (дневная, заочка и т. д.)

https://api.grsu.by/1.x/app1/getDepartments?lang=ru_RU

```json
{"items":[{"id":"2","title":"дневная форма"},{"id":"3","title":"заочная форма"},{"id":"4","title":"вечерняя форма"},{"id":"5","title":"дистанционная форма"},{"id":"6","title":"соискательство"}]}
```

### Получение списка факультетов

https://api.grsu.by/1.x/app1/getFaculties?lang=ru_RU

```json
{"items":[{"id":"3952","title":"Военный факультет"},{"id":"4907","title":"Инженерно-строительный факультет"}]}
```

### Получение списка учителей (по факту, и иных лиц - внешних и, видимо, сотрудников, по крайней мере некоторых)

http://api.grsu.by/1.x/app1/getTeachers?sort=surname,name&fields=surname,name,patronym,post&lang=ru_RU

Факт: поле fields игнорируется, и его в запрос имеет смысл включать только для мимикрирования под родное приложение.

```json
{"count":1069,
"items":[
{"id":"3","name":"Татьяна","surname":"Гимпель","patronym":"Михайловна","post":"ст.пр.","phone":"","descr":"","email":"t.himpel@grsu.by","skype":""},
{"id":"74","name":"Владимир","surname":"Барсуков","patronym":"Георгиевич","post":"зав.каф.","phone":"","descr":"","email":"v.g.barsukov@grsu.by","skype":""},
{"id":"93","name":"Олег","surname":"Коляго","patronym":"Владимирович","post":"ст.пр.","phone":"","descr":"","email":"okaliaha@grsu.by","skype":""}
]
}
```

### Получение списка групп и их айди

http://api.grsu.by/1.x/app1/getGroups?departmentId=2&facultyId=3&course=1&lang=ru_RU

```json
{"items":[{"id":"13127","title":"СДП-ПМ-211"},{"id":"13119","title":"СДП-ПОИТ-211"},{"id":"13120","title":"СДП-ПОИТ-212"},{"id":"13121","title":"СДП-ПОИТ-213"}]}
```

### Получение расписания по айди группы

http://api.grsu.by/1.x/app1/getGroupSchedule?groupId=13120&dateStart=30.09.2021&dateEnd=09.10.2021&lang=ru_RU

Важно: содержит информацию по всем подгруппам (по лабораторным и физкультурным).

ТуДу: проверить, что если подставить айди подгруппы.
```json
{"count":2,"days":[
{"num":"4","count":13,"date":"2021-09-30","lessons":[
{"timeStart":"08:30","timeEnd":"09:50","teacher":{"id":"30016","fullname":"Флерко Александр Леонидович","post":"Старший преподаватель"},"label":"","type":"практ. зан.","title":"Физическая культура","address":"Захарова, 32","room":"Спортивный комплекс","subgroup":{"id":"13498","title":"СДР-ФаМИ-211.6.1"}},
{"timeStart":"08:30","timeEnd":"09:50","teacher":{"id":"76730","fullname":"Маклаков Виталий Анатольевич","post":"Доцент"},"label":"","type":"практ. зан.","title":"Физическая культура","address":"Захарова, 32","room":"Спортивный комплекс","subgroup":{"id":"13500","title":"СДР-ФаМИ-211.6.3"}},
{"timeStart":"08:30","timeEnd":"09:50","teacher":{"id":"96182","fullname":"Романчук Екатерина Викторовна","post":"Старший преподаватель"},"label":"","type":"практ. зан.","title":"Физическая культура","address":"Захарова, 32","room":"Спортивный комплекс","subgroup":{"id":"13507","title":"СДР-ФаМИ-211.6.11"}},
{"timeStart":"08:30","timeEnd":"09:50","teacher":{"id":"97393","fullname":"Кулешов Валерий Иванович","post":"Старший преподаватель"},"label":"","type":"практ. зан.","title":"Физическая культура","address":"Захарова, 32","room":"Спортивный комплекс","subgroup":{"id":"13502","title":"СДР-ФаМИ-211.6.5"}},
{"timeStart":"10:05","timeEnd":"11:25","teacher":{"id":"10108","fullname":"Иванов Виктор Александрович","post":"Старший преподаватель"},"label":"","type":"практ. зан.","title":"Физическая культура","address":"Захарова, 32","room":"Спортивный комплекс","subgroup":{"id":"13501","title":"СДР-ФаМИ-211.6.4"}},
{"timeStart":"10:05","timeEnd":"11:25","teacher":{"id":"30016","fullname":"Флерко Александр Леонидович","post":"Старший преподаватель"},"label":"","type":"практ. зан.","title":"Физическая культура","address":"Захарова, 32","room":"Спортивный комплекс","subgroup":{"id":"13499","title":"СДР-ФаМИ-211.6.2"}},
{"timeStart":"10:05","timeEnd":"11:25","teacher":{"id":"76730","fullname":"Маклаков Виталий Анатольевич","post":"Доцент"},"label":"","type":"практ. зан.","title":"Физическая культура","address":"Захарова, 32","room":"Спортивный комплекс","subgroup":{"id":"13505","title":"СДР-ФаМИ-211.6.8"}},
{"timeStart":"10:05","timeEnd":"11:25","teacher":{"id":"89335","fullname":"Тонкоблатова Ирина Викторовна","post":"Старший преподаватель"},"label":"","type":"практ. зан.","title":"Физическая культура","address":"Захарова, 32","room":"Спортивный комплекс","subgroup":{"id":"13503","title":"СДР-ФаМИ-211.6.6"}},
{"timeStart":"10:05","timeEnd":"11:25","teacher":{"id":"96182","fullname":"Романчук Екатерина Викторовна","post":"Старший преподаватель"},"label":"","type":"практ. зан.","title":"Физическая культура","address":"Захарова, 32","room":"Спортивный комплекс","subgroup":{"id":"13504","title":"СДР-ФаМИ-211.6.7"}},
{"timeStart":"10:05","timeEnd":"11:25","teacher":{"id":"96186","fullname":"Зенкевич Валентина Николаевна","post":"Преподаватель"},"label":"","type":"практ. зан.","title":"Физическая культура","address":"Захарова, 32","room":"Спортивный комплекс","subgroup":{"id":"13506","title":"СДР-ФаМИ-211.6.10"}},
{"timeStart":"11:40","timeEnd":"13:00","teacher":{"id":"8814","fullname":"Ливак Елена Николаевна","post":"Доцент"},"label":"начало в 12:00","type":"лек.","title":"Организация и функционир. компьют. систем  [начало в 12:00]","address":"","room":"Вебинар (Webex)","subgroup":{"id":"0","title":""}},
{"timeStart":"13:30","timeEnd":"14:50","teacher":{"id":"20200","fullname":"Карканица Анна Викторовна","post":"Доцент"},"label":"","type":"лек.","title":"Основы программной инженерии","address":"","room":"Вебинар (Discord)","subgroup":{"id":"0","title":""}},
{"timeStart":"16:40","timeEnd":"18:00","teacher":{"id":"55084","fullname":"Бич Наталья Николаевна","post":"Доцент"},"label":"","type":"практ. зан.","title":"Организация и функционир. компьют. систем","address":"БЛК, 5","room":"405","subgroup":{"id":"0","title":""}}]},
{"num":"5","count":1,"date":"2021-10-01","lessons":[
{"timeStart":"18:15","timeEnd":"19:35","teacher":{"id":"30016","fullname":"Флерко Александр Леонидович","post":"Старший преподаватель"},"label":"","type":"практ. зан.","title":"Физическая культура (легкая атлетика)","address":"Захарова, 32","room":"Спортивный комплекс","subgroup":{"id":"13600","title":"СДР-УН-211.6.1001"}}]}]}
```

### Получение айди студента и минимальной информации об нём по логину

http://api.grsu.by/1.x/app1/getStudent?login=Xhadnyj_DS_21&lang=ru_RU

```json
{"id":162712,"fullname":"Щадный Даниил Сергеевич","studenttype":"Студент","grouptitle":"СДП-ПОИТ-212","nzach":"2021-2133","k_sgryp":13120,"kvidstud":1}
```

### Получение личного расписания по айди студента

http://api.grsu.by/1.x/app1/getGroupSchedule?studentId=162712&dateStart=30.09.2021&dateEnd=09.10.2021&lang=ru_RU

Формат расписания такой же, как и при запросе по айди группы.
