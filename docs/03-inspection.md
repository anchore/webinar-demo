# Inspection

Security checks inspecting for vulnerabilities, secrets, permissions, and malware.

In the previous lab, we looked at Anchore's SBOM capability and vital foundation for exploring the impacts of our software. 
In this lab we will do deeper and inspect these results and also cover how vulnerability feed source information is gathered and is made available and can enrich our SBOMs.
Just like SBOM data, vulnerability data is foundational and without it, you won't have accurate data to make informed decisions.

Inspecting the results of your SBOMs and Vulnerabilities across source applications and containers can help you identify many issues, here are our top 10:

1. Inspect files for malicious content
2. Inspect packages for malicious content
3. Analyze each vulnerability to gather sufficient information about risk to plan its remediation
4. Inspect for license abuse/misuse
5. Inspect source code repos for vulns
6. Inspect & monitor file permissions
7. Inspect for misconfiguration in the Dockerfiles
8. Detect known exploited vulnerabilities
9. Inspect for vulns inherited by base images
10. Inspect relational analysis to identify vulns across images and stages

## Lab Exercises

Anchore Enterprise uses security vulnerability data from a number of different sources from NVD to more specific source such as GHSA (GitHub Advisory Database) and vendor specific sources.
The Anchore Feed Service collects this vulnerability source data and normalizes it into a dataset that Anchore Enterprise can distribute and utilize.
For the demo environment, don't worry we have pre-configured this data for you. The demo does miss some enterprise sources such as MSRC and Anchore's own exclusions data.

> [!TIP]
> For a visual walkthrough checkout the [inspection workshop materials](https://viperr.anchore.com/inspection/).


Next: [Policy Enforcement](04-policy-enforcement.md)