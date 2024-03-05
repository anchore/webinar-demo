# 2023-12-demo

Simple demo for Anchore Enterprise.

Partial list of conditions that can be tested with this image:

1. xmrig cryptominer installed at `/xmrig/xmrig`
2. simulated AWS access key in `/aws_access`
3. simulated ssh private key in `/ssh_key`
4. selection of commonly-blocked packages installed (sudo, curl, etc)
5. `/log4j-core-2.14.1.jar` (CVE-2021-44228, et al)
6. added anchorectl to demonstrate automatic go library detection in binaries
7. wide variety of ruby, node, python, java installed with different licenses
8. build drift detection (see .baseline directory for Dockerfile/Jenkinsfile)
9. Terraform RPM with BUSL license installed
10. modify file from gzip RPM to trigger package verification gate

Secret scanning and hints file handling for distributed scanning is configured in .anchorectl.yaml

Learn more over at - https://github.com/pvnovarese/2023-12-demo