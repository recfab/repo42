---
id: 20211216161646
created: 2021-12-16T16:16:46-0800
modified: 2021-12-16T16:16:46-0800
---
# Sieve of Aristophanes

- Generates prime numbers up to a given limit
- TODO fill out this note

```python
def sieve(n):
  not_prime = []
  for i in range(2, n + 1):
    if i not in not_prime:
      print(i)
      for j in range(i * i, n + 1, i):
        not_prime.append(j)
```
