class biga {	; class attributes	static throwExceptions := true	static limit := -1	chunk(param_array,param_size:=1) {
		if (!IsObject(param_array)) {
			this.internal_ThrowException()
		}
		l_array := []
		param_array := this.clone(param_array)

		; keep working till the parameter array is empty
		while (this.size(param_array) > 0) {
			l_InnerArr := []
			; fill the Inner Array to the max size of the size parameter
			loop, % param_size {
				; exit loop if there is nothing left in parameter array to work with
				if (this.size(param_array) == 0) {
					break
				}
				l_InnerArr.push(param_array.RemoveAt(1))
			}
		l_array.push(l_InnerArr)
		}
		return l_array
	}
	compact(param_array) {
		if (!IsObject(param_array)) {
			this.internal_ThrowException()
		}
		l_array := []

		for Key, Value in param_array {
			if (Value != "" && Value != 0 && Value != false) {
				l_array.push(Value)
			}
		}
		return l_array
	}
	concat(param_array,param_values*) {
		if (!IsObject(param_array)) {
			this.internal_ThrowException()
		}
		; data preparation
		l_array := this.clone(param_array)

		; create the return
		for index, object in param_values {
			; push on any plain values
			if (!IsObject(object)) {
				l_array.push(object)
			} else { ;push object values 1 level deep
				for index2, object2 in object {
					l_array.push(object2)
				}
			}
		}
		return l_array
	}
	difference(param_array,param_values*) {
		if (!IsObject(param_array)) {
			this.internal_ThrowException()
		}
		l_array := this.clone(param_array)

		; loop all Variadic inputs
		for i, obj in param_values {
			loop, % obj.Count() {
				foundIndex := this.indexOf(l_array, obj[A_Index])
				if (foundIndex != -1) {
					l_array.RemoveAt(foundIndex)
				}
			}
		}
		return l_array
	}
	drop(param_array,param_n:=1) {
		if param_n is not number
		{
			this.internal_ThrowException()
		}

		if (IsObject(param_array)) {
			l_array := this.clone(param_array)
		}
		if (param_array is alnum) {
			l_array := StrSplit(param_array)
		}

		; create the slice
		loop, % param_n
		{
			l_array.RemoveAt(1)
		}
		; return empty array if empty
		if (l_array.Count() == 0) {
			return []
		}
		return l_array
	}
	dropRight(param_array,param_n:=1) {
		if param_n is not number 
		{
			this.internal_ThrowException()
		}

		if (IsObject(param_array)) {
			l_array := this.clone(param_array)
		}
		if (param_array is alnum) {
			l_array := StrSplit(param_array)
		}

		; create the slice
		loop, % param_n
		{
			l_array.RemoveAt(l_array.Count())
		}
		; return empty array if empty
		if (l_array.Count() == 0) {
			return []
		}
		return l_array
	}
	fill(param_array,param_value:="",param_start:=1,param_end:=-1) {
		if (!IsObject(param_array)) {
			this.internal_ThrowException()
		}

		; prepare data
		l_array := this.clone(param_array)
		if (param_end == -1) {
			param_end := this.size(param_array)
		}

		; create the array
		for Key, Value in l_array {
			if (Key >= param_start && Key <= param_end) {
				l_array[Key] := param_value
			}
		}
		return l_array
	}
	findIndex(param_array,param_value,fromIndex:=1) {
		if (!IsObject(param_array)) {
			this.internal_ThrowException()
		}

		; data setup
		shorthand := this.internal_differenciateShorthand(param_value, param_array)
		if (shorthand != false) {
			BoundFunc := this.internal_createShorthandfn(param_value, param_array)
		}
		if (IsFunc(param_value)) {
			BoundFunc := param_value
		}
		if (IsObject(param_value) && !IsFunc(param_value)) { ; do not convert objects that are functions
			vSearchingobjects := true
			param_value := this.printObj(param_value)
		}

		; create the return
		for Index, Value in param_array {
			if (Index < fromIndex) {
				continue
			}

			if (shorthand == ".matchesProperty" || shorthand == ".property") {
				if (BoundFunc.call(param_array[Index]) == true) {
					return Index
				}
			}
			if (vSearchingobjects) {
				Value := this.printObj(param_array[Index])
			}
			if (IsFunc(BoundFunc)) {
				if (BoundFunc.call(param_array[Index]) == true) {
					return Index
				}
			}
			if (this.isEqual(Value, param_value)) {
				return Index
			}
		}
		return -1
	}
	findLastIndex(param_array,param_value,fromIndex:=1) {
		if (!IsObject(param_array)) {
			this.internal_ThrowException()
		}

		; create the return
		l_array := this.reverse(this.cloneDeep(param_array))
		l_count := this.size(l_array)
		l_foundIndex := this.findIndex(l_array, param_value, fromIndex)

		if (l_foundIndex < 0) {
			return -1
		} else {
			finalIndex := l_count + 1
			finalIndex := finalIndex - l_foundIndex
		}
		return finalIndex
	}
	flatten(param_array) {
		if (!IsObject(param_array)) {
			this.internal_ThrowException()
		}

		; data setup
		l_obj := []

		; create the return
		for Index, Object in param_array {
			if (IsObject(Object)) {
				for Index2, Object2 in Object {
					l_obj.push(Object2)
				}
			} else {
				l_obj.push(Object)
			}
		}
		return l_obj
	}
	flattenDeep(param_array) {
		if (!IsObject(param_array)) {
			this.internal_ThrowException()
		}

		; data setup
		l_depth := this.depthOf(param_array)

		; create the return
		return this.flattenDepth(param_array, l_depth)

	}

