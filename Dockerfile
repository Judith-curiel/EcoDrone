FROM ghcr.io/cirruslabs/flutter:stable

WORKDIR /app

COPY . .

RUN flutter pub get

RUN flutter build web

CMD sh -c "python3 -m http.server $PORT --directory build/web"