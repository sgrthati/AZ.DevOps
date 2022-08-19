# OVERVIEW:

i have taken simple java project from Aws Labs and tried to import in azure devops project,for project creation developer words has been given below

we have to run .build.sh file to create a war file(inorder to run properly we must have installed JDK in Agent

Same way i did in pipeines
# Pipelines
1> installed JDK using pipeline in running agent 
   sudo apt install -y openjdk-8-jdk
2> in order to create war file(executable under tomcat apps) we have to run build.sh same i added extra command to remove previously generated WAR files
   rm -rf ROOT* && sudo bash ./build.sh
3> here i renamed package to particular version
   mv ROOT.war ROOT$(build.buildId).war
4> i have created a Docker file to create image,before that for Docker installation i have given below command and i have given suffiecient priviliges to run docker
   sudo apt install docker.io && sudo chmod 777 /var/run/docker.sock
5> Docker Push and Publish(to push image into azure container registry and Docker Container registry
   steps:
- task: Docker@2
  displayName: 'Docker & ACR  buildAndPush'
  inputs:
    containerRegistry: ACR
    repository: sgrthati/tomcatsnakes
    buildContext: '$(Build.Repository.LocalPath)'
    tags: '$(build.buildId)'
    addPipelineData: false
    addBaseImageData: false
 ![image](https://user-images.githubusercontent.com/101870480/185590837-c7106531-f3db-446c-90b0-edf6c2e339c4.png)

6> here i have moved terraform folder to Artifactory staging folder to use in release pipelines
   ![image](https://user-images.githubusercontent.com/101870480/185591065-dc77dbe6-5b3c-485a-9563-305b2cb4ff73.png)
   
   
7> published artifact:
   ![image](https://user-images.githubusercontent.com/101870480/185591193-68a97a2a-bb61-4a22-adf3-0e13b3fac384.png)
   
   

by doing we will succesfully created our image and we can push it into Azure container registry and docker container registry
now we have to implement Steps in Release pipeline


![image](https://user-images.githubusercontent.com/101870480/185591449-c5ba651a-774b-425f-8cb0-62e327d7a0da.png)



1> Artifact settings:
![image](https://user-images.githubusercontent.com/101870480/185591554-7bf6227b-5f34-4724-81b9-6a8b2c721964.png)


2> Tasks:
   ![image](https://user-images.githubusercontent.com/101870480/185591665-b2f57831-40ae-416b-9210-85eceac676e4.png)
   
   
3> Replace tockens used to replace secret variables from Key Vault which are mapped under librarys to variable group

![image](https://user-images.githubusercontent.com/101870480/185591892-1a8ef4c0-7df0-4e58-a960-139f9899d819.png)


4> Terraform Init:
   ![image](https://user-images.githubusercontent.com/101870480/185592020-3d108eeb-0400-4d15-8633-6da32243d3bd.png)
   
   
5> Terraform Apply

![image](https://user-images.githubusercontent.com/101870480/185592083-f5418f54-efbb-46fd-9690-999fc5a75729.png)

same way i have created test and prod and dev and staging

to acess portal we have to use :(here 102 is Build.BuildID

dev-102.centralindia.azurecontainer.io:8080/ROOT102/
   


# Developer Instructions

eb-tomcat-snakes
Tomcat application that shows the use of RDS in a Java EE web application in AWS Elastic Beanstalk. The project shows the use of Servlets, JSPs, Simple Tag Support, Tag Files, JDBC, SQL, Log4J, Bootstrap, Jackson, and Elastic Beanstalk configuration files.

## INSTRUCTIONS
Install the Java 8 JDK. The java compiler is required to run the build script.
If you would like to run the web app locally, install Tomcat 8 and Postgresql 9.4.

You can deploy the ROOT.war archive that build.sh generates to an AWS Elastic Beanstalk web server environment running the Tomcat 8 platform.

### To download, build and deploy the project
Clone the project (SSH):

	~$ git clone git@github.com:awslabs/eb-tomcat-snakes.git

Or with HTTPS:

	~$ git clone https://github.com/awslabs/eb-tomcat-snakes.git

Run ``build.sh`` to compile the web app and create a WAR file (OS X or Linux):

	~$ cd eb-tomcat-snakes
	~/eb-tomcat-snakes$ ./build.sh

Or in Windows with Git Bash:

	~/eb-tomcat-snakes$ ./build-windows.sh

**IMPORTANT**
Always run build.sh from the root of the project directory.

The script compiles the project's classes, packs the necessary files into a web archive, and then attempts to copy the WAR file to ``/Library/Tomcat`` for local testing. If you installed Tomcat to another location, change the path in ``build.sh``:

	if [ -d "/path/to/Tomcat/webapps" ]; then
	  cp ROOT.war /path/to/Tomcat/webapps

Open [localhost:8080](http://localhost:8080/) in a web browser to view the application running locally.





