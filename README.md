# CMClient

Use this module to kick off many common client triggers like Machine Policy Download, Discovery Data Cycle, Compliance Evaluation, Application Deployment Evaluation, Hardware Inventory, Software Inventory, Update Deployment Evaluation and Update Scan.  Also stay tuned for many more ConfigMgr client functions!

Each of the client action functions is simply an easy way to trigger client schedule IDs. Each function feeds back to the the function that’s doing the work; Invoke-CMClientAction. If you specify -AsJob on any function, that gets passed to the Initialize-CMClientJob.
