---
title: "How to use DependsOn attribute in CloudFormation"
date: 3021-07-22T23:15:00+07:00
slug: dependson-with-cloudformation
category: cloudformation
description: "A guide explaining how the attribute DependsOn works in CloudFormation and how to use it"
draft: false
---


Cloudformation is a declarative language, that means that in Cloudformation you can declare what you want and the 
order does not matter, it will know how to interpret what is inside the template and it will handle the right order of creation for the resources.

By default Cloudformation creates all the resources in parallel, but we have some exceptions. When using the functions !Ref or !GetAtt, the resources that 
are dependent on other resources are created after its dependencies. For example, let's say you are creating an elastic ip and you want to 
attach it to an EC2. You will have a !Ref inside the elastic ip resource pointing to the EC2 resource, in this case the elastic ip is 
dependent on the EC2, so Cloudformation will create first the EC2 and then the elastic ip. The same happens when you use **!GetAtt**.

```yml
Resources:
    # Created first
    MyEC2Instance: 
        Type: AWS::EC2::Instance
    # Created in second due to the dependency
    MyEIP:
        Type: AWS::EC2::EIP
        Properties:
```

The other exception is when we use the *DependsOn* attribute. This attribute explicitly specifies a dependency. 
When we use this attribute to a resource, that resource is created only after the creation of the resource specified in the *DependsOn* attribute.

The *DependsOn* attribute is used when we need a resource created or deleted in a specific order. For example, let's say we need a RDS database
to be available before creating the EC2, we would use the attribute to reach this.

```yml
Resources:
    MyEC2:
    # Created after the MyDB
        Type: AWS::EC2::Instance
        DependsOn: MyDB #Dependency
    # Created before the MyEC2
    MyDB:
        Type: AWS::RDS::DBInstance
        Properties:
        AllocatedStorage: '5'
        DBInstanceClass: db.t2.small
        Engine: MySQL
        EngineVersion: '5.5'
        MasterUsername: MyName
        MasterUserPassword: MyPassword
```
