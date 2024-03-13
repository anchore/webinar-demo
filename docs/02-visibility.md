# Visibility

Building an accurate Software Bill of Materials (SBOM) from source to a built and running container across the SDLC is vital.
This data is needed to aid compliance as well as operational tasks such as analysis, policy enforcement and remediation.
In this lab, you will be adding some example applications across source and container origins to get visibility into their contents and application at the different stages of the SDLC.

There are many scenarios around SBOM visibility, here are our top 10:

1. Identification of OS + Language packages
2. Identification of package licensing
3. Identification of package origin
4. Identification of package size
5. Identification of all files
6. Identification of file size
7. Identification of file permissions
8. Identification of files unique identifiers
9. Identification of relevant image/pkg metadata
10. Collect, safeguard, maintain, and share provenance data for all components of each software release

## Lab Exercises

An application starts life as code, and eventually (in the cloud native world) transforms into distributable container. 
The end-to-end process is commonly referred to as the SDLC (Software Delivery Lifecycle), and across the different stages Anchore Enterprise can track and manage the SBOM.
Let's now unpack how you can create, track and manage those SBOMS within Anchore.

### SBOM Visibility with Source Code

Create a new Anchore application, with which we can associate source code and containers.
```bash
anchorectl application add app --description "Webinar Demo App"
```
> NOTE! - you can only currently add, edit and delete applications via the anchorectl or Anchore API

Review the first example application source code and generate an SBOM (locally) for it. 
Then we can map the source code reference and SBOM into Anchore. 
This would be a typical task that gets carried out during CI.
```bash
cd ./examples/app
syft -o json . | anchorectl source add github.com/anchore/webinar-demo@73522db08db1758c251ad714696d3120ac9b55f4 --from -
```
Now we associate the source artifact to our application tag HEAD. As you continuously integrate you also can update Anchore with the latest code. 
```bash
anchorectl application artifact add app@HEAD source 10bfb040-5a53-417c-8648-4b22fbfd7ba9
```
Now output the SBOM contents to screen in the table format. This could be useful for reporting or as output step in CI.
```bash
anchorectl source sbom 10bfb040-5a53-417c-8648-4b22fbfd7ba9 -o table
```
Check out the new application in the Web UI by visiting `/applications` and see the mapping over to our source control commit.
Finally drill in and export an SBOM.

**Now we are ready for release v1.0.0!**

Navigate to the v1.0.0 code in the repo for our example application. Now let's create a new release v1.0.0 for the 'app' in Anchore.
```bash
cd ./examples/app:v1.0.0
anchorectl application version add app@v1.0.0
```
Now let's build the SBOM for this release and associate a source artifact to our app v1.0.0 version. All in one line!
```bash
syft -o json . | anchorectl source add github.com/anchore/webinar-demo@88ae9c020d4b730d510e97a31848e181c4934bf0 --branch 'v1.0.0' --author 'author-from-ci@example.com' --application 'app@v1.0.0' --workflow-name 'default' --from -
```
Check out the new application in the Web UI by visiting `/applications` and see the Dockerfile getting picked up.
Finally drill in and export an SBOM.

### SBOM Visibility with Images

Now that the v1.0.0 app has parsed ALL the unit & integration tests we are ready to bundle this software into a container as part of the CD process.

Build the v1.0.0 app image locally and tag it as v1.0.0
```bash
docker build . -t app:v1.0.0
```
Submit the new image to Anchore Enterprise (anchorectl will perform full local image analysis locally)
```bash
anchorectl image add app:v1.0.0 --from docker 
```
> Local image analysis can be useful if for example, you cannot reach the Anchore API / Deployment from your CI/CD environment
> For this you can locally perform analysis and store the resulting output like SBOM files into the release notes, code repo or container image currently being built.
> There are some limitations for example Malware scanning can only take place on the server with centralised analysis.

