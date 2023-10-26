cmake_minimum_required(VERSION 3.21 FATAL_ERROR)

# create project
project(MyProject)

# add executable
add_executable(main main.cpp)

# add dependencies
include(cmake/CPM.cmake)

CPMAddPackage("gh:fmtlib/fmt#7.1.3")
CPMAddPackage("gh:boost-ext/ut@2.0.0")
CPMAddPackage("gh:ericniebler/range-v3#0.12.0")
CPMAddPackage(NAME juce 
  GITHUB_REPOSITORY "juce-framework/JUCE"
  GIT_TAG 7.0.8
  OPTIONS "JUCE_MODULES_ONLY ON") # Used in order to note have to build juceaide

# link dependencies
target_link_libraries(main fmt::fmt Boost::ut range-v3 juce::juce_core juce::juce_recommended_config_flags juce::juce_recommended_lto_flags juce::juce_recommended_warning_flags)

target_compile_definitions(main PRIVATE JUCE_USE_CURL=0 JUCE_WEB_BROWSER=0)

target_link_options(main PUBLIC $<$<CXX_COMPILER_ID:AppleClang>:-Wl,-weak_reference_mismatches,weak>)

enable_testing()
add_test(NAME main COMMAND main)
