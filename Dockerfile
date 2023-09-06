FROM alpine

RUN apk update
RUN apk add ffmpeg
RUN apk add --no-cache tzdata
ENV TZ=Australia/Sydney

ADD app /app

RUN chmod +x /app
RUN crontab /app/timelapse-cron

RUN mkdir /app/pics

CMD crond -f
