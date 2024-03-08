# Prerequisites

## Step 0: Checkout this Repo

Clone this repo to a suitable location that will allow you to setup your Anchore deployment and run through the lab examples.

## Step 1: Get Access to Anchore Enterprise

You will require an Anchore license and set of credentials to pull the images for this demo.

To obtain the required licence and credentials instantly, please fill out this [form](https://forms.gle/NMhpVU19SuXRnLhC9).
Copy the returned form output into deployment/demo-secrets.yaml.
```bash
cd deployment
echo 'form-sign-up-file-contents-here' > demo-secrets.yaml
```

## Step 2: Deploy Anchore Enterprise

You can spin up an Anchore Enterprise Demo environment in three ways:

### Option 1: AWS using the Anchore Trial

**Requirements**
- An AWS account with the ability to launch instances in us-west-1, us-east-1, or us-east-2 is required.
- Fill out this form [Anchore Free Trial](https://get.anchore.com/free-trial/)

**Setup**

Follow the [installation instructions](https://sites.google.com/anchore.com/anchore-enterprise-trial) included in the free trial email.

**Login**

Review [launching the trial](https://sites.google.com/anchore.com/anchore-enterprise-trial#h.ddctetfymxlt) and [accessing the trial](https://sites.google.com/anchore.com/anchore-enterprise-trial#h.ddctetfymxlt) on how to access the Anchore Enterprise UI and login.

### Option 2: Helm on Kubernetes

**Requirements**
- [Helm](https://helm.sh/) >=3.8
- [Kubernetes](https://kubernetes.io/) >=1.23
   - A stand-alone deployment requires at least 4GB of RAM, and enough disk space available to support the largest container images or source repositories that you intend to analyze.
- Kubectl installed and configured

**Setup**
```bash
# Make the script executable
chmod +x ./deployment/setup.sh

# Run the script
./deployment/setup.sh

# Please note it may take a few minutes for Anchore to spin up and for all services to be operational
```
**Login**

```bash
# Setup port forwarding for both the API and UI

# The Anchore UI can be accessed via localhost:8080 with kubernetes port-forwarding:
kubectl port-forward svc/anchore-enterprise-ui 8080:80

# The Anchore API can be accessed via localhost:8228 with kubernetes port-forwarding:
kubectl port-forward svc/anchore-enterprise-api 8228:8228

# Get the default admin password using the following command:
kubectl get secret anchore-enterprise -o jsonpath='{.data.ANCHORE_ADMIN_PASSWORD}' | base64 -D
    
# Point your browser at the Anchore Enterprise UI by directing it to http://localhost:8080/ and use username: admin password: as per kubectl secret output above.
```
### Option 3: Docker Compose

**Requirements**
- Docker v1.12 or higher
- Docker Compose that supports at least v2 of the docker-compose configuration format.
- A stand-alone deployment requires at least 4GB of RAM, and enough disk space available to support the largest container images or source repositories that you intend to analyze.

**Setup**
```bash
# Extract the license from demo-secrets.yaml and write license.yaml in the deployment directory
grep -A0 '\license.yaml' demo-secrets.yaml | tail -n1 | awk '{ print $2}' | base64 --decode > license.yaml

# Print the config to screen for reference
grep -A0 '\.dockerconfigjson' demo-secrets.yaml | tail -n1 | awk '{ print $2}' | base64 --decode

# Login to DockerHub with access the Anchore Enterprise product images. Use the password shown on the previous step
docker login --username <from-previous-step> --password-stdin

# Pull the images from the Registry
docker pull docker.io/anchore/webinar-content-test:enterprise-x
docker pull docker.io/anchore/webinar-content-test:enterprise-ui-x

# Run compose and spin up Anchore Enterprise
docker compose -f anchore-compose.yaml up -d
```

**Login**
```
# Point your browser at the Anchore Enterprise UI by directing it to http://localhost:8080/ and use username: admin password: foobar
```

## Step 3: Install AnchoreCTL

Next, we'll install the lightweight Anchore Enterprise client tool, quickly test using the `version` operation, and set up a few environment variables to allow it to interact with your quickstart deployment using the following process:

Download and install the AnchoreCTL
```bash
curl -sSfL  https://anchorectl-releases.anchore.io/anchorectl/install.sh  | sh -s -- -b /usr/local/bin v5.3.0
```

Edit and set up the AnchoreCTL environment variables
```bash
export ANCHORECTL_URL="http://localhost:8228"
export ANCHORECTL_USERNAME="admin"
# Compose
# export ANCHORECTL_PASSWORD="foobar" 
# Kubernetes 
# export ANCHORECTL_PASSWORD=$(kubectl get secret anchore-enterprise -o jsonpath='{.data.ANCHORE_ADMIN_PASSWORD}' | base64 -D)
```

Quickly test using the `version` operation that anchorectl has been set up correctly. Your output should look like the following:
```
./anchorectl version
Application:        anchorectl
Version:            5.3.0
SyftVersion:        v0.97.1
BuildDate:          2023-11-21T22:09:54Z
GitCommit:          f7604438b45f7161c11145999897d4ae3efcb0c8
GitDescription:     v5.3.0
Platform:           linux/amd64
GoVersion:          go1.21.1
Compiler:           gc
```

> **NOTE:** for this tutorial, we're installing the tool in your local directory `./` and will be using environment variables throughout. 
> You can permanently install and configure `anchorectl` removing the need for setting environment variables, see [Installing AnchoreCTL](https://docs.anchore.com/current/docs/deployment/anchorectl/}).

## Step 4: Nice work!

Congratulations you have achieved much. Now onwards, to learning about Anchore Enterprise.

Next Lab: [Visibility](02-visibility.md)