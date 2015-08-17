# CMClient

Use this module to kick off many common client triggers like Machine Policy Download, Discovery Data Cycle, Compliance Evaluation, Application Deployment Evaluation, Hardware Inventory, Software Inventory, Update Deployment Evaluation and Update Scan.  

This module has something a lot of the other modules I've seen don't have which is -AsJob support.  This means you don't have to wait around on each of your clients to invoke whatever action they'r doing.  Instead, you can use the -AsJob parameter which will invoke each action as a PowerShell job so you can run lots of actions asynchronously.