# Stage 1: Builder - Download and prepare plugins
FROM debian:trixie-slim as builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \n        wget \n        unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Download QgisModelBaker
RUN wget -O QgisModelBaker.zip https://github.com/opengisch/QgisModelBaker/releases/download/v8.2.4/QgisModelBaker.v8.2.4.zip && \
    unzip -q QgisModelBaker.zip && \
    rm QgisModelBaker.zip

# Stage 2: Runtime - Minimal image with only necessary packages
FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \n        qgis \n        xvfb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy prepared plugins from builder
COPY --from=builder /build/QgisModelBaker share/QGIS/QGIS3/profiles/default/python/plugins/QgisModelBaker

# Create QGIS profile directory structure
RUN mkdir -p share/QGIS/QGIS3/profiles/default/python/plugins && \
    echo "[core]\nlastProfile=default" > share/QGIS/QGIS3/profiles/profiles.ini && \
    echo "hasProcessingProvider=yes" >> share/QGIS/QGIS3/profiles/default/python/plugins/QgisModelBaker/metadata.txt

ENTRYPOINT ["qgis_process"]
CMD ["--help"]