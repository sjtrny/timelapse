FROM python:3.9-slim

RUN apt update

RUN apt install -y cron
RUN apt install -y ffmpeg

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

ADD app /app
RUN mkdir /app/data
RUN mkdir /app/data/pics
RUN mkdir /app/data/timelapses
RUN chmod -R +x /app

RUN crontab /app/timelapse-cron

CMD ["cron", "-f"]
