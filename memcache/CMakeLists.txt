set(memcache_SRCS
	memcache.c
	net.c
	client.c
	mcsdb.h
	"${CMAKE_CURRENT_BINARY_DIR}/cmds.h"
	)

set(memcache_server_SRCS
	main.c
	protocol.c
	)

set(memcache_client_SRCS
	mainclient.c
	)

include_directories("${CMAKE_CURRENT_BINARY_DIR}") # For cmds.h
add_library(mcsdb STATIC ${memcache_SRCS})
target_link_libraries(mcsdb sdb_static)
target_include_directories(mcsdb PUBLIC
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}> # Only when building
	$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}> # Only when building
	$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/sdb>) # Only when exporting

add_executable(mcsdbd ${memcache_server_SRCS})
target_link_libraries(mcsdbd mcsdb)

add_executable(mcsdbc ${memcache_client_SRCS})
target_link_libraries(mcsdbc mcsdb)

install(TARGETS mcsdb mcsdbd mcsdbc
	RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
	LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
	ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}")
install(FILES "mcsdb.h" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/sdb")

include_directories("${CMAKE_SOURCE_DIR}/src") # For util.c-stuff
include_directories("${CMAKE_BINARY_DIR}/src") # For sdb_version.h
# TODO: Cross compiling support
add_executable(mcsdb_cmds "${CMAKE_SOURCE_DIR}/src/util.c" cmds.c)
add_custom_command(OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/cmds.h"
	COMMAND $<TARGET_FILE:mcsdb_cmds> > "${CMAKE_CURRENT_BINARY_DIR}/cmds.h"
	COMMENT "Generating commands for memcache"
	VERBATIM) # VERBATIM required for IO redirection
