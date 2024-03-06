# Prerequisites

## Step 1: Get Access to Anchore Enterprise

Anchore Enterprise requires a license and access to container images to operate.

To get access, you have two options:
1. Use our [Anchore AWS Free Trial](https://get.anchore.com/free-trial/) 
   1. _An AWS account and ability to launch instances in us-west-1, us-east-1, or us-east-2 is required._
2. For Compose and K8s deployments - Fill out this [simple form](https://forms.gle/NMhpVU19SuXRnLhC9) to get access credentials.
   1. _Please create a file named demo-secrets.yaml in the deployment directory using the contents you receive after submitting the form._

## Step 2: Deploy Anchore Enterprise

You can now deploy Anchore Enterprise into your chosen environment.

### Deployment Instructions for AWS - Anchore Trial AMI
Follow the [installation instructions](https://sites.google.com/anchore.com/anchore-enterprise-trial) included in the free trial email.
Move to Step 3 below when you have a working environment

### Deployment Instructions for Compose and K8s
Follow the instructions below to Deploy Anchore Enterprise into your chosen deployment environment

### Requirements
- Compose
  - Docker v1.12 or higher, and a version of Docker Compose that supports at least v2 of the docker-compose configuration format.
- Helm Deployment to K8s
  - [Helm](https://helm.sh/) >=3.8
  - [Kubernetes](https://kubernetes.io/) >=1.23
  - Kubectl 
- demo-secrets.yaml
  -  This contains an Anchore license and credentials to access Anchore Enterprise images in DockerHub

### Setup

**K8s & Compose**
```
# Create demo-secrets.yaml in the deployment directory
```

**Compose**
```
# Run compose
docker compose -f ./deployment/anchore-compose.yaml up -d
```
**K8s**
```
# Make the script executable
chmod +x ./deployment/setup.sh

# Run the script
./deployment/setup.sh
# Please note it may take a few minutes for Anchore to spin up and for all services to be operational
```

### Login to the Anchore Web Application

To use Anchore you need the URL, username, and password to access the API and/or the UI.

**Compose**
1. Point your browser at the Anchore Enterprise UI by directing it to http://localhost:3000/.
2. Enter the username admin and password foobar to log in.

**K8s**
```
# The Anchore UI can be accessed via localhost:8080 with kubernetes port-forwarding:

    kubectl port-forward svc/anchore-enterprise-ui 8080:80

# The Anchore API can be accessed via localhost:8228 with kubernetes port-forwarding:

    kubectl port-forward svc/anchore-enterprise-api 8228:8228

# Get the default admin password using the following command:

    kubectl get secret anchore-enterprise -o jsonpath='{.data.ANCHORE_ADMIN_PASSWORD}' | base64 -D
```
Point your browser at the Anchore Enterprise UI by directing it to http://localhost:8080/ and use username: admin password: as per kubectl output above.

## Step 3: Install AnchoreCTL

Next, we'll install the lightweight Anchore Enterprise client tool, quickly test using the `version` operation, and set up a few environment variables to allow it to interact with your quickstart deployment using the following process:

Edit and run the following script
```shell script
# curl -sSfL  https://anchorectl-releases.anchore.io/anchorectl/install.sh  | sh -s -- -b /usr/local/bin v5.3.0

# ./anchorectl version
Application:        anchorectl
Version:            5.3.0
SyftVersion:        v0.97.1
BuildDate:          2023-11-21T22:09:54Z
GitCommit:          f7604438b45f7161c11145999897d4ae3efcb0c8
GitDescription:     v5.3.0
Platform:           linux/amd64
GoVersion:          go1.21.1
Compiler:           gc

export ANCHORECTL_URL="http://localhost:8228"
export ANCHORECTL_USERNAME="admin"
# Compose
# export ANCHORECTL_PASSWORD="foobar" 
# K8s
# export ANCHORECTL_PASSWORD=$(kubectl get secret anchore-enterprise -o jsonpath='{.data.ANCHORE_ADMIN_PASSWORD}' | base64 -D)

```
NOTE: for this tutorial, we're installing the tool in your local directory `./` and will be using environment variables throughout.  To more permanently install and configure `anchorectl` to remove the need for setting environment variables and putting the tool in a globally accessible path, see [Installing AnchoreCTL](https://docs.anchore.com/current/docs/deployment/anchorectl/}).

## Step 5: Nice work!

Congratulations you have achieved much. Now onwards - to learning about Anchore Enterprise.

Next Lab: [Visibility](02-visibility.md)