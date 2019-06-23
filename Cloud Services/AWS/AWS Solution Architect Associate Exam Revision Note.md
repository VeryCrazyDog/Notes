# AWS Solution Architect Associate Exam Revision Note
This is the revision note for AWS solution architect associate exam.

## EC2
1. Termination Protection only prevent termination by API (AWS console and CLI also use API), and does not prevent you from terminating an instance by initiating shutdown from the instance with shutdown behavior set to `Terminate`.

## Auto Scaling
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

## S3
1. Cross-region replication requires versioning on both source bucket and destination bucket. [Reference](https://docs.aws.amazon.com/AmazonS3/latest/dev/crr.html).
2. Cross-region replication requires the source bucket owner have the source and destination AWS Regions enabled. [Reference](https://docs.aws.amazon.com/AmazonS3/latest/dev/crr.html).

## ElastiCache ([FAQ](https://aws.amazon.com/elasticache/faqs/))
1. Memcached did not support encryption. Redis support encryption for version 3.2.6, 4.0.10 and later.
2. Memcached did not support replication, therefore when a node was failed, some data was lost.
3. Memcached run in cluster, and can scale out and in by adding node and removing node.
4. There are 2 types of Redis clusters (a.k.a replication groups in API/CLI). They are Redis (cluster mode disabled) cluster and Redis (cluster mode enabled) cluster.
5. Data partitioning is supported in memcached and Redis (cluster mode enabled) cluster.
6. One Redis node with 0 to 5 Redis replica node form a shard (a.k.a node group in API/CLI). Redis (cluster mode disabled) cluster only contain 1 shard. Redis (cluster mode enabled) cluster can contain 1 to 90 shard.
7. Redis replica node provide high availibity and read throughput. If the write node failed, it is possible to failover to the replica node.

## Route 53
1. The follow routing rules are supported in traffic policy:
	* Failover rule
	* Geolocation rule
	* Latency rule
	* Geoproximity rule
	* Multivalue answer rule
	* Weighted rule

## Storage Gateway ([FAQ](https://aws.amazon.com/storagegateway/faqs/))
1. There are 3 types of gateways:
	* File gateway
	* Volume gateway
	* Tape gateway
2. File gateway only work in cached mode, while volume gateway support both cached volumes and stored volumes


## EBS
1. EBS is relatively less scalable. Scaling is possible on capacity, IPOS, and by switching to different volume type. These changes can be done while the volume is attached and in used, but will take times to complete.
