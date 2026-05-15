FROM ghcr.io/cirruslabs/flutter:stable

WORKDIR /app

COPY . .

RUN flutter pub get
RUN flutter build web

RUN apt-get update && apt-get install -y python3

EXPOSE 8080

CMD ["python3", "-m", "http.server", "8080", "--directory", "build/web"]