	depthOf(param_obj,param_depth:=1) {
		for Key, Value in param_obj {
			if (IsObject(Value)) {
				param_depth++
				param_depth := this.depthOf(Value, param_depth)
			}
		}
		return param_depth
	}
	flattenDepth(param_array,param_depth:=1) {
		if (!IsObject(param_array)) {
			this.internal_ThrowException()
		}

		; data setup
		l_obj := this.cloneDeep(param_array)

		; create the return
		loop, % param_depth {
			l_obj := this.flatten(l_obj)
		}
		return l_obj
	}
	fromPairs(param_pairs) {
		if (!IsObject(param_pairs)) {
			this.internal_ThrowException()
		}

		l_obj := {}
		for Key, Value in param_pairs {
			l_obj[Value[1]] := Value[2]
		}
		return l_obj
	}
	head(param_array) {

		return this.take(param_array)[1]
	}
	indexOf(param_array,param_value,fromIndex:=1) {
		 if (!IsObject(param_array)) {
			  this.internal_ThrowException()
		 }

		 for Index, Value in param_array {
			  if (Index < fromIndex) {
					continue
			  }
			  if (this.isEqual(Value, param_value)) {
					return Index
			  }
		 }
		 return -1
	}
	initial(param_array,param_n:=1) {
		if param_n is not number
		{
			this.internal_ThrowException()
		}

		; prepare data
		if (IsObject(param_array)) {
			l_array := this.clone(param_array)
		}
		if (param_array is alnum) {
			l_array := StrSplit(param_array)
		}

		; create the slice
		loop, % param_n
		{
			l_array.RemoveAt(l_array.Count())
		}
		; return empty array if empty
		if (l_array.Count() == 0) {
			return []
		}
		return l_array
	}
	intersection(param_arrays*) {
		if (!IsObject(param_arrays)) {
			this.internal_ThrowException()
		}

		; prepare data
		tempArray := A.cloneDeep(param_arrays[1])
		l_array := []

		; create the slice
		for Key, Value in tempArray { ;for each value in first array
			for Key2, Value2 in param_arrays { ;for each array sent to the method
				; search entire array for value in first array
				if (this.indexOf(Value2, Value) != -1) {
					found := true
				} else {
					found := false
				}
			}
			if (found) {
				l_array.push(Value)
			}
		}
		return l_array
	}
	join(param_array,param_sepatator:=",") {
		if (!IsObject(param_array) || IsObject(param_sepatator)) {
			this.internal_ThrowException()
		}

		; create the return
		l_array := this.clone(param_array)
		loop, % l_array.Count() {
			if (A_Index == 1) {
				l_string := "" l_array[A_Index]
				continue
			}
			l_string := l_string param_sepatator l_array[A_Index]
		}
		return l_string
	}
	lastIndexOf(param_array,param_value,param_fromIndex:=0) {
		if (param_fromIndex == 0) {
			param_fromIndex := param_array.Count()
		}
		for Index, Value in param_array {
			Index -= 1
			vNegativeIndex := param_array.Count() - Index
			if (vNegativeIndex > param_fromIndex) { ;skip search
				continue
			}
			if (this.isEqual(param_array[vNegativeIndex], param_value)) {
				return vNegativeIndex 
			}
		}
		return -1
	}
	nth(param_array,param_n:=1) {
		if param_n is not number
		{
			this.internal_ThrowException()
		}

		if (IsObject(param_array)) {
			l_array := this.clone(param_array)
		}
		if (param_array is alnum) {
			l_array := StrSplit(param_array)
		}
		if (param_n == 0) {
			param_n := 1
		}

		; create the slice
		if (l_array.Count() < param_n) { ;return "" if n is greater than the array's size
			return ""
		}
		if (param_n > 0) {
			return l_array[param_n]
		}
		; return empty array if empty
		if (l_array.Count() == 0) {
			return ""
		}
		; if called with negative n, call self with reversed array and positive number
		l_array := this.reverse(l_array)
		param_n := 0 - param_n
		return this.nth(l_array, param_n)
	}
	reverse(param_collection) {
		if (!IsObject(param_collection)) {
			this.internal_ThrowException()
		}
		l_array := []
		while (param_collection.Count() != 0) {
			l_array.push(param_collection.pop())
		}
		return l_array
	}
	slice(param_array,param_start:=1,param_end:=0) {
		if param_start is not number
		{
			this.internal_ThrowException()
		}
		if param_end is not number
		{
			this.internal_ThrowException()
		}

		; defaults
		if (param_array is alnum) {
			param_array := this.split(param_array, "")
		}
		if (param_end == 0) {
			param_end := param_array.Count()
		}

		l_array := []

		; create the slice
		for Key, Value in param_array {
			if (A_Index >= param_start && A_Index <= param_end) {
				l_array.push(Value)
			}
		}
		return l_array
	}
	sortedIndex(param_array,param_value) {
		if (param_value < param_array[1]) {
			return 1
		}
		loop, % param_array.Count() {
			if (param_array[A_Index] < param_value && param_value < param_array[A_Index+1]) {
				return A_Index + 1
			}
		}
		return param_array.Count() + 1
	}
	tail(param_array) {

		return this.drop(param_array)
	}
	take(param_array,param_n:=1) {
		if param_n is not number 
		{
			this.internal_ThrowException()
		}

		if (IsObject(param_array)) {
			param_array := this.clone(param_array)
		}
		if (param_array is alnum) {
			param_array := StrSplit(param_array)
		}
		l_array := []

		; create the slice
		loop, % param_n
		{
			;continue if requested index is higher than param_array can account for
			if (param_array.Count() < A_Index) {
				continue
			}
			l_array.push(param_array[A_Index])
		}
		; return empty array if empty
		if (l_array.Count() == 0 || param_n == 0) {
			return []
		}
		return l_array
	}
	takeRight(param_array,param_n:=1) {
		if param_n is not number 
		{
			this.internal_ThrowException()
		}

		if (IsObject(param_array)) {
			param_array := this.clone(param_array)
		}
		if (param_array is alnum) {
			param_array := StrSplit(param_array)
		}
		l_array := []

		; create the slice
		loop, % param_n
		{
			if (param_array.Count() == 0) {
				continue
			}
			vValue := param_array.pop()
			l_array.push(vValue)
		}
		; return empty array if empty
		if (l_array.Count() == 0 || param_n == 0) {
			return []
		}
		return this.reverse(l_array)
	}
	union(param_arrays*) {

