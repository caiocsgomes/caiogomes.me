---
title: "Strategies on container promotion pipelines"
date: 2040-01-15T11:18:00-03:00
slug: "strategies-on-container-promotion-pipelines" # The unique identifier of the post in the URL, if you place a new slug the URL will change, i this case it would be https://caiogomes.me/posts/here-you-will-place-the-slug-of-the-post/
category: gategory # The category of the post, it will be used to group posts in the same category. Not using for now
description: "Description of the post, it will be used in the meta description of the post"
draft: false
---

In this post we wil talk about lore ipsum blablabla

Just start the post here, it will be written in markdown. You can use the following as a template:


REFERENCE: https://wordpress.com/support/markdown-quick-reference/

<!-- Paragraphs and headers (if necessary) -->
# Header 1
lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nisl eget ultricies ultricies, nunc nisl ultricies nunc, quis ul

lore ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nisl eget ultricies ultricies, nunc nisl ultricies nunc, quis ul. lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nisl eget ultricies ultricies, nunc nisl ultricies nunc, quis ul

lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nisl eget ultricies ultricies, nunc nisl ultricies nunc, quis ul

## Header 2
lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nisl eget ultricies ultricies, nunc nisl ultricies nunc, quis ul

### Header 3

<!-- Make a link -->
[**GitHub actions**](https://docs.github.com/en/actions/quickstart)

<!-- Bold -->
**GitHub actions**

<!-- Italic -->
*GitHub actions*

<!-- Code -->
```yml
Here goes the code
```

<!-- Image -->
![Image description](images/image.png)

<!-- ordered list -->
1. Install Hugo in the machine that will build the app
2. Install de AWS CLI in order to upload the app to S3
3. Set the credentials in the machine so that it has access to the AWS account
4. Check out the repository
5. Run Hugo on the repository to build the app
6. Upload the files to S3
7. Optional. Invalidate the Cloufront distribution in case we are using it to cache the website.


<!-- 
Notes:

# Docker build in each environment

## Disadvantages

- Computed resources wasted in each environment, since the image is built repeatedly
- Risk of the image being different in each environment

## Advantages
- Easy to implement
- No need to worry with the promotion process, since the image is built in each environment

# Docker build in one environment and promote the image to the other environments

## Disadvantages
- Hard to implement
- A check process is necessary to promote the image between image repositories

## Advantages
- The image is guaranteed to be the same in all environments
- No resources wasted in each environment, since the image is built only once
- The image is built only once, so the process is faster and cheaper 

## Check process

- Verify with the build info in the image registry if the git branch is protected and is the default branch
- Verify status of the build in the CI pipeline (github actions workflow for instance)
-->