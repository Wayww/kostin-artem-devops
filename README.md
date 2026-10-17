# DevOps Student Application

Учебный проект для лабораторной работы по Linux, Git, Docker и Jenkins.

Приложение запускает HTTP-сервер на порту `8080` и показывает данные студента,
полученные из переменных окружения.

## Быстрый запуск

```bash
export STUDENT_NAME=Artem
export STUDENT_SURNAME=Kostin
export STUDENT_GROUP=IT23-14
export STUDENT_ID=37089
python3 app/main.py
```

Откройте `http://localhost:8080/` или проверьте ответ:

```bash
curl http://localhost:8080/
```

Для автоматической проверки состояния доступна конечная точка
`http://localhost:8080/health`, которая возвращает `{"status": "ok"}`.

## Проверки

```bash
python3 -m unittest discover -s tests -v
python3 app/main.py --check
```

## Integrated DevOps Workflow

1. **Linux** предоставляет файловую систему, права, процессы и shell-команды,
   необходимые для разработки и эксплуатации проекта.
2. **Git** фиксирует изменения, позволяет работать в ветках и возвращаться к
   проверенным версиям.
3. **GitHub** хранит центральную копию репозитория, доступную студенту,
   преподавателю и Jenkins.
4. **Jenkins** получает Jenkinsfile и исходный код из GitHub, после чего
   автоматически запускает Build и Test.
5. **Docker Build** создаёт воспроизводимый image с приложением. Image является
   неизменяемым шаблоном файлов и настроек.
6. **Docker Run** создаёт работающий container - экземпляр image со своим
   процессом, окружением и сетевыми портами.
7. При успехе всех этапов Pipeline завершается статусом `SUCCESS`. Ошибка любого
   этапа останавливает последующие этапы и переводит сборку в `FAILURE`.
