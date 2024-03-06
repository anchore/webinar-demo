# Cleanup

## Step 1: Spin down your Anchore deployment

**Compose**
```
# Bring Anchore Compose down
docker compose -f ./deployment/anchore-compose.yaml down
```
**K8s**
```
TBD
helm uninstall anchore
```

## Step2: Ways to learn more about Anchore Enterprise

