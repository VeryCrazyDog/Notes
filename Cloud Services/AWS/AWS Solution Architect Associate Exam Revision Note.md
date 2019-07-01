# AWS Solution Architect Associate Exam Revision Note
This is the revision note for AWS solution architect associate exam.

## General
### Exam Advice
1. Don't consider corner case.
2. Choose the most reasonable answer.
3. Choose an answer which has least dependency. For example, if we want to get the total count of HTTP 404, we can use CloudWatch metric, but we need the log first, so enable logging is the answer.
### Concept
1. High availability and fault tolerant are 2 different concepts. High availability in AWS definition is that it will automatically recover without manual intervention. Down time or degraded service is allowed. Fault tolerant means user should not notice fault is happens, and no downtime and degrade is allowed.
2. RTO means recovery time objective, RPO means recovery point objective.
### Practice
1. Using AWS managed services should always be preferred.
2. Expect that everything will fail at some point and design accordingly.
3. In practice, we should set the minimum capacity of an auto scaling group to 0, 1, 2, even there is no restriction in AWS.
4. Prefer IAM roles to access keys.
### Policy
1. No prior AWS approval is required for penetration test on some AWS services such as EC2, RDS, CloudFront, API Gateway, etc. ([Reference](https://aws.amazon.com/security/penetration-testing/))
### AWS
1. AWS assigns two unique IDs to each AWS account: an AWS account ID and a canonical user ID. The AWS account ID is a 12-digit number, such as 123456789012. The canonical user ID is a long string, such as 79a59df900b949e55d96a1e698fbacedfd6e09d98eacf8f8d5218e7cd47ef2be.
2. Besides EC2 and RDS, reserved resources with discounted price are also available for:
	* ElastiCache
	* DynamoDB
	* Redshift

## Compute: EC2 ([FAQ](https://aws.amazon.com/ec2/faqs/))
1. Termination Protection only prevent termination by API (AWS console and CLI also use API), and does not prevent you from terminating an instance by initiating shutdown from the instance with shutdown behavior set to `Terminate`.
2. Once an instance is launched, the user cannot change the availability zone of that instance unless he creates an AMI of that instance and launches a new instance from it.
3. AMI ID is different for different region even the image is the same.
4. *InstanceLimitExceeded* error occur when you have reached the limit on the number of instances that you can launch in a region.
5. *InsufficientInstanceCapacity* error occur when AWS does not currently have enough available On-Demand capacity to service your request.
6. EC2 has 3 types of tenancy:
	* Default, which your instance runs on shared hardware.
	* Dedicated or dedicated instance, which your instance runs on single-tenant hardware.
	* Host or dedicated host, which your instance runs on a dedicated host, which is an isolated server with configurations that you can control.
### Scheduled instance ([Reference](https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/ec2-scheduled-instances.html))
1. Scheduled instance cannot be stopped or rebooted, only manual termination is allowd. After terminated for a few minutes, it can be relaunch again.
2. Scheduled instance is terminated three minutes before the end of the current scheduled time period.
3. After you purchase a scheduled instance, you can't cancel, modify, or resell your purchase.
4. As of 2019-06-26, the required term is 365 days (one year).
5. As of 2019-06-26, the minimum required utilization is 1,200 hours per year. From AWS console, the total schedule duration should be greater than 1,200hrs/year, 100hrs/month, 24hrs/week, or 4hrs/day.
### Reserved instance
1. There are two scope of reserved instance. One is zonal and one is regional. Both are costing the same. [Reference](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/reserved-instances-scope.html).
2. Zonal reserved instances provide no availability zone flexibility and no instance size flexibility whereas regional do. [Reference](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/reserved-instances-scope.html).
3. Regional reserved instances provide no capacity reservation whereas zonal do. [Reference](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/reserved-instances-scope.html).
4. There are two type of offering classes: standard and convertible.
5. Standard reserved instances can be sold in the Reserved Instance Marketplace whereas convertible reserved instances cannot.
6. You cannot exchange a standard reserved instance. Only modification is allowed. Instance family cannot be modified. However some attributes are allowed to be changed during the term. These includes:
	* Scope, to change between regional and zonal.
	* Availability zones in the same region for regional reserved instances.
	* Instance size, but only apply to Amazon Linux on default tenancy.
7. Convertible reserved instance can be exchanged during the term for another convertible reserved instance with new attributes including instance family, instance type, platform, scope, or tenancy. You can also modify some attributes of a convertible reserved instance the same way as standard reserved instance.
8. Instance size flexibility is determined by the normalization factor of the instance size. The discount applies either fully or partially to running instances of the same instance family, depending on the instance size of the reservation, in any Availability Zone in the Region. The only attributes that must be matched are the instance family, tenancy, and platform. [Reference](https://docs.aws.amazon.com/en_us/AWSEC2/latest/UserGuide/apply_ri.html).

## Compute: EC2 Auto Scaling
1. A running EC2 instance can be added to a new auto scaling group.
2. [From CloudAcademy, not verified] A running EC2 instance can also be added to an existing auto scaling group, but only limited to auto scaling group using EC2 launch template and not auto scaling group using auto scaling launch configuration.
3. EC2 instance can also be detached from existing auto scaling group.
4. Autoscaling group has the following [scaling options](https://docs.aws.amazon.com/autoscaling/ec2/userguide/scaling_plan.html).
	* Maintain current instance levels at all times
	* Manual scaling
	* Scale based on a schedule
	* Scale based on demand (dynamic scaling)
		* Target tracking scaling
		* Step scaling
		* Simple scaling
5. It is possible to set the instance health status to `Healthy` or `Unhealthy`.
6. After an instance has been marked unhealthy by Auto Scaling, as a result of an Amazon EC2 or ELB health check, it is almost immediately scheduled for replacement as it will never automatically recover its health.
7. CloudWatch detailed monitoring is by default enabled in autoscaling launch configuration (not to be confused with EC2 launch template).
8. Auto scaling consists of the following processes, and we can edit the auto scaling group to suspend one or more processes.
	* Launch
	* Terminate
	* AddToLoadBalancer
	* AlarmNotification
	* AZRebalance
	* HealthCheck
	* ReplaceUnhealthy
	* ScheduledActions
9. Both step scaling and simple scaling need to configure scaling adjustment types, 3 available types as of 2019-06-23 are:
	* ChangeInCapacity
	* ExactCapcity
	* PercentChangeInCapacity

## Storage: S3 ([FAQ](https://aws.amazon.com/s3/faqs/))
1. Cross-region replication requires versioning on both source bucket and destination bucket. [Reference](https://docs.aws.amazon.com/AmazonS3/latest/dev/crr.html).
2. Cross-region replication requires the source bucket owner have the source and destination AWS Regions enabled. [Reference](https://docs.aws.amazon.com/AmazonS3/latest/dev/crr.html).
3. To use server-side encryption with customer-provided encryption keys (SSE-C), encryption key and other related information need to be provided in each API call via HTTP headers. [Reference](https://docs.aws.amazon.com/AmazonS3/latest/dev/ServerSideEncryptionCustomerKeys.html).
4. A presigned URL gives you access to the object identified in the URL, provided that the creator of the presigned URL has permissions to access that object. The presigned URLs are useful if you want your user/customer to be able to upload a specific object to your bucket, but you don't require them to have AWS security credentials or permissions. When you create a presigned URL, you must provide your security credentials and then specify a bucket name, an object key, an HTTP method (PUT for uploading objects), and an expiration date and time.
5. S3 use write once read many (WORM) model. It means the objects are immutable. That is, the only way to change a single byte in an object is to replace the object.
6. To make objects publicly readable, this can be done by either modifying the ACL on the objects one by one to allow public read, or by using bucket policy managed by the bucket owner.
7. By default, only the object owner can read the object and change the object ACL. The bucket owner is not able to read or change the ACL unless access has been granted to the bucket owner. Bucket owner can enforce all objects put into the bucket granted access right to the bucket owner via bucket policy.
8. Only list and write access are avaiable to grant in bucket ACL. To grant read access to object in a bucket, object ACL should be used.
9. Objects uploaded to a bucket by another account don't automatically inherit the permissions defined in the bucket policy. The bucket owner must take ownership of the object for the bucket policy to apply. [Reference](https://aws.amazon.com/premiumsupport/knowledge-center/s3-bucket-acl-email-error/).
10. To allow another account to upload objects to your bucket, it's a best practice to create an AWS Identity and Access Management (IAM) role from your account that the other account can assume. [Reference](https://aws.amazon.com/premiumsupport/knowledge-center/s3-bucket-acl-email-error/).

## Storage: Storage Gateway
1. There are 3 types of gateways:
	* File gateway
	* Volume gateway
	* Tape gateway
2. File gateway only work in cached mode, while volume gateway support both cached volumes and stored volumes

## Storage: EBS
1. EBS is relatively less scalable. Scaling is possible on capacity, IPOS, and by switching to different volume type. These changes can be done while the volume is attached and in used, but will take times to complete.
2. SSD vs HDD is not about cost or speed. It is about random access vs sequel access.
3. Data stored on EBS is automatically replicated within an availability zone, but does not replicate cross availability zone.
4. An EBS-optimized instance provides additional, dedicated throughput for Amazon EBS I/O. This provides improved performance for your Amazon EBS volumes and enables instances to use provisioned IOPs fully. For example, using a t2.micro instance with high IOPS EBS volume will not deliver IOPS as the network link is shared between EBS I/O and network I/O.

## Storage: RDS ([FAQ](https://aws.amazon.com/rds/faqs/))
1. In RDS, multi-AZ and read replica are different. Standby instance in multi-AZ is not read accessible.
2. RDS reserved instance is similiar to EC2 standard regional reserved instance with instance size flexibility.

## Storage: ElastiCache
1. Data partitioning is supported in memcached and Redis (cluster mode enabled) cluster.
### Memcached
1. Memcached did not support encryption. Redis support encryption for version 3.2.6, 4.0.10 and later.
2. Memcached did not support replication, therefore when a node was failed, some data was lost.
3. Memcached run in cluster, and can scale out and in by adding node and removing node.
### Redis
1. There are 2 types of Redis clusters (a.k.a replication groups in API/CLI). They are Redis (cluster mode disabled) cluster and Redis (cluster mode enabled) cluster.
2. One Redis node with 0 to 5 Redis replica node form a shard (a.k.a node group in API/CLI). Redis (cluster mode disabled) cluster only contain 1 shard. Redis (cluster mode enabled) cluster can contain 1 to 90 shard.
3. Redis replica node provide high availibity and read throughput. If the write node failed, it is possible to failover to the replica node.

## Storage: CloudFront
1. CloudFront signed URLs and signed cookies allow you to control who can access your content so that you can serve private content through CloudFront. [Reference](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-choosing-signed-urls-cookies.html).
2. Origin access identity should be used to allow only CloudFront to access the private content on S3 and not allow users to direct access S3. [Reference](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html).

## Network: VPC ([FAQ](https://aws.amazon.com/vpc/faqs/))
1. Security groups actually applies to ENI (elastic network interface), not EC2 instance or Lambda or RDS.
2. Besides public subnet and private subnet, if a subnet has default route to a virtual private gateway for a Site-to-Site VPN connection, the subnet is known as a VPN-only subnet.

## Network: Route 53 ([FAQ](https://aws.amazon.com/route53/faqs/))
1. The follow routing rules are supported in traffic policy:
	* Failover rule
	* Geolocation rule
	* Latency rule
	* Geoproximity rule
	* Multivalue answer rule
	* Weighted rule

## Network: ELB
### Classic load balancer
1. Classic load balancer supports the following protocols:
	* Layer 4
		* TCP
		* SSL
	* Layer 7
		* HTTP
		* HTTPS
2. Classic load balancer supports the following configuration:
	* Layer 4
		* TCP front-end, TCP back-end
		* SSL front-end, TCP back-end
		* SSL front-end, SSL back-end
	* Layer 7
		* HTTP front-end, HTTP back-end
		* HTTPS front-end, HTTP back-end
		* HTTPS front-end, HTTPS back-end
3. For classic load balancer:
	* For layer 4 protocol, only TCP back-end supports proxy protocol header and by default it is not enabled. SSL back-end do not supports proxy protocol header.
	* For layer 7 protcool, both HTTP and HTTPS back-end supports X-Forwarded headers. By default it is enabled?
4. Classic load balancer support sticky sessions for layer 7 protocol. Cookie is needed and it will be created by the classic load balancer.
5. With cross-zone load balancing, each load balancer node for your Classic Load Balancer distributes requests evenly across the registered instances in all enabled Availability Zones. If cross-zone load balancing is disabled, each load balancer node distributes requests evenly across the registered instances in its Availability Zone only.  [Reference](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-disable-crosszone-lb.html).
6. Classic load balancer attaches to subnet level.
7. Classic load balancer is actually a fleet of EC2 instances.
8. Classic load balancer requires at least 1 subnet to be selected to route traffic to, but recommend to select 2 subnets in 2 different AZ to provide high availability on the classic load balancer.

## Messaging: SQS ([FAQ](https://aws.amazon.com/sqs/faqs/))
