# DecisionTree

Требуется реализовать на RoR или Sinatra REST сервис, который умеет хранить описания классов объектов и строить “дерево принятия решений”, пригодное для классификации объектов в соответствии с хранящимися классами.

Требования к результату

Обязательно:

- [x]Сервис предоставляет REST интерфейс

- [x]Реализован на RoR

- [x]Позволяет создавать и получать Action’ы

- [x]Позволяет получить DecisionTree, построенное по всем Action’ам

- [x]Основные функции покрыты тестами

- [x]Входные данные проверяются на корректность, при ошибке возвращается ошибка 400 в json формате

- [x]При проблемах на стороне сервиса возвращается ошибка 500 в json формате

- [x]Поведение в неопределенных случаях выбрать самому и описать.

## API

### Actions

#### Создание

```
POST /api/v1/actions
Content-Type: application/json

{
	"properties": { "value": "moscow" }
}
````

Если все верно, то отвечает `200`, иначе `400` с описанием ошибки

#### Получение

```
GET /api/v1/actions
````

Всегда возвращает `200` с массивом Action-ов

### DecisionTree

#### Получение

```
GET /api/v1/decision_tree
````

Всегда возвращает дерево решений со статусом `200`


## Неопределенные случаи

- неверный формат `properties` для `Action` – ошибка с описанием
- `decision_tree` возвращает `[]` если нет actions
- ключами могут быть любые объекты. Важно знать, что они конвертируются в строку. Для классификации объекта, его значения тоже нужно приводить к строке

## Тестирование

```
bundle exec rspec
```

Тестирование на performance (по-умолчанию исключено)

```
bundle exec rspec --tag perf
```

