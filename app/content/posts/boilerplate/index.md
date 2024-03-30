---
title: "Here you will place the title of the post"
date: 2040-01-15T11:18:00-03:00
slug: "here-you-will-place-the-slug-of-the-post" # The unique identifier of the post in the URL, if you place a new slug the URL will change, i this case it would be https://caiogomes.me/posts/here-you-will-place-the-slug-of-the-post/
category: gategory # The category of the post, it will be used to group posts in the same category. Not using for now
description: "Description of the post, it will be used in the meta description of the post"
draft: false
---

Describe here about the post

In this post we wil talk about lore ipsum blablabla

Just start the post here, it will be written in markdown. You can use the following as a template:

REFERENCE: https://wordpress.com/support/markdown-quick-reference/

<!-- Paragraphs and headers (if necessary) -->
## First header 1 (I'm starting usually with ##)
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
