
// Terraform configuration for AWS resources
terraform {
  backend "s3" {
    bucket = "applicationflow-dev-jackson"
    key    = "applicationflow/terraform.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region_name
}

// IAM Role for createApplication with basic permissions and Put_Item_Policy
resource "aws_iam_role" "create_application_lambda_role" {
  name = "createApplication-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

// IAM Role for listApplications with basic permissions and List_Item_Policy
resource "aws_iam_role" "list_applications_lambda_role" {
  name = "listApplications-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

// IAM Role for getApplication with basic permissions and Get_Item_Policy

resource "aws_iam_role" "get_application_lambda_role" {
  name = "getApplication-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

// IAM Role for updateApplication with basic permissions and Update_Item_Policy

resource "aws_iam_role" "update_application_lambda_role" {
  name = "updateApplication-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

// IAM Role for deleteApplication with basic permissions and Delete_Item_Policy

resource "aws_iam_role" "delete_application_lambda_role" {
  name = "deleteApplication-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

// Policy to allow Lambda function to put items into job-applications table
resource "aws_iam_policy" "Put_Item_Policy" {
  name        = "PutItemPolicy"
  path        = "/"
  description = "DynamoDB PutItem policy for createApplication Lambda function"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:PutItem"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.job_applications_table.arn
      },
    ]
  })
}


// Policy to allow Lambda function to list items from job-applications table
resource "aws_iam_policy" "List_Items_Policy" {
  name        = "ListItemsPolicy"
  path        = "/"
  description = "DynamoDB ListItems policy for listApplications Lambda function"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:Scan"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.job_applications_table.arn
      },
    ]
  })
}

// Policy to allow Lambda function to get item from job-applications table
resource "aws_iam_policy" "Get_Item_Policy" {
  name        = "GetItemPolicy"
  path        = "/"
  description = "DynamoDB GetItem policy for getApplication Lambda function"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:GetItem"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.job_applications_table.arn
      },
    ]
  })
}

// Policy to allow Lambda function to update item in job-applications table
resource "aws_iam_policy" "Update_Item_Policy" {
  name        = "UpdateItemPolicy"
  path        = "/"
  description = "DynamoDB UpdateItem policy for updateApplication Lambda function"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:UpdateItem"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.job_applications_table.arn
      },
    ]
  })
}

// Policy to allow Lambda function to delete item from job-applications table
resource "aws_iam_policy" "Delete_Item_Policy" {
  name        = "DeleteItemPolicy"
  path        = "/"
  description = "DynamoDB DeleteItem policy for deleteApplication Lambda function"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:DeleteItem"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.job_applications_table.arn
      },
    ]
  })
}

// createApplication role attachments

// Attach basic Lambda execution policy to create_application_lambda_role
resource "aws_iam_role_policy_attachment" "createApplication_basic_lambda_policy_attachment" {
  role     = aws_iam_role.create_application_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// Attach Put_Item_Policy to create_application_lambda_role
resource "aws_iam_role_policy_attachment" "DynamoDBPutItemPolicyAttachment" {
  role     = aws_iam_role.create_application_lambda_role.name
  policy_arn = aws_iam_policy.Put_Item_Policy.arn
}

// listApplications role attachments

// Attach basic Lambda execution policy to list_applications_lambda_role
resource "aws_iam_role_policy_attachment" "listApplications_basic_lambda_policy_attachment" {
  role     = aws_iam_role.list_applications_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// Attach List_Item_Policy to list_applications_lambda_role
resource "aws_iam_role_policy_attachment" "DynamoDBListItemPolicyAttachment" {
  role     = aws_iam_role.list_applications_lambda_role.name
  policy_arn = aws_iam_policy.List_Items_Policy.arn
}

// getApplication role attachments

// Attach basic Lambda execution policy to get_application_lambda_role
resource "aws_iam_role_policy_attachment" "getApplication_basic_lambda_policy_attachment" {
  role     = aws_iam_role.get_application_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// Attach Get_Item_Policy to get_application_lambda_role
resource "aws_iam_role_policy_attachment" "DynamoDBGetItemPolicyAttachment" {
  role     = aws_iam_role.get_application_lambda_role.name
  policy_arn = aws_iam_policy.Get_Item_Policy.arn
}

// updateApplication role attachments

// Attach basic Lambda execution policy to get_application_lambda_role
resource "aws_iam_role_policy_attachment" "updateApplication_basic_lambda_policy_attachment" {
  role     = aws_iam_role.update_application_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// Attach Update_Item_policy to update_application_lambda_role
resource "aws_iam_role_policy_attachment" "DynamoDBUpdateItemPolicyAttachment" {
  role     = aws_iam_role.update_application_lambda_role.name
  policy_arn = aws_iam_policy.Update_Item_Policy.arn
}

// deleteApplication role attachments

// Attach basic Lambda execution policy to delete_application_lambda_role
resource "aws_iam_role_policy_attachment" "deleteApplication_basic_lambda_policy_attachment" {
  role     = aws_iam_role.delete_application_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// Attach Delete_Item_Policy to delete_application_lambda_role
resource "aws_iam_role_policy_attachment" "DynamoDBDeleteItemPolicyAttachment" {
  role     = aws_iam_role.delete_application_lambda_role.name
  policy_arn = aws_iam_policy.Delete_Item_Policy.arn
}

// DynamoDB table resource for job applications
resource "aws_dynamodb_table" "job_applications_table" {
  name = "job-applications"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "id"
  attribute {
    name = "id"
    type = "S"
  }
}

// Lambda function resource createApplication
resource "aws_lambda_function" "create_application" {
  function_name = "createApplication"
  role          = aws_iam_role.create_application_lambda_role.arn
  handler       = "dist/handlers/createApplication.handler"
  runtime       = "nodejs22.x"
  filename      = "function.zip"
  source_code_hash = filebase64sha256("function.zip")

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.job_applications_table.name
    }
  }
}
// Lambda function resource listApplications
resource "aws_lambda_function" "list_applications" {
  function_name = "listApplications"
  role          = aws_iam_role.list_applications_lambda_role.arn
  handler       = "dist/handlers/listApplications.handler"
  runtime       = "nodejs22.x"
  filename      = "function.zip"
  source_code_hash = filebase64sha256("function.zip")
  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.job_applications_table.name
    }
  }
}

// Lambda function resource getApplication
resource "aws_lambda_function" "get_application" {
  function_name = "getApplication"
  role          = aws_iam_role.get_application_lambda_role.arn
  handler       = "dist/handlers/getApplication.handler"
  runtime       = "nodejs22.x"
  filename      = "function.zip"
  source_code_hash = filebase64sha256("function.zip")
  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.job_applications_table.name
    }
  }
}

// Lambda function resource updateApplication
resource "aws_lambda_function" "update_application" {
  function_name = "updateApplication"
  role          = aws_iam_role.update_application_lambda_role.arn
  handler       = "dist/handlers/updateApplication.handler"
  runtime       = "nodejs22.x"
  filename      = "function.zip"
  source_code_hash = filebase64sha256("function.zip")
  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.job_applications_table.name
    }
  }
}

// Lambda function resource deleteApplication
resource "aws_lambda_function" "delete_application" {
  function_name = "deleteApplication"
  role          = aws_iam_role.delete_application_lambda_role.arn
  handler       = "dist/handlers/deleteApplication.handler"
  runtime       = "nodejs22.x"
  filename      = "function.zip"
  source_code_hash = filebase64sha256("function.zip")

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.job_applications_table.name
    }
  }
}




