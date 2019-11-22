# Trigger an evaluation cycle

A policy evaluation cycle will trigger every so often, and the duration of the cycle may take time.  
Luckily, you can trigger an evaluation cycle.

- Review the script
- Run the script `Start-PolicyEvaluation.ps1`
  (This script waits for the evaluation to complete, which may take a while.)
- Note that script ends with displaying the Policy State
- Fix an incompliant resource, e.g. enable 'Secure transfer required' on 'stdemohttps[nnnnn]', and re-run the script.

Details can be found here:
<https://docs.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data>

