cmake_minimum_required(VERSION 3.21 FATAL_ERROR)

set(CMAKE_CXX_STANDARD 20)

# create project
project(cpm-demo)

# add executable
add_executable(main main.cpp)

find_package(fmt REQUIRED CONFIG)
find_package(range-v3 REQUIRED CONFIG)
find_package(JUCE REQUIRED)
find_package(Eigen3 3.3 REQUIRED CONFIG)
find_package(Microsoft.GSL REQUIRED CONFIG)
find_package(ut REQUIRED CONFIG)

target_link_libraries(main fmt::fmt Boost::ut range-v3::range-v3 juce::juce_core juce::juce_recommended_config_flags juce::juce_recommended_lto_flags juce::juce_recommended_warning_flags Eigen3::Eigen Microsoft.GSL::GSL)

target_compile_definitions(main PRIVATE JUCE_USE_CURL=0 JUCE_WEB_BROWSER=0)

target_link_options(main PUBLIC $<$<CXX_COMPILER_ID:AppleClang>:-Wl,-weak_reference_mismatches,weak>)

enable_testing()
add_test(NAME main COMMAND main)
