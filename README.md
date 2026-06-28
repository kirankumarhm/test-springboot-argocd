# Test Spring Boot ArgoCD Project

This project is a demonstration of a Spring Boot application deployed to a Kubernetes cluster using ArgoCD for Continuous Delivery. It showcases the integration of a Java backend with Helm charts and GitOps practices, specifically tailored for local development using **Minikube**.

## 🚀 Project Overview

The project consists of a simple Spring Boot application that is containerized and deployed via a Helm chart. ArgoCD is used to synchronize the state of the Kubernetes cluster with the configuration stored in this Git repository.

### Tech Stack
- **Backend:** Java 17, Spring Boot 4.0.6
- **Build Tool:** Maven
- **Containerization:** Docker
- **Orchestration:** Kubernetes (Minikube for local dev)
- **Package Management:** Helm
- **CD Tool:** ArgoCD

## 📁 Project Structure

```text
├── Dockerfile               # Docker configuration for the application
├── pom.xml                  # Maven project object model
├── src/                      # Java source code and resources
├── k8s/                      # Kubernetes configuration
│   ├── argocd/              # ArgoCD Application manifest
│   │   └── application.yaml
│   └── helm/                # Helm charts for the service
│       └── test-app-service/
│           ├── Chart.yaml
│           ├── values.yaml
│           └── templates/    # Kubernetes resource templates
└── HELP.md                  # Additional help documentation
```

## 🛠️ Getting Started

### Prerequisites
- Java 17 JDK
- Maven
- Docker
- **Minikube** (Local Kubernetes cluster)
- **Helm** (Kubernetes package manager)
- ArgoCD installed in the cluster

### Local Development
1. Clone the repository:
   ```bash
   git clone https://github.com/kirankumarhm/test-springboot-argocd.git
   cd test-springboot-argocd
   ```
2. Build the application:
   ```bash
   ./mvnw clean package
   ```
3. Run the application:
   ```bash
   java -jar target/test-0.0.1-SNAPSHOT.jar
   ```

## 🚢 Deployment Guide

### 1. Local Kubernetes Setup with Minikube
To run this project locally, start Minikube and point your Docker daemon to the Minikube environment so you don't have to push images to a remote registry:

```bash
# Start Minikube
minikube start

# Set Docker to use Minikube's internal Docker daemon
eval $(minikube docker-env)
```

### 2. Building and Loading the Image
Since we are using `pullPolicy: Never` in `values.yaml` for local development, we build the image directly inside the Minikube Docker environment:

```bash
docker build -t kiran/api-service:1.0.0 .
```

### 3. Deploying with Helm (Manual Method)
If you want to test the deployment without ArgoCD first:

```bash
# Install the chart manually
helm install test-app-service k8s/helm/test-app-service -n testapps --create-namespace
```

### 4. GitOps Deployment with ArgoCD
The project uses an ArgoCD `Application` manifest in `k8s/argocd/application.yaml` to automate the deployment.

**Deployment Steps:**
1. Apply the application manifest to your cluster:
   ```bash
   kubectl apply -f k8s/argocd/application.yaml
   ```
2. ArgoCD will automatically:
   - Pull the Helm chart from the `k8s/helm/test-app-service` directory.
   - Deploy the resources to the `testapps` namespace.
   - Maintain the desired state via self-healing and pruning.

## ⚙️ Kubernetes & Helm Configuration

### Helm Chart Details
The chart `test-app-service` manages the following:
- **Deployment**: Scales the application (default: 2 replicas).
- **Service**: Exposes the application on port 80 (ClusterIP).
- **Ingress**: Configurable via `values.yaml` to route traffic to the `/api` path.

### Key Configuration in `values.yaml`
- `image.repository`: Set to `kiran/api-service`.
- `image.pullPolicy`: Set to `Never` (essential for Minikube local images).
- `service.port`: 80 (External) $\rightarrow$ 8080 (Spring Boot internal).

## 📄 License
This project is for demonstration purposes.

