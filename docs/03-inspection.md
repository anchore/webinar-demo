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
The Anchore Feed Service collects this vulnerability source data and normalizes it into a dataset, which in turn is used to show vulnerabilities for specific iamges/source, by the Policy Engine for finding vulnerabilities and finally for evaluating policies.
For the demo environment, don't worry we have pre-configured this data for you. The demo does miss some enterprise sources such as MSRC and Anchore's own exclusions' data.

## Feed Sources
Anchore prefers to use the most specific data to enable the best possible vulnerability findings. For example, whilst a general CVE might apply to a particular version of Bash, the way an OS vendor like Ubuntu could install Bash, might mean that the general CVE has a lower risk and rating.
Having up to date, relevant and specific vulnerability data is paramount. In combinations with accurate SBOMs, the correctness of vulnerability data helps steer you away from false positives and false negatives and get you the insights about the software that you need.

Let's check what vulnerability data we have in our new deployment. Is it up to date? Does it cover what we need?
```bash
anchorectl feed list
┌─────────────────┬────────────────────┬─────────┬──────────────────────┬──────────────┐
│ FEED            │ GROUP              │ ENABLED │ LAST SYNC            │ RECORD COUNT │
├─────────────────┼────────────────────┼─────────┼──────────────────────┼──────────────┤
│ vulnerabilities │ github:composer    │ true    │ 2024-03-14T12:55:47Z │ 2821         │
│ vulnerabilities │ github:dart        │ true    │ 2024-03-14T12:55:47Z │ 6            │
│ vulnerabilities │ github:gem         │ true    │ 2024-03-14T12:55:47Z │ 763          │
│ vulnerabilities │ github:go          │ true    │ 2024-03-14T12:55:47Z │ 1504         │
│ vulnerabilities │ github:java        │ true    │ 2024-03-14T12:55:47Z │ 4777         │
│ vulnerabilities │ github:npm         │ true    │ 2024-03-14T12:55:47Z │ 13363        │
│ vulnerabilities │ github:nuget       │ true    │ 2024-03-14T12:55:47Z │ 566          │
│ vulnerabilities │ github:python      │ true    │ 2024-03-14T12:55:47Z │ 2488         │
│ vulnerabilities │ github:rust        │ true    │ 2024-03-14T12:55:47Z │ 730          │
│ vulnerabilities │ github:swift       │ true    │ 2024-03-14T12:55:47Z │ 30           │
│ vulnerabilities │ nvd                │ true    │ 2024-03-14T12:55:47Z │ 241467       │
│ vulnerabilities │ alpine:3.19        │ true    │ 2024-03-14T12:55:47Z │ 6087         │
│ vulnerabilities │ alpine:3.2         │ true    │ 2024-03-14T12:55:47Z │ 305          │
...
│ vulnerabilities │ alpine:edge        │ true    │ 2024-03-14T12:55:47Z │ 6096         │
│ vulnerabilities │ amzn:2             │ true    │ 2024-03-14T12:55:47Z │ 1990         │
│ vulnerabilities │ amzn:2022          │ true    │ 2024-03-14T12:55:47Z │ 276          │
│ vulnerabilities │ amzn:2023          │ true    │ 2024-03-14T12:55:47Z │ 579          │
│ vulnerabilities │ chainguard:rolling │ true    │ 2024-03-14T12:55:47Z │ 1593         │
│ vulnerabilities │ debian:10          │ true    │ 2024-03-14T12:55:47Z │ 29569        │
...
│ vulnerabilities │ debian:7           │ true    │ 2024-03-14T12:55:47Z │ 20455        │
│ vulnerabilities │ debian:unstable    │ true    │ 2024-03-14T12:55:47Z │ 32200        │
│ vulnerabilities │ mariner:1.0        │ true    │ 2024-03-14T12:55:47Z │ 2092         │
│ vulnerabilities │ mariner:2.0        │ true    │ 2024-03-14T12:55:47Z │ 2148         │
│ vulnerabilities │ ol:5               │ true    │ 2024-03-14T12:55:47Z │ 1255         │
..
│ vulnerabilities │ rhel:5             │ true    │ 2024-03-14T12:55:47Z │ 7202         │
..
│ vulnerabilities │ rhel:9             │ true    │ 2024-03-14T12:55:47Z │ 2331         │
│ vulnerabilities │ sles:11            │ true    │ 2024-03-14T12:55:47Z │ 594          │
..
│ vulnerabilities │ sles:15.5          │ true    │ 2024-03-14T12:55:47Z │ 8731         │
│ vulnerabilities │ ubuntu:12.04       │ true    │ 2024-03-14T12:55:47Z │ 14934        │
...
│ vulnerabilities │ ubuntu:23.10       │ true    │ 2024-03-14T12:55:47Z │ 15359        │
│ vulnerabilities │ wolfi:rolling      │ true    │ 2024-03-14T12:55:47Z │ 1449         │
└─────────────────┴────────────────────┴─────────┴──────────────────────┴──────────────┘
```
You also inspect the events data to see when each source was last updated and if there were any problems.

