Gets `n` random elements at unique keys from collection up to the size of collection.


## Arguments
collection (Array|Object): The collection to sample.

[n=1] (number): The number of elements to sample.


## Returns
(Array): Returns the random elements.


## Example
```autohotkey
output := A.sampleSize([1, 2, 3], 2)
; => [3, 1]

output := A.sampleSize([1, 2, 3], 4)
; => [2, 3, 1]
```
