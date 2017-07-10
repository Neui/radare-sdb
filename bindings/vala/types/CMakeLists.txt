include_directories("${CMAKE_SOURCE_DIR}/src")

set(sdbtypes_vala_SRCS
	hash.vala
	stack.vala
	stackiterator.vala
	array.vala
	arrayiterator.vala
	list.vala
	listiterator.vala
	iterator.vala
	serializable.vala
	iterable.vala
	../sdb.vapi
	)

# It changes the build options a bit when using memcache, that seems to use
# memcache or so... Is that necessary at all? Or can we just build 2 libraries?
# TODO: Check if we need to build an memcache-specialized library for vala

vala_precompile_target(
	sdbtypes-vala
	sdbtypes_vala_C_SRCS
	sdbinstance.vala ${sdbtypes_vala_SRCS}
	VAPI "${CMAKE_CURRENT_BINARY_DIR}/sdbtypes.vapi"
	HEADER "${CMAKE_CURRENT_BINARY_DIR}/sdbtypes.h"
	)

add_library(sdbtypes STATIC ${sdbtypes_vala_C_SRCS})
target_link_libraries(sdbtypes sdb_static gobject-2.0)
target_include_directories(sdbtypes PUBLIC
	$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}> # Only when building
	$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>) # Only when exporting
add_dependencies(sdbtypes sdbtypes-vala)

install(TARGETS sdbtypes
	LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
	ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}")
install(FILES "sdbtypes.h" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}")
install(FILES "sdbtypes.vapi" DESTINATION "${VAPIDIR}")

# Tests
vala_precompile_target(
	test-sdbtypes-vala
	test_sdbtypes_vala_C_SRCS
	main.vala
	PACKAGES sdbtypes
	DEPENDS sdbtypes
	FLAGS "--vapidir=${CMAKE_CURRENT_BINARY_DIR}"
	)
add_executable(test-sdbtypes EXCLUDE_FROM_ALL ${test_sdbtypes_vala_C_SRCS})
target_link_libraries(test-sdbtypes sdbtypes gobject-2.0)
add_dependencies(test-sdbtypes test-sdbtypes-vala)
add_test(NAME "sdbtypes" COMMAND "$<TARGET_FILE:test-sdbtypes>")
add_dependencies(build-test test-sdbtypes)

