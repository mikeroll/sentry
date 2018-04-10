FROM python:2.7.14-slim
#ENV PYTHONUNBUFFERED 1

RUN groupadd -r redis --gid=998 && useradd -r -g redis --uid=998 redis \
    && groupadd -r postgres --gid=999 && useradd -r -g postgres --uid=999 postgres
ARG NODE_VERSION
        # PYTHONUNBUFFERED: 1
        # PIP_NO_CACHE_DIR: "off"
        # PIP_DISABLE_PIP_VERSION_CHECK: "on"
        # DEBIAN_FRONTEND: noninteractive
        # SENTRY_CONF: /etc/sentry
        # C_FORCE_ROOT: 1
RUN apt-get update && apt-get install -y --no-install-recommends -q=2\
        # clang \
        curl \
        # g++ \
        # gcc \
        # git \
        # libffi-dev \
        # libjpeg-dev \
        # libpq-dev \
        # libxml2-dev \
        # libxslt-dev \
        # libyaml-dev \
        # llvm-3.5 \
        # bzip2 \
        # # Extra dev tooling
        # make \
        # vim-nox \
        # less \
        # ntp \
    && rm -rf /var/lib/apt/lists/*

# Sane defaults for pip
# ENV PIP_NO_CACHE_DIR off
# ENV PIP_DISABLE_PIP_VERSION_CHECK on
# ENV PYTHONUNBUFFERED 1

# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

# ENV NODE_VERSION 4.4.5
RUN echo "Node version: $NODE_VERSION" \
    && echo \
    && echo \
    && echo

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
    && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --verify SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
    && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
    && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc

# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
# RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
#     && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
# ENV LANG en_US.utf8

# RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

# ENV PG_MAJOR 9.5
# ENV PG_VERSION 9.5.*
# ENV PATH /usr/lib/postgresql/$PG_MAJOR/bin:$PATH

# RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list \
#     && apt-get update && apt-get install -y --no-install-recommends \
#         postgresql-common \
#         postgresql-$PG_MAJOR=$PG_VERSION \
#         postgresql-client-$PG_MAJOR=$PG_VERSION \
#         postgresql-contrib-$PG_MAJOR=$PG_VERSION \
#     && rm -rf /var/lib/apt/lists/* \
#     && rm "/etc/postgresql/$PG_MAJOR/main/pg_hba.conf" \
#     && touch "/etc/postgresql/$PG_MAJOR/main/pg_hba.conf" \
#     && chown -R postgres "/etc/postgresql/$PG_MAJOR/main/pg_hba.conf" \
#     && { echo; echo "host all all 0.0.0.0/0 trust"; } >> "/etc/postgresql/$PG_MAJOR/main/pg_hba.conf" \
#     &&  { echo; echo "local all all trust"; } >> "/etc/postgresql/$PG_MAJOR/main/pg_hba.conf"

# RUN service postgresql start \
#     && createdb -U postgres -E utf-8 --template template0 sentry \
#     && service postgresql stop

# ENV DEBIAN_FRONTEND=noninteractive
# RUN apt-get update && apt-get install -y --no-install-recommends \
#         redis-server \
#         memcached \
#         postfix \
#     && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/sentry
RUN mkdir -p /etc/sentry
WORKDIR /usr/src/sentry
# ENV SENTRY_CONF /etc/sentry
# ENV C_FORCE_ROOT 1

# ADD scripts/docker-entrypoint.sh /entrypoint.sh
# ENTRYPOINT [ "/entrypoint.sh" ]

# EXPOSE 8000
CMD [ "bash" ]
