---
title: "Using a bash script with sed to clean data"
layout: "categories"
date: 3020-08-21T23:15:00+07:00
slug: bash-sed
category: bash
description: "A post explaining the basics of sed to clean flat files before importing them to a database"
draft: false
---

After creating a database the first things you will do with it are creating the schema (tables, relationships, indexes, etc) and importing data.
One of the options for importing data is to import it from a flat file like txt, csv, tsv, etc. I'm developing an API now and when I imported data
from a tsv (tab separated values) file Postgresql started to give errors like this in several lines:

```bash
128190:23: actual: ": A Short Film", expected: value separator (\t)
```

Inspecting the lines from the tsv file with grep they all had the same pattern:

```bash
tt0294236	short 'Arry and Arriet's Evening Out	'Arry and 'Arriet's Evening Out	0	1909	Comedy
```

All the lines that had a word starting with single quotes, like *'Arry and Arriet's Evening Out*, or double quotes
were showing errors, as the importer was trying to find a tab and mistakingly assuming the quotes were the separation between values and not the tab. So,
in order to import the data I had to clean it before, removing single quotes from the start of values, which has no value for the API, and
all double quotes, since the values are already strings they have no value as well. To clean it I've used
*Sed*.

Sed is a stream editor in bash, what it means is it can perform editing operations on text coming from standard input or a file, like insertion, deleting,
find and replacing, etc, so it's really useful to clean data from files. The use case here is to find the data I don't want and replace it.

Let's work with two real case here, the lines are these ones:

```bash
tt0294236	short	'Arry and Arriet's Evening Out	'Arry and 'Arriet's Evening Out	0	1909	Comedy
```

```bash
tt9913170	tvEpisode	"American Gods"	"American Gods"	0	2019	Talk-Show
```

On the first one we will have to remove the single quote from the value's start and on the second we will have to remove all the double quotes.
The result has to be this:

```bash
tt0294236	short	Arry and Arriet's Evening Out	Arry and 'Arriet's Evening Out	0	1909	Comedy
```

```bash
tt9913170 tvEpisode	American Gods     American Gods	0	2019	Talk-Show
```

Sed uses regular expressions to find the data we want to replace, a simple table showing some of the patters would be this:

|  Pattern  |  Use case     | 
| ----------| ------------- | 
|     .     |      Matches any character, including newline  |
|     ^     |      Matches the null string at beginning of the pattern space, i.e. what appears after the circumflex must appear at the beginning of the pattern space |
|     $     |      It is the same as ^, but refers to end of pattern space     | 
|     \     |      Used to escape (use) invalid characters in strings     |

With these pattern you can do a lot of different stuff. We wil start from the basics here and do a simple find and replace.
You need to save both lines with the quotes from above in a file, it can be called with-quotes.txt.

One example of how Sed works for replacement would be this:

```bash
sed -i 's/"what I want to replace"/"what I will use for as replacement"/g' file.txt
```

Explaining each part, we have *sed* which is the command we are using, *-i* means I'll do the work on the current file (inline) and not produce the results on another file, *s/* for substitution, *"what I want to replace"* is the pattern of what I want to remove,
*"what I will use for as replacement"*, is what I'll use for substitution at the places I have removed the characters,
*/g* is for global, so I'll do the substitution on all the cases and not just the first in each line and
*file.txt* is the file we will do the work on.

So, translating for double quotes removal, which is one of the patterns we want, we have this:

```bash
sed -i 's/"//g' with-quotes.txt
```
Following the explanation I gave before, this will replace double quotes with nothing, so we are halfway to our goal, which is removing double
quotes and single quotes at the start of values, and the with-quotes.txt should be like this:

```bash
tt0294236	short	'Arry and Arriet's Evening Out	'Arry and 'Arriet's Evening Out	0	1909	Comedy
tt9913170	tvEpisode	American Gods	American Gods	0	2019	Talk-Show
```

Now we have to remove the single at the start of values. As the values are separated by tabs, all the starting values are preceded by tabs,
in which case all starting single quotes will have the following pattern: *\t*. The *\t* means the tab. We will replace this pattern with a tab only, and then we will have only the tab remaining and the single quote will disappear.

For this case we should use this command:

```bash
sed -i "s/\t'/\t/g" with-quotes.txt
```

And then we have clean data:

```bash
 tt0294236	short	Arry and Arriet's Evening Out	Arry and 'Arriet's Evening Out	0	1909	Comedy

 tt9913170	tvEpisode	American Gods	American Gods	0	2019	Talk-Show
```
As I have several files that have to be cleaned, it makes sense to have a bash script that does the job instead of running these command in each file.
The bash script that will do the job is this one:

```bash
    #!/bin/bash
    echo "Type the file name in the current directory you want to clean"
    read filename

    echo "Cleaning double quotes"
    command_out=$(sed -i -e 's/"//g' ./$filename)
    echo $command_out
    
    echo "Cleaning phrases starting with single quotes"
    command_out=$(sed -i -e "s/\t'/\t/g" ./$filename)
    echo $command_out

    echo "Done!"
```

And then we can run these sed command or eventually other commands we have to use to clean the data in one step