		l_array := []
		for Key, Array in param_arrays {
			if (IsObject(Array)) {
				l_array := this.concat(l_array, Array)
			} else {
				l_array.push(Array)
			}
		}
		return this.uniq(l_array)
	}
	uniq(param_collection) {
		if (!IsObject(param_collection)) {
			this.internal_ThrowException()
		}

		; prepare data
		tempArray := []
		l_array := []

		; create the slice
		for Key, Value in param_collection {
			printedelement := this.internal_MD5(this.printObj(param_collection[Key]))
			if (this.indexOf(tempArray, printedelement) == -1) {
				tempArray.push(printedelement)
				l_array[Key] := Value
			}
		}
		return l_array
	}
	without(param_array,param_values*) {
		if (!IsObject(param_array)) {
			this.internal_ThrowException()
		}
		l_array := this.clone(param_array)

		; loop all Variadic inputs
		for i, val in param_values {
			while (foundindex := this.indexOf(l_array, val) != -1) {
				l_array.RemoveAt(foundindex)
			}
		}
		return l_array
	}
	zip(param_arrays*) {
		if (!IsObject(param_arrays)) {
			this.internal_ThrowException()
		}
		l_array := []

		; loop all Variadic inputs
		for Key, Value in param_arrays {
			; for each value in the supplied set of array(s)
			for Key2, Value2 in Value {
				loop, % Value.Count() {
					if (Key2 == A_Index) {
						; create array if not encountered yet
						if (IsObject(l_array[A_Index]) == false) {
							l_array[A_Index] := []
						}
						; push values onto the array for their position in the supplied arrays
						l_array[A_Index].push(Value2)
					}
				}
			}
		}
		return l_array
	}
	zipObject(param_props,param_values) {
		if (!IsObject(param_props)) {
			param_props := []
		}
		if (!IsObject(param_values)) {
			param_values := []
		}

		l_obj := {}
		for Key, Value in param_props {
			vValue := param_values[A_Index]
			l_obj[Value] := vValue
		}
		return l_obj
	}
	every(param_collection,param_predicate) {
		if (!IsObject(param_collection)) {
			this.internal_ThrowException()
		}

		; data setup
		l_array := []
		shorthand := this.internal_differenciateShorthand(param_predicate, param_collection)
		if (shorthand != false) {
			boundFunc := this.internal_createShorthandfn(param_predicate, param_collection)
		}
		for Key, Value in param_collection {
			if (!this.isUndefined(param_predicate.call(Value))) {
				boundFunc := param_predicate.bind()
			}
			break
		}

		; perform the action
		for Key, Value in param_collection {
			; msgbox, % "value is " this.printObj(Value)
			if (shorthand != false) {
				if (boundFunc.call(Value, Key, param_collection) == true) {
					continue
				}
				return false
			}
			if (param_predicate.call(Value, Key, param_collection) == true) {
				continue
			}
		}
		return true
	}
	filter(param_collection,param_predicate) {
		if (!IsObject(param_collection)) {
			this.internal_ThrowException()
		}

		; data setup
		shorthand := this.internal_differenciateShorthand(param_predicate, param_collection)
		if (shorthand != false) {
			boundFunc := this.internal_createShorthandfn(param_predicate, param_collection)
		}
		l_array := []

		; create the slice
		for Key, Value in param_collection {
			; functor
			if (IsFunc(param_predicate)) {
				if (param_predicate.call(Value)) {
					l_array.push(Value)
				}
				continue
			}
			; predefined !functor handling (slower as it .calls blindly)
			vValue := param_predicate.call(Value)
			if (vValue) {
				l_array.push(Value)
				continue
			}
			; shorthand
			if (shorthand != false) {
				if (boundFunc.call(Value)) {
					l_array.push(Value)
				}
				continue
			}
		}
		return l_array
	}
	find(param_collection,param_predicate,param_fromindex:=1) {
		if (!IsObject(param_collection)) {
			this.internal_ThrowException()
		}

		; data setup
		shorthand := this.internal_differenciateShorthand(param_predicate, param_collection)
		if (shorthand != false) {
			boundFunc := this.internal_createShorthandfn(param_predicate, param_collection)
		}

		; perform
		for Key, Value in param_collection {
			if (param_fromindex > A_Index) {
				continue
			}
			; regular function
			if (IsFunc(param_predicate)) {
				if (param_predicate.call(Value)) {
					return Value
				}
				continue
			}
			; undeteriminable functor
			if (param_predicate.call(Value)) {
				return Value
			}
			; shorthand
			if (shorthand) {
				if (boundFunc.call(Value)) {
					return Value
				}
				continue
			}
		}
		return false
	}
	forEach(param_collection,param_iteratee:="__identity") {
	    if (!IsObject(param_collection)) {
	        this.internal_ThrowException()
	    }
	    ; check what kind of param_iteratee being worked with
	    if (!IsFunc(param_iteratee)) {
	        BoundFunc := param_iteratee.Bind(this)
	    }

	    ; prepare data
	    l_paramAmmount := param_iteratee.MaxParams
	    if (l_paramAmmount == 3) {
	        collectionClone := this.cloneDeep(param_collection)
	    }

	    ; run against every value in the collection
	    for Key, Value in param_collection {
	        if (!BoundFunc) { ; is property/string
	            ;nothing currently
	        }
	        if (l_paramAmmount == 3) {
	            if (!BoundFunc.call(Value, Key, collectionClone)) {
	                vIteratee := param_iteratee.call(Value, Key, collectionClone)
	            }
	        }
	        if (l_paramAmmount == 2) {
	            if (!BoundFunc.call(Value, Key)) {
	                vIteratee := param_iteratee.call(Value, Key)
	            }
	        }
	        if (l_paramAmmount == 1) {
	            if (!BoundFunc.call(Value)) {
	                vIteratee := param_iteratee.call(Value)
	            }
	        }
	        ; exit iteration early by explicitly returning false
	        if (vIteratee == false) {
	            return param_collection
	        }
	    }
	    return param_collection
	}
	includes(param_collection,param_value,param_fromIndex:=1) {
		if (IsObject(param_collection)) {
			for Key, Value in param_collection {
				if (param_fromIndex > A_Index) {
					continue
				}
				if (Value = param_value) {
					return true
				}
			}
			return false
		} else {
			; RegEx
			if (RegEx_value := this.internal_JSRegEx(param_value)) {
				return RegExMatch(param_collection, RegEx_value, RE, param_fromIndex)
			}
			; Normal string search
			if (A_StringCaseSense == "On") {
				StringCaseSense := 1
			} else {
				StringCaseSense := 0
			}
			if (InStr(param_collection, param_value, StringCaseSense, param_fromIndex)) {
				return true
			} else {
				return false
			}
		}
	}
	keyBy(param_collection,param_iteratee:="__identity") {
		if (!IsObject(param_collection)) {
			this.internal_ThrowException()
		}
		; check what kind of param_iteratee being worked with
		if (!IsFunc(param_iteratee)) {
			BoundFunc := param_iteratee.Bind(this)
		}

		; prepare data
		l_paramAmmount := param_iteratee.MaxParams
		if (l_paramAmmount == 3) {
			collectionClone := this.cloneDeep(param_collection)
		}
		l_obj := {}

		; run against every value in the collection
		for Key, Value in param_collection {
			if (!BoundFunc) { ; is property/string
				;nothing currently
			}
			if (l_paramAmmount == 3) {
				if (!BoundFunc.call(Value, Key, collectionClone)) {
					vIteratee := param_iteratee.call(Value, Key, collectionClone)
				}
			}
			if (l_paramAmmount == 2) {
				if (!BoundFunc.call(Value, Key)) {
					vIteratee := param_iteratee.call(Value, Key)
				}
			}
			if (l_paramAmmount == 1) {
				if (!BoundFunc.call(Value)) {
					vIteratee := param_iteratee.call(Value)
				}
			}
			ObjRawSet(l_obj, vIteratee, Value)
		}
		return l_obj
	}
	map(param_collection,param_iteratee:="__identity") {
		if (!IsObject(param_collection)) {
			this.internal_ThrowException()
		}

		l_array := []

		; data setup
		shorthand := this.internal_differenciateShorthand(param_iteratee, param_collection)
		if (shorthand == ".property") {
			param_iteratee := this.property(param_iteratee)
		}
		for Key, Value in param_collection {
			if (!this.isUndefined(param_iteratee.call(Value))) {
				thisthing := "function"
			}
			break
		}
		l_array := []

		; create the array
		for Key, Value in param_collection {
			if (param_iteratee == "__identity") {
				l_array.push(Value)
				continue
			}
			if (thisthing == "function") {
				l_array.push(param_iteratee.call(Value))
				continue
			}
			if (IsFunc(param_iteratee)) { ;if calling own method
				BoundFunc := param_iteratee.Bind(this)
				l_array.push(BoundFunc.call(Value))
			}
		}
		return l_array
	}
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
	reject(param_collection,param_predicate) {
		if (!IsObject(param_collection)) {
			this.internal_ThrowException()
		}

		; data setup
		shorthand := this.internal_differenciateShorthand(param_predicate, param_collection)
		if (shorthand != false) {
			boundFunc := this.internal_createShorthandfn(param_predicate, param_collection)
		}
		l_array := []

		; create the slice
		for Key, Value in param_collection {
			; functor
			; predefined !functor handling (slower as it .calls blindly)
			if (IsFunc(param_predicate)) {
				if (!param_predicate.call(Value)) {
					l_array.push(Value)
				}
				continue
			}
			; shorthand
			if (shorthand != false) {
				if (!boundFunc.call(Value)) {
					l_array.push(Value)
				}
				continue
			}
			; predefined !functor handling (slower as it .calls blindly)
			vValue := param_predicate.call(Value)
			if (!vValue) {
				l_array.push(Value)
				continue
			}
		}
		return l_array
	}
	sample(param_collection) {
		if (!IsObject(param_collection)) {
			this.internal_ThrowException()
		}

		; prepare data
		l_array := []
		for Key, Value in param_collection {
			l_array.push(Value)
		}

		; create
		vSampleArray := this.sampleSize(l_array)
		return vSampleArray[1]
	}
	sampleSize(param_collection,param_SampleSize:=1) {
		if (!IsObject(param_collection)) {
			this.internal_ThrowException()
		}

		; return immediately if array is smaller than requested sampleSize
		if (param_SampleSize > param_collection.Count()) {
			return param_collection
		}

		; prepare data
		l_collection := this.clone(param_collection)
		l_array := []
		tempArray := []
		loop, % param_SampleSize
		{
			Random, randomNum, 1, l_collection.Count()
			while (this.indexOf(tempArray, randomNum) != -1) {
				tempArray.push(randomNum)
				Random, randomNum, 1, l_collection.Count()
			}
			l_array.push(l_collection[randomNum])
			l_collection.RemoveAt(randomNum)
		}
		return l_array
	}
	shuffle(param_collection) {
		if (!IsObject(param_collection)) {
			this.internal_ThrowException()
		}

		; prepare data
		l_array := this.clone(param_collection)
		l_shuffledArray := []

		; create
		loop, % l_array.Count() {
			random := this.sample(l_array)
			index := this.indexOf(l_array, random)
			l_array.RemoveAt(index)
			l_shuffledArray.push(random)
		}
		return l_shuffledArray
	}
	size(param_collection) {

		; create the return
		if (param_collection.Count() > 0) {
			return param_collection.Count()
		}
		if (param_collection.MaxIndex() > 0) {
			return  param_collection.MaxIndex()
		}
		return StrLen(param_collection)
	}
	sortBy(param_collection,param_iteratees:="") {
		if (!IsObject(param_collection)) {
			this.internal_ThrowException()
		}
		l_array := this.cloneDeep(param_collection)

		; if called with a function
		if (IsFunc(param_iteratees)) {
			tempArray := []
			for Key, Value in param_collection {
				bigaIndex := param_iteratees.call(param_collection[Key])
				param_collection[Key].bigaIndex := bigaIndex
				tempArray.push(param_collection[Key])
			}
			l_array := this.sortBy(tempArray, "bigaIndex")
			for Key, Value in l_array {
				l_array[Key].Remove("bigaIndex")
			}
			return l_array
		}

		; if called with shorthands
		if (IsObject(param_iteratees)) {
			; sort the collection however many times is requested by the shorthand identity
			for Key, Value in param_iteratees {
				l_array := this.internal_sort(l_array, Value)
			}
		} else {
			l_array := this.internal_sort(l_array, param_iteratees)
		}
		return l_array
	}

