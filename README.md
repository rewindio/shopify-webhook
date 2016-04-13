# Shopify Webhooks in AWS
This details how to handle Shopify webhooks using AWS API Gateway, Lambda, and SQS.

# Why
Shopify webhooks are useful for getting information from Shopify in realtime. However for popular apps with thousands of users, these webhooks can overwhelm a system. For example, when a Shopify store imports data from another system (for example for syncing inventory numbers), Shopify can send out 10s of thousands of webhooks that the app must respond to within 3 seconds.

This solution uses AWS infrastructure to handle the webhooks, and provides a scaffold that will can be used in conjunction with Shoryuken to process the webhooks as required.

# Requirements
You need an AWS account to implement this solution.

# Setup
## Step 1 - Lambda
In AWS Lambda, click on "Create New Function". Click "Skip" to not use a prebuilt template. Give your function a name ("ShopifyWebhook") and select Python as the runtime. 
For code enter:
```python
import boto3  
import json

def lambda_handler(event, context):
    sqs = boto3.resource('sqs')
    queue = sqs.get_queue_by_name(QueueName=event["queue"])
    response = queue.send_message(MessageBody=json.dumps(event))
```   

## Step 2 - SQS Queue
Setup as many queues as you want for each environment you're going to support. We recommend 3:
Development - Queue name: shopify-dev
Staging - Queue name: shopify-staging
Production - Queue name: shopify-prod

## Step 3 - API Gateway
### a - Create API Gateway Model
In Amazon API Gateway, create a model called Shopify Webhook that looks like:
```javascript
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "ShopifyWebhookInput",
  "type": "object",
  "properties": {
    "header": { "type": "string" },
    "body": {
      "type": "string"
    }
  }
}
```
### b - Create API Gateway Endpoint method.
Create a new API that responds to POST requests.  
In the Method Request, choose the request model you setup above.
In Integration Request, select the Lambda function "shopify_webhook". In the "Body Mapping Template", create a new template and use the following template:
```javascript
#set($inputRoot = $input.path('$'))
{
  "X-Shopify-Shop-Domain" : "$input.params().header.get('X-Shopify-Shop-Domain')",
  "X-Shopify-Topic" : "$input.params().header.get('X-Shopify-Topic')",
  "X-Shopify-Hmac-SHA256" : "$input.params().header.get('X-Shopify-Hmac-SHA256')",
  "body" : $input.json('$'),
  "queue" : "$stageVariables.sqs_queue"
}
```
Set Integration Response to the default values.
Set the Method Response to 200 (success). This ensures Shopify won't delete your webhook.

### c - Set stage variables
In our example we use stage variables to determine the queue to send to. Local development (Rails DEV ENV) goes to the queue "shopify-dev", staging goes to "shopify-staging" and production goes to "shopify-prod". 
In the the left hand side, under your API ("ShopifyWebhook"), click on "Stages". Create the stages you want, and under "Stage Variables" set the stage variable "sqs_queue" to the name of the SQS Queue you'd like to send to. 

