# Makefile for DevSecOps Setup

# Main target to set up the environment
setup:
	@echo "Making the script executable..."
	@chmod +x devsecops_start_setup.sh
	@echo "Running the setup script..."
	@./devsecops_start_setup.sh
	@echo "Setup script completed. Use 'make dashboards' to open Minikube and Snyk dashboards."

# Optional target for cleaning up the environment if necessary
clean:
	@echo "Cleaning up the environment..."
	@# Add any cleanup commands you need here

# Open Snyk and Minikube dashboards sequentially
dashboards:
	@echo "Opening Snyk Dashboard in your browser..."
	@open https://app.snyk.io &
	@sleep 5 # Allow time for the Snyk Dashboard command to initialize
	@echo "Opening Minikube Dashboard in your browser..."
	@minikube dashboard & # Keeps Minikube running until manually terminated by the user

