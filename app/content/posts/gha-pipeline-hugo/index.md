---
title: "Using GitHub Actions to deploy a Hugo website to S3"
date: 2023-01-15T11:18:00-03:00
slug: gha-pipeline-hugo
category: github-actions
description: "A guide explaining how to build a pipeline using GitHub Actions to deploy a static website created with Hugo to S3"
draft: false
---

[**GitHub actions**](https://docs.github.com/en/actions/quickstart) is an automation service that allows us to automate all kinds of repository related processes and actions. Using GitHub Actions we provide GitHub with a *yml* file describing our *workflow* in *steps*, and it will run the workflow based on an *event* that can be a *push*. This way everytime we make a push to the repository it will run the actions described in the yml file with our repository. This is perfect to build **CI/CD** pipelines.

[**Hugo**](https://gohugo.io/) is a *static website generator* that converts *Markdown* files (the .md files) into websites. This way instead of writing in HTML we can write in Markdown that is pretty easier. Another benefit of Hugo is we can use [*themes*](https://themes.gohugo.io/), which are premade websites with structure and css already incorporated into it. This way we don't need to worry with style if we are able to use one of the themes with our project. This blog is built with Hugo and uses the [PaperMod](https://themes.gohugo.io/themes/hugo-papermod/) theme, so when I need to write something on it I just write Markdown and run Hugo on it to create the website (HTML+CSS+JS).

This blog uses both *Hugo* and *GitHub Actions* and the [repository](https://github.com/caiocsgomes/caiogomes.me) has everything we are going to talk here implemented and working. Our objective is to use Github Actions to build a website using Hugo and deploy it on S3 to have a static website. To achive this we need to follow these steps:

1. Install Hugo in the machine that will build the app
2. Install de AWS CLI in order to upload the app to S3
3. Set the credentials in the machine so that have access to the AWS account
4. Checkout the repository
5. Run Hugo on the repository to build the app
6. Upload the files to S3
7. Optional. Invalidate the Cloufront distribution in case we are using it to cache the website.

To achieve this we set the workflow in the *.github/workflows/deploy.yml*. The *.github/workflows* folder must be in the root of the repository, as GitHub searches for worflows in this path. This is the *deploy.yml* file that achieves the described above (we will go through it in the sequence):

```yml
name: S3 Deploy

on:
  workflow_dispatch:
  push:
    paths:
      - 'app/**'
      - '.github/workflows/deploy.yml'
jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      AWS_DEFAULT_REGION: sa-east-1
      BUCKET_NAME: caiogomes.me
    steps:
        - name: Install hugo
          run: sudo apt install hugo

        - name: Install aws cli
          id: install-aws-cli
          uses: unfor19/install-aws-cli-action@v1
          with:
            version: 2
            verbose: false
            arch: amd64
            rootdir: ""
            workdir: "" 

        - name: Checkout repository
          uses: actions/checkout@v3
          with:
            submodules: 'true'

        - name: Build
          run: cd app/ && hugo

        - name: Upload files to S3
          run: aws s3 sync app/public/ s3://${{ env.BUCKET_NAME }}/ --exact-timestamps --delete

  create-cloudfront-invalidation:
    needs: build-and-deploy
    runs-on: ubuntu-latest
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      AWS_DEFAULT_REGION: sa-east-1
      CLOUDFRONT_DISTRIBUTION_ID: ${{ secrets.CLOUDFRONT_DISTRIBUTION_ID }}
    steps:
      - name: Install aws cli
        id: install-aws-cli
        uses: unfor19/install-aws-cli-action@v1
        with:
          version: 2
          verbose: false
          arch: amd64
          rootdir: ""
          workdir: "" 

      - name: Invalidate clodufront distribution
        run: aws cloudfront create-invalidation --distribution-id ${{ secrets.CLOUDFRONT_DISTRIBUTION_ID }} --paths "/*"
```

## Events

```yml
on:
  workflow_dispatch:
  push:
    paths:
      - 'app/**'
      - '.github/workflows/deploy.yml'
```

Everytime something changes in the repository GitHub fires an [Event](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows). For example, a push will fire a push event, opening an issue will open a issue event and so on. When an event fires, GitHub compares the event with the `on` section, and if the event matches the workflow is started. So in the code above everytime a push is made the workflow is started, but that's not all. We only want the event to be started if the *app* changes or if we change our workflow *github/workflows/deploy.yml*, so we add a filter to only start the workflow if the change is made to these `paths`.

The *workflow_dispatch* event is another event that let's us run the workflow manually. This will create a button in the workflow and we can press to trigger it.

## Jobs and steps
In Github Actions a **workflow** is a structured sequence of **jobs**, we use the workflow to structure and organize everything that needs to be made in a process, in this case to build and deploy the app. The **job** is a sequence of **steps** that run on the same *runner* (the machine that is executing the commands). The *steps* are what actually do the work, running commands with *run* option or using *actions* with *uses* option. 

**Actions** are apps in the GitHub marketplate that do repeated and common actions. For example, checking out (downloading) code is a preety common step in any pipeline, so we have the `actions/checkout@v3` that does that. The same happens for installing the AWS CLI, so the `unfor19/install-aws-cli-action@v1` was created. These two can be seen in action in our workflow.

## Secrets

If we have *sensitive data*, like database credentials or api secrets, we can store in [Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets), this webpage describes how to store it. After storing it we can access in our workflow like a variable. If we store the *AWS_SECRET_ACCESS_KEY* we can access it with `${{ secrets.AWS_SECRET_ACCESS_KEY }}` as it can be seen in the workflow.

## Environmental variables
If we need variables that are reused inside our workflow, jobs or steps we can define environmental variables in any of these levels. In our case we needed inside our machine the AWS credentials available for the CLI and also the bucket name. So we've defined these in our jobs.

```yml
jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      AWS_DEFAULT_REGION: sa-east-1
      BUCKET_NAME: caiogomes.me
```

After it we can use it in any step following the same syntax `${{ env.VARIABLE_NAME }}`


## Hugo CLI

To build a static website with Hugo we just need to run the *Hugo* command in a folder that has the Hugo project. This is what this step does, it enters the app folder where the app is stored and runs the Hugo command inside it.

```yml
- name: Build
  run: cd app/ && hugo
```

After running the command the generated website will be stored in the *public*. This folder will have the *index.html* file that contains the app.

## AWS CLI

The last step is syncing the *public* folder that contains the generated app and the bucket. It can be done with the command below, this will make the public folder and the bucket have the same content.

```yml
- name: Upload files to S3
  run: aws s3 sync app/public/ s3://${{ env.BUCKET_NAME }}/ --exact-timestamps --delete
```

After it the [website hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html) option can be activated in S3 and the website will be accessible through the internet.

## Cloudfront invalidation
This is optional. In my case I'm using CloudFront as a CDN to cache my content, if you are doing the same and change the S3 content, it will be not immediately accessible, as CloudFront will be using its cache. To *invalidate* the cache and make CloudFront access the content from S3 we make an invalidation using the cloudfront API as described below.


```yml
- name: Invalidate clodufront distribution
  run: aws cloudfront create-invalidation --distribution-id ${{ secrets.CLOUDFRONT_DISTRIBUTION_ID }} --paths "/*"
```