---
title: "Writing more pythonic code"
date: 2021-05-02T23:15:00+07:00
slug: python-pythonic
category: python
description: "Tips about writing cleaner code in python using its resources for a more pythonic approach"
draft: false
---


If you like me started programming with a c-style language, like c, c++, c#, java, etc, you probably have a way to handle problems in
code that resemble these languages. While this is not a problem, one of the best strengths of python is its readability and simplicity.
Python provide several instruments, like using *range* function to iterate over for loops, list comprehension
to generate lists instead of the traditional for loop approach, lambda functions, f-strings to improve string formatting, etc, to improve
readability and make code clearer.
So, what do I mean by pythonic code? From [stackoverflow](https://stackoverflow.com/questions/25011078/what-does-pythonic-mean#:~:text=Loading%20when%20this%20answer%20was,is%20intended%20to%20be%20used).


> Exploiting the features of the Python language to produce code that is clear, concise and maintainable.

> Pythonic means code that doesn't just get the syntax right but that follows the conventions of the Python community and uses the language in the way it is intended to be used."

So in this post I'll describe a series of python features and idioms that make code, elegant and more readable. As I'm always studying python
and always learning something new while coding, this will be an ever changing list.

## 1. List Comprehensions

Python offer several ways of creating lists. The most obvious way of creating them, if you already code in another language, is
creating an empty list and appending the values you want in it. Usually for this you do some loop and in each iteration you append
data to the list. Python has a more readable way to do this and it's called list comprehension.

Let's say you have a dictionary, with people and their number.

```python
    people_list = [
        {
            'name': 'caio',
            'phone': '9908-9908'
        },
        {
            'name': 'thais',
            'phone': '9909-9909'
        },
        {
            'name': 'john',
            'phone': '9910-9910'
        },
        {
            'name': 'jane',
            'phone': '9911-9911'
        }
    ]
```

Let's say you want only their numbers in a list so you can do an automation to call them. What's the first thought? Well, we can create an empty
list, iterate over the values and in each iteration we add the number.

```python
    phone_list = []

    for people in people_list:
        phone_list.append(people['phone'])
    # print(phone_list) -> ['9908-9908', '9909-9909', '9910-9910']
```

The pythonic way to solve this would be list comprehension that takes the following form.

```python
    new_list = [expression for item in list]
```

The expression can be any function or statement that will be applied in each item. For the example above we would have:

```python
    phone_list = [people['phone'] for people in people_list]
    # print(phone_list) -> ['9908-9908', '9909-9909', '9910-9910']
```

## 2. Swap variables

When swapping two variables.

```python
    name1 = 'caio'
    name2 = 'thais'
```

Instead of this:

```python
    temp_var = name1
    name1 = name2
    name2 = temp_var

    # print(name1, name2) -> thais caio
```
            
Do this:
```python
    name1, name2 = name2, name1

    # print(name1, name2) -> thais caio
```


## 3. Use f-strings to format strings</h2>

Before python version 3.6 the common way to format strings was the *format()* method from the *str* class.
So let's say you had some user data and wanted to create a description phrase.

```python
    name = 'eric'
    age = 34
    city = 'são paulo'
```
        <p class="my-6">
            You had to use the <span class="italic">format()</span> method.
        </p>
```python
    description_prhase = "{} is {} and lives in {}".format(name, age, city)
    # print(description_prhase) -> 'eric is 34 and lives in são paulo'
```

While the *format()* seems fine, think if you had 10 words to insert in the phrase. This would start to get messy
and you'd have a hard time verifying where each variable is placed. Using f-strings we would have this:

```python
    description_phrase = f'{name} is {age} and lives in {city}'
    # print(description_prhase) -> 'eric is 34 and lives in são paulo'
```

That's more organized and we don't have to search where each word is inserted, because they are already in-place. Another cool thing is
f-strings are evaluated at runtime. This means we can use expressions and functions as well inside strings.

```python
    description_phrase = f'{name.upper()} is {age} and lives in {city.upper()}'
    # print(description_prhase) -> 'ERIC is 34 and lives in SÃO PAULO'
```


## 4. Don't use list comprehensions for its side effects

List comprehensions should be used with caution, since they can make you code harder to understand and more bloated.

There is a great book called *Fluent Python by Luciano Ramalho that explains in details when to,
and when not to, use list comprehensions. In a summary, you want to use them when you are creating list, and not when you want side
its effects, like executing functions in a loop.

If you have a list of names

```python
    names = ['caio', 'thais', 'vinicius', 'valkiria']
```

And you want to print them, this is a a bad approach:

```python
    [print(name) for name in name]
```

It makes your code harder to understand and list comprehensions are used to create lists. The example it's not creating
a list but executing a function in a for loop. The right approach would be the good and clear for loop:

```python
    for name in names:
        print(name)
```

