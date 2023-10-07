
# About

This is my personal website and blog. Each folder has a different project. The *app* folder has the static website that is written using the Hugo static site generator. The *infra* folder has the serverless infra written in terraform for AWS. The infra is pretty regular for a static website, *s3* to store the static app, *cloudfront* to distribute it and act as CDN, *route 53* for DNS and as a registrar form my domain and *ACM* to generate the ssl certificate it needs.

# Creating a Hugo website and deploying it so S3 using Github Actions

This is the current project explained step by step

https://caiogomes.me/posts/gha-pipeline-hugo/

# Getting started

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