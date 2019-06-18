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
