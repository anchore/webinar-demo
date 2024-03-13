# Policy Enforcement

Enforce compliance with external and/or internal standards.

Facilitating everything from policy creation to policy enforcement can help meet compliance goals and importantly prioritize your efforts without crippling developer velocity.

Anchore Enterprise enables users to define automated rules that indicate which vulnerabilities violate their organizations’ policies or compliance goals.
For example, an organization may raise policy violations for vulnerabilities scored as Critical or High that have a fix available.
These policy violations can generate alerts and notifications or be used to stop builds in the CI/CD pipeline or prevent code from moving to production.
Policy enforcement can be applied at any stage in the development process, from the selection and usage of open source components through the build, staging, and deployment process, here are our top 10 uses:

1. Policy alerts and enforces for malware findings
2. Create a policy that doesn't cripple velocity
3. Enforce control of license abuse/misuse via Policy
4. Enforce secret + password monitoring in Policy
5. Policy checks for known exploited vulnerabilities across SDLC
6. Enforce building from approved images
7. Detect & Block misconfigurations in images
8. Policy blocks unauthorized software reaching kubernetes
9. Policy blocks unauthorized images reaching registry
10. Don’t pass builds that violate CVE thresholds

## Lab Exercises

> [!TIP]
> For a visual walkthrough checkout the [Policy enforcement workshop materials](https://viperr.anchore.com/policy/).

Next: [Remediation](05-remediation.md)