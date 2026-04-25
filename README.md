# Job Application Tracker

![ci](https://github.com/jaxjoelliott/job-tracker/actions/workflows/ci.yml/badge.svg)

In progress web application to track job application information. 

## Stack

Lambda · API Gateway · DynamoDB

## Structure

src/handlers/ — Lambda functions
terraform/ — infrastructure as code (DynamoDB table)

## Architecture
POST /applications → API Gateway → createApplication Lambda → DynamoDB
GET /applications → API Gateway → listApplications Lambda → DynamoDB
GET /applications/{id} → API Gateway → getApplication Lambda → DynamoDB
PUT /applications/{id} → API Gateway → updateApplication Lambda → DynamoDB
DELETE /applications/{id} → API Gateway → deleteApplication Lambda → DynamoDB

## Setup
1. Clone the repo
2. Run `npm install`
3. Configure AWS CLI: `aws configure sso`
4. Deploy infrastructure: `cd terraform && terraform apply`

## Deployment
1. Build: `npm run build`
2. Zip: `zip -r function.zip dist/ node_modules/`
3. Upload zip to Lambda via AWS console
4. Set environment variable `TABLE_NAME=job-applications`

## Testing
npm test
