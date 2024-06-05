# Dinca Dragos Ionut - Proiect licenta

# Infrastructura terraform - AWS

## VPC - details
```
CIDR: "10.16.0.0/16"

Public subnets: "10.16.101.0/24", "10.16.102.0/24"
Database subnets: "10.16.21.0/24", "10.16.22.0/24"

Security groups for EC2 and RDS
```

## EC2 - details
```
OS type: Ubuntu 20.04
Instance type: t2.micro

```

## RDS - details
```
Engine: mysql 8.0
Instance class: db.t2.micro
Alocated storage: 10GB
```

## GITLAB-CI pipeline
```
Stage to run terraform commands:
-init
-validate
-plan
-apply
```
