# Mlflow Compose

## Назначение

Репозиторий, предоставляющий шаблон для развёртывания
инфраструктуры mlflow.

Основная идея при создании этого проекта:
Mlflow поддерживает работу только с экспериментами,
которые не сепарированы между проектами.
Мне хотелось иметь разные серверы Mlflow для разных
рабочих проектов, чтобы эксперименты не перемешивались.

## Архитектура шаблона

```txt
open_mlflow_infra
 ├╴  minio
 │ ├╴  buckets_list.txt - список бакетов minio под разные проекты
 │ ├╴  minio.env - переменные для контейнера minio
 │ └╴  minio_init.sh - команды для создания бакетов в minio
 ├╴  mlflow
 │ ├╴  envs - папка с окружениями mlflow
 │ │ └╴  test_project.env - окружение тестового проекта в mlflow
 │ │ ... - сюда можно добавлять свои окружения
 │ ├╴  clean_del.sql - команды sql для полного удаления экспериментов из БД
 │ ├╴  entrypoint.sh - команда запуска mlflow сервера (можно поменять на свою)
 │ └╴  minio_connect.env - переменные для подключения к minio из mlflow
 ├╴  postgres
 │ ├╴  postgres.env - переменные для postgres контейнера
 │ └╴  projects_db_configs.json - json список с базами данных для проектов
 ├╴  README.md - документация по проекту
 ├╴  compose.yaml - файл с инфраструктурой для mlflow (db, s3, init bs/s3)
 ├╴  .env - здесь можно задать какой проект запускать
 └╴  test_flow.compose.yaml - compose файл с сервером mlflow для проекта
```

## Запуск

### Тестовый проект

Для запуска тестового проекта нужно ввести:

```bash
docker compose up -d
```

После этого поднимется инфраструктура Mlflow.

Адреса:

- Mlflow: `http://localhot:5801`
- postgres: `localhost:8533`
- minio api: `localhost:9574`
- minio ui: `http://localhost:9321`

По умолчанию будет создан бакет `bucket1` в minio.
В postgres будет создана база `mlflow` для проекта test

### Рабочий проект

Для запуска рабочего проекта необходимо добавить его имя compose
конфигурации в файл `.env`.

Например, вы создали новый проект в файле `new-project.compose.yaml`.
Вам для его запуска нужно ввести команду:

```bash
docker compose -f compose.yaml -f new-project.compose.yaml up -d
```

Можно не вводить эту длинную команду, а изменить `.env` файл:

```env
COMPOSE_FILE='./compose.yaml,./new-project.compose.yaml'
COMPOSE_PATH_SEPARATOR=','
```

## Настройка

Чтобы создать свой проект, нужно провести следующие манипуляции:

1. указать имя бакета для проекта в файле `minio/buckets_list.txt`
(сохранять файл нужно обязательно в unix формате **LF line end**)
[info](https://labex.io/tutorials/linux-how-to-normalize-line-endings-in-linux-text-files-418212)
2. в файле `postgres/projects_db_configs.json` добавить конфигурацию бд
проекта в список `db_projects_configs`. Нужно указать
пользователя, имя бд, пароль подключения
3. в папку `mlflow/envs/` добавить файл с переменными окружения
mlflow для подключения к базе и s3. Создавать по аналогии с
[примером](./mlflow/envs/test_project.env)
4. наконец, по аналогии с [файлом](./test_flow.compose.yaml)
создать свою конфигурацию compose для проекта.
Обязательно нужно поменять:

## Используемые контейнеры

В данном проекте используются кастомные контейнеры:

- [lenow/mlflow-server](https://hub.docker.com/r/lenow/mlflow-server) - сервер mlflow
- [lenow/sql-initer](https://hub.docker.com/r/lenow/sql-initer) - создание баз данных
по конфигурации

Посмотреть код этих контейнеров и собрать их самостоятельно
можно [здесь](https://github.com/lenow55/open_mlflow_docker)
