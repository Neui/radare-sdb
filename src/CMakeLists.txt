configure_file("sdb_version.h.in" "sdb_version.h" @ONLY)

# TODO: Maybe just add js0n as a dependency?
set(JS0N_DEST "${CMAKE_CURRENT_BINARY_DIR}/json/js0n.c")
set(JS0N_SRC "${CMAKE_CURRENT_SOURCE_DIR}/json/js0n.c")
set(JS0N_FILE "${JS0N_SRC}")
if(NOT EXISTS "${JS0N_SRC}")
	file(DOWNLOAD "https://github.com/quartzjer/js0n/raw/master/src/js0n.c"
		"${JS0N_DEST}" STATUS JS0N_DL_STATUS)
	list(GET JS0N_DL_STATUS 0 JS0N_DL_CODE)
	list(GET JS0N_DL_STATUS 1 JS0N_DL_STR)
	if(NOT JS0N_DL_CODE EQUAL 0)
		message(SEND_ERROR "Couldn't download js0n.c! (${JS0N_DL_STR})")
	endif()
	set(JS0N_FILE "${JS0N_DEST}")
endif()

set(sdb_SRCS
	cdb.c cdb.h
	buffer.c buffer.h
	cdb_make.c cdb_make.h
	ls.c
	ht.c ht.h
	sdbht.c sdbht.h
	sdb.c sdb.h
	num.c
	base64.c
	match.c
	json.c
	ns.c
	lock.c
	util.c
	disk.c
	query.c
	array.c
	fmt.c
	journal.c
	types.h
	sdb_version.h
	)
set(sdb_HEADERS
	sdb.h
	cdb.h
	ht.h
	types.h
	ls.h
	cdb_make.h
	buffer.h
	config.h
	sdb_version.h
	)
include_directories("${CMAKE_CURRENT_BINARY_DIR}") # To find sdb_version.h

add_library(sdb_static STATIC ${sdb_SRCS})
set_target_properties(sdb_static PROPERTIES OUTPUT_NAME sdb)

add_library(sdb_shared SHARED ${sdb_SRCS})
set_target_properties(sdb_shared PROPERTIES OUTPUT_NAME sdb)

foreach(TARGET sdb_static sdb_shared)
	target_include_directories(${TARGET} PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}> # Only when building
		$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}> # Only when building
		$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/sdb>) # Only when exporting
	target_sources(${TARGET} PRIVATE ${sdb_HEADERS})
endforeach()

add_executable(sdb_exe main.c)
set_target_properties(sdb_exe PROPERTIES OUTPUT_NAME sdb)
target_link_libraries(sdb_exe sdb_static)

install(TARGETS sdb_exe sdb_shared sdb_static
	RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
	LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
	ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}")
install(FILES "sdb.1" DESTINATION "${CMAKE_INSTALL_MANDIR}/man1")
install(FILES ${sdb_HEADERS} DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/sdb")
