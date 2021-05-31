# Cybersecurity-Project-1
1st project for the UWA Cybersecurity Boot Camp

## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

![Cybersecurity-Project-1/Diagrams/Project_1_Diagram_Ben_Burrell.png](Diagrams/Project_1_Diagram_Ben_Burrell.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, we can select portions of the yml and config files that may be used to install only certain pieces of it, such as Filebeat.

- [Ansible Playbook](Ansible/ansible-playbook.yml)
- [Ansible Configuration File](Ansible/ansible.cfg)
- [Ansible Hosts File](Ansible/ansible_hosts_file)
- [Ansible ELK Installation and ELK VM Configuration](Ansible/install-elk.yml)
- [Ansible Filebeat Playbook](Ansible/filebeat-playbook.yml)
- [Ansible Filebeat Configuration File](Ansible/filebeat-config.yml)
- [Ansible Metricbeat Playbook](Ansible/metricbeat-playbook.yml)
- [Ansible Metricbeat Configuration File](Ansible/metricbeat-config.yml)


This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting traffic to the network.
- **Load Balancers:** A load balancer can add additional layers of security to web VMs with minimal changes, it does protect against DDos attacks by distributing traffic evenly against the nominated VMs in the backend pool but it would also be possible to add additional security measures here such as authentication of user access via username and password before further access or the deployment of a web application firewall (WAP) to protect applications from emerging threats.
- **Jump Box:** An advantage of using a secure computer jump box is that all admins must first connect to it before launching any administrative task or use it as an origination point to connect to other servers or untrusted environments. Having restricted administrative access in this way can make a network more secure, it can also simplify the execution of tasks across a network.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the data and system logs.
- **Filebeat:** Filebeat monitors the log files or specifically nominated locations and log events, it will forward them to Elasticsearch or Logstash depending on which is the most appropriate.
- **Metricbeat:**  Metricbeat records differing metrics and statistics and ships them to a specified output location such as Elasticsearch or Logstash.

The configuration details of each machine may be found below.

| Name     | Function | IP Address | Operating System |
|----------|----------|------------|------------------|
| Jump Box | Gateway  | 20.36.45.213 / 10.1.0.4   | Linux            |
| Web-1     |   Web Server       |       10.1.0.5     |         Linux         |
| Web-2     |    Web Server      |     10.1.0.6       |        Linux          |
| Web-3     |    Web Server      |      10.1.0.7      |        Linux          |
| ELK    |    ELK Server      |     52.141.5.171 / 10.2.0.4 |   Linux      |
| Load Balancer     | Load Balancer  | 20.36.43.5      |        Linux   |
| Workstation     |    Access Control | External IP      | Linux          |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the ELK Server machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
- A singular workstation public IP address (this address is pre-registered in the ELK machines security rules), it will be seeking a destination port of 5601.

Machines within the network can only be accessed by Jump Box Provisioner.
- Jump Box Provisioner IP: 10.1.0.4 on SSH port 22, this access is provided in the security rules covering the network. 

A summary of the access policies in place can be found in the table below.

| Name     | Publicly Accessible | Allowed IP Addresses |
|----------|---------------------|----------------------|
| Jump Box | No              | Workstation Public IP on SSH port 22    |
|    Web-1 | No              | 10.1.0.4 on SSH 22                 |
|       Web-2    |   No                   |10.1.0.4 on SSH port 22
|      Web-3    |   No                  |    10.1.0.4 on SSH port 22                  |
|  ELK        | Yes                    |       Workstation Public IP on Port 5601               |
|   Load Balancer       |         No            |     Workstation Public IP on HTTP port 80     |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because this limits the time and human error concerns in successful deployment. Ansible allows us to deploy multitier apps more easily, more quickly and with consistency. Ansible's ability for automatic configuration only requires us to list the tasks we need to be completed in the correct syntax and it will execute the tasks and make the necessary systems adjustments to reflect the requests from the playbook file.

The playbook implements the following tasks:

- We **name** this configuration and specify the **hosts** to which we want to deploy it, we also name a different **remote user** 
```bash
  - name: Configure Elk VM with Docker
    hosts: elk
    remote_user: azdmin
    become: true
    tasks:
```
- We use apt module in Linux to install **docker.io** and **python3-pip** and then **docker** which is a docker python pip module
```bash
  - name: Install docker.io
      apt:
        update_cache: yes
        force_apt_get: yes
        name: docker.io
        state: present
  - name: Install python3-pip
      apt:
        force_apt_get: yes
        name: python3-pip
        state: present
  - name: Install Docker module
      pip:
        name: docker
        state: present
```
- We use **sysctl** to increase memory to make sure that ELK can run effectively
```bash 
  - name: Use more memory
      sysctl
        name: vm.max_map_count
        value: "262144"
        state: present
        reload: yes
```
- We now launch the **docker container** and expose it on the list of **published ports** we have created
```bash
  - name: download and launch a docker elk container
      docker_container:
        name: elk
        image: sebp/elk:761
        state: started
        restart_policy: always
        published_ports:
          -  5601:5601
          -  9200:9200
          -  5044:5044
```
The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![TODO: Update the path with the name of your screenshot of docker ps output](Diagrams/ELK_docker_ps.png)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- Web-1 : 10.1.0.5
- Web-2 : 10.1.0.6
- Web-3 : 10.1.0.7

We have installed the following Beats on these machines:
- We successfully installed **Filebeat** and **Metricbeat** as part of our ELK stack, the relevant information from Web-1, Web-2, and Web-3 is transported to the ELK server.

These Beats allow us to collect the following information from each machine:
- **Filebeat:** collects log events such as SSH logins, Sudo commands, and syslogs. we can use this data to see who is accessing the system and how they are doing it as well as what they are doing in the system. 
- **Metricbeat:** collects metrics for the system, the host, and the containers. This includes metrics on the CPU, memory, processes, and network traffic to name a few. This helps us to see if the systems are executing unusual processes or monitor any unusual network traffic patterns. 

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the **elk_install.yml** file to **/etc/ansible/roles/elk_install.yml**
- Update the **hosts** file to include the attribute **[elk]** underneath the **[webservers]** and their IPs and then include the IP of the Korean ELK server directly below **[elk]**. In the .yml file to be installed it should nominate the group of machines that the file will be installed on, it will do this in the first section of the .yml file under the section for **hosts:**. For example the **elk_install.yml** will have **hosts: elk** nominated, for **filebeat** or **metricbeat** it would have **hosts: webservers** nominated. Once the ansible **hosts** file is updated it should look like this: 
```bash 
# /etc/ansible/hosts
[webservers]
10.1.0.5 ansible_python_interpreter=usr/bin/python3
10.1.0.6 ansible_python_interpreter=usr/bin/python3
10.1.0.7 ansible_python_interpreter=usr/bin/python3

[elk]
10.2.0.4 ansible_python_interpreter=usr/bin/python3
```

- Run the playbook by using the command 
```bash
ansible-playbook /etc/ansible/roles/elk_install.yml
```
- Then navigate in your browser using your elk server public IP to **http://[your elk_server]:5601/app/kibana** to check that the installation worked as expected, in our case we will use **http://52.141.5.171:5601/app/kibana**. If it is working correctly we should see the following;

<img src="https://github.com/bigben130/Cybersecurity-Project-1/blob/main/Diagrams/Korea-VM-ELK%20Kibana%20Screen%20Shot.png">

_As a **Bonus**, provide the specific commands the user will need to run to download the playbook, update the files, etc._

### Downloading Filebeat

For the filebeat playbook we can access the file from the kibana site we accessed at http://52.141.5.171:5601/app/kibana, we will now find the tab "add log data", then locate the "system log" box and click, then under the 'Getting Started' heading we find the "DEB" tab and click, we can see here that the comands to download and install filebeat.

Download
```bash
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.4.0-amd64.deb
```
Install
```bash
sudo dpkg -i filebeat-7.4.0-amd64.deb
```
before we run this playbook we must first update the configuration file appropriatly, we can download the filebeat configuration file using this command
```bash 
curl -L -O https://gist.githubusercontent.com/slape/5cc350109583af6cbe577bbcc0710c93/raw/eca603b72586fbe148c11f9c87bf96a63cb25760/Filebeat
```
This file should be named filebeat-config.yml (rename this file if it does not appear so) and as advised in the "System Logs" "Getting Started" guide we must update two specific areas of the config file with the host details to ensure the smooth installation of filebeat. To access the file contents we will use command
```bash
nano filebeat-config.yml
```
now we can update the following area
```bash 
output.elasticsearch:
  hosts: ["10.2.0.4:9200"] 
  username: "elastic"
  password: "changeme"
```
and also
```bash 
setup.kibaba:
  host: "10.2.0.4:5601"
```
completed copies of the [filebeat-playbook.yml](Ansible/filebeat-playbook.yml) amd [filebeat-config.yml](Ansible/filebeat-config.yml) can be viewed here. 

The downloaded and updated files need to be saved in the apropriate loactions on the **Jumpbox ansible container** so that they will run correctly, the **filebeat-config.yml** file needs to be saved in **/etc/ansible/files** and the **filebeat-playbook.yml** needs to be saved in **/etc/ansible/roles**. 

We can now run the filebeat-playbook.yml with this command while in the **Jumpbox ansible container**
```bash
ansible-playbook /etc/ansible/roles/filebeat-playbook.yml
```
After it has successfully completed we can check that the filebeat information from Web-1, Web-2, and Web-3 is successfully being recieved by Kibana on our ELK server by navigating in Kibana to the **"check data"** box in the "System Logs" "Getting Started" guide, if it is successfulf we should see a green box appear with "Data successfully recieved from this module" 

<img src="https://github.com/bigben130/Cybersecurity-Project-1/blob/main/Diagrams/Korea-VM-ELK%20Kibana%20Filebeat%20Check%20Data%20Screen%20Shot.png">

### Downloading Metricbeat

For the metricbeat playbook we can access the file from the kibana site we accessed at http://52.141.5.171:5601/app/kibana, we will now find the tab "add metric data", then locate the "docker metrics" box and click, then under the 'Getting Started' heading we find the "DEB" tab and click, we can see here that the comands to download and install metricbeat.

Download
```bash
curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.4.0-amd64.deb
```
Install
```bash
sudo dpkg -i metricbeat-7.4.0-amd64.deb
```
before we run this playbook we must first update the configuration file appropriatly, we can download the metricbeat configuration file using this command
```bash 
curl -L -O  https://gist.githubusercontent.com/slape/58541585cc1886d2e26cd8be557ce04c/raw/0ce2c7e744c54513616966affb5e9d96f5e12f73/metricbeat
```
This file should be named metricbeat-config.yml (rename this file if it does not appear so) and as advised in the "docker metrics" "Getting Started" guide we must update two specific areas of the config file with the host details to ensure the smooth installation of metricbeat. To access the file contents we will use command
```bash
nano metricbeat-config.yml
```
now we can update the following area
```bash 
setup.kibaba:
  host: "10.2.0.4:5601"
```
and also
```bash 
output.elasticsearch:
  hosts: ["10.2.0.4:9200"] 
  username: "elastic"
  password: "changeme"
```
completed copies of the [metricbeat-playbook.yml](Ansible/metricbeat-playbook.yml) amd [metricbeat-config.yml](Ansible/metricbeat-config.yml) can be viewed here.

The downloaded and updated files need to be saved in the apropriate loactions on the **Jumpbox ansible container** so that they will run correctly, the **metricbeat-config.yml** file needs to be saved in **/etc/ansible/files** and the **metricbeat-playbook.yml** needs to be saved in **/etc/ansible/roles**. 

We can now run the metricbeat-playbook.yml with this command while in the **Jumpbox ansible container**
```bash
ansible-playbook /etc/ansible/roles/metricbeat-playbook.yml
```
After it has successfully completed we can check that the filebeat information from Web-1, Web-2, and Web-3 is successfully being recieved by Kibana on our ELK server by navigating in Kibana to the **"check data"** box in the "Docker metrics" "Getting Started" guide, if it is successfulf we should see a green box appear with "Data successfully recieved from this module" 

<img src="https://github.com/bigben130/Cybersecurity-Project-1/blob/main/Diagrams/Korea-VM-ELK%20Kibana%20Metricbeat%20Check%20Data%20Screen%20Shot.png">

