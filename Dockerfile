FROM python:3.9-slim-bullseye

# set environment variables.
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# creating and changing to none-root user. (-mr: creating a HOME directory)
RUN apt-get update && \
    apt-get install gosu -y  && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +s /usr/sbin/gosu && \
    useradd -mr -d /home/app -s /bin/bash app

USER app

# set work directory.
WORKDIR /home/app

# add /home/app/.local/bin to PATH
ENV PATH "$PATH:/home/app/.local/bin"

# upgrading pip and installing dependencies.
RUN pip install --upgrade pip 
COPY --chown=app:app ./requirements.txt .
RUN pip install -r requirements.txt 

# copy project
COPY --chown=app:app . .

EXPOSE 8000

# adding exec permission to entypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/home/app/entrypoint.sh"]
