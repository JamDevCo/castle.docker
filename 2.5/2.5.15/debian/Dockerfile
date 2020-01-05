FROM python:2.7-slim-stretch

ENV PIP=19.3.1 \
    ZC_BUILDOUT=2.11.4 \ 
    SETUPTOOLS=39.1.0 \
    WHEEL=0.31.1 \
    CASTLE_MAJOR=2.5 \
    CASTLE_VERSION=2.5.15 \
    CASTLE_MD5=a7433e259c8db9b08e04b5c10932c94c

LABEL castle=$CASTLE_VERSION \
    os="debian" \
    os.version="9" \
    name="Castle $CASTLE_VERSION" \
    description="CastleCMS image, based on Plone 5.0.x" \
    maintainer="Plone Community"

RUN buildDeps="git ssh dpkg-dev gcc libbz2-dev libc6-dev libjpeg62-turbo-dev libopenjp2-7-dev libpcre3-dev libssl-dev libtiff5-dev libxml2-dev libxslt1-dev wget zlib1g-dev" \
 && runDeps="gosu libjpeg62 libopenjp2-7 libtiff5 libxml2 libxslt1.1 lynx netcat poppler-utils rsync wv" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps

RUN useradd --system -m -d /castle -U -u 500 castle \
 && mkdir -p /castle/instance/ /data/filestorage /data/blobstorage

RUN mkdir -p /castle && cd /castle && git clone --branch 2.5.15 https://github.com/castlecms/castle.cms.git instance

COPY *.cfg /castle/instance/
WORKDIR /castle/instance
RUN cd /castle/instance


RUN buildDeps="dpkg-dev gcc libbz2-dev libc6-dev libjpeg62-turbo-dev libopenjp2-7-dev libpcre3-dev libssl-dev libtiff5-dev libxml2-dev libxslt1-dev wget zlib1g-dev" \
 && runDeps="gosu libjpeg62 libopenjp2-7 libtiff5 libxml2 libxslt1.1 lynx netcat poppler-utils rsync wv" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps $runDeps \
 && pip install pip==$PIP setuptools==$SETUPTOOLS zc.buildout==$ZC_BUILDOUT wheel==$WHEEL \
 && pip install -r requirements.txt \
 && cd /castle/instance \
 && mkdir products \
 && buildout \
 && ln -s /data/filestorage/ /castle/instance/var/filestorage \
 && ln -s /data/blobstorage /castle/instance/var/blobstorage \
 && chown -R castle:castle /castle /data \
 && apt-get purge -y --auto-remove $buildDeps \
 && apt-get install -y --no-install-recommends $runDeps \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /castle/buildout-cache/downloads/*

COPY docker-initialize.py docker-entrypoint.sh /
RUN chmod 755 /docker-initialize.py /docker-entrypoint.sh

EXPOSE 8080
VOLUME /data

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]