Keeping Anchore fresh with relevant data is one of the key tenants of the product and service.

> [!TIP]
> We can also see this feed information in the Web UI under `system` when logged in as Admin.

## Vulnerabilities

During the analysis of container images, Anchore Enterprise performs deep inspection, collecting data on all artifacts in the image including files, operating system packages and software artifacts such as Ruby GEMs and Node.JS NPM modules.
Base Image example

When we add an image, it takes time to analyze. We can find out if that analysis has completed. We could run this with --wait if we put this into a pipeline.
```bash
anchorectl image get app:v2.0.0
Tag: docker.io/app:v2.0.0
Digest: sha256:30c82fbf2de5a357a91f38bf68b80c2cd5a4b9ded849dbdf4b4e82e807511ffa
ParentDigest: sha256:30c82fbf2de5a357a91f38bf68b80c2cd5a4b9ded849dbdf4b4e82e807511ffa
ID: c0f2aa60caaed2d504b23b9fd280f73341906b00ffcd8a6ecfe52acda252d359
Analysis: analyzed
Status: active
```
We can show OS, Non-OS or ALL the vulnerabilities we find.
```bash
anchorectl image vulnerabilities app:v2.0.0 -a
all
non-os
os
```

Let's grab the Non-OS vulns in a table format (handy for those pipeline outputs)* Output available in other formats like json.
```bash
anchorectl image vulnerabilities app:v2.0.0 -t non-os
┌─────────────────────┬──────────┬──────────────────────────────────┬────────────────────────────────────┬────────┬──────────────┬────────┬───────────────┬────────────────┬───────────────────────────────────────────────────┐
│ ID                  │ SEVERITY │ NAME                             │ VERSION                            │ FIX    │ WILL NOT FIX │ TYPE   │ FEED GROUP    │ CVES           │ URL                                               │
├─────────────────────┼──────────┼──────────────────────────────────┼────────────────────────────────────┼────────┼──────────────┼────────┼───────────────┼────────────────┼───────────────────────────────────────────────────┤
│ CVE-2023-45290      │ Unknown  │ stdlib                           │ go1.19.12                          │ None   │ false        │ go     │ nvd           │                │ https://nvd.nist.gov/vuln/detail/CVE-2023-45290   │
│ CVE-2023-44487      │ High     │ stdlib                           │ go1.19.12                          │ None   │ false        │ go     │ nvd           │ CVE-2023-44487 │ https://nvd.nist.gov/vuln/detail/CVE-2023-44487   │
│ CVE-2023-45285      │ High     │ stdlib                           │ go1.19.12                          │ None   │ false        │ go     │ nvd           │ CVE-2023-45285 │ https://nvd.nist.gov/vuln/detail/CVE-2023-45285   │
│ CVE-2024-24785      │ Unknown  │ stdlib                           │ go1.19.12                          │ None   │ false        │ go     │ nvd           │                │ https://nvd.nist.gov/vuln/detail/CVE-2024-24785   │
│ CVE-2023-39326      │ Medium   │ stdlib                           │ go1.19.12                          │ None   │ false        │ go     │ nvd           │ CVE-2023-39326 │ https://nvd.nist.gov/vuln/detail/CVE-2023-39326   │
│ GHSA-hpxr-w9w7-g4gv │ Medium   │ github.com/anchore/stereoscope   │ v0.0.0-20230627195312-cd49355d934e │ 0.0.1  │ false        │ go     │ github:go     │ CVE-2024-24579 │ https://github.com/advisories/GHSA-hpxr-w9w7-g4gv │
│ GHSA-m425-mq94-257g │ High     │ google.golang.org/grpc           │ v1.55.0                            │ 1.56.3 │ false        │ go     │ github:go     │                │ https://github.com/advisories/GHSA-m425-mq94-257g │
│ GHSA-2wrh-6pvc-2jm9 │ Medium   │ golang.org/x/net                 │ v0.11.0                            │ 0.13.0 │ false        │ go     │ github:go     │ CVE-2023-3978  │ https://github.com/advisories/GHSA-2wrh-6pvc-2jm9 │
│ GHSA-jq35-85cj-fj4p │ Medium   │ github.com/docker/docker         │ v24.0.2+incompatible               │ 24.0.7 │ false        │ go     │ github:go     │                │ https://github.com/advisories/GHSA-jq35-85cj-fj4p │
│ CVE-2023-39319      │ Medium   │ stdlib                           │ go1.19.12                          │ None   │ false        │ go     │ nvd           │ CVE-2023-39319 │ https://nvd.nist.gov/vuln/detail/CVE-2023-39319   │
│ GHSA-4374-p667-p6c8 │ High     │ golang.org/x/net                 │ v0.11.0                            │ 0.17.0 │ false        │ go     │ github:go     │ CVE-2023-39325 │ https://github.com/advisories/GHSA-4374-p667-p6c8 │
│ GHSA-7ww5-4wqc-m92c │ Medium   │ github.com/containerd/containerd │ v1.7.0                             │ 1.7.11 │ false        │ go     │ github:go     │                │ https://github.com/advisories/GHSA-7ww5-4wqc-m92c │
│ CVE-2023-45287      │ High     │ stdlib                           │ go1.19.12                          │ None   │ false        │ go     │ nvd           │ CVE-2023-45287 │ https://nvd.nist.gov/vuln/detail/CVE-2023-45287   │
│ CVE-2023-45289      │ Unknown  │ stdlib                           │ go1.19.12                          │ None   │ false        │ go     │ nvd           │                │ https://nvd.nist.gov/vuln/detail/CVE-2023-45289   │
│ GHSA-qppj-fm5r-hxr3 │ Medium   │ golang.org/x/net                 │ v0.11.0                            │ 0.17.0 │ false        │ go     │ github:go     │ CVE-2023-44487 │ https://github.com/advisories/GHSA-qppj-fm5r-hxr3 │
│ GHSA-8489-44mv-ggj8 │ Medium   │ log4j-core                       │ 2.15.0                             │ 2.17.1 │ false        │ java   │ github:java   │ CVE-2021-44832 │ https://github.com/advisories/GHSA-8489-44mv-ggj8 │
│ GHSA-45x7-px36-x8w8 │ Medium   │ golang.org/x/crypto              │ v0.10.0                            │ 0.17.0 │ false        │ go     │ github:go     │ CVE-2023-48795 │ https://github.com/advisories/GHSA-45x7-px36-x8w8 │
│ GHSA-9763-4f94-gfch │ High     │ github.com/cloudflare/circl      │ v1.3.3                             │ 1.3.7  │ false        │ go     │ github:go     │                │ https://github.com/advisories/GHSA-9763-4f94-gfch │
│ GHSA-crh6-fp67-6883 │ Critical │ xmldom                           │ 0.6.0                              │ None   │ false        │ npm    │ github:npm    │ CVE-2022-39353 │ https://github.com/advisories/GHSA-crh6-fp67-6883 │
│ GHSA-mw99-9chc-xw7r │ High     │ github.com/go-git/go-git/v5      │ v5.7.0                             │ 5.11.0 │ false        │ go     │ github:go     │ CVE-2023-49568 │ https://github.com/advisories/GHSA-mw99-9chc-xw7r │
│ GHSA-p6xc-xr62-6r2g │ High     │ log4j-core                       │ 2.15.0                             │ 2.17.0 │ false        │ java   │ github:java   │ CVE-2021-45105 │ https://github.com/advisories/GHSA-p6xc-xr62-6r2g │
│ GHSA-5fg8-2547-mr8q │ Medium   │ xmldom                           │ 0.6.0                              │ None   │ false        │ npm    │ github:npm    │ CVE-2021-32796 │ https://github.com/advisories/GHSA-5fg8-2547-mr8q │
│ CVE-2023-39318      │ Medium   │ stdlib                           │ go1.19.12                          │ None   │ false        │ go     │ nvd           │ CVE-2023-39318 │ https://nvd.nist.gov/vuln/detail/CVE-2023-39318   │
│ GHSA-qppj-fm5r-hxr3 │ Medium   │ google.golang.org/grpc           │ v1.55.0                            │ 1.56.3 │ false        │ go     │ github:go     │ CVE-2023-44487 │ https://github.com/advisories/GHSA-qppj-fm5r-hxr3 │
│ CVE-2024-24783      │ Unknown  │ stdlib                           │ go1.19.12                          │ None   │ false        │ go     │ nvd           │                │ https://nvd.nist.gov/vuln/detail/CVE-2024-24783   │
│ GHSA-8gq9-2x98-w8hf │ High     │ protobuf                         │ 3.20.0                             │ 3.20.2 │ false        │ python │ github:python │ CVE-2022-1941  │ https://github.com/advisories/GHSA-8gq9-2x98-w8hf │
│ CVE-2024-24784      │ Unknown  │ stdlib                           │ go1.19.12                          │ None   │ false        │ go     │ nvd           │                │ https://nvd.nist.gov/vuln/detail/CVE-2024-24784   │
│ GHSA-7rjr-3q55-vv33 │ Critical │ log4j-core                       │ 2.15.0                             │ 2.16.0 │ false        │ java   │ github:java   │ CVE-2021-45046 │ https://github.com/advisories/GHSA-7rjr-3q55-vv33 │
│ CVE-2023-39323      │ High     │ stdlib                           │ go1.19.12                          │ None   │ false        │ go     │ nvd           │ CVE-2023-39323 │ https://nvd.nist.gov/vuln/detail/CVE-2023-39323   │
│ GHSA-449p-3h89-pw88 │ Critical │ github.com/go-git/go-git/v5      │ v5.7.0                             │ 5.11.0 │ false        │ go     │ github:go     │ CVE-2023-49569 │ https://github.com/advisories/GHSA-449p-3h89-pw88 │
└─────────────────────┴──────────┴──────────────────────────────────┴────────────────────────────────────┴────────┴──────────────┴────────┴───────────────┴────────────────┴───────────────────────────────────────────────────
```

