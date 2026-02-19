FROM debian:trixie-backports

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN \
    apt-get -y update && \
    apt-get install -y wget && \
    apt-get -y update && \
    apt-get install -y \
        unzip \
        qgis \
        xvfb && \
    apt-get -y --purge autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Mimic a QGIS user profile directory
RUN mkdir -p share/QGIS/QGIS3/profiles/default/python/plugins && \
    echo "[core]\nlastProfile=default" > share/QGIS/QGIS3/profiles/profiles.ini

# Manually install Model Baker
RUN wget -O QgisModelBaker.zip https://github.com/opengisch/QgisModelBaker/releases/download/v8.2.4/QgisModelBaker.v8.2.4.zip && \
    unzip QgisModelBaker.zip -d share/QGIS/QGIS3/profiles/default/python/plugins/ && \
    rm QgisModelBaker.zip && \
    # See also https://docs.qgis.org/3.40/en/docs/pyqgis_developer_cookbook/processing.html
    echo "hasProcessingProvider=yes" >> share/QGIS/QGIS3/profiles/default/python/plugins/QgisModelBaker/metadata.txt

ENTRYPOINT ["qgis_process"]
CMD ["--help"]