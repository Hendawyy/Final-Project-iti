# Jenkins-CI/CD for Google Cloud Platform (GCP) Infrastructure and Application ☁️

This project showcases the implementation of Continuous Integration and Continuous Deployment (CI/CD) for Google Cloud Platform (GCP) infrastructure and applications using Jenkins. The infrastructure is managed as code with Terraform, and the application, consisting of a MongoDB replica set and a Node.js web application, is containerized and deployed on Google Kubernetes Engine (GKE).

## Project Components  🛠️

### This project encompasses the following key components:

-Terraform Infrastructure: We leverage custom Terraform modules to create and manage the necessary infrastructure on Google Cloud Platform. This includes setting up Identity and Access Management (IAM), network configuration (Virtual Private Cloud, subnets, firewall rules, NAT), compute resources (private VM, GKE standard cluster across three zones), and storage through the Artifact Registry.

-Infrastructure Pipeline: The first Jenkins pipeline is dedicated to managing GCP infrastructure as code. It provides two pivotal options: "apply" and "destroy," using Terraform to create or dismantle the infrastructure components.

-Application Pipeline: The second Jenkins pipeline is our CI/CD pipeline, responsible for building, containerizing, and deploying the Node.js web application and MongoDB replica set on GKE.

## 🚀 Getting Started

### Prerequisites  🛠️

Before you begin, ensure you have the following installed:

- Jenkins 🤖
- Terraform 🏗️
- Google Cloud SDK ☁️
- Docker  🐋
- Kubectl ☸

### Install The Google Cloud SDK ☁️.

1. Open a terminal window.
2. Run the following command:
   
  ```
  sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
  ```
3. Configure your GCP account and select your project by running:

  ```
  gcloud auth login
  ```
4. You will be prompted to enter the project ID.
> [!NOTE]
>If you're unsure where to find your project ID, visit the GCP console dashboard to locate this essential piece of information.
> Your chosen project will serve as the default project for all gcloud commands until it's changed.

---- 🌟 ----

### Clone this repository to your local environment to start setting up the infrastructure.

To set up the infrastructure, clone this repository to your local environment:
  ```
  git clone https://github.com/Hendawyy/Final-Project-iti.git
  cd Final-Project-iti
  ```

---- 🌟 ----

### Integration with Jenkins for automated provisioning. 🤖
 
 You need to create 2 pipelines
 Infrastructure Pipeline (1st Pipeline)
 The Infrastructure Pipeline is responsible for managing the GCP infrastructure with Terraform. It provides two options:
 
 Apply: Apply the Terraform configuration to create the infrastructure.
 Destroy: Destroy the infrastructure.
  
>[!NOTE]
> You need to push your terraform infrastructure to a version control system and use it in the pipeline or you can keep it and use this pipeline.
 
 ---- 🌟 ----
 
 Application Pipeline (2nd Pipeline)
 The Application Pipeline is a CI/CD pipeline responsible for deploying the Node.js web application and MongoDB replica set on GKE.
 
 Configure the Application Pipeline in Jenkins. Create a new pipeline job, define build parameters, and link this job to your version control system to trigger on changes.
 
 In your Jenkins job configuration, specify the necessary credentials for Google Cloud, Docker, and GKE.
 
 The Application Pipeline is triggered automatically by the Infrastructure Pipeline when the GCP infrastructure is created or updated.
 
 ---- 🌟 ----

