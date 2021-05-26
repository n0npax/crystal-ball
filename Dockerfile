FROM google/dart as builder
LABEL author="Marcin <n0npax> Niemira"
RUN mkdir /app
COPY . /app
WORKDIR /app

RUN pub get
RUN dart compile exe bin/crystal-ball.dart

FROM alpine:latest
LABEL author="Marcin <n0npax> Niemira"
RUN mkdir -p /app/bin/
COPY --from=builder /app/bin/crystal-ball.exe /app/bin/crystal-ball.exe
COPY ./entrypoint.sh /app

ENTRYPOINT ["/app/entrypoint.sh"]