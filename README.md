# Azure Infrastructure as Code
This repository contains all Bicep, ARM templates, and scripts used in the book [Azure Infrastructure as Code](https://www.manning.com/books/azure-infrastructure-as-code) written by [Henry Been](https://www.linkedin.com/in/henrybeen/), [Erwin Staal](https://www.linkedin.com/in/erwinstaal/) and [Eduard Keilholz](https://www.linkedin.com/in/eduard-keilholz/)

# Versions of this repository
- Main branch which is, when needed, updated to ensure examples keep compiling even with Microsoft updates. Find it at: [Release Branch 'as-in-book'](https://github.com/AzureIaCBook/book-templates/tree/main) 
- Release branch which contains the code as-published in the book. Find it at: [Release Branch 'as-in-book'](https://github.com/AzureIaCBook/book-templates/tree/releases/as-in-book) 

## Required tooling
- Install [Visual Studio Code](https://code.visualstudio.com/download) 
- Add Visual Studio Code extensions:
  - Install the [ARM template extension](https://marketplace.visualstudio.com/items?itemName=msazurermtools.azurerm-vscode-tools)
  - Install the [Bicep extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)
- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Install [Bicep](https://github.com/Azure/bicep/blob/main/docs/installing.md#install-and-manage-via-azure-cli-easiest) 
  - Update the tools version if you had it installed already: `az bicep upgrade`

## Deployment
To deploy any of the templates, you will need an Azure Subscription. Get your free Azure subscription [here](https://azure.microsoft.com/en-us/free). You will need a credit card, but it won't be charged, provided you clean up all resources after deploying a template. Use the following commands to login and set the correct Azure Subscription:
```
az login

az account set -s <subscriptionId>
```