To utilize GCP within Terraform, follow these steps:
1. Create a service account. You can do this through the GCP console or using gcloud commands:
   GCP console:
    - 1.1. Navigate to IAM.
    - 1.2. Find Service Accounts.
    - 1.3. Create a service account.
    - 1.4. Grant the editor role to this account.
    - 1.5. Inside this service account, find keys.
    - 1.6. Add a key and choose the JSON format.
    - 1.7. After adding the key, it will be downloaded automatically.
    - 1.8. Copy this key to your project directory.
    - 1.9. Create a directory called "secrets."
    - 1.10. Copy your key to this directory.
    - 1.11. Add this secret to the ```.gitignore``` file.
    - 1.12. Install to jenkins
    - 1.13. Access Jenkins Homepage [Jenkins](https://localhost:8080).
    - 1.14. Retrieve the Jenkins Admin Password:
      ```
      cat /var/jenkins_home/secrets/initialAdminPassword
      ```
   - 1.15. Enter the generated password from your terminal into your initial password on Jenkins and press "Install Suggested Plugins" and create the admin user.
   - 1.16. Inisde jenkins the first thing you need to do is to Configure Servica account Credentials
             - Go to manage jenkins
             - Select Credentials
             - Press the global Hyperlink
             - Choose "Add Credentials"
             - Choose "Secret file" as the kind
             - Upload the key you created in earlier steps. 
             - An choose an ID for this Credential ```(eg. MyGoogleServiceAccountKey)```.
   - 1.17. Then Create a New Jenkins Pipeline Job:  
          - Go to your Dashboard.
          - Click on "New Item" to create a new Jenkins job.
          - Enter a name for your job (e.g., "TerraformPipeline").
          - Choose "Pipeline" as the job type and click "OK." 
   - 1.18. Configure the Pipeline:
        - In the job configuration page:
        - Scroll down to the "Pipeline" section and choose the "Pipeline script" option.
        - Then Add the code in the ```Jenkins-Pipelines/Pipeline1-Terraform-Infrastructure-Apply.groovy``` file.
        - Then save the job.
        - Chooe build with paramaters.
        - Don't buld just yet.
  - 1.19. Then Create a New Jenkins Pipeline Job:  
       - Go to your Dashboard.
       - Click on "New Item" to create a new Jenkins job.
       - Enter a name for your job (e.g., "Deploy-and-run-Pipeline").
       - Choose "Pipeline" as the job type and click "OK".
    >[!NOTE]
    > This pipeline gets the Kubernetes file that deploys the web app from your project directory and sends it to the VM this is all done in the pipeline code however you need to change the path of the Kubernetes directory to ypur path and the anme of the VM and user.

  - 1.20. Configure the Pipeline:
       - In the job configuration page:
       - Scroll down to the "Pipeline" section and choose the "Pipeline script" option.
       - Then Add the code in the ```Jenkins-Pipelines/Pipeline2-Push&Deploy.groovy``` file.
       - Then save the job.
       - Now go to the "TerraformPipeline" and build with parameter.
       - Choose the desired action ```Apply``` or ```Destroy``` and then build.
       - Check your GCP account to ensure all instances have been created successfully.
    

---- 🌟 ----

### Startup Script 🖥️

1. The Startup script can be found in ```Scripts/Startupscript.sh``` and
2. The script installs & Confgures needed libraries in the Private VM instance.
3. GCP Authentication: The script fetches a service account key, decrypts it, activates the service account, and configures Docker for GCP.
4. Cluster Connection: It connects to the GCP Kubernetes cluster.

---- 🌟 ----

### 🌐  Access the GKE Cluster 
After applying the Terraform configuration, you'll want to access the private VM instance through Identity-Aware Proxy (IAP) and check the progress of the startup script. Follow these steps:

1. Access the private VM instance using the following command, replacing <project-name> and <vm-zone> with your specific project and zone information:
   ```
   gcloud compute ssh <instance-name> --project=<project-name> --zone=<vm-zone> --tunnel-through-iap
   ```
2. Once connected, check the progress of the startup script by viewing the log file:
   ```
   cat /var/log/syslog | grep startup-script
   ```
3. Obtain the cluster credentials using the following command, replacing <cluster-name>, <cluster-zone>, and <project-name> with your specific cluster and project details:
   ```
   gcloud container clusters get-credentials <cluster-name> --zone <cluster-zone> --project <project-name> --internal-ip
   ```
4. After building the Jenkins pipeline, you will see running pods. To access the web application, obtain the service IP:
   ```
   kubectl get svc -n node
   ```
5. Copy the External-IP and paste it into your browser to access the web application. The web app displays the number of visits, which increases every time you reload the page.
6. this app has ```visists:number of visits``` every time you reload the ```number of visits``` will increase
7. since in Kubernetes (K8s), "stateful" means  that each pod in a stateful application has persistent storage to maintain its state. If the database fails for any reason, you can still access the data.
8. You can check this by destroying mongodb-0 and then reloading the browser. The ```number of visits``` will remain unchanged and increase from the last visit.
   ```
   curl <EXTERNAL_IP>
   delete pods mongodb-0-n mongo
   curl <EXTERNAL_IP>
   ```

---- 🌟 ----

### 🧹 Clean Up

To clean up and delete all resources:
```
# Delete all pods by deleting namespaces
kubectl delete ns mongo node

```
- In order to destroy all the instances, navigate to the first pipeline job, "TerraformPipeline," and trigger it with parameters. 
- Choose the "destroy" action, and during the destruction process, remember to delete the disks used by the databases from the Google Cloud Console.
- You can find these disks under Compute Engine, where you can select and delete them. 

---- 🌟 ----

## Questions or Need Help?

If you have any questions, suggestions, or need assistance, please don't hesitate to Contact Me [Seif Hendawy](mailto:seifhendawy1@gmail.com). 😉

