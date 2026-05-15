FROM ghcr.io/cirruslabs/flutter:stable

WORKDIR /app

COPY . .

RUN flutter pub get

RUN flutter build web

EXPOSE 8080

CMD ["python3", "-m", "http.server", "8080", "--directory", "build/web"]