	internal_sort(param_collection,param_iteratees:="") {
		l_array := this.cloneDeep(param_collection)

		if (param_iteratees != "") {
			; sort associative arrays
			for Index, obj in l_array {
				out .= obj[param_iteratees] "+" Index "|" ; "+" allows for sort to work with just the value
				; out will look like:   value+index|value+index|
			}
			lastValue := l_array[Index, param_iteratees]
		} else {
			; sort regular arrays
			for Index, obj in l_array {
				out .= obj "+" Index "|"
			}
			lastValue := l_array[l_array.Count()]
		}

		if lastValue is number
		{
			sortType := "N"
		}
		StringTrimRight, out, out, 1 ; remove trailing | 
		Sort, out, % "D| " sortType
		arrStorage := []
		loop, parse, out, |
		{
			arrStorage.push(l_array[SubStr(A_LoopField, InStr(A_LoopField, "+") + 1)])
		}
		return arrStorage
	}
	; /--\--/--\--/--\--/--\--/--\
	; Internal functions
	; \--/--\--/--\--/--\--/--\--/

	printObj(param_obj) {
		if (!IsObject(param_obj)) {
			return """" param_obj """"
		}
		if this.internal_IsCircle(param_obj) {
			this.internal_ThrowException()
		}

		for Key, Value in param_obj {
			if Key is not Number 
			{
				Output .= """" . Key . """:"
			} else {
				Output .= Key . ":"
			}
			if (IsObject(Value)) {
				Output .= "[" . this.printObj(Value) . "]"
			} else if Value is not number
			{
				Output .= """" . Value . """"
			}
			else {
				Output .= Value
			}
			Output .= ", "
		}
		StringTrimRight, OutPut, OutPut, 2
		return OutPut
	}
	print(param_obj) {
		if (!IsObject(param_obj)) {
			return """" param_obj """"
		}
		if this.internal_IsCircle(param_obj) {
			this.internal_ThrowException()
		}

		return this.printObj(param_obj)
	}

