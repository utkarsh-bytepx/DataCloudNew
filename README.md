Connecting a Data Source to Salesforce Data Cloud
Step 1: Connect the Data Source
Navigate to Setup > Salesforce CRM.

Connect the source you want to integrate with, such as a Salesforce Developer or Sandbox Org.

If you want to connect to a third-party source, proceed directly to the next step.

Assign the appropriate permission set, Data Cloud Salesforce Connector, to ensure the required objects and fields have Read access.

Step 2: Create a Data Stream
Go to Data Cloud > Data Streams and click New.

Choose the connection you want to integrate with Data Cloud.

For example, to connect another Salesforce Org, select Salesforce CRM Connector and choose the org you authorized in Step 1.

Select the Data Bundles or Objects you want to ingest from the connected Salesforce Org.

Choose the fields you want to import.

Provide a label for the object and select the object category.

Click Deploy.

Step 3: Map the Data
Once deployed, you will see the object in the Data Streams list.

Navigate to Data Stream > Data Lake Objects > Data Mapping to map the object.

Create an Identity Resolution (IR) Ruleset to unify data based on your desired logic (e.g., name, email, or phone).

Step 4: View Unified Data
After the IR runs successfully:

Go to Object Manager and select the ingested object (e.g., Contact).

You will see a new tab called Data Cloud Related List.

Click New, and then select:

The related object (e.g., Account Contact).

The Unified Object, which corresponds to the latest IR set that was run.

Click Save.

Go to the record page where the related list was added and ensure it's visible.

Save the layout.

Now, you will be able to see the related data from all connected orgs.

Additional Integrations
For data coming from Snowflake via API, we have embedded the LWC component contactDataList on the Contact record page.

For displaying Snowflake data using a Streamlit UI, we have embedded another iframe-enabled LWC component on the Contact record page named snowflake.

# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
