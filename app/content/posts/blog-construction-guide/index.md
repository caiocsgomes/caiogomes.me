---
title: "Building a blog using AWS (infra), Hugo (app) and Github Actions (CI/CD)"
date: 2040-01-15T11:18:00-03:00
slug: "blog-construction-guide"
category: AWS
description: "This post explains step by step how to build a blog using AWS (infra), Hugo (app) and Github Actions (CI/CD)"
draft: false
---

Today one of the best ways to build a blog is using a static site generator. There are many options out there, but I chose Hugo because it is written in Go, it is fast and it is easy to use. I also chose AWS to host the blog because I am familiar with it and it is cheap. I chose Github Actions to build and deploy the blog because it is free and it is easy to use.

In this post we will go through the steps to build a blog using Hugo, AWS and Github Actions. We will split it into three parts, the app, the infra and the CI/CD.

# Application

[**Hugo**](https://gohugo.io/) is a *static website generator* that converts *Markdown* files (the .md files) into websites. This way instead of writing in HTML we can write in Markdown that is pretty easier. Another advantage of Hugo is that we can use [*themes*](https://themes.gohugo.io/), which are premade websites with structure and css already incorporated into it. This way we don't need to worry with style since we are able to use one of the themes in our project. This blog is built with Hugo and uses the [PaperMod](https://themes.gohugo.io/themes/hugo-papermod/) theme, so when I need to write something on it I just write Markdown and run Hugo on it to create the website (HTML+CSS+JS).

## Installing hugo

To install Hugo we can follow the [official documentation](https://gohugo.io/getting-started/installing/). 

## Creating a new Hugo project

To create a new Hugo project we can follow the [official documentation](https://gohugo.io/getting-started/quick-start/). The command to create a new project is which is a folder with the name of the project and a specific [directory structure](https://gohugo.io/getting-started/directory-structure/)

```bash
# Create a new project
hugo new site <project-name>
```

The project configuration is in the *config.toml* file. In this file we can set the theme we want to use, the title of the website, the description, the language, etc. The *config.toml* file is the main configuration file of the project.

## Installing a theme

# Infrastructure

# CI/CD