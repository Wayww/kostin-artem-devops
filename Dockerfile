FROM python:3.12-slim

WORKDIR /app

COPY app/ ./app/
COPY tests/ ./tests/

RUN python -m unittest discover -s tests -v

ENV APP_PORT=8080
EXPOSE 8080

CMD ["python", "app/main.py"]
