if(EXISTS "___delkey.db")
	file(REMOVE "___delkey.db")
endif()

execute_process(COMMAND ${SDBEXE} "___delkey.db" "foo=bar"
	RESULT_VARIABLE RESULT)
if(NOT RESULT EQUAL 0)
	message(FATAL_ERROR "delkey test setup FAILED")
endif()


execute_process(COMMAND ${SDBEXE} "___delkey.db" "foo=bar"
	RESULT_VARIABLE RESULT OUTPUT_VARIABLE OUTPUTRESULT
	OUTPUT_STRIP_TRAILING_WHITESPACE)
if(NOT RESULT EQUAL 0)
	message(FATAL_ERROR "delkey test FAILED with result ${RESULT}")
elseif(NOT OUTPUTRESULT STREQUAL "")
	message(FATAL_ERROR "delkey test FAILED")
else()
	message(STATUS "delkey test OK")
endif()
