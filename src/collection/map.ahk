map(param_collection,param_iteratee) {
    if (!IsObject(param_collection)) {
        throw { error: "Type Error", file: A_LineFile, line: A_LineNumber }
    }
    l_array := []
    ; check what kind of param_iteratee being worked with
    if (IsFunc(param_iteratee)) {
        BoundFunc := param_iteratee.Bind(this)
    } else {
        BoundFunc := false
    }

    ; run against every value in the collection
    for Key, Value in param_collection {
        if (!BoundFunc) { ; is property/string
            vReturn := param_collection[A_Index][param_iteratee]
            l_array.push(vReturn)
            continue
        }
        vReturn := BoundFunc.Call(Value)
        if (vReturn) {
            l_array.push(vReturn)
        } else {
            l_array.push(param_iteratee.Call(Value))
        }
    }
    return l_array
}


; tests
square(n) {
  return % n * n
}

assert.test(A.map([4,8],Func("square")),[16, 64])
assert.test(A.map({ "a": 4, "b": 8 },Func("square")),[16, 64])

users := [{ "user": "barney" }, { "user": "fred" }]
assert.test(A.map(users,"user"),["barney","fred"])
