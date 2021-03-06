partition(param_collection,param_predicate) {
	if (!IsObject(param_collection)) {
		this.internal_ThrowException()
	}
	
	; data setup
	trueArray := []
	falseArray := []
	shorthand := this.internal_differenciateShorthand(param_predicate, param_collection)
	if (shorthand != false) {
		BoundFunc := this.internal_createShorthandfn(param_predicate, param_collection)
	}
	for Key, Value in param_collection {
		if (!this.isUndefined(param_predicate.call(Value))) {
			BoundFunc := param_predicate.bind()
		}
		break
	}

	; perform the action
	for Key, Value in param_collection {
		if (BoundFunc.call(Value) == true) {
			trueArray.push(Value)
		} else {
			falseArray.push(Value)
		}
	}
	return [trueArray, falseArray]
}


; tests
users := [ { "user": "barney", "age": 36, "active": false }
	, { "user": "fred", "age": 40, "active": true }
	, { "user": "pebbles", "age": 1, "active": false } ]

assert.test(A.partition(users, func("partitionfunction1")), [[{ "user": "fred", "age": 40, "active": true }], [{ "user": "barney", "age": 36, "active": false }, { "user": "pebbles", "age": 1, "active": false }]])
partitionfunction1(o) {
	return o.active
}

; The A.matches iteratee shorthand.
assert.test(A.partition(users, {"age": 1, "active": false}), [[{ "user": "pebbles", "age": 1, "active": false }], [{ "user": "barney", "age": 36, "active": false }, { "user": "fred", "age": 40, "active": true }]])

; The A.propertyMatches iteratee shorthand.
assert.test(A.partition(users, ["active", false]), [[{ "user": "barney", "age": 36, "active": false }, { "user": "pebbles", "age": 1, "active": false }] ,[{ "user": "fred", "age": 40, "active": true }]])

; The A.property iteratee shorthand.
assert.test(A.partition(users, "active"), [[{ "user": "fred", "age": 40, "active": true }], [{ "user": "barney", "age": 36, "active": false }, { "user": "pebbles", "age": 1, "active": false }]])
