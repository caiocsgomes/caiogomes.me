---
title: "The basics of Github Actions"
date: 2023-01-22T22:00:00-03:00
slug: gha-notes
category: github-actions
description: "A summary of Github Actions"
draft: false
---

# Notes about Github Actions

This is a summary about the main features of Github Actions and a way to speep up its use when necessary. I'll go over the features, with examples, that are most used in any pipeline and provide links to the documentation if a deep dive is necessary. This will probably be enough for most pipelines.

## GitHub Actions

[**GitHub actions**](https://docs.github.com/en/actions/quickstart) is an automation service that allows us to automate all kinds of repository related processes and actions. Using GitHub Actions we provide GitHub with a *yml* file describing our *workflow* in *steps*, and it will run the workflow based on an *event* that can be a *push*. This way everytime we make a push to the repository it will run the actions described in the yml file with our repository. This is perfect to build **CI/CD** pipelines.

## Basic components
### Workflows
### Jobs
### Steps
### Actions
### Runner

## Events
### Filters
### Activity types

## Context objects

## Uploading and downloading artifacts

## Caching

## Environmental variables

## Secrets

## Conditional workflows

