# Prints failure and stops
macro(fail TESTNAME)
	math(EXPR FAILED "${FAILED}+1")
	set(FAILED "${FAILED}" PARENT_SCOPE)
	if(COLOR_SUPPORT EQUAL 1)
		execute_process(COMMAND ${CMAKE_COMMAND} -E echo_append "Test '${TESTNAME}' ")
		execute_process(COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --red "FAIL")
	endif()
	end()
	message(FATAL_ERROR "Test '${TESTNAME}' FAIL")
endmacro(fail)

# Prints broken and continues
macro(broken TESTNAME)
	math(EXPR BROKEN "${BROKEN}+1")
	set(BROKEN "${BROKEN}" PARENT_SCOPE)
	if(COLOR_SUPPORT EQUAL 1)
		execute_process(COMMAND ${CMAKE_COMMAND} -E echo_append "Test '${TESTNAME}' ")
		execute_process(COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --red "BROKEN")
	else()
		message(STATUS "Test '${TESTNAME}' BROKEN")
	endif()
endmacro(broken)

# Prints success
macro(success TESTNAME)
	math(EXPR SUCCESS "${SUCCESS}+1")
	set(SUCCESS "${SUCCESS}" PARENT_SCOPE)
	if(COLOR_SUPPORT EQUAL 1)
		execute_process(COMMAND ${CMAKE_COMMAND} -E echo_append "Test '${TESTNAME}' ")
		execute_process(COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --green "OK")
	else()
		message(STATUS "Test '${TESTNAME}' OK")
	endif()
endmacro(success)

# Prints fixed
macro(fixed TESTNAME)
	math(EXPR FIXED "${FIXED}+1")
	set(FIXED "${FIXED}" PARENT_SCOPE)
	if(COLOR_SUPPORT EQUAL 1)
		execute_process(COMMAND ${CMAKE_COMMAND} -E echo_append "Test '${TESTNAME}' ")
		execute_process(COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --blue "FIXED")
	else()
		message(STATUS "Test '${TESTNAME}' FIXED")
	endif()
endmacro(fixed)

# Check if we have cmake -E cmake_echo_color avilable
execute_process(COMMAND "${CMAKE_COMMAND}" -E cmake_echo_color
	RESULT_VARIABLE COLOR_RESULT OUTPUT_VARIABLE COLOR_OUTPUT)
if(COLOR_RESULT EQUAL 0)
	set(COLOR_SUPPORT 1)
endif()

function(check_process_result TESTNAME GOT)
	if(NOT GOT EQUAL 0)
		fail("${TESTNAME}")
	endif()
endfunction()

function(check_file TESTNAME FILEE EXPECTED)
	execute_process(COMMAND "${SDBEXE}" "${FILEE}"
		RESULT_VARIABLE RESULTVAR
		OUTPUT_VARIABLE OUTPUTVAR
		OUTPUT_STRIP_TRAILING_WHITESPACE)
	check_process_result("${TESTNAME}" "${RESULTVAR}")
	if(NOT RESULTVAR EQUAL 0)
		fail("${TESTNAME}")
	elseif(NOT OUTPUTVAR STREQUAL "${EXPECTED}")
		message(STATUS "Expected '${EXPECTED}', got '${OUTPUTVAR}'")
		fail("${TESTNAME}")
	else()
		success("${TESTNAME}")
	endif()
endfunction(check_file)

function(run TESTNAME CMD OUTPUT)
	execute_process(
		COMMAND ${SDBEXE} - "${CMD}"
		RESULT_VARIABLE RESULTVAR
		OUTPUT_VARIABLE OUTPUTVAR
		OUTPUT_STRIP_TRAILING_WHITESPACE)
	if(NOT RESULTVAR EQUAL 0)
		fail("${TESTNAME}")
	elseif(NOT OUTPUTVAR STREQUAL "${OUTPUT}")
		message(STATUS "Expected '${OUTPUT}', got '${OUTPUTVAR}'")
		fail("${TESTNAME}")
	else()
		success("${TESTNAME}")
	endif()
endfunction(run)

function(run2 TESTNAME CMD CMDOUT OUTPUT)
	file(REMOVE "suite.db")
	execute_process(
		COMMAND ${SDBEXE} "suite.db" "${CMD}"
		RESULT_VARIABLE RESULTVAR)
	check_process_result("${TESTNAME} setup" "${RESULTVAR}")
	execute_process(
		COMMAND ${SDBEXE} "suite.db" "${CMDOUT}"
		RESULT_VARIABLE RESULTVAR
		OUTPUT_VARIABLE OUTPUTVAR
		OUTPUT_STRIP_TRAILING_WHITESPACE)
	if(NOT RESULTVAR EQUAL 0)
		fail("${TESTNAME}")
	elseif(NOT OUTPUTVAR STREQUAL "${OUTPUT}")
		message(STATUS "Expected '${OUTPUT}', got '${OUTPUTVAR}'")
		fail("${TESTNAME}")
	else()
		success("${TESTNAME}")
	endif()
	file(REMOVE "suite.db")
endfunction(run2)

function (brk TESTNAME CMD OUTPUT)
	execute_process(
		COMMAND ${SDBEXE} - "${CMD}"
		RESULT_VARIABLE RESULTVAR
		OUTPUT_VARIABLE OUTPUTVAR
		OUTPUT_STRIP_TRAILING_WHITESPACE)
	if(NOT RESULTVAR EQUAL 0)
		broken("${TESTNAME}")
	elseif(NOT OUTPUTVAR STREQUAL "${OUTPUT}")
		message(STATUS "Expected '${OUTPUT}', got '${OUTPUTVAR}'")
		broken("${TESTNAME}")
	else()
		fixed("${TESTNAME}")
	endif()
endfunction()

set(FAILED 0)
set(BROKEN 0)
set(SUCCESS 0)
set(FIXED 0)
function(end)
	message(STATUS "Stats: FAIL/OK/BROKEN/FIX ${FAILED}/${SUCCESS}/${BROKEN}/${FIXED}")
	if(NOT BROKEN EQUAL 0)
		message(FATAL_ERROR "There are broken tests!")
	elseif(NOT FAILED EQUAL 0)
		message(FATAL_ERROR "There are failed tests!")
	endif()
endfunction(end)
