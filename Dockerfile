FROM ubuntu:22.04
LABEL maintainer="Ravi Patel <https://rbsoft.uservoice.com>"

ENV COMMAND_LINE_TOOLS="11479570"

ENV ANDROID_SDK_ROOT="/android_sdk"
# Keep alias for compatibility
ENV ANDROID_HOME="${ANDROID_SDK_ROOT}"
ENV PATH="$PATH:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update \
 && apt-get install -qqy --no-install-recommends \
      bzip2 \
      curl \
      git-core \
      ca-certificates \
      html2text \
      openjdk-17-jdk \
      libc6-i386 \
      lib32stdc++6 \
      lib32gcc-s1 \
      lib32ncurses6 \
      lib32z1 \
      unzip \
      locales \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN update-ca-certificates
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN rm -f /etc/ssl/certs/java/cacerts; \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure

RUN curl -s https://dl.google.com/android/repository/commandlinetools-linux-${COMMAND_LINE_TOOLS}_latest.zip > /cmdline-tools.zip \
 && mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
 && mkdir /temp \
 && unzip /cmdline-tools.zip -d /temp \
 && mv -v /temp/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
 && rm -v -r /temp \
 && rm -v /cmdline-tools.zip

RUN mkdir -p /root/.android \
 && touch /root/.android/repositories.cfg \
 && yes | sdkmanager --licenses >/dev/null \
 && sdkmanager --update

ADD packages.txt ${ANDROID_SDK_ROOT}
RUN sdkmanager --package_file=${ANDROID_SDK_ROOT}/packages.txt
