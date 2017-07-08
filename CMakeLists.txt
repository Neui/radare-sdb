cmake_minimum_required(VERSION 3.2 FATAL_ERROR)

# Because sdb ships with Makefiles and so on, just let's disallow in-source
# builds.
# Undocumented:
# https://github.com/Kitware/CMake/blob/99b1ff714b45d34ad84a5d897b4fce30a9ec3041/Source/cmMakefile.cxx#L2216
set(CMAKE_DISABLE_SOURCE_CHANGES ON)
set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)
# Just for all cases, check manually
if (CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_CURRENT_BINARY_DIR)
	message(FATAL_ERROR "In-source builds aren't allowed!") # Yet.
endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

project("sdb" C)

option(BUILD_MEMCACHE "Build memcache" OFF)
option(BUILD_TESTS "Build tests" ON)

include(GNUInstallDirs) # Defines CMAKE_INSTALL_*DIR, requires CMake 2.8.5
enable_testing()

set(SDBVER "1.0.0")

add_subdirectory(src)
if(BUILD_MEMCACHE)
	add_subdirectory(memcache)
endif()
if(BUILD_TESTS)
	add_subdirectory(test)
endif()
add_subdirectory(bindings)