Let's resubmit our local app image, but this time add the Dockerfile as extra data
```bash
anchorectl image add app:v1.0.0 --from docker --dockerfile ./Dockerfile
```
When reviewing the UI for this image you may notice "No results" for the Dockerfile tab under images in the Web UI.
This is because we need to tell Anchore to re analyse the image, and we can do this with --force
```bash
anchorectl image add app:v1.0.0 --from docker --dockerfile ./Dockerfile --force
```
Now go check the UI under images.

Finally, let's associate this container image to v1.0.0 of the app in Anchore.
```bash
anchorectl application artifact add app@v1.0.0 image sha256:5e08f037b46b8bbc670adb862857c6a581f1fba517143e8f855562ea16353140
```
With that we have seen how both Source and Image SBOMS can be mapping to entities we call applications. 
This helps you maintain provenance and history about your releases and the source and containers associated with them.

### SBOM Visibility with Multi-Architecture Images

Another lens to cover with SBOMS for container images, is that Anchore can support multi-architecture images. 
Perhaps you ship a product or container that needs to work across many types of architectures. 
In any case, you will need to manage the SBOMS and associated security data and here Anchore can support your efforts. Let's run through an example

Submit image for addition to Anchore Enterprise (Anchore Enterprise will pull image from a public registry and perform full analysis)
This is called centralized analysis. 
Please note this image is hosted publicly so NO credentials are required. However, Anchore does support private repositories that conform to the docker_v2 api.
```bash
anchorectl image add docker.io/centos:latest
```
Review this new CentOS image in the `images` tab in the Web UI, once loaded select the SBOM Tab. 
You will notice it contains several images, this is because the CentOS image is a multi architecture image.
Let's now re-add the CentOS image, but this time be specific and add only the ARM64 platform image.
```bash
anchorectl image add docker.io/centos:latest --from registry --platform arm64 --force
```
> NOTE: Remember --force tells Anchore Enterprise to reanalyse from the image. And not just reload the latest vulnerabilities.

Check the Web UI once again to see the arm64 architecture in the Image SHA and also check out the Changelog tab.
You can see the new Architecture but also how this changed over time. This is what we call SBOM drift. 
Drift can help us detect deeper security issues, we will cover this more in a later lab on policy enforcement. 
This can uncover changes in everything from Architecture changes like this example to more nuanced package changes.

### SBOM Visibility with Watchers & Subscriptions

Anchore has the capability to monitor external Docker Registries for updates to tags as well as new tags. As new updates are discovered, they are automatically submitted for SBOM Analysis & more.
Then you can if needed, set up a subscription which will generate a notification when the event is triggered, such as new tag, or analysis update. 
For example, when a new image has been added to the registry or when Anchore has spotted a new vulnerability, submit a notice to JIRA.

Let's run through an example:

Check if we are watching the repo we have scanned (in this case we are not)
```bash
anchorectl repo add --dry-run docker.io/danperry/nocode
 ✔ Added repo
┌───────────────────────────┬─────────────┬────────┐
│ KEY                       │ TYPE        │ ACTIVE │
├───────────────────────────┼─────────────┼────────┤
│ docker.io/danperry/nocode │ repo_update │ false  │
└───────────────────────────┴─────────────┴────────┘
```
We can subscribe to every new tag, or in this case any change being submitted to the repository
```bash
 anchorectl repo add --auto-subscribe docker.io/danperry/nocode
✔ Added repo
┌───────────────────────────┬─────────────┬────────┐
│ KEY                       │ TYPE        │ ACTIVE │
├───────────────────────────┼─────────────┼────────┤
│ docker.io/danperry/nocode │ repo_update │ true   │
└───────────────────────────┴─────────────┴────────┘
```
We can not only scan or watch new tags as they are pushed into the registry.
But we can also add a subscription to trigger an event.