We can inspect an image from other "view points" as well. This can be handy to trigger rules, checks or steps, based on what is discovered
```bash
anchorectl image content app:v2.0.0 -a
binary
content_search
files
gem
go
java
malware
npm
nuget
os
python
retrieved_files
secret_search
```

Now let's check out something specific.
```bash
anchorectl image content app:v2.0.0 -t java
Java Packages:
┌────────────┬───────────────┬───────────────┬───────────────┬──────────┬──────────────────────────┬────────────────────────┬─────────┐
│ PACKAGE    │ IMPL. VERSION │ SPEC. VERSION │ MAVEN VERSION │ TYPE     │ ORIGIN                   │ LOCATION               │ VERSION │
├────────────┼───────────────┼───────────────┼───────────────┼──────────┼──────────────────────────┼────────────────────────┼─────────┤
│ log4j-core │ 2.15.0        │ 2.15.0        │ 2.15.0        │ JAVA-JAR │ org.apache.logging.log4j │ /log4j-core-2.15.0.jar │ 2.15.0  │
└────────────┴───────────────┴───────────────┴───────────────┴──────────┴──────────────────────────┴────────────────────────┴─────────┘
```
We should really get someone to check this package out a little more... See policy enforcement & remediation labs for how we enforce and remediate for these situations.

We have base image as a concept, so you can focus the efforts on fixing your commonly use golden base images.
```bash
anchorectl image ancestors centos:latest
┌───────────────────────┬────────┬──────┐
│ ANCESTOR IMAGE DIGEST │ LAYERS │ TAGS │
├───────────────────────┼────────┼──────┤
└───────────────────────┴────────┴──────┘
```

> We can also see this vuln information in the Web UI under `image' or via the `application` page.

> [!TIP]
> For a visual walkthrough checkout the [inspection workshop materials](https://viperr.anchore.com/inspection/).


Next: [Policy Enforcement](04-policy-enforcement.md)