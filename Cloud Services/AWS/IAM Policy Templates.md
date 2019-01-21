Unless other specified, all permissions here should produce no error when accessing via AWS Management Console

## S3
Allow read access on specific S3 buckets
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "S3AllowListAllBuckets",
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "*"
        },
        {
            "Sid": "S3AllowReadBuckets",
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
                "arn:aws:s3:::mybucketname",
                "arn:aws:s3:::mybucketname/*"
            ]
        }
    ]
}
```

## RDS
(This permission is not yet tested, read permission is missing) Allow start, stop, reboot and failover
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "RdsAllowOperate",
            "Effect": "Allow",
            "Action": [
                "rds:StartDBCluster",
                "rds:StopDBCluster",
                "rds:FailoverDBCluster",
                "rds:StartDBInstance",
                "rds:StopDBInstance",
                "rds:RebootDBInstance"
            ],
            "Resource": [
                "arn:aws:rds:ap-southeast-1:123456789012:cluster:mydbcluster",
                "arn:aws:rds:ap-southeast-1:123456789012:db:mydbinstance"
            ]
        }
    ]
}
```

## Lambda
For programmatic access. This allow full read access to Lambda, allow full access
at function level but exclude delete and tagging. Full access to event source mapping and layer are not included.
Notice that from testing result as of 2019-01-14, Lambda permission using 'lambda:TagResource'
and 'lambda:UntagResource' still allow tags to be removed. Seems it is a bug.
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "IamAllowGetAndPassRoles",
            "Effect": "Allow",
            "Action": [
                "iam:GetRole",
                "iam:PassRole"
            ],
            "Resource": [
                "arn:aws:iam::123456789012:role/myfunctionexecutionrole"
            ]
        },
        {
            "Sid": "LambdaAllowListAndRead",
            "Effect": "Allow",
            "Action": [
                "lambda:ListEventSourceMappings",
                "lambda:ListFunctions",
                "lambda:ListLayers",
                "lambda:ListLayerVersions",
                "lambda:GetAccountSettings",
                "lambda:GetEventSourceMapping"
            ],
            "Resource": "*"
        },
        {
            "Sid": "LambdaAllowFunctionFullAccessExceptDeleteAndTagging",
            "Effect": "Allow",
            "Resource": [
                "arn:aws:lambda:ap-southeast-1:123456789012:function:myfunction"
            ],
            "NotAction": [
                "lambda:DeleteFunction",
                "lambda:*TagResource*"
            ]
        }
    ]
}
```

## CloudWatch Logs
Allow full read access to CloudWatch Logs but limited to log group level,
modified based on AWS managed IAM policy `CloudWatchLogsReadOnlyAccess`
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LogsAllowListAndRead",
            "Effect": "Allow",
            "Action": [
                "logs:DescribeDestinations",
                "logs:DescribeExportTasks",
                "logs:DescribeLogGroups",
                "logs:DescribeQueries",
                "logs:DescribeResourcePolicies",
                "logs:GetLogDelivery",
                "logs:GetLogRecord",
                "logs:GetQueryResults",
                "logs:ListLogDeliveries",
                "logs:StopQuery",
                "logs:TestMetricFilter"
            ],
            "Resource": "*"
        },
        {
            "Sid": "LogsAllowReadLogGroups",
            "Effect": "Allow",
            "Action": [
                "logs:Describe*",
                "logs:Get*",
                "logs:List*",
                "logs:StartQuery",
                "logs:FilterLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:ap-southeast-1:123456789012:log-group:/aws/apigateway/welcome:*"
            ]
        }
    ]
}
```

## AWS managed IAM policies reference
`AmazonS3ReadOnlyAccess`
- ARN: `arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess`
- Version: 1
- Creation time: 2015-02-07 02:40 UTC+0800
- Description: Provides read only access to all buckets via the AWS Management Console.
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": "*"
        }
    ]
}
```

`AWSLambdaFullAccess`
- ARN: `arn:aws:iam::aws:policy/AWSLambdaFullAccess`
- Version: 8
- Creation time: 2017-11-28 07:22 UTC+0800
- Description: Provides full access to Lambda, S3, DynamoDB, CloudWatch Metrics and Logs.
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudformation:DescribeChangeSet",
                "cloudformation:DescribeStackResources",
                "cloudformation:DescribeStacks",
                "cloudformation:GetTemplate",
                "cloudformation:ListStackResources",
                "cloudwatch:*",
                "cognito-identity:ListIdentityPools",
                "cognito-sync:GetCognitoEvents",
                "cognito-sync:SetCognitoEvents",
                "dynamodb:*",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "events:*",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:ListRolePolicies",
                "iam:ListRoles",
                "iam:PassRole",
                "iot:AttachPrincipalPolicy",
                "iot:AttachThingPrincipal",
                "iot:CreateKeysAndCertificate",
                "iot:CreatePolicy",
                "iot:CreateThing",
                "iot:CreateTopicRule",
                "iot:DescribeEndpoint",
                "iot:GetTopicRule",
                "iot:ListPolicies",
                "iot:ListThings",
                "iot:ListTopicRules",
                "iot:ReplaceTopicRule",
                "kinesis:DescribeStream",
                "kinesis:ListStreams",
                "kinesis:PutRecord",
                "kms:ListAliases",
                "lambda:*",
                "logs:*",
                "s3:*",
                "sns:ListSubscriptions",
                "sns:ListSubscriptionsByTopic",
                "sns:ListTopics",
                "sns:Publish",
                "sns:Subscribe",
                "sns:Unsubscribe",
                "sqs:ListQueues",
                "sqs:SendMessage",
                "tag:GetResources",
                "xray:PutTelemetryRecords",
                "xray:PutTraceSegments"
            ],
            "Resource": "*"
        }
    ]
}
```

`CloudWatchLogsReadOnlyAccess`
- ARN: `arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess`
- Version: 4
- Creation time: 2019-01-15 03:32 UTC+0800
- Description: Provides read only access to CloudWatch.
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:Describe*",
                "logs:Get*",
                "logs:List*",
                "logs:StartQuery",
                "logs:StopQuery",
                "logs:TestMetricFilter",
                "logs:FilterLogEvents"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
```
