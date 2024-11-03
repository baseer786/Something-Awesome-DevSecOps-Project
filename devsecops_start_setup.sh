#!/bin/bash

# This script sets up the entire DevSecOps pipeline environment
# Please make sure Docker, Minikube, Jenkins, Ansible, and Kubernetes are installed and accessible

# Function to check the status of services
check_service_status() {
    echo "Checking Docker Status..."
    docker ps

    echo "Checking Kubernetes Status..."
    kubectl get nodes
    kubectl get pods --all-namespaces

    echo "Checking Ansible Setup..."
    ansible --version
}

# Install dependencies for user, order, and product services
install_dependencies() {
    echo "Installing service dependencies..."
    for service in user-service order-service product-service; do
        echo "Installing dependencies for $service..."
        (cd services/$service && npm install)
    done
}

# Run ESLint checks
run_eslint() {
    echo "Running ESLint checks for all services..."
    for service in user-service order-service product-service; do
        echo "Running ESLint for $service..."
        (cd services/$service && npx eslint .)
    done
}

# Run OWASP Dependency-Check
run_owasp_check() {
    echo "Running OWASP Dependency-Check for all services..."
    for service in user-service order-service product-service; do
        echo "Running OWASP Dependency-Check for $service..."
        (cd services/$service && $(brew --prefix dependency-check)/bin/dependency-check --project "$service" --scan . --format ALL --out ./dependency-check-report --nvdApiKey 581c658a-1edf-40a7-aa4b-b5772a7699cd)
        mkdir -p owasp-reports/$service
        mv services/$service/dependency-check-report/* owasp-reports/$service/
    done
    echo "OWASP Dependency-Check reports can be retrieved from the owasp-reports folder."
}

# Build Docker images
build_docker_images() {
    echo "Building Docker images for all services..."
    for service in user-service order-service product-service; do
        echo "Building Docker image for $service..."
        (cd services/$service && docker build -t baseerburney/$service:latest .)
    done
}

# Kubernetes deployment using Ansible
deploy_to_kubernetes() {
    echo "Deploying services to Kubernetes using Ansible..."
    echo "Activating virtual environment at /Users/baseerikram/venvs/ansible-env"
    source /Users/baseerikram/venvs/ansible-env/bin/activate
    ansible-playbook -i ansible/inventory ansible/deploy.yml --connection=local
}

# Kubernetes health checks
run_kubernetes_health_checks() {
    echo "Running Kubernetes Health Checks..."
    kubectl get deployments
    kubectl get pods
    kubectl get services
    kubectl describe deployments
    kubectl describe pods
    kubectl describe services
}

# Main execution
main() {
    check_service_status
    install_dependencies
    run_eslint
    run_owasp_check
    build_docker_images
    deploy_to_kubernetes
    run_kubernetes_health_checks

    echo "All tasks are completed. You can run 'make dashboards' to open the Minikube and Snyk dashboards."
}

main

