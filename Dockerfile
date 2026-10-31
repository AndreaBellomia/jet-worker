# syntax=docker/dockerfile:1
ARG UV_VERSION=0.13.6
ARG PYTHON_SERIES=3.13
FROM ghcr.io/astral-sh/uv:${UV_VERSION} AS uv
FROM python:${PYTHON_SERIES}-alpine3.23 AS development
ARG PYTHON_SERIES
ARG LOCAL_UID=1000
ARG LOCAL_GID=1000
COPY --from=uv /uv /uvx /usr/local/bin/
ENV UV_PROJECT_ENVIRONMENT=/home/app/.venv \
    UV_PYTHON=/usr/local/bin/python \
    UV_PYTHON_DOWNLOADS=never \
    UV_LINK_MODE=copy \
    UV_NO_PROGRESS=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/home/app/.venv/bin:$PATH"
RUN apk add --no-cache git openssh-client libgcc libstdc++ \
    && uv pip uninstall --system pip setuptools \
    && if ! getent group "${LOCAL_GID}" >/dev/null; then addgroup -g "${LOCAL_GID}" app; fi \
    && adduser -D -u "${LOCAL_UID}" -G "$(getent group "${LOCAL_GID}" | cut -d: -f1)" app \
    && mkdir /app && chown "${LOCAL_UID}:${LOCAL_GID}" /app
WORKDIR /app
COPY --chown=${LOCAL_UID}:${LOCAL_GID} . .
USER app
RUN uv sync --locked --all-groups \
    && python -c "import sys; expected = tuple(map(int, '${PYTHON_SERIES}'.split('.'))); assert sys.version_info[:2] == expected, (sys.version, expected)"
ENTRYPOINT ["sh", "/app/scripts/container-entrypoint.sh"]
CMD ["sh", "scripts/check.sh"]
