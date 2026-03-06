```
# Kratix Deployment Tool

## Project Structure

The Kratix Deployment Tool is a collection of Ansible roles and playbooks designed to simplify the deployment of Kratix clusters. The project structure is organized into the following directories:

* `roles`: contains two Ansible roles, `kratix_install` and `kratix_worker`, each with its own set of tasks, templates, and variables.
* `k8s`: contains various Kubernetes configuration files, including YAML files for creating clusters and deploying applications.
* `group_vars`: contains a single YAML file, `all.yml`, which defines default variables for Ansible playbooks.
* `secrets.yml`: contains sensitive configuration information, such as API keys and credentials, encrypted using Ansible's built-in vault functionality.
* `create_clusters.sh`: a Bash script that automates the creation of Kratix clusters using the Ansible playbooks.
* `install_kratix.sh`: a Bash script that automates the installation of Kratix using the Ansible role.
* `install_kratix.yaml`: an Ansible playbook that installs Kratix using the Ansible role.
* `requirements.txt` and `requirements.yml`: specify the required Ansible modules and dependencies for the project.

## Installation

To install the Kratix Deployment Tool, follow these steps:

1. Clone the repository using Git: `git clone https://github.com/your-username/kratix-deployment-tool.git`
2. Install the required Ansible modules by running: `ansible-galaxy install -r requirements.yml`
3. Run the `install_kratix.sh` script to install Kratix: `./install_kratix.sh`
4. Run the `create_clusters.sh` script to create a Kratix cluster: `./create_clusters.sh`

## Usage

Once the Kratix Deployment Tool is installed, you can use it to create and manage Kratix clusters. Here are some examples of how to use the tool:

* Create a new Kratix cluster: `ansible-playbook -i <inventory_file> create_cluster.yml`
* Install Kratix on a machine: `ansible-playbook -i <inventory_file> install_kratix.yml`
* Configure a Kratix cluster: `ansible-playbook -i <inventory_file> configure_cluster.yml`

Note: You will need to replace `<inventory_file>` with the path to your Ansible inventory file.

For more information on using Ansible and the Kratix Deployment Tool, please refer to the Ansible documentation and the Kratix documentation.

