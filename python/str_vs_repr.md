# `__str__` vs `__repr__`

This two built-n magic methods (aka dunders - double underscores) are often confused by begginers, intermediate developers, but also by advanced devs.

First of all we have to say that this methods are not equivalent. The purpose of each is different. Let's have a look into official docs.

### Official documentation

[`__repr__`](https://docs.python.org/3/reference/datamodel.html#object.__repr__): 
> `object.__repr__(self)`
> Called by the `repr()` built-in function to compute the “official” string representation of an object. If at all possible, this should look like a valid Python expression that could be used to recreate an object with the same value (given an appropriate environment). If this is not possible, a string of the form `<...some useful description...>` should be returned. The return value must be a string object. If a class defines `__repr__()` but not `__str__()`, then `__repr__()` is also used when an “informal” string representation of instances of that class is required.
>
> This is typically used for debugging, so it is important that the representation is information-rich and unambiguous.

[`__str__`](https://docs.python.org/3/reference/datamodel.html#object.__str__): 
> object.__str__(self)
> Called by str(object) and the built-in functions format() and print() to compute the “informal” or nicely printable string representation of an object. The return value must be a string object.
> 
> This method differs from object.__repr__() in that there is no expectation that __str__() return a valid Python expression: a more convenient or concise representation can be used.
>
> The default implementation defined by the built-in type object calls object.__repr__().


### What does it mean?

As for `__repr__`: it should in be such a form that it could be evaluated as valid Python code. If this is not possible then it should be in form of a string that starts and ends with angled brackets (`<...>`). 

Mark Lutz in Learing Python also says that `__repr__` should be used as a way to display all revelant data in object when debugging in interactive mode. This happens when you state the instance variable directly in the shell like `>> my_instance` instead of calling `>> print(my_instance)` (which calls `__str__`).

`__repr__` should allow to recreate (create a copy of) an object when `eval(repr(obj))` is called or at least throw SyntaxError (caused by angled brackets) to prevent evaluating returned string. 

As for `__str__`: it should be in such a form that it would return string object and should contain convinient information about object.


### Examples
*Examples are based on Chapter 27 Learing Python, Forth Edition by Mark Lutz*

Let's say we have a class:
```python
class Person:
    def __init__(self, name, job, pay):
        self.name = name
        self.job = job 
        self.pay = pay
```
Below is the default behaviour of this object:
```python
In [1]: from str_and_repr import Person

In [2]: anna = Person('Anna', 'Python Developer', 10000)

In [3]: anna
Out[3]: <str_and_repr.Person at 0x7fad3d8ea2e0>

In [4]: print(anna)
<str_and_repr.Person object at 0x7fad3d8ea2e0>

In [5]: repr(anna)
Out[5]: '<str_and_repr.Person object at 0x7fad3d8ea2e0>'

In [6]: eval(repr(anna))
Traceback (most recent call last):

  File "/Library/Frameworks/Python.framework/Versions/3.9/lib/python3.9/site-packages/IPython/core/interactiveshell.py", line 3441, in run_code
    exec(code_obj, self.user_global_ns, self.user_ns)

  File "<ipython-input-6-a7cc71f00926>", line 1, in <module>
    eval(repr(anna))

  File "<string>", line 1
    <str_and_repr.Person object at 0x7fad3d8ea2e0>
    ^
SyntaxError: invalid syntax
```
Now, let's tweak around and overload method `__str__`
```python
def __str__(self):
    return f"<Person: {self.name}>"
```
And run the same instructions as previously:
```python
...
In [3]: anna
Out[3]: <str_and_repr.Person at 0x7fed62ff01f0>

In [4]: print(anna)
<Person: Anna>

In [5]: repr(anna)
Out[5]: '<str_and_repr.Person object at 0x7fed62ff01f0>'

In [6]: eval(repr(anna))
Traceback (most recent call last):

  File "/Library/Frameworks/Python.framework/Versions/3.9/lib/python3.9/site-packages/IPython/core/interactiveshell.py", line 3441, in run_code
    exec(code_obj, self.user_global_ns, self.user_ns)

  File "<ipython-input-7-a7cc71f00926>", line 1, in <module>
    eval(repr(anna))

  File "<string>", line 1
    <str_and_repr.Person object at 0x7fed62ff01f0>
    ^
SyntaxError: invalid syntax
```
Now, we see that output of line 4 is different, but nowhere else. This is expected.

Let's remove `__str__` method and overload `__repr__` instead, but it will return similar string to what `__str__` returned previously:
```python
def __repr__(self):
    return f"<Person: {self.name}>"
```
Again, with same instructions:
```python
...
In [3]: anna
Out[3]: <Person: Anna>

In [4]: print(anna)
<Person: Anna>

In [5]: repr(anna)
Out[5]: '<Person: Anna>'

In [6]: eval(repr(anna))
Traceback (most recent call last):

  File "/Library/Frameworks/Python.framework/Versions/3.9/lib/python3.9/site-packages/IPython/core/interactiveshell.py", line 3441, in run_code
    exec(code_obj, self.user_global_ns, self.user_ns)

  File "<ipython-input-6-a7cc71f00926>", line 1, in <module>
    eval(repr(anna))

  File "<string>", line 1
    <Person: Anna>
    ^
SyntaxError: invalid syntax
```
Now we see that line 3, 5 and 6 are different and this is expected since we changed `__repr__`. Line 4 is also different - this happens due to the fact that if method  `__str__` is not overloaded, by default it returns same thing as `__repr__` would.

So now we can implement `__str__` to return convinient information and `__repr__` to return all attributes for the sake of debuging.
```python
def __str__(self):
    return f"<Person: {self.name}>"

def __repr__(self):
    return f"<Person: {self.name}, {self.job}, {self.pay}>"
```
Output:
```python
...
In [3]: anna
Out[3]: <Person: Anna, Python Developer, 10000>

In [4]: print(anna)
<Person: Anna>

In [5]: repr(anna)
Out[5]: '<Person: Anna, Python Developer, 10000>'

In [6]: eval(repr(anna))
Traceback (most recent call last):

  File "/Library/Frameworks/Python.framework/Versions/3.9/lib/python3.9/site-packages/IPython/core/interactiveshell.py", line 3441, in run_code
    exec(code_obj, self.user_global_ns, self.user_ns)

  File "<ipython-input-6-a7cc71f00926>", line 1, in <module>
    eval(repr(anna))

  File "<string>", line 1
    <Person: Anna, Python Developer, 10000>
    ^
SyntaxError: invalid syntax
```
Now, this is more like it. But still we've got some issues with evaluating. For this to work, the string returned by `__repr__` must be a valid Python code that would create for us copy of our Person instance. We're writting it down just like we would instantiate object instance.
```python
def __repr__(self):
    return f"Person('{self.name}', '{self.job}', {self.pay})"
```
Instructions as previously, with a few new ones:
```python
In [1]: from str_and_repr import Person

In [2]: anna = Person('Anna', 'Python Developer', 10000)

In [3]: anna
Out[3]: Person('Anna', 'Python Developer', 10000)

In [4]: print(anna)
<Person: Anna>

In [5]: repr(anna)
Out[5]: "Person('Anna', 'Python Developer', 10000)"

In [6]: eval(repr(anna))
Out[6]: Person('Anna', 'Python Developer', 10000)

# something new below
In [7]: anna2 = eval(repr(anna))

In [8]: anna2
Out[8]: Person('Anna', 'Python Developer', 10000)

In [9]: anna2 == anna
Out[9]: False

In [10]: anna2 is anna
Out[10]: False

In [11]: id(anna2) == id(anna)
Out[11]: False

In [12]: anna2.name = 'Anna Karenina'

In [13]: anna2.name
Out[13]: 'Anna Karenina'

In [14]: anna.name
Out[14]: 'Anna'
```

### Conclusion
`__str__` and `__repr__` are very convinient methods. Both can be used to provide usefull information for user and developer during runtime and in interactive mode. Great power and responsibility of `__repr__` is often forgotten and misunderstood. Correct usage of this method can provide very smart way to create a copy of an object. Depending on types and representations of its attributes it can be limited, but creating more generic implementation of `__repr__` can solve that problem.

### More generic `__repr__`
The solution below provides more generic implementation. The limitations are unknown, but it seems to be working for nested objects.
```python
def __repr__(self):
        return f"{self.__class__.__name__}(**{self.__dict__})"
```
Example:
```python
class Person:
    def __init__(self, name, job, pay, books):
        self.name = name
        self.job = job 
        self.pay = pay
        self.books = books

    def __str__(self):
        return f"<Person: {self.name}>"

    def __repr__(self):
        return f"{self.__class__.__name__}(**{self.__dict__})"

class Book:
    def __init__(self, title, author):
        self.title = title
        self.author = author

    def __str__(self):
        return f"<Book: {self.title}>"

    def __repr__(self):
        return f"{self.__class__.__name__}(**{self.__dict__})"
    

if __name__ == '__main__':
    b = Book('Anne of Green Gables', 'Lucy Montgomery')
    p = Person('Anna', 'developer', 1000, [b])
    p2 = eval(repr(p))
    assert p != p2
    b2 = p2.books[0]
    assert b != b2
```


### Sorces 
- https://docs.python.org/3/reference/datamodel.html#object.__repr__
- https://docs.python.org/3/reference/datamodel.html#object.__str__
- https://stackoverflow.com/questions/20996445/how-to-use-repr-to-create-new-object-from-it