	internal_MD5(param_string, case := 0) {
		static MD5_DIGEST_LENGTH := 16
		hModule := DllCall("LoadLibrary", "Str", "advapi32.dll", "Ptr")
		, VarSetCapacity(MD5_CTX, 104, 0), DllCall("advapi32\MD5Init", "Ptr", &MD5_CTX)
		, DllCall("advapi32\MD5Update", "Ptr", &MD5_CTX, "AStr", param_string, "UInt", StrLen(param_string))
		, DllCall("advapi32\MD5Final", "Ptr", &MD5_CTX)
		loop % MD5_DIGEST_LENGTH
			o .= Format("{:02" (case ? "X" : "x") "}", NumGet(MD5_CTX, 87 + A_Index, "UChar"))
		return o, DllCall("FreeLibrary", "Ptr", hModule)
	}

	internal_JSRegEx(param_string) {
		if (this.startsWith(param_string, "/") && this.startsWith(param_string, "/", StrLen(param_string))) {
			return  SubStr(param_string, 2 , StrLen(param_string) - 2)
		}
		return false
	}

	internal_differenciateShorthand(param_shorthand,param_objects:="") {
		if (IsObject(param_shorthand)) {
			for Key, in param_shorthand {
				if Key is number
				{
					continue
				} else {
					return ".matches"
				}
			}
			return ".matchesProperty"
		}
		if (this.size(param_shorthand) > 0) {   
			if (IsObject(param_objects)) {
				if (param_objects[1][param_shorthand] != "") {
					return ".property"
				}
			}
		}
		return false
	}

	internal_createShorthandfn(param_shorthand,param_objects) {
		shorthand := this.internal_differenciateShorthand(param_shorthand, param_objects)
		if (shorthand == ".matches") {
			return this.matches(param_shorthand)
		}
		if (shorthand == ".matchesProperty") {
			return this.matchesProperty(param_shorthand[1], param_shorthand[2])
		}
		if (shorthand == ".property") {
			return this.property(param_shorthand)
		}
	}

