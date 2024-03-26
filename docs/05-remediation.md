# Remediation

Recommendations and automation to help resolve issues more quickly. Give the developer what they need to move fast.

Anchore Enterprise provides capabilities to alert engineers of issues through the Web UI but also to other tools, such as Jira, GitHub issues or Slack. 
It also lets users define actionable remediation workflows with automated remediation recommendations that can assist a course of action. 
The capabilities here can can support many use-cases and here are our top 10:

1. Provide remediation steps for software violating secure coding standards
2. Automate the flow of CVE fix information to developers
3. Provide ownership who owns the fix (upstream or us)
4. Integrate remediation to your notification & build service
5. Prioritize remediation that are actively being exploited
6. Provide recommended remediation steps in developer workflows
7. Enforce remediation standards via policy
8. Centralize recommended remediation into a plan of action
9. Automated remediation responses to stakeholders
10. Create timeouts for remediation using policy

## Lab Exercises

### Remediation with the Action Workbench

For this lab we turn to some Web UI work to generate some remediation actions.
First navigate to an image, and load the policy compliance page. Below the donut chart you should see a list.  
Click on the down arrow or on the right hand side click on tools and then show remediation suggestions.
You then have some suggestions to chose from along with a notes field. Note: This can contain recommendations you have built into the policy itself. 
We call these rule creator recommendations. You can also see these with the show details button the the recommendation column.
Add some notes and then press Add item to the Action Workbench.
Now in the tab click on Action Workbench, from here you can push out these actions to an endpoint such as GitHub issues or a custom webhook

> You can switch between policies by clicking on the right hand side dropdown view on the policy compliance page. 
> However, please note when the non-active policy is selected, you are only previewing the artifact evaluation output produced selected policy.

### Remediation for a limited time only...

You can define policies that are contextual based on time.
For example, you can only configure policies to just 'WARN' for a software package that was only discovered x days ago.
Giving you time to set the workflow in place to resolve, but keep you shipping if that's a suitable risk for your scenario.

See the max_days_since_creation, max_days_since_fix trigger for examples - https://docs.anchore.com/current/docs/compliance_management/policy_overview_ctl/policy_checks/

### Remediation with automated notifications on Vulnerability and Policy Changes

You can subscribe to policy_evaluation changes, for example when a policy moves from GO to STOP.

You can also configure these to be sent as a notification via a webhook to an endpoint like email or Slack.
These are also logged as events in the events ui, where the json payload can be viewed.

Beyond just simple policy checks, you may want to activate subscriptions on your new image.  
This will begin continuous updates of the vulnerability matches and/or policy evaluation in the background (this is most useful when coupled with the "Notifications" facility of Anchore Enterprise, see the [Notifications documentation](https://docs.anchore.com/current/docs/configuration/notifications/) for more details):

Begin continuous updates of vulnerability matches
```bash
anchorectl subscription activate ${IMAGE_NAME} vuln_update
```

Begin continuous updates of policy evaluation
```bash
anchorectl subscription activate ${IMAGE_NAME} policy_eval   
```

In either case, if new vulnerability matches are found or the pass/fail policy result changes, an event is created which can trigger notifications, hit a webhook, etc.

> [!NOTE] You will need to set up a notification endpoint.


> [!TIP]
> For a visual walkthrough checkout the [Remediation workshop materials](https://viperr.anchore.com/remediation/).

Next: [Reporting](06-reporting.md)