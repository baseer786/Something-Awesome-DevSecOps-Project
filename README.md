# Something-Awesome-DevSecOps-Project

This project was developed for course COMP6441 - Security Engineering and Cyber Security called "Something Awesome Project" 
This project repo provides a template for DevSecOps pipeline using Docker, Kubernetes, Jenkins, Ansible, OWASP Dependency Check, Snyk, and other security tools. The pipeline enables continuous integration, deployment, and security scanning of the microservices.

## Setup Instructions

### Clone the Repository

1. Clone the repository to your local machine:

    ```bash
    git clone <your-repository-url>
    cd Something-Awesome-DevSecOps-Project
    ```

### Install Dependencies for Services

2. Navigate to the `services` directory and install dependencies for each microservice:

    ```bash
    cd services/user-service && npm install
    cd ../order-service && npm install
    cd ../product-service && npm install
    ```

## Prerequisites

Ensure the following tools are installed on your system:

### For Local Setup

1. **Homebrew (For macOS users):**

    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

2. **Node.js and npm:**

    ```bash
    brew install node
    ```

3. **Docker:**
   - Install Docker Desktop from Docker's official website.
   - Ensure Docker is running before starting the setup.

4. **Kubernetes (Minikube):**

    ```bash
    brew install minikube
    minikube start
    ```

5. **Jenkins (Optional for Jenkins setup):**

    Install Jenkins using Homebrew:

    ```bash
    brew install jenkins-lts
    ```

6. **Ansible:**

    Install Ansible for managing deployments:

    ```bash
    brew install ansible
    ```

7. **OWASP Dependency Check:**

    ```bash
    brew install dependency-check
    ```

8. **Snyk CLI:**

    ```bash
    npm install -g snyk
    ```

## Project Structure

- **services/**: Contains microservices for User, Order, and Product.
- **ansible/**: Includes Ansible playbooks for deployment.
- **terraform/**: Terraform configurations for infrastructure setup (if needed).
- **Jenkinsfile**: Jenkins pipeline script to automate CI/CD.

## Running the Project Locally

To manually run the different components and services of the project:

### Step 1: Install Dependencies

Install Node.js dependencies for each microservice:

```bash
cd services/user-service && npm install
cd ../order-service && npm install
cd ../product-service && npm install
```

### Step 2: Run OWASP Dependency Check

Run OWASP Dependency Check on each microservice:

```bash
cd services/user-service
$(brew --prefix dependency-check)/bin/dependency-check --project "user-service" --scan . --format ALL --out ../../owasp-reports/user-service
```

**Note:** OWASP Dependency Check requires access to the National Vulnerability Database (NVD) to fetch the latest vulnerability information. You might need an NVD API key to avoid rate-limiting issues, which can be obtained from [NVD's website](https://nvd.nist.gov/developers/request-an-api-key). Make sure to add the `--nvdApiKey YOUR_API_KEY` argument when running the scan if required.

Repeat for the other microservices (order-service and product-service).

### Step 3: Build Docker Images

Build Docker images for each microservice:

```bash
cd services/user-service && docker build -t user-service:latest .
cd ../order-service && docker build -t order-service:latest .
cd ../product-service && docker build -t product-service:latest .
```

### Step 4: Deploy with Kubernetes using Ansible

Activate the Ansible virtual environment and deploy to Kubernetes:

```bash
source /Users/venvs/ansible-env/bin/activate
ansible-playbook -i ansible/inventory ansible/deploy.yml --connection=local
```

### Step 5: Check Kubernetes Status

Verify Kubernetes deployments, pods, and services:

```bash
kubectl get deployments
kubectl get pods
kubectl get services
```

### Step 6: Run Snyk Scan

Run Snyk to scan for vulnerabilities:

```bash
snyk auth <YOUR_SNYK_TOKEN>
snyk test
```

**Note:** Snyk is an essential part of the security scan process and must be run to ensure no vulnerabilities exist in the codebase.

### Step 7: Launch Minikube Dashboard

You can access the Kubernetes dashboard using:

```bash
minikube dashboard
```

**Note:** This command will block the terminal. Use a separate terminal window for further commands.

## Running the Project with Jenkins

### Step 1: Start Jenkins

Start Jenkins manually:

```bash
brew services start jenkins-lts
```

Jenkins will be available at [http://localhost:8080](http://localhost:8080).

### Step 2: Setup Jenkins Job

1. Create a new Jenkins Pipeline job.
2. Use the Jenkinsfile from the root of this repository for the pipeline script.
3. Configure any required credentials:
    - **DockerHub Credentials**: For pushing Docker images.
    - **Snyk API Token**: For running vulnerability scans.

### Step 3: Run the Pipeline

Run the Jenkins pipeline to perform the full CI/CD process, including:

- Installing dependencies for all services.
- Running ESLint checks.
- Running Snyk tests and uploading results.
- Running OWASP Dependency Check.
- Building Docker images and pushing them to DockerHub.
- Deploying to Kubernetes using Ansible.
- Performing Kubernetes health checks.

## Using the Makefile

Once everything is set up, you can use the Makefile to automate checks:

### Setup All Services

Ensure all services are running smoothly:

```bash
make setup
```

### Launch Kubernetes Dashboard

Open the Minikube dashboard:

```bash
make dashboard
```
