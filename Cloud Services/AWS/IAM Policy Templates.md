Unless other specified, all permissions here should produce no error when accessing via AWS Management Console

## S3
Allow read access on specified S3 buckets
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
            "Sid": "VisualEditor0",
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

## CloudWatch Logs
Allow full read access to CloudWatch Logs but limited to log group level, modified based on AWS managed IAM policy `CloudWatchLogsReadOnlyAccess`
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LogsAllowListLogGroups",
            "Effect": "Allow",
            "Action": "logs:DescribeLogGroups",
            "Resource": "*"
        },
        {
            "Sid": "LogsAllowListAndRead",
            "Effect": "Allow",
            "Action": [
                "logs:DescribeDestinations",
                "logs:DescribeExportTasks",
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


`CloudWatchLogsReadOnlyAccess`
- ARN: `arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess`
- Version: 4
- Creation time: 2019-01-15 03:32 UTC+0800
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
