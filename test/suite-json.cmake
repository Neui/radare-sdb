include("${COMMON}")

set(P "JSON")
# indent is broken because run() doesnt handle multiline outputs, but it works :P
run("${P} 1" "foo={\"bar\":[1,2,3]};foo:"
	"{\n  \"bar\": [\n    1,\n    2,\n    3\n  ]\n}")
brk("${P} 2" "foo={\"bar\":[1,2,3]};foo:bar[1]=;foo" "{\"bar\":[1,3]}")
brk("${P} 3" "foo={\"bar\":[1,2,3,4]};foo:bar[0]=;foo" "{\"bar\":[2,3,4]}")
brk("${P} 4" "foo={\"bar\":[1,2,3,4]};foo:bar[1]=;foo" "{\"bar\":[1,3,4]}")
brk("${P} 5" "foo={\"bar\":[1,2,3,4]};foo:bar[2]=;foo" "{\"bar\":[1,2,4]}")
brk("${P} 5" "foo={\"bar\":[1,2,3,4]};foo:bar[3]=;foo" "{\"bar\":[1,2,3]}")
run("${P} 6" "foo={\"bar\":123};foo:bar=pop;foo:bar=cow;foo:bar" "cow")
run("${P} 7" "foo={\"bar\":123};foo:bar=3;foo:bar" "3")
run("${P} 8" "foo={\"bar\":123};foo:bar=pop;foo:bar" "pop")
run("${P} 9" "foo={\"bar\":123};foo:bar=true;foo:bar" "true")
run("${P} 10" "foo=[1,2,3];foo:[1]" "2")
run("${P} 11" "foo=[1,2,3];+foo:[1];foo:[1]" "3\n3")
run("${P} 12" "foo=[1,2,3];foo:[1]=999;foo" "[1,999,3]")
run("${P} 13" "foo={\"bar\":\"V\"};foo:bar" "V")
run("${P} 14" "a={\"a\":1,\"b\":2};a:a=;a:b=;a" "{}")
run("${P} 15" "a={\"a\":1,\"b\":2};a:b=;a" "{\"a\":1}")
run("${P} 16" "foo={\"bar\":123};foo:bar" "123")
run("${P} 17" "foo={\"bar\":123};foo:bar=69;foo:bar" "69")
run("${P} 18" "foo={\"bar\":\"pop\"};foo:bar=\"jiji\";foo:bar" "jiji")
run("${P} 19" "foo={\"bar\":[1,2]};foo:bar[0]" "1")

run("${P} 20" "foo={\"bar\":\"pop\"};foo:bar=\"jiji\";foo"
	"{\"bar\":\"jiji\"}")
run("${P} 21" "foo={\"pop\":123,\"bar\":\"cow\"};foo:pop=;foo"
	"{\"bar\":\"cow\"}")
run("${P} 22" "foo={\"pop\":123,\"bar\":\"cow\"};foo:pop=;foo:pop=123;foo"
	"{\"pop\":123,\"bar\":\"cow\"}")
run("${P} 23" "foo={};foo:pop=123;foo" "{\"pop\":123}")
run("${P} 24" "foo=;foo:pop=123;foo" "{\"pop\":123}")

end()
