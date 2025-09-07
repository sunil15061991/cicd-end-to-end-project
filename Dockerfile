FROM ubuntu
RUN apt-get update && apt-get install -y --no-install-recommends openjdk-8-jdk \
    && rm -rf /var/lib/apt/lists/*
RUN useradd -ms /bin/bash appuser
USER appuser
WORKDIR /opt
COPY staging/com/meportal/springboot-app/1.0.1/springboot-app-1.0.1.war welcomeapp.war
CMD ["java", "-jar", "welcomeapp.war"]
