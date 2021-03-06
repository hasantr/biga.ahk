kebabCase(param_string:="") {
	if (IsObject(param_string)) {
		this.internal_ThrowException()
	}

	; create the return
	l_string := this.startCase(param_string)
	l_string := StrReplace(l_string, " ", "-")
	return l_string
}


; tests
assert.test(A.kebabCase("Foo Bar"), "foo-bar")
assert.test(A.kebabCase("fooBar"), "foo-bar")
assert.test(A.kebabCase("--FOO_BAR--"), "foo-bar")


; omit
assert.test(A.kebabCase("  Foo-Bar--"), "FOO-BAR")
