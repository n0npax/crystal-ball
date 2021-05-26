FROM google/dart

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN pub get
RUN dart compile exe bin/crystal-ball.dart

ENTRYPOINT ["/app/entrypoint.sh"]