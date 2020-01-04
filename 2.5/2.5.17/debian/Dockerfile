FROM python:2.7-slim-stretch

ENV PIP=19.3 \
    ZC_BUILDOUT=2.13.2 \
    SETUPTOOLS=41.4.0 \
    WHEEL=0.33.6 \
    PLONE_MAJOR=5.0 \
    PLONE_VERSION=5.0.10 \
    PLONE_MD5=73322c58961f7f0e477cf359e0887cca \
    CASTLE_MAJOR=2.5 \
    CASTLE_VERSION=2.5.16 \
    CASTLE_MD5=e550b1661c46e673d022122a3c871954

LABEL plone=$PLONE_VERSION \
    os="debian" \
    os.version="9" \
    name="Castle $CASTLE_VERSION" \
    description="CastleCMS image, based on Plone $PLONE_VERSION" \
    maintainer="Plone Community"

RUN useradd --system -m -d /plone -U -u 500 plone \
 && mkdir -p /plone/instance/ /data/filestorage /data/blobstorage

COPY *.cfg /plone/instance/

RUN buildDeps="gosu git ssh dpkg-dev gcc libbz2-dev libc6-dev libjpeg62-turbo-dev libopenjp2-7-dev libpcre3-dev libssl-dev libtiff5-dev libxml2-dev libxslt1-dev wget zlib1g-dev" \
 && runDeps="gosu git libjpeg62 libopenjp2-7 libtiff5 libxml2 libxslt1.1 lynx netcat poppler-utils rsync wv" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps $runDeps \
 && wget -O Plone.tgz https://launchpad.net/plone/$PLONE_MAJOR/$PLONE_VERSION/+download/Plone-$PLONE_VERSION-UnifiedInstaller.tgz \
 && echo "$PLONE_MD5 Plone.tgz" | md5sum -c - \
 && tar -xzf Plone.tgz \
 && cp -rv ./Plone-$PLONE_VERSION-UnifiedInstaller/base_skeleton/* /plone/instance/ \
 && cp -v ./Plone-$PLONE_VERSION-UnifiedInstaller/buildout_templates/buildout.cfg /plone/instance/buildout-base.cfg \
 && pip install pip==$PIP setuptools==$SETUPTOOLS zc.buildout==$ZC_BUILDOUT wheel==$WHEEL

RUN mkdir -p /plone/instance/src \
 && cd /plone/instance/src \
 && rm -rf /plone/instance/src/castle.cms \
 && git clone --branch master https://github.com/castlecms/castle.cms.git \
 && cd /plone/instance \
 && cp src/castle.cms/versions.cfg castle-versions.cfg \
 && chown -R plone:plone /plone /data

WORKDIR /plone/instance
RUN ls -al .
RUN gosu plone buildout

RUN ln -s /data/filestorage/ /plone/instance/var/filestorage \
 && ln -s /data/blobstorage /plone/instance/var/blobstorage \
 && find /data  -not -user plone -exec chown plone:plone {} \+ \
 && find /plone -not -user plone -exec chown plone:plone {} \+ \

RUN rm -rf /Plone* \
 && apt-get purge -y --auto-remove $buildDeps \
 && apt-get install -y --no-install-recommends $runDeps \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /plone/buildout-cache/downloads/*

VOLUME /data

COPY docker-initialize.py docker-entrypoint.sh /

EXPOSE 8080

HEALTHCHECK --interval=1m --timeout=5s --start-period=1m \
  CMD nc -z -w5 127.0.0.1 8080 || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]
