FROM  accenture/adop-jenkins-slave:latest

MAINTAINER "Abul Kashim Gofur" <nabul.k.gofur@accenture.com>

# Swarm Env Variables (defaults)
ENV SWARM_MASTER=http://jenkins:8080/jenkins/
ENV SWARM_USER=jenkins
ENV SWARM_PASSWORD=jenkins

# Slave Env Variables
ENV SLAVE_NAME="Swarm_Slave"
ENV SLAVE_LABELS="docker aws ldap"
ENV SLAVE_MODE="exclusive"
ENV SLAVE_EXECUTORS=1
ENV SLAVE_DESCRIPTION="Core Jenkins Slave"

# Adding Perl dependencies
RUN yum install -y perl-Data-Dumper \
	perl-devel

# Adding perm module Log4Perl
RUN curl -fsSL http://search.cpan.org/CPAN/authors/id/M/MS/MSCHILLI/Log-Log4perl-1.49.tar.gz > Log-Log4perl-1.49.tar.gz &&\
    tar -xzf Log-Log4perl-1.49.tar.gz &&\
    cd Log-Log4perl-1.49 &&\
    perl Makefile.PL &&\
    make &&\
	make install

CMD java -jar /bin/swarm-client.jar -executors ${SLAVE_EXECUTORS} -description "${SLAVE_DESCRIPTION}" -master ${SWARM_MASTER} -username ${SWARM_USER} -password ${SWARM_PASSWORD} -name "${SLAVE_NAME}" -labels "${SLAVE_LABELS}" -mode ${SLAVE_MODE}