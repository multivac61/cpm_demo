cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

# create project
project(MyProject)

# add executable
add_executable(main main.cpp)

# add dependencies
include(cmake/CPM.cmake)

CPMAddPackage("gh:fmtlib/fmt#7.1.3")
CPMAddPackage("gh:boost-ext/ut@2.0.0")
CPMAddPackage("gh:ericniebler/range-v3#0.12.0")

# link dependencies
target_link_libraries(main fmt::fmt Boost::ut range-v3)
