# Prerequisites

## Step 1: Get Access to Anchore Enterprise

Anchore Enterprise requires a license and access to container images to operate.

To get access, you have two options:
- Use our [Anchore AWS Free Trial](https://get.anchore.com/free-trial/) 
  - _An AWS account and ability to launch instances in us-west-1, us-east-1, or us-east-2 is required._
- For Compose and K8s deployments - Fill out this [simple form](https://forms.gle/NMhpVU19SuXRnLhC9) for instant access.
  - _Please copy the setup.sh script linked in the submitted form._

## Step 2: Download setup script & Deploy Anchore Enterprise

You can now deploy Anchore Enterprise into your chosen environment.

### AWS - Trial AMI
Follow the [installation instructions](https://sites.google.com/anchore.com/anchore-enterprise-trial) included in the free trial email.

### For Compose and K8s deployments

**Requirements**
- Compose
  - Docker v1.12 or higher, and a version of Docker Compose that supports at least v2 of the docker-compose configuration format.
- Helm Deployment to K8s
  - [Helm](https://helm.sh/) >=3.8
  - [Kubernetes](https://kubernetes.io/) >=1.23

Download a copy of the setup.sh and run it to get license and access to images in DockerHub
```
# curl https://<setup.sh-script-fromt-step-1>/ > setup.sh
# review setup.sh
# ./setup.sh
```

**Compose**
```
# cd /deployment
# docker-compose up -d
```
**K8s**
```
# cd /deployment
# helm install ....
```

## Step 3: Install AnchoreCTL

Next, we'll install the lightweight Anchore Enterprise client tool, quickly test using the `version` operation, and set up a few environment variables to allow it to interact with your quickstart deployment using the following process:

```shell script
# curl -sSfL  https://anchorectl-releases.anchore.io/anchorectl/install.sh  | sh -s -- -b /usr/local/bin v5.3.0

# ./anchorectl version
Application:        anchorectl
Version:            {{< param anchorectl_current_semver >}}
SyftVersion:        v0.97.1
BuildDate:          2023-11-21T22:09:54Z
GitCommit:          f7604438b45f7161c11145999897d4ae3efcb0c8
GitDescription:     {{< param anchorectl_current_version >}}
Platform:           linux/amd64
GoVersion:          go1.21.1
Compiler:           gc

# export ANCHORECTL_URL="http://localhost:8228"
# export ANCHORECTL_USERNAME="admin"
# export ANCHORECTL_PASSWORD="foobar"

```
NOTE: for this tutorial, we're installing the tool in your local directory `./` and will be using environment variables throughout.  To more permanently install and configure `anchorectl` to remove the need for setting environment variables and putting the tool in a globally accessible path, see [Installing AnchoreCTL](https://docs.anchore.com/current/docs/deployment/anchorectl/}).

## Step 4: Login to the Anchore Web Application

Now that you have Anchore deployed, you can point your browser at the Anchore Enterprise UI by directing it to http://localhost:3000/.
Enter the username admin and password foobar to log in.

## Step 5: Nice work!

Congratulations you have achieved much. Now onwards - to learning about Anchore Enterprise.

Next Lab: [Visbility](02-visibility.md)