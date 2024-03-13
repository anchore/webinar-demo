# Cleanup

Please continue testing Anchore Enterprise, you can easily add your own source, images and other integrations (such as JIRA, SSO and more).
It's a great way to explore further and examine what the results and workflows could look like for you.

If you need to spin down resources, please check out the steps below.

## Spin down your Anchore deployment

**Compose**
```bash
docker compose -f deployment/anchore-compose.yaml down
```
**Kubernetes**
```bash
helm uninstall anchore
```
**AWS Free Trial**
Please follow the instructions you have received via email.

## Ways to learn more about Anchore Enterprise

Anchore supports many use cases, configurations and environments. 
The labs in this demo covered some common uses cases, there are however many more, from how to support specific language ecosystems to how to enable enterprise level features.

For this you can review our Docs, Webinars, and also reach out directly.

- [Anchore Enterprise Docs](https://docs.anchore.com/current/docs/)
- [Resources](https://anchore.com/resources/)
- [Get in touch](https://get.anchore.com/contact/)