```bash
➜  ~ anchorectl subscription list
✔ Fetched subscriptions
┌─────────────────────────────────┬─────────────────┬────────┐
│ KEY                             │ TYPE            │ ACTIVE │
├─────────────────────────────────┼─────────────────┼────────┤
│ docker.io/danperry/nocode       │ repo_update     │ true   │
│ docker.io/danperry/nocode:1.0.0 │ alerts          │ true   │
└─────────────────────────────────┴─────────────────┴────────┘
```
```bash
➜  ~ anchorectl subscription activate docker.io/danperry/nocode:1.0.0 tag_update
✔ Activate subscription
Key: docker.io/danperry/nocode:1.0.0
Type: tag_update
Id: e737986c26126b062de917d36b6eb33c
Active: true
```
```bash
➜  ~ anchorectl subscription list
✔ Fetched subscriptions
┌─────────────────────────────────┬─────────────────┬────────┐
│ KEY                             │ TYPE            │ ACTIVE │
├─────────────────────────────────┼─────────────────┼────────┤
│ docker.io/danperry/nocode:1.0.0 │ policy_eval     │ false  │
│ docker.io/danperry/nocode:1.0.0 │ vuln_update     │ false  │
│ docker.io/danperry/nocode:1.0.0 │ analysis_update │ true   │
│ docker.io/danperry/nocode       │ repo_update     │ true   │
│ docker.io/danperry/nocode:1.0.0 │ alerts          │ true   │
│ docker.io/danperry/nocode:1.0.0 │ tag_update      │ true   │
└─────────────────────────────────┴─────────────────┴────────┘
```
Try for yourself with the centos repo in the docker.io registry.

Set up a subscription to new tag updates for the centos repo from the docker registry. Then submit a bunch of images and checkout the "Event's & Notifications Web" UI.
```bash
anchorectl image add docker.io/centos:8
anchorectl image add docker.io/centos:7
```
Check out the events generated in the Web UI by visiting `/events`

Watches and Subscriptions offer many possibilities and combined with notifications, you can start to build very powerful workflows.

### SBOM Visibility with Hints

Now that v2.0.0 of the app has passed ALL the tests we are ready to build the container as part of the CD process and eventually delivery to pur production environment.
However, we know that some bespoke packages are not getting discovered, and we want to manually flag or 'hint' that these exist. 
We can achieve this by adding a hints json file that contains the metadata anchore can detect and process.

Checkout the hints file, then build the image locally and tag it as v2.0.0
```bash
cd ./examples/app:v2.0.0
cat anchore_hints.json
docker build . -t app:v2.0.0
```
Add version v2.0.0 for our application
```bash
anchorectl application version add app@v2.0.0
```
Submit image for addition to Anchore Enterprise (anchorectl will perform full local image analysis, SBOM + additional data pushed to Anchore Enterprise)
```bash
anchorectl image add app:v2.0.0 --from docker --dockerfile ./Dockerfile
```
Now go check the Web UI. Let's associate this container image to our v2.0.0 of the application in Anchore
```bash
anchorectl application artifact add app@v2.0.0 image sha256:30c82fbf2de5a357a91f38bf68b80c2cd5a4b9ded849dbdf4b4e82e807511ffa
```
Anchore Enterprise includes the ability to read a user-supplied ‘hints’ file to allow users to add software artifacts to Anchore’s analysis report. The hints file, if present, contains records that describe a software package’s characteristics explicitly, and are then added to the software bill of materials (SBOM).
You may have noticed but v2.0.0 has a hints file called anchore_hints.json. Check it out and also look in the UI/SBOM for these artifacts.

### Additional examples

Below are some additional examples that illustrate some building blocks that Anchore provides.
Most capabilities are exposed via the AnchoreCTL but all of them are exposed via the API that has a 100% coverage.

Submit and wait for analysis to complete. really useful for decisions you might want to make during your CI/CD pipeline
```bash
anchorectl image add docker.io/nginx:latest --wait
```
Submit and fetch all results to a directory. Useful if you want to store the results in your CI/CD pipeline
```bash
anchorectl image add docker.io/library/nginx:latest --get all=./tmp/app
```

You can export and download the SBOM in a variety of formats. Try figuring out how to do this with both the UI and then AnchoreCTL.

> [!TIP]
> For a visual walkthrough checkout the [visibility workshop materials](https://viperr.anchore.com/visibility/).

Next: [Inspection](03-inspection.md)