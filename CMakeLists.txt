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
CPMAddPackage("gh:juce-framework/JUCE#7.0.8")

# link dependencies
target_link_libraries(main PUBLIC fmt::fmt Boost::ut range-v3 juce::juce_core juce::juce_recommended_config_flags juce::juce_recommended_lto_flags juce::juce_recommended_warning_flags)


target_link_options(main PUBLIC $<$<CXX_COMPILER_ID:AppleClang>:-Wl,-weak_reference_mismatches,weak>)
