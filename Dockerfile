FROM python:3.9-slim

RUN apt update

RUN apt install -y cron
RUN apt install -y ffmpeg

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

ADD app /app
RUN chmod -R +x /app

RUN crontab /app/timelapse-cron
RUN mkdir /app/pics

CMD ["cron", "-f"]
