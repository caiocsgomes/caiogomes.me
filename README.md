
# About

This is my personal website and blog. Each folder has a different project. The *app* folder has the static website that is written using the Hugo static site generator. The *infra* folder has the serverless infra written in terraform for AWS. The infra is pretty regular for a static website, *s3* to store the static app, *cloudfront* to distribute it and act as CDN, *route 53* for DNS hosting/registrar for my domain and *ACM* to generate the ssl certificate it needs.

![Architecture](https://github.com/caiocsgomes/caiogomes.me/blob/assets/architecture.png)

# Creating a Hugo website and deploying it so S3 using Github Actions

I'll describe how to run the application, how to build the infrastructure using Terraform and how to deploy the application using Github Actions.

## Running it locally

1. Install Hugo

https://gohugo.io/installation/

2. Clone the repo
```bash
git clone --recurse-submodules https://github.com/caiocsgomes/caiogomes.me.git
```

3. Change to the app folder

```bash
cd caiogomes.me/app
```

4. Start the app using Hugo

```bash
hugo server
```

## Building the infrastructure in AWS and deploying the blog

I'll describe here how to have the same setup I have, but you can change it to your needs. I'll use Terraform to build the infrastructure and Github Actions to deploy the app. This way it is possible to have a simple CI/CD pipeline for the app and the infrastructure.

### Prerequisites

1. Have an AWS account
2. Have a domain registered in AWS Route 53
3. Have a SSL certificate for your domain in AWS ACM
4. Have a role to be assumed by Github Actions and used by Terraform to deploy the infrastructure