# Monitoring

## Metrics vs Monitoring
Metrics are measurements or data points that tell you what is happening. For example, the number of steps you walk each day, your heart rate, or the temperature outside—these are all metrics.

Monitoring is the process of watching these metrics over time to understand what’s normal, spot changes, and detect problems.

## 🚀 Prometheus Overview
Prometheus is an open-source system for monitoring and sending alerts. It collects and stores time-series data (data that changes over time) using its own database. It can be used in various environments, including Kubernetes.

### Prometheus Architecture
Here's a simple view of how Prometheus works:

![alt text](prometheus-architecture.gif)

- **Prometheus Server**: The main component that collects (scrapes) metrics and stores them.
- **Service Discovery**: Automatically finds services and applications to monitor.
- **Pushgateway**: Allows short-lived jobs to push metrics.
- **Alertmanager**: Manages alerts and sends notifications via email, Slack, or PagerDuty.
- **Exporters**: Collects metrics from external systems and makes them available to Prometheus.
- **Grafana**: Visualizes the collected metrics.

## 🛠️ Installation & Configuration

### Step 1: Create GKE Cluster
Make sure you have a GKE cluster up and running.

### Step 2: Install kube-prometheus-stack
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

### Step 3: Deploy into a Namespace
```bash
kubectl create ns monitoring
cd day-2
helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring -f ./custom_kube_prometheus_stack.yml
```

### Step 4: Verify Installation
```bash
kubectl get all -n monitoring
```

## 📍 Step 5: Access Prometheus, Grafana, and Alertmanager
Create LoadBalancer services using the following YAML:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: prometheus-loadbalancer
  namespace: monitoring
spec:
  type: LoadBalancer
  ports:
  - port: 9090
    targetPort: 9090
    protocol: TCP
  selector:
    app.kubernetes.io/name: prometheus
---
apiVersion: v1
kind: Service
metadata:
  name: grafana-loadbalancer
  namespace: monitoring
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 3000
    protocol: TCP
  selector:
    app.kubernetes.io/name: grafana
---
apiVersion: v1
kind: Service
metadata:
  name: alertmanager-loadbalancer
  namespace: monitoring
spec:
  type: LoadBalancer
  ports:
  - port: 9093
    targetPort: 9093
    protocol: TCP
  selector:
    app.kubernetes.io/name: alertmanager
```

Apply the services:
```bash
kubectl apply -f loadbalancer_services.yaml
```

Get the External IPs:
```bash
kubectl get svc -n monitoring
```
- **Prometheus**: `http://<EXTERNAL_IP_PROMETHEUS>:9090`
- **Grafana**: `http://<EXTERNAL_IP_GRAFANA>` (Password: `prom-operator`)
- **Alertmanager**: `http://<EXTERNAL_IP_ALERTMANAGER>:9093`

## 🧼 Step 6: Clean Up
Uninstall helm chart:
```bash
helm uninstall monitoring --namespace monitoring
```
Delete namespace:
```bash
kubectl delete ns monitoring
```
Delete GKE Cluster:
```bash
gcloud container clusters delete observability --region=us-central1
```
