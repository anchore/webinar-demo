# Software Security in the Real World

This tutorial steps you through deploying Anchore Enterprise (version 5.6.2) and a series of labs showcasing how you can use Anchore Enterprise to improve security across your software supply chain.

> _The deployment from this tutorial should not be viewed as production ready, and will receive limited support from Anchore, but don't let that stop you from learning!_

## Target Audience

This repo and labs are for anyone who wants to understand how to improve security across their SDLC and software estate.
We help you set up and deploy Anchore Enterprise to an environment of choice, from Docker Compose to Kubernetes. 
Once you have a running deployment, we provide you with some repeatable examples (with only basic knowledge of containers and software required) across a series of themed labs.

## Use cases

Anchore Enterprise is a flexible platform that can be utilized in many ways, here are some of these use cases that you might recognise.

**SBOM (Software Bill of Materials)** - Get comprehensive visibility of your software components to bolster security and ensure vulnerability accuracy with the most complete SBOM available.

**Container Vulnerability Scanning** - Reduce false positives and false negatives with best-in-class signal-to-noise ratio.

**Container Security** - Identify and remediate container security risks, and monitor post-deployment for new vulnerabilities.

**Container Registry Scanning** - Get continuous security and compliance checks integrated directly into your container image registry.

**CI/CD Pipeline Security** - Embed security and compliance into your CI/CD / DevSecOps pipeline to uncover vulnerabilities, secrets, and malware in your automated build processes and keep development moving.

**Cluster Integrations** - Allow or prevent deployment of images based on flexible policies and continuously monitor the inventory of insecure images running in your clusters.

**FedRAMP Vulnerability Scanning** - Meet the new FedRAMP Vulnerability Scanning Requirements for Containers and achieve compliance faster with Anchore.

**Cybersecurity & Federal Compliance** - Automate compliance checks using out-of-the-box and custom policies.

## Labs

After initial setup in prerequisites, each lab guides you through tried and tested examples across use cases from software visibility to reporting and remediation.  

* [Prerequisites](docs/01-prerequisites.md)
* [Visibility](docs/02-visibility.md)
* [Inspection](docs/03-inspection.md)
* [Policy Enforcement](docs/04-policy-enforcement.md)
* [Remediation](docs/05-remediation.md)
* [Reporting](docs/06-reporting.md)
* [Cleaning Up](docs/07-cleanup.md)

## Getting Started 

[Your Anchore journey starts here](docs/01-prerequisites.md)