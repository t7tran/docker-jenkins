FROM jenkins/jenkins:2.126-alpine

# Distributed Builds plugins
RUN /usr/local/bin/install-plugins.sh ssh-slaves && \
# install Notifications and Publishing plugins
    /usr/local/bin/install-plugins.sh email-ext && \
    /usr/local/bin/install-plugins.sh mailer && \
    /usr/local/bin/install-plugins.sh slack && \
# Artifacts
    /usr/local/bin/install-plugins.sh htmlpublisher && \
# SCM
    /usr/local/bin/install-plugins.sh git && \
# UI
    /usr/local/bin/install-plugins.sh cloudbees-folder && \
    /usr/local/bin/install-plugins.sh greenballs && \
    /usr/local/bin/install-plugins.sh simple-theme-plugin && \
# Security
    /usr/local/bin/install-plugins.sh dependency-check-jenkins-plugin && \
    /usr/local/bin/install-plugins.sh antisamy-markup-formatter && \
# Workflow/Pipeline
    /usr/local/bin/install-plugins.sh workflow-aggregator && \
    /usr/local/bin/install-plugins.sh blueocean && \
    /usr/local/bin/install-plugins.sh timestamper && \
    /usr/local/bin/install-plugins.sh ws-cleanup && \
    /usr/local/bin/install-plugins.sh build-timeout && \
    /usr/local/bin/install-plugins.sh credentials-binding && \
# Scaling
    /usr/local/bin/install-plugins.sh kubernetes && \
# LDAP
    /usr/local/bin/install-plugins.sh ldap && \
# Matrix-base security
    /usr/local/bin/install-plugins.sh matrix-auth && \
# JIRA plugin
    /usr/local/bin/install-plugins.sh jira

# switch to root for easy debugging
USER root

RUN apk --no-cache add tzdata curl dpkg openssl && \
    # install gosu
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
    curl -fsSL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$dpkgArch" -o /usr/local/bin/gosu && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true && \
    # complete gosu
    apk del curl dpkg && \
    rm -rf /apk /tmp/* /var/cache/apk/*

ENTRYPOINT ["gosu", "jenkins", "/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]