	internal_ThrowException() {
		if (this.throwExceptions == true) {
			throw Exception("Type Error", -2)
		}
	}
	clone(param_value) {
		if (IsObject(param_value)) {
			return param_value.Clone()
		} else {
			return param_value
		}
	}
	cloneDeep(param_array) {
		Objs := {}
		Obj := param_array.Clone()
		Objs[&param_array] := Obj ; Save this new array
		for Key, Value in Obj {
			if (IsObject(Value)) ; if it is a subarray
				Obj[Key] := Objs[&Value] ; if we already know of a refrence to this array
				? Objs[&Value] ; Then point it to the new array
				: this.clone(Value, Objs) ; Otherwise, clone this sub-array
		}
		return Obj
	}
	isEqual(param_value,param_other) {
		if (IsObject(param_value)) {
			param_value := this.printObj(param_value)
			param_other := this.printObj(param_other)
		}

		return !(param_value != param_other) ; != follows StringCaseSense
	}
	isMatch(param_object,param_source) {
		for Key, Value in param_source {
			if (param_object[key] == Value) {
				continue
			} else {
				return false
			}
		}
		return true
	}
	isUndefined(param_value) {
		if (param_value == "") {
			return true
		}
		return false
	}
	add(param_augend,param_addend) {
		if (IsObject(param_augend) || IsObject(param_addend)) {
			this.internal_ThrowException()
		}

		; create the return
		param_augend += param_addend
		return param_augend
	}
	ceil(param_number,param_precision:=0) {
		if (IsObject(param_number) || IsObject(param_precision)) {
			this.internal_ThrowException()
		}

		if (param_precision == 0) { ; regular ceil
			return ceil(param_number)
		}

		offset := 0.5 / (10**param_precision)
		if (param_number < 0 && param_precision >= 1) {
			offset //= 10 ; adjust offset for negative numbers and positive param_precision
		}
		if (param_precision >= 1) {
			n_dec_char := strlen( substr(param_number, instr(param_number, ".") + 1) ) ; count the number of decimal characters
			sum := format("{:." this.max([n_dec_char, param_precision]) + 1 "f}", param_number + offset)
		} else {
			sum := param_number + offset
		}
		sum := trim(sum, "0") ; trim zeroes
		value := (SubStr(sum, 0) = "5") && param_number != sum ? SubStr(sum, 1, -1) : sum ; if last char is 5 then remove it unless it is part of the original string
		result := Round(value, param_precision)
		return result
	}
	divide(param_dividend,param_divisor) {
		if (IsObject(param_dividend) || IsObject(param_divisor)) {
			this.internal_ThrowException()
		}

		; create the return
		vValue := param_dividend / param_divisor
		return vValue
	}
	floor(param_number,param_precision:=0) {
		if (IsObject(param_number) || IsObject(param_precision)) {
			this.internal_ThrowException()
		}

		if (param_precision == 0) { ; regular floor
			return floor(param_number)
		}

		offset := -0.5 / (10**param_precision)
		if (param_number < 0 && param_precision >= 1) {
			offset //= 10 ; adjust offset for negative numbers and positive param_precision
		}
		if (param_precision >= 1) {
			n_dec_char := strlen( substr(param_number, instr(param_number, ".") + 1) ) ; count the number of decimal characters
			sum := format("{:." this.max([n_dec_char, param_precision]) + 1 "f}", param_number + offset)
		} else {
			sum := param_number + offset
		}
		sum := trim(sum, "0") ; trim zeroes
		value := (SubStr(sum, 0) = "5") && param_number != sum ? SubStr(sum, 1, -1) : sum ; if last char is 5 then remove it unless it is part of the original string
		result := Round(value, param_precision)
		return result
	}
	max(param_array) {
		if (!IsObject(param_array)) {
			this.internal_ThrowException()
		}

		vMax := ""
		for Key, Value in param_array {
			if (vMax < Value || this.isUndefined(vMax)) {
				vMax := Value
			}
		}
		return vMax
	}
	mean(param_array) {
		if (!IsObject(param_array)) {
			this.internal_ThrowException()
		}

		vSum := 0
		for Key, Value in param_array {
			vSum += Value
		}
		return vSum / this.size(param_array)
	}
	meanBy(param_array,param_iteratee:="__identity") {
		if (!IsObject(param_array)) {
			this.internal_ThrowException()
		}

		; data setup
		if (!IsFunc(param_iteratee)) {
			BoundFunc := param_iteratee.Bind(this)
		}
		shorthand := this.internal_differenciateShorthand(param_iteratee, param_array)
		if (shorthand != false) {
			boundFunc := this.internal_createShorthandfn(param_iteratee, param_array)
		}

		; prepare data
		if (l_paramAmmount == 3) {
			arrayClone := this.cloneDeep(param_array)
		}
		l_TotalVal := 0

		; run against every value in the array
		for Key, Value in param_array {
			; shorthand
			if (shorthand == ".property") {
				fn := this.property(param_iteratee)
				vIteratee := fn.call(Value)
			}
			if (BoundFunc) {
				vIteratee := BoundFunc.call(Value)
			}
			if (param_iteratee.MaxParams == 1) {
				if (!BoundFunc.call(Value)) {
					vIteratee := param_iteratee.call(Value)
				}
			}
			l_TotalVal += vIteratee 
		}
		return l_TotalVal / param_array.Count()
	}
	min(param_array) {
		if (!IsObject(param_array)) {
			this.internal_ThrowException()
		}

		vMin := ""
		for Key, Value in param_array {
			if (vMin > Value || this.isUndefined(vMin)) {
				vMin := Value
			}
		}
		return vMin
	}
	multiply(param_multiplier,param_multiplicand) {
		if (IsObject(param_multiplier) || IsObject(param_multiplicand)) {
			this.internal_ThrowException()
		}

		; create the return
		vValue := param_multiplier * param_multiplicand
		return vValue
	}
	round(param_number,param_precision:=0) {
		if (IsObject(param_number) || IsObject(param_precision)) {
			this.internal_ThrowException()
		}

		; create the return
		return round(param_number, param_precision)
	}
	subtract(param_minuend,param_subtrahend) {
		if (IsObject(param_minuend) || IsObject(param_subtrahend)) {
			this.internal_ThrowException()
		}

		; create the return
		param_minuend -= param_subtrahend
		return param_minuend
	}
	sum(param_array) {
		if (!IsObject(param_array)) {
			this.internal_ThrowException()
		}

		vSum := 0
		for Key, Value in param_array {
			vSum += Value
		}
		return vSum
	}
	clamp(param_number,param_lower,param_upper) {
		if (IsObject(param_number) || IsObject(param_lower) || IsObject(param_upper)) {
			this.internal_ThrowException()
		}

		; check the lower bound
		if (param_number < param_lower) {
			param_number := param_lower
		}
		; check the upper bound
		if (param_number > param_upper) {
			param_number := param_upper
		}
		return param_number
	}
	inRange(param_number,param_lower,param_upper) {
		if (IsObject(param_number) || IsObject(param_lower) || IsObject(param_upper)) {
			this.internal_ThrowException()
		}

		; prepare data
		if (param_lower > param_upper) {
			x := param_lower
			param_lower := param_upper
			param_upper := x
		}

		; check the bounds
		if (param_number > param_lower && param_number < param_upper) {
			return true
		}
		return false
	}
	random(param_lower:=0,param_upper:=1,param_floating:=false) {
		if (IsObject(param_lower) || IsObject(param_upper) || IsObject(param_floating)) {
			this.internal_ThrowException()
		}

		; prepare data
		if (param_lower > param_upper) {
			x := param_lower
			param_lower := param_upper
			param_upper := x
		}
		if (param_floating) {
			param_lower += 0.0
			param_upper += 0.0
		}

		; create the return
		Random, vRandom, param_lower, param_upper
		return vRandom
	}
	defaults(param_object,param_sources*) {
		if (!IsObject(param_object)) {
			this.internal_ThrowException()
		}

		; data setup
		l_obj := this.clone(param_object)
		param_sources := this.reverse(param_sources)

		; create
		for Index, Object in param_sources {
			for Key, Value in Object {
				if (!l_obj.HasKey(Key)) { ; if the key is not already in use
					l_obj[Key] := Value
				}
			}
		}
		return l_obj
	}
	merge(param_collections*) {
		if (!IsObject(param_collections)) {
			this.internal_ThrowException()
		}

		result := param_collections[1]
		for index, obj in param_collections {
			if(A_Index = 1) {
				continue 
			}
			result := this.internal_Merge(result, obj)
		}
		return result
	}

