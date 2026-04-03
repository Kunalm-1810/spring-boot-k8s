# Spring Boot CRUD App — Kubernetes Deployment

A production-style deployment of a Spring Boot REST API backed by MySQL, fully orchestrated on **Kubernetes** with persistent storage, environment-based configuration, and multi-replica scaling.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Backend | Java 11, Spring Boot, Spring Data JPA |
| Database | MySQL 5.7 |
| Containerization | Docker |
| Orchestration | Kubernetes (kubectl) |
| Build Tool | Maven |

---

## Architecture

```
                        ┌─────────────────────────────────┐
                        │         Kubernetes Cluster        │
                        │                                   │
  Client ──► NodePort ──►  springboot-crud-svc (port 8080) │
                        │           │                       │
                        │  ┌────────▼────────┐             │
                        │  │  Spring Boot Pod │ x3 replicas │
                        │  └────────┬────────┘             │
                        │           │                       │
                        │  ┌────────▼────────┐             │
                        │  │   mysql Service  │ (ClusterIP) │
                        │  └────────┬────────┘             │
                        │           │                       │
                        │  ┌────────▼────────┐             │
                        │  │   MySQL Pod      │             │
                        │  │  + PVC (1Gi)     │             │
                        │  └─────────────────┘             │
                        └─────────────────────────────────┘
```

---

## Project Structure

```
├── src/
│   └── main/
│       ├── java/com/singam/crud/
│       │   ├── controller/    # REST endpoints
│       │   ├── service/       # Business logic
│       │   ├── repository/    # JPA repository
│       │   └── entity/        # Order entity
│       └── resources/
│           └── application.yml
├── app-deployment.yaml        # Spring Boot Deployment + NodePort Service
├── db-deployment.yaml         # MySQL PVC + Deployment + ClusterIP Service
└── pom.xml
```

---

## REST API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/orders` | Create a new order |
| `GET` | `/orders` | Fetch all orders |
| `GET` | `/orders/{id}` | Fetch order by ID |

### Sample Request — Create Order

```json
POST /orders
{
  "name": "Laptop",
  "qty": 2,
  "price": 999.99
}
```

---

## Kubernetes Resources

### `db-deployment.yaml`
- **PersistentVolumeClaim** — 1Gi storage for MySQL data
- **Deployment** — MySQL 5.7 with volume mount at `/var/lib/mysql`
- **Service** — Headless ClusterIP (`clusterIP: None`) for DNS-based discovery

### `app-deployment.yaml`
- **Deployment** — Spring Boot app with **3 replicas**, DB config via env vars
- **Service** — NodePort on port `8080` for external access

---

## Environment Configuration

DB connection is injected via environment variables (no hardcoded secrets in code):

```yaml
env:
  - name: DB_HOST      # mysql  (K8s DNS resolves to MySQL service)
  - name: DB_NAME      # singamlabs
  - name: DB_USERNAME  # root
  - name: DB_PASSWORD  # root
```

> **Note:** For production, replace plain-text values with Kubernetes `Secrets` and `ConfigMaps`.

---

## How to Run

### Prerequisites
- Docker Desktop with Kubernetes enabled **or** Minikube
- `kubectl` configured

### Deploy

```bash
# 1. Deploy MySQL (PVC + Deployment + Service)
kubectl apply -f db-deployment.yaml

# 2. Deploy Spring Boot app (Deployment + Service)
kubectl apply -f app-deployment.yaml

# 3. Verify pods are running
kubectl get pods
kubectl get services
```

### Access the API

```bash
# Get the NodePort assigned
kubectl get svc springboot-crud-svc

# Access via
curl http://localhost:<NodePort>/orders
```

---

## Key Concepts Demonstrated

- **Multi-tier Kubernetes deployment** — separate DB and app layers
- **Persistent storage** with PersistentVolumeClaim (data survives pod restarts)
- **Service discovery** via Kubernetes DNS (`DB_HOST=mysql`)
- **Horizontal scaling** — 3 replicas of the Spring Boot app
- **Environment-based config** — 12-factor app principles
- **Recreate strategy** for stateful MySQL deployment

---

## Screenshots

| Pods Running | Services | API Response |
|---|---|---|
| ![pods](Screenshot%202026-04-01%20000014.png) | ![services](Screenshot%202026-04-01%20000037.png) | ![api](Screenshot%202026-04-01%20003917.png) |

---

## Author

**Swapnil** — [GitHub](https://github.com/) · [LinkedIn](https://linkedin.com/in/)
