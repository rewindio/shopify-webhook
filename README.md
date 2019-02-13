# Shopify Webhooks in AWS
This details how to handle Shopify webhooks using AWS API Gateway, Lambda, and SQS. Read the complete blog post at https://rewind.io/blog/handle-shopify-webhooks-without-a-server/ first.

# Why
Shopify webhooks are useful for getting information from Shopify in realtime. However for popular apps with thousands of users, these webhooks can overwhelm a system. For example, when a Shopify store imports data from another system (when syncing inventory numbers for ex.), Shopify can send out thousands of webhooks that the app must respond to within 3 seconds.

This solution uses AWS infrastructure to handle the webhooks. It uses AWS Workers to process the webhooks by posting the data from an SQS queue to http://localhost.

# Requirements
You need an AWS account to implement this solution.

# Setup
Follow the instructions in this blog post to setup AWS to handle the webhooks with a combination of AWS API Gateway, Lambda, SQS, and ElasticBeanstalk workers.

## Sample Rails Files
In this repository we have two sample files that you can use to process the webhooks.

You'll need a rails application that has the ShopifyAPI gem in it. The two files provided are:

```
app/controllers/shopify_webhook_controller.rb
config/routes.rb
```
Create a rails application first. Then use these two files to process the webhooks. Enter your own logic in shopify_webhooks_controller.rb to do whatever you want with the webhook data.
