# simpler

## Запуск приложения:
1. Установите зависимости:  
- `bundle add rack`
- `gem install sqlite3`
- `gem install sequel`
2. Запустите сервер: `rackup`
3. Сервер будет доступен по адресу **http://localhost:9292**

## Тестовые запросы:
- Получение статуса ответа 200:  
`curl --url localhost:9292/tests`