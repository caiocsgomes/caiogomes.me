
# About

This is my personal website and also a blog template. Each folder has a different project. The *app* folder has the static website that is written using the Hugo static site generator. The *infra* folder has the serverless infra written in terraform for AWS. The infra is pretty regular for a static website, *s3* to store the static app, *cloudfront* to distribute it and act as CDN, *route 53* for DNS hosting/registrar for my domain and *ACM* to generate and store the ssl certificate it needs.

![Architecture](https://github.com/caiocsgomes/caiogomes.me/blob/assets/architecture.png)

# Creating a Hugo website and deploying it so S3 using Github Actions

I'll describe how to run the application, how to build the infrastructure using Terraform and how to deploy the application using Github Actions.

## Running it locally

1\. Install Hugo

https://gohugo.io/installation/

2\. Clone the repo
```bash
git clone https://github.com/caiocsgomes/caiogomes.me.git
```

3\. Change to the app folder

```bash
cd caiogomes.me/app
```

4\. Start the app using Hugo

```bash
hugo server
```

## Building the infrastructure in AWS and deploying the blog

I'll describe here how to have the same setup I have, but you can change it to your needs. I'll use Terraform to build the infrastructure and Github Actions to deploy the app. This way it is possible to have a simple CI/CD pipeline for the app and the infrastructure.

### Prerequisites

1\. Have an AWS account

We will use AWS to host the static website and the infrastructure. You can create an account here: https://aws.amazon.com/free/

2\. Have a domain registered in AWS Route 53

We will use AWS Route 53 to host the DNS records for our domain. You can register a domain following this [guide](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html). Remember that to use S3 to host a static website the bucket name must be the same as the domain name. So if you want to use *example.com* as your domain you need to create a bucket with the name *example.com*. Verify that the bucket name is available before registering the domain.

3\. Create a repository in Github to host the code

You can use this repository as a template to create your own. You can go to the repository page and click in the **Use this template** button. After that you can clone the repository and start working on it. Remember to make it public so we have all options that we need available.

4\. Have a role to be assumed by Github Actions and used by Terraform to deploy the infrastructure.

In the console there is a new option to create a role for Github Actions, you just need to go to IAM -> Roles -> Create Role choose as in the image below, passing the data necesary like the repository, org (your user) and branch the workflow will run.

![Create Role](https://github.com/caiocsgomes/caiogomes.me/blob/assets/iam-role-github-actions.png)

After the role is created it is going to have an ARN. We need to place this ARN in the repository secrets in Github as the workflow will use it to assume the role and deploy the infrastructure. You can go to the repository settings -> Secrets and create a new secret with the name `AWS_ROLE_ARN` and the value as the ARN of the role you created.

![Github Actions Secrets](https://github.com/caiocsgomes/caiogomes.me/blob/assets/github-actions-blog-secrets.png)


5\. Create a protection rule for the main branch

I like to have a protection rule for review in a **production** environment, so I can only deploy the Terraform changes after I verify the *terraform plan* (in a real production environment I'd do this in the PR but for a personal blog this is enough). 

If you take a look into the *.github/workflows/terraform.yaml* you will see the first job makes the plan and the second job applies it. The second job has the **production** environment set. This will make the workflow hang and wait for a review/aproval before applying the changes.

To create the protection rule for the environment you can go to the repository settings -> Environment and create a new environment called **production**. After that you can go to the **Deployment protection rules** and create the rule as below adding you as the reviewer.

![Github Actions Environment](https://github.com/caiocsgomes/caiogomes.me/blob/assets/github-actions-blog-environment-protection-rules.png)

### Deploying the infrastructure

Clone your repository

```bash
git clone --recurse-submodules **YOUR-REPO**
```

Go to the *infra/terraform.tfvars* and change the *project_name* to your domain name set on prerequisites step 2. Also in the *infra/provider.tf* change the region to the region you want to deploy the infrastructure. Then commit this changes and push.

After that you can go to the **Actions** tab in your repository and you will see the workflow *Terraform Deploy* running. After it finishes you will have the infrastructure ready to deploy the app.

### Deploying the app

If you take a look at the deploy workflow in *.github/workflows/deploy.yaml* you will see that it is using some variables. I'm setting the cloudfront id in the secrets of the repository using the `CLOUDFRONT_DISTRIBUTION_ID` variable name. You can get the cloudfront id in the AWS console in the cloudfront service and store it as we did for the role ARN. I'm also setting the bucket name and the region in the workflow. You need to update these values to your bucket name and region and push the commit. After that you can go to the **Actions** tab in your repository and you will see the workflow *Deploy* running. After it finishes you will have the app deployed.
