include("${COMMON}")

if(EXISTS "createfail.db")
	file(REMOVE "createfail.db")
endif()

function(test_it TESTNAME INFILE)
	execute_process(${ARGN}
		RESULT_VARIABLE RESULTVAR)
	check_process_result("${TESTNAME} setup" "${RESULTVAR}")
	check_file("${TESTNAME}" "createfail.db" "${INFILE}")
endfunction(test_it)

test_it("Create" "a=c"
	COMMAND "${SDBEXE}" "createfail.db" "a=c")
test_it("Rereate" "a=d"
	COMMAND "${SDBEXE}" "createfail.db" "a=d")

file(REMOVE "createfail.db")
test_it("Make" "a=c"
	COMMAND ${CMAKE_COMMAND} -E echo "a=c"
	COMMAND "${SDBEXE}" "createfail.db" "=")
test_it("Remake" "a=d"
	COMMAND ${CMAKE_COMMAND} -E echo "a=d"
	COMMAND "${SDBEXE}" "createfail.db" "=")

file(REMOVE "createfail.db")
test_it("Dash" "a=c"
	COMMAND ${CMAKE_COMMAND} -E echo "a=c"
	COMMAND "${SDBEXE}" "createfail.db" "-")
test_it("Redash" "a=d"
	COMMAND ${CMAKE_COMMAND} -E echo "a=d"
	COMMAND "${SDBEXE}" "createfail.db" "-")
