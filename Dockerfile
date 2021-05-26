FROM google/dart as builder

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN pub get
RUN dart compile exe bin/crystal-ball.dart

FROM alpine:latest
RUN mkdir -p /app/bin/
COPY --from=builder /app/bin/crystal-ball.exe /app/bin/
COPY ./entrypoint.sh /app

ENTRYPOINT ["/app/entrypoint.sh"]