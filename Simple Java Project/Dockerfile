FROM tomcat:8.0-alpine
LABEL maintainer = 'sgrthati@gmail.com'
ADD ROOT*.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD ["catalina.sh","run"]