	internal_Merge(param_collection1, param_collection2) {
		if(!IsObject(param_collection1) && !IsObject(param_collection2)) {
			; if only one OR the other exist, display them together. 
			if(param_collection1 = "" || param_collection2 = "") {
				return param_collection2 param_collection1
			}
			; return only one if they are the same
			if (param_collection1 = param_collection2)
				return param_collection1
			; otherwise, return them together as an object. 
			return [param_collection1, param_collection2]
		}

		; initialize an associative array
		combined := {}

		for Key, Value in param_collection1 {
			combined[Key] := this.internal_Merge(Value, param_collection2[Key])
		}
		for Key, Value in param_collection2 {
			if(!combined.HasKey(Key)) {
				combined[Key] := Value
			}
		}
		return combined
	}
	pick(param_object,param_paths) {
		if (!IsObject(param_object)) {
			this.internal_ThrowException()
		}

		; data setup
		l_obj := {}

		; create the return
		if (IsObject(param_paths)) {
			for Key, Value in param_paths {
				vValue := this.internal_property(Value, param_object)
				l_obj[Value] := vValue
			}
		} else {
			vValue := this.internal_property(param_paths, param_object)
			l_obj[param_paths] := vValue
		}
		return  l_obj
	}
	toPairs(param_object) {
		if (!IsObject(param_object)) {
			this.internal_ThrowException()
		}

		l_array := []
		for Key, Value in param_object {
			l_array.push([Key, Value])
		}
		return l_array
	}
	camelCase(param_string:="") {
		if (IsObject(param_string)) {
			this.internal_ThrowException()
		}

		; create the return
		l_string := this.startCase(param_string)
		l_startChar := this.head(l_string)
		l_outputString := this.toLower(l_startChar) this.join(this.tail(StrReplace(l_string, " ", "")), "")

		return l_outputString
	}
	endsWith(param_string,param_needle,param_fromIndex:="") {
		if (IsObject(param_string) || IsObject(param_needle) || IsObject(param_fromIndex)) {
			this.internal_ThrowException()
		}

		; prepare defaults
		if (param_fromIndex = "") {
			param_fromIndex := StrLen(param_string)
		}
		if (StrLen(param_needle) > 1) {
			param_fromIndex := StrLen(param_string) - StrLen(param_needle) + 1
		}

		; create
		l_endChar := SubStr(param_string, param_fromIndex, StrLen(param_needle))
		if (this.isEqual(l_endChar, param_needle)) {
			return true
		}
		return false
	}
	escape(param_string:="") {
		if (IsObject(param_string)) {
			this.internal_ThrowException()
		}

		; prepare data
		HTMLmap := [["&","&amp;"], ["<","&lt;"], [">","&gt;"], ["""","&quot;"], ["'","&#39;"]]

		for Key, Value in HTMLmap {
			element := Value
			param_string := StrReplace(param_string, element.1, element.2, , -1)
		}
		return param_string
	}
	kebabCase(param_string:="") {
		if (IsObject(param_string)) {
			this.internal_ThrowException()
		}

		; create the return
		l_string := this.startCase(param_string)
		l_string := StrReplace(l_string, " ", "-")
		return l_string
	}
	lowerCase(param_string:="") {
		if (IsObject(param_string)) {
			this.internal_ThrowException()
		}

		; create the return
		l_string := this.startCase(param_string)
		l_string := this.toLower(this.trim(l_string))
		return l_string
	}
	parseInt(param_string:="0") {
		if (IsObject(param_string)) {
			this.internal_ThrowException()
		}

		l_int := this.trimStart(param_string, " 0_")
		if (this.size(l_int) = 0) {
			return 0
		}
		return l_int + 0
	}
	repeat(param_string,param_number:=1) {
		if (IsObject(param_string)) {
			this.internal_ThrowException()
		}

		if (param_number == 0) {
			return ""
		}
		return StrReplace(Format("{:0" param_number "}", 0), "0", param_string)
	}
	replace(param_string:="",param_needle:="",param_replacement:="") {
	    l_string := param_string
	    ; RegEx
	    if (l_needle := this.internal_JSRegEx(param_needle)) {
	        return  RegExReplace(param_string, l_needle, param_replacement, , this.limit)
	    }
	    output := StrReplace(l_string, param_needle, param_replacement, , this.limit)
	    return output
	}
	snakeCase(param_string:="") {
		if (IsObject(param_string)) {
			this.internal_ThrowException()
		}

		; create the return
		l_string := this.startCase(param_string)
		l_string := StrReplace(l_string, " ", "_")
		return l_string
	}
	split(param_string:="",param_separator:=",",param_limit:=0) {
	    if (IsObject(param_string) || IsObject(param_string) || IsObject(param_limit)) {
	        this.internal_ThrowException()
	    }

	    ; prepare inputs if regex detected
	    if (this.internal_JSRegEx(param_separator)) {
	        param_string := this.replace(param_string, param_separator, ",")
	        param_separator := ","
	    }

	    ; create the return
	    oSplitArray := StrSplit(param_string, param_separator)
	    if (!param_limit) {
	        return oSplitArray
	    } else {
	        oReducedArray := []
	        loop, % param_limit {
	            if (A_Index <= oSplitArray.Count()) {
	                oReducedArray.push(oSplitArray[A_Index])
	            }
	        }
	    }
	    return oReducedArray
	}
	startCase(param_string:="") {
		if (IsObject(param_string)) {
			this.internal_ThrowException()
		}

		l_string := this.replace(param_string, "/(\W)/", " ")
		l_string := this.replace(l_string, "/([\_])/", " ")

		; create the return
		; add space before each capitalized character
		RegExMatch(l_string, "O)([A-Z])", RE_Match)
		if (RE_Match.Count()) {
			loop, % RE_Match.Count() {
				l_string := % SubStr(l_string, 1, RE_Match.Pos(A_Index) - 1) " " SubStr(l_string, RE_Match.Pos(A_Index))
			}
		}
		; Split the string into array and Titlecase each element in the array
		l_array := StrSplit(l_string, " ")
		loop, % l_array.Count() {
			x_string := l_array[A_Index]
			StringUpper, x_string, x_string, T
			l_array[A_Index] := x_string
		}
		; join the string back together from Titlecased array elements
		l_string := this.join(l_array, " ")
		l_string := this.trim(l_string)
		return l_string
	}
	startsWith(param_string,param_needle,param_fromIndex:= 1) {
		if (IsObject(param_string) || IsObject(param_needle) || IsObject(param_fromIndex)) {
			this.internal_ThrowException()
		}

		l_startString := SubStr(param_string, param_fromIndex, StrLen(param_needle))
		; check if substring matches
		if (this.isEqual(l_startString, param_needle)) {
			return true
		}
		return false
	}
	toLower(param_string) {
		if (IsObject(param_string)) {
			this.internal_ThrowException()
		}

		; create the return
		StringLower, OutputVar, param_string
		return  OutputVar
	}
	toUpper(param_string) {
		StringUpper, OutputVar, param_string
		return  OutputVar
	}
	trim(param_string,param_chars:="") {
		if (param_chars = "") {
			l_string := this.trimStart(param_string, param_chars)
			return  this.trimEnd(l_string, param_chars)
		} else {
			l_string := param_string
			l_removechars := "\" this.join(StrSplit(param_chars, ""), "\")

			; replace starting characters
			l_string := this.trimStart(l_string, param_chars)
			; replace ending characters
			l_string := this.trimEnd(l_string, param_chars)
			return l_string
		}
	}
	trimEnd(param_string,param_chars:="") {
		if (param_chars = "") {
			l_string := param_string
			return  regexreplace(l_string, "(\s+)$") ;trim ending whitespace
		} else {
			l_array := StrSplit(param_chars, "")
			for Key, Value in l_array {
				if (this.includes(Value, "/[a-zA-Z0-9]/")) {
					l_removechars .= Value
				} else {
					l_removechars .= "\" Value
				}
			}
			; replace ending characters
			l_string := this.replace(param_string, "/([" l_removechars "]+)$/", "")
			return l_string
		}
	}
	trimStart(param_string,param_chars:="") {
		if (param_chars = "") {
			return  regexreplace(param_string, "^(\s+)") ;trim beginning whitespace
		} else {
			l_array := StrSplit(param_chars, "")
			for Key, Value in l_array {
				if (this.includes(Value, "/[a-zA-Z0-9]/")) {
					l_removechars .= Value
				} else {
					l_removechars .= "\" Value
				}
			}
			; replace leading characters
			l_string := this.replace(param_string, "/^([" l_removechars "]+)/", "")
			return l_string
		}
	}
	truncate(param_string,param_options:="") {
		if (IsObject(param_string)) {
			this.internal_ThrowException()
		}

		; prepare default options object
		if (!IsObject(param_options)) {
			param_options := {}
			param_options.length := 30
		}
		if (!param_options.omission) {
			param_options.omission := "..."
		}

		; check that length is even worth working on
		if (StrLen(param_string) + StrLen(param_options.omission) < param_options.length && !param_options.separator) {
			return param_string
		}

		l_array := StrSplit(param_string, "")
		l_string := ""
		; cut length of the string by character count + the omission's length
		if (param_options.length) {
			loop, % l_array.Count() {
				if (A_Index > param_options.length - StrLen(param_options.omission)) {
					l_string := l_string param_options.omission
					break
				}
				l_string := l_string l_array[A_Index]
			}
		}

		; separator
		if (this.internal_JSRegEx(param_options.separator)) {
			param_options.separator := this.internal_JSRegEx(param_options.separator)
		}
		if (param_options.separator) {
			return  RegexReplace(l_string, "^(.{1," param_options.length "})" param_options.separator ".*$", "$1") param_options.omission

		}
		return l_string
	}
	unescape(param_string:="") {
		if (IsObject(param_string)) {
			this.internal_ThrowException()
		}

		; prepare data
		HTMLmap := [["&","&amp;"], ["<","&lt;"], [">","&gt;"], ["""","&quot;"], ["'","&#39;"]]

		for Key, Value in HTMLmap {
			element := Value
			param_string := StrReplace(param_string, element.2, element.1, , -1)
		}
		return param_string
	}
	upperCase(param_string:="") {
		if (IsObject(param_string)) {
			this.internal_ThrowException()
		}

		; create the return
		l_string := this.startCase(param_string)
		l_string := this.toupper(this.trim(l_string))
		return l_string
	}
	words(param_string,param_pattern:="/[^\W]+/") {
		if (IsObject(param_string) || IsObject(param_pattern)) {
			this.internal_ThrowException()
		}

		l_string := param_string
		l_array := []
		if (l_needle := this.internal_JSRegEx(param_pattern)) {
			param_pattern := l_needle
		}
		l_needle := "O)" param_pattern
		while(RegExMatch(l_string, l_needle, RE_Match)) {
			tempString := RE_Match.Value()
			l_array.push(tempString)
			l_string := SubStr(l_string, RE_Match.Pos()+RE_Match.Len())
		}
		return l_array
	}
	matches(param_source) {
		if (!IsObject(param_source)) {
			this.internal_ThrowException()
		}

		BoundFunc := ObjBindMethod(this, "internal_matches", param_source)
		return BoundFunc
	}

	internal_matches(param_matches,param_itaree) {
		for Key, Value in param_matches {
			if (param_matches[Key] != param_itaree[Key]) {
				return false
			}
		}
		return true
	}
	matchesProperty(param_path,param_srcValue) {
		if (IsObject(param_srcValue)) {
			this.internal_ThrowException()
		}

		; create the property fn
		fnProperty := this.property(param_path)
		; create the fn
		boundFunc := ObjBindMethod(this, "internal_matchesProperty", fnProperty, param_srcValue)
		return boundFunc
	}

	internal_matchesProperty(param_property,param_matchvalue,param_itaree) {
		itareeValue := param_property.call(param_itaree)
		; msgbox, % "comparing " this.printObj(param_matchvalue) " to " this.printObj(itareeValue) " from(" this.printObj(param_itaree) ")"
		if (!this.isUndefined(itareeValue)) {
			if (itareeValue = param_matchvalue) {
				return true
			}
		}    
		return false
	}
	property(param_source) {
		if (IsObject(param_srcValue)) {
			this.internal_ThrowException()
		}

		; prepare data
		if (this.includes(param_source, ".")) {
			param_source := this.split(param_source, ".")
		}

		; create the fn
		if (IsObject(param_source)) {
			keyArray := []
			for Key, Value in param_source {
				keyArray.push(Value) 
			}
			BoundFunc := ObjBindMethod(this, "internal_property", keyArray)
			return BoundFunc
		} else {
			BoundFunc := ObjBindMethod(this, "internal_property", param_source)
		return BoundFunc
		}
	}

	internal_property(param_property,param_itaree) {
		if (IsObject(param_property)) {
			for Key, Value in param_property {
				if (param_property.Count() == 1) {
					; msgbox, % "dove deep and found: " ObjRawGet(param_itaree, Value)
					return  ObjRawGet(param_itaree, Value)
				} else if (param_itaree.hasKey(Value)){
					rvalue := this.internal_property(this.tail(param_property), param_itaree[Value])
				}
			}
			return rvalue
		}
		return  param_itaree[param_property]
	}
}class A extends biga {}