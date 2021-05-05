# Luis Enrique Fuentes Plata

FROM python:3.7.10-slim-buster

ENV APP_HOME /usr/src/app
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && \
    apt-get install -y locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    echo LANG=en_US.utf8 > /etc/default/locale && \
    apt-get install -yy wget curl && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

COPY ./requirements.txt $APP_HOME/requirements.txt

WORKDIR $APP_HOME

RUN pip install -r requirements.txt && rm requirements.txt
