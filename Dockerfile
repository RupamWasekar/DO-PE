FROM eclipse-temurin:11-jre
ARG JMETER_VERSION=5.6.3

RUN apt-get update && apt-get install -y curl unzip ca-certificates && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz \
    | tar -xz -C /opt

ENV JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}
ENV PATH="${JMETER_HOME}/bin:${PATH}"

WORKDIR /tests

# Copy all plugin JARs
COPY plugins/*.jar ${JMETER_HOME}/lib/ext/

# Keep container alive
CMD ["tail", "-f", "/dev/null"]
