pipeline { 
agent {label 'TestNode' }
	environment
	{
		def dockerHUBUser = 'jmunuswa'
		def gitURL = 'https://github.com/jmunuswa/website.git'
		def registryCredential = 'dockerhub_id' 
		def seleniumTestJar = 'CapestonePrj1.jar'
		def argServer = 'http://18.191.155.113:8080/index.html'
		def argDriver = '/home/ubuntu/chromedriver'
		def argOS ='L'
		def argInstname = 'capstnprj2'
		def argK8SName = 'capstnprj2'
	}
    stages 
	{ 
	
        stage('DownloadCode') 
		{ 

            steps 
			{
			
				echo "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&[[[[[[RUN FOR GIT BRANCH : ${env.BRANCH_NAME}]]]]]]&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"


					displayMessage("Download files from GitHub - Begin")

					git url: "${gitURL}",branch: "${env.BRANCH_NAME}"
					
				displayMessage("Download files from GitHub - End")
            }
 
        }
		
		stage('BuildCode') 
		{ 

            steps 
			{
			
				displayMessage("Build Docker image - Begin")
				
					sh "sudo docker build -t ${dockerHUBUser}/${argInstname}-${env.BRANCH_NAME} ."
				
				displayMessage("Build Docker image - End")
            }
 
        }
		
		
		stage('TestCode') 
		{ 

            steps 
			{
                 
				 displayMessage("Run docker image and test using selenium - Begin")
				 
					 sh "sudo docker rm -f ${argInstname} || true"
					 sh "sudo docker run -d -p 8080:80 --name ${argInstname}  ${dockerHUBUser}/${argInstname}-${env.BRANCH_NAME}"
					 sh "cp ./${seleniumTestJar}  /home/ubuntu"
					 sh "java -jar ${seleniumTestJar} ${argServer} ${argOS}"
				 
				 displayMessage("Run docker image and test using selenium - End")
				 
				 displayMessage("Uplaod docker image to Dockerhub - Begin")
				 
					 withCredentials([string(credentialsId: 'dockerhubpwd', variable: 'dockerhubpwd')]) 
					 {
						sh "sudo docker login -u ${dockerHUBUser} -p ${dockerhubpwd}"
					 }
					 
					 sh "sudo docker push ${dockerHUBUser}/${argInstname}-${env.BRANCH_NAME}"
				 				 
				 displayMessage("Uplaod docker image to Dockerhub - End")
				 
            }
 
        }
		
		
		stage('DeploytoPROD') 
		{ 

            steps 
			{
						
				node('ProdNode')
				{
				
					 
					 displayMessage("Run K8S in PROD - Begin")
					 
					 
						kubectl delete service ${argK8SName} || true
						kubectl delete deployment ${argK8SName} || true
					 
						kubectl create deployment ${argK8SName} --image=${dockerHUBUser}/${argInstname}-${env.BRANCH_NAME} --port=80 --replicas=2
						kubectl expose deployment ${argK8SName} --type=NodePort  --port=80
					 
					 displayMessage("Run K8S in PROD - End")
				}

                
            }
 
        }
		 
    }           
 }
 
 
 void displayMessage(String argMessage) 
 {
    echo "*******************************************[[ ${argMessage} ]]****************************************************"
 }