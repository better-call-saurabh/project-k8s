# docker/Dockerfile
FROM python:3.11-slim AS build
WORKDIR /wheels

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc libmariadb-dev-compat libmariadb-dev \
    && rm -rf /var/lib/apt/lists/*

COPY app/requirements.txt /wheels/requirements.txt

RUN pip install --upgrade pip setuptools wheel \
    && pip wheel -r requirements.txt --wheel-dir /wheels/wheels


FROM python:3.11-slim
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    libmariadb3 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /wheels/wheels /wheels/wheels
RUN pip install --no-cache /wheels/wheels/*

COPY app /app

RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

ENV FLASK_ENV=production PYTHONUNBUFFERED=1
EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app", "--workers", "3", "--threads", "2"]

