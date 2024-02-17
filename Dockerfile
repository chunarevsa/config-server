# Используем образ с Java и Gradle
FROM gradle:latest AS builder

# Устанавливаем рабочую директорию
WORKDIR /app/config-server

# Копируем файлы с зависимостями и сборки
COPY build.gradle .
COPY settings.gradle .
COPY src src

# Собираем проект
RUN gradle build --no-daemon --exclude-task test

# Используем минимальный образ с JRE
FROM openjdk:11-jre-slim

# Устанавливаем рабочую директорию
WORKDIR /app/config-server

# Копируем JAR файл из предыдущего этапа сборки
COPY --from=builder /app/config-server/build/libs/config-server-0.0.1-SNAPSHOT.jar .

# Задаем команду для запуска приложения
CMD ["java", "-jar", "config-server-0.0.1-SNAPSHOT.jar"]