# Callisto Smart-contract auditing department.
# Free security audits, for the safety of the entire industry.

![alt text](https://github.com/EthereumCommonwealth/Callisto-Media-Kit/blob/master/logo-official-twitter_506x253.png)

Callisto Security department performs free security audits for smart-contracts. Our security auditors are paid from [Callisto Treasury](https://github.com/EthereumCommonwealth/Roadmap/issues/48). Anyone can submit a request for security audit of a smart-contract free of charge.

ETC (Ethereum Classic) and CLO (Callisto) Solidity smart-contracts have the highest priority.

# Submitting an audit request

1. Go to Auditing/issues section and click a [New Issue](https://github.com/EthereumCommonwealth/Auditing/issues/new) button.
2. Fill the form and click a "Submit New Issue" button.
3. Follow the comments in the corresponding "issue" discussion.
4. The result of a security audit will be published at the comments once auditors complete their task.


## Callisto Security Department workflow.

There are two types of participants in the Security Department:
- auditing manager
- security auditors

### Audit requests order (auditing manager)

For smart-contracts, the following order of audits is determined:
- Contracts that are important for the whole cryptocurrency industry, can have the highest priority.
- Contracts intended for deployment in the ETC/CLO network have the highest priority (with the exception of previous paragraph).
- Contracts of the ETH network have medium priority.
- Other contracts have low priority.
- If the audit of the smart contract is already started, then it continues until it is completed, regardless of the availability of other contracts with higher priority in the queue.

After the audit request has been created, it is viewed by the audit manager. If the request meets the requirements, then the auditing manager assigns it `approved` status. `approved` label means that the audit request is available for auditors for picking.

If there are several requests with different priorities in the queue, then the manager **should** assign the `approved` status only to contracts with the highest priority. The remaining contracts will be checked after the audit of the contracts with the highest priority has been performed. If there are several contracts in the queue with the highest priority, then the audit manager **should** assign the status of `approved` to all these contracts simultaneously. In this case, the contract that auditors will begin to check first will be checked earlier.

### Performing an audit (security auditor)

After an audit request with an `approved` label appears, an auditor can pick it by commenting the issue and indicating how much time it should take to audit this smart-contract (roughly/ in days). After that, the auditor can start reviewing the code immediately. Other community members **may** also pick the request and submit their audit reports. These reports **must** be reviewed by auditor manager at the end of the auditing process. If the audit request was approved, but none of the auditors picked it, then the audit manager can appoint auditors to check this request if they are not engaged in checking another smart-contract.

Auditing manager **must** comment that the audit is successfully started and mention github nicknames of all the auditors which will be responsible for the check of the corresponding contract after several auditors have picked the issue-request. The audit manager **must** also comment his contact email, to which the auditors will send their secret gists (audit reports).

After the auditor began to check the code, he **must** create a **secret** [github gist](https://gist.github.com/) and send it to the auditing manager by email. An auditor **must not** reveal the audit report gist or publish it anywhere, so that only auditing manager and auditor (gist owner) could review it during the auditing process.

After the auditor has completed the verification of the code, he should comment to the appropriate issue that his audit report is completed. NOTE: An auditor **must not** reveal his report gist!

### Completion of the audit

After all the responsible auditors have completed their reports, the audit manager must compare the reports.

If there are no significant discrepancies in the reports and no critical errors are detected, then the audit manager **must** complete the audit by summarizing the reports and submitting secret gist urls in the comment of the corresponding audit request-issue. The audit is considered complete after all the responsible auditors have submitted their reports, and the audit manager has summarized the results of these reports and published report gist urls.

If one of the community members has expressed a desire to participate in the audit of this contract and also sent his report to the audit manager, then the audit manager **must** review the report and comment its secret gist url to the corresponding github request-issue regardless of whether the audit was already completed or not.

### Disclosure policy

After the audit was completed, the audit manager **may** inform the customer about the results without revealing the reports. After 15 days from the date of informing the customer about the findings, the reports should still be published and the results summed up.
