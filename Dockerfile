FROM centos:7.9.2009

# MariaDB ColumnStore 1.2.5の公式インストール手順を参考にする
RUN yum update -y \
    && yum install -y epel-release \
    && yum install -y \
    jemalloc \
    boost \
    expect perl perl-DBI openssl zlib file sudo libaio rsync snappy net-tools numactl-libs nmap \
    wget \
    less \
    # ProcMonで利用
    which \
    # pidofで利用
    sysvinit-tools \
    # syslogで利用
    rsyslog \
    && yum clean all

# syslogの出力設定
RUN echo '[ -f /usr/sbin/rsyslogd ] && /usr/sbin/rsyslogd' >> /etc/profile
RUN sed -i -e '/$SystemLogSocketName/s/^/#/' /etc/rsyslog.d/listen.conf
RUN sed -i -e '/$ModLoad imjournal/s/^/#/' /etc/rsyslog.conf
RUN sed -i -e 's/$OmitLocalLogging on/$OmitLocalLogging off/' /etc/rsyslog.conf
RUN sed -i -e '/$IMJournalStateFile/s/^/#/' /etc/rsyslog.conf

# 言語設定
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

# MariaDB ColumnStoreのインストール
WORKDIR /root
RUN wget https://downloads.mariadb.com/ColumnStore/1.2.5/centos/x86_64/7/mariadb-columnstore-1.2.5-1-centos7.x86_64.rpm.tar.gz \
    && tar xvzf mariadb-columnstore-1.2.5-1-centos7.x86_64.rpm.tar.gz \
    && rpm -ivh mariadb-columnstore*.rpm \
    && rm mariadb-columnstore*

# MariaDB ColumnStoreのシングルノードを設定
RUN printf '%s\n' 1 mcs-single 1 1 | /usr/local/mariadb/columnstore/bin/postConfigure

COPY docker-entrypoint.sh /root/docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["rsyslogd", "-n"]