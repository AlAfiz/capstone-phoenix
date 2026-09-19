# Team Task Manager: DevOps Capstone Project

## Project Overview
The Team Task Manager is a robust 3-tier web application deployed using a modern GitOps workflow on a K3s Kubernetes cluster. This project demonstrates end-to-end DevOps engineering practices, integrating continuous integration, container registry management, and continuous deployment through declarative infrastructure. 

## Architecture & Tech Stack
The application is structured into three primary tiers:
* **Frontend:** A React single-page application built with Vite and served via an Nginx container.
* **Backend:** A RESTful API built with Python, Flask, and SQLAlchemy.
* **Database:** PostgreSQL (15-alpine) for persistent relational data storage.

**DevOps Toolchain:**
* **CI/CD Pipeline:** GitHub Actions
* **Container Registry:** GitHub Container Registry (GHCR)
* **Continuous Deployment:** Argo CD
* **Infrastructure:** K3s (Lightweight Kubernetes)

## CI/CD & GitOps Workflow
This repository utilizes a full GitOps deployment strategy where the `main` branch serves as the single source of truth for application code and infrastructure state.

1. **Continuous Integration (GitHub Actions):** 
   Pushes modifying the `taskapp_backend_assignment/` or `taskapp_frontend/` directories trigger the automated CI pipeline. The workflow builds the Docker images and pushes them directly to GHCR as `ghcr.io/alafiz/taskapp-backend:latest` and `ghcr.io/alafiz/taskapp-frontend:latest`.
2. **Continuous Deployment (Argo CD):** 
   An Argo CD controller running inside the K3s cluster actively monitors the `manifests/` directory. It automatically syncs the cluster state to match the declarative YAML definitions whenever changes are detected.

## Kubernetes Resources
* **Postgres:** Deployment and ClusterIP Service providing stateful data storage.
* **Backend:** Deployment scaling the Flask API container, coupled with a ClusterIP Service exposed on port 5000.
* **Frontend:** Deployment running compiled React/Nginx static assets, with a ClusterIP Service exposed on port 80.

## Crucial Technical Configurations
* **Database Connection Management:** The backend relies on decoupled environment variables (`DATABASE_HOST=postgres`, `DATABASE_PORT=5432`, `DATABASE_NAME=taskapp`, `DATABASE_USER=taskapp_user`, `DATABASE_PASSWORD=taskapp_password`) rather than a hardcoded URI string.
* **Frontend API Routing:** The React frontend requires API URL injection during the Docker build phase. This is handled in GitHub Actions by passing `VITE_API_URL=http://localhost:5000/api` as a build argument to Vite so requests route successfully to the backend.

## Setup and Access Instructions
Because the application utilizes internal Kubernetes ClusterIP services, it is not exposed directly to the public internet. To access the live application locally, you must establish port-forwarding tunnels.

Open two separate terminal windows and execute the following commands:

**Terminal 1 (Expose the Frontend):**
```bash
kubectl port-forward svc/frontend 3000:80
```

**Terminal 2 (Expose the Backend API):**
```bash
kubectl port-forward svc/backend 5000:5000
```

Once both tunnels are active, navigate to `http://localhost:3000` in your web browser. 

**Demo Credentials:**
Upon the initial successful database connection, the backend automatically seeds the database with a default administrator account.
* **Username:** `admin`
* **Password:** `admin123`