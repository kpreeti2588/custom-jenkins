FROM jenkins/jenkins:lts
USER root

COPY /configs/users "$JENKINS_HOME"/users/

COPY /configs/nodes "$JENKINS_HOME"/nodes/

COPY /configs/credentials.xml "$JENKINS_HOME"/credentials.xml

COPY /configs/jenkins_home_config.xml "$JENKINS_HOME"/config.xml

# Name the jobs  
ARG job_name_1="my_super_job"  
ARG job_name_2="my_ultra_job"
# Create the job workspaces  
RUN mkdir -p "$JENKINS_HOME"/workspace/${job_name_1}  
RUN mkdir -p "$JENKINS_HOME"/workspace/${job_name_2}

# Create the jobs folder recursively  
RUN mkdir -p "$JENKINS_HOME"/jobs/${job_name_1}  
RUN mkdir -p "$JENKINS_HOME"/jobs/${job_name_2}

# Add the custom configs to the container  
COPY /configs/${job_name_1}_config.xml "$JENKINS_HOME"/jobs/${job_name_1}/config.xml  
COPY /configs/${job_name_2}_config.xml "$JENKINS_HOME"/jobs/${job_name_2}/config.xml


# Create build file structure  
RUN mkdir -p "$JENKINS_HOME"/jobs/${job_name_1}/latest/  
RUN mkdir -p "$JENKINS_HOME"/jobs/${job_name_1}/builds/1/

# Create build file structure  
RUN mkdir -p "$JENKINS_HOME"/jobs/${job_name_2}/latest/  
RUN mkdir -p "$JENKINS_HOME"/jobs/${job_name_2}/builds/1/


COPY /configs/jobs "$JENKINS_HOME"/jobs/
COPY /configs/plugins "$JENKINS_HOME"/plugins/ 
COPY /configs/war "$JENKINS_HOME"/war/
COPY /configs/updates "$JENKINS_HOME"/updates/
COPY /configs/secrets "$JENKINS_HOME"/secrets/
COPY /configs/xmlsroot "$JENKINS_HOME"/

RUN /usr/local/bin/install-plugins.sh docker-slaves github-branch-source:1.8

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]
USER root
