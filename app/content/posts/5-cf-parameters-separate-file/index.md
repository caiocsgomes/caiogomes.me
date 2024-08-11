---
title: "How to have paramaters in an external file for CloudFormation"
date: 3021-06-27T23:15:00+07:00
slug: parameters-in-external-file-using-cloudformation
category: cloudformation
description: "A guide explaining how to split parameters and templates in separate files in CloudFormation"
draft: false
---

If you are using a reusable CloudFormation template you'll probably want to use Parameters. Parameters are variables 
that you can use inside the template to input values each time you create or update a stack. This way the values are not 
hard-coded on the template and you can reuse it just changing the variables.

If you do not specify the parameters and upload the template using the console, CloudFormation will ask each of them when creating 
or updating the stack and you'll input on the console. Another approach is to have a parameters file for prod and dev and pass 
this file when creating the stack using the AWS CLI. This page shows how to do that.

The approach I take is to make a *parameters-dev.json* and a *parameters-prod.json*.
Then on each file I specify the parameters for each environment. The parameters would use this structure inside a json file:

```json
[
    {
        "ParameterKey": "BucketVersioningConfiguration",
        "ParameterValue": "Suspended"
    },
    {
        "ParameterKey": "BucketAccessControl",
        "ParameterValue": "PublicRead"
    }
]
```

Then on the template we would first declare the parameters and then use them inside any section.

```yaml
Parameters:
    BucketAccessControl:
        Description: Bucket access control type
        Type: String
    BucketVersioningConfiguration:
        Description: Bucket versioning
        Type: String
    
Resources:
    S3Bucket:
        Type: 'AWS::S3::Bucket'
        Properties:
        AccessControl: !Ref BucketAccessControl
        VersioningConfiguration:
            Status: !Ref BucketVersioningConfiguration
        Tags:
            - Key: type
            Value: example
```

To create the stack using the *parameters.json* file and the *template.yml* file with the AWS CLI, we would need the following command:

I have a [repo](https://github.com/caiocsgomes/cloudformation/tree/main/cf-parameters-separate-file) with a code example that can be cloned.
