
find_package(GLib)
find_package(Vala)

if(VALA_FOUND AND GLIB_FOUND)
	option(BINDING_VALA "Build vala binding" ON)
else()
	option(BINDING_VALA "Build vala binding" OFF)
endif()

if(BINDING_VALA)
	if(NOT VALA_FOUND)
		message(FATAL_ERROR "Couldn't find valac!")
	endif()
	if(NOT GLIB_FOUND)
		message(FATAL_ERROR "Couldn't find glib!")
	endif()
	set(VAPIDIR "${CMAKE_INSTALL_DATADIR}/vala/vapi")
	add_subdirectory(types)
	
	install(FILES "sdb.vapi" DESTINATION "${VAPIDIR}")
	
	# Tests
	vala_precompile_target(
		test-sdb-vala-vala
		test_sdb_vala_C_SRCS
		test.vala
		PACKAGES sdb posix
		FLAGS "--vapidir=${CMAKE_CURRENT_SOURCE_DIR}"
		)
	add_executable(test-sdb-vala EXCLUDE_FROM_ALL ${test_sdb_vala_C_SRCS})
	target_link_libraries(test-sdb-vala sdb_static gobject-2.0)
	add_dependencies(test-sdb-vala test-sdb-vala-vala)
	add_test(NAME "sdb-vala" COMMAND "$<TARGET_FILE:test-sdb-vala>")
	add_dependencies(build-test test-sdb-vala)
endif()
