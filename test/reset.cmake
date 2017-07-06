include("${COMMON}")

if(EXISTS "db.test")
	file(REMOVE "db.test")
endif()

execute_process(COMMAND ${SDBEXE} "db.test" "foo=old"
	RESULT_VARIABLE RESULTVAR)
if (NOT RESULTVAR EQUAL 0)
	message(STATUS "Got result: '${RESULVART}'")
	fail("reset setup")
endif()

execute_process(COMMAND ${TESTEXE}
	RESULT_VARIABLE RESULTVAR)
if (NOT RESULTVAR EQUAL 0)
	fail("reset")
else()
	success("reset")
endif()
