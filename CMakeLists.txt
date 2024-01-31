cmake_minimum_required(VERSION 3.21 FATAL_ERROR)

set(CMAKE_CXX_STANDARD 20)

project(cpm-demo)

add_executable(main main.cpp)

foreach(pkg fmt JUCE ut etl sml range-v3 Microsoft.GSL Eigen3)
  find_package(${pkg} REQUIRED CONFIG)
endforeach()

target_link_libraries(main Microsoft.GSL::GSL range-v3::range-v3 sml::sml etl::etl fmt::fmt Boost::ut juce::juce_core juce::juce_recommended_config_flags juce::juce_recommended_lto_flags juce::juce_recommended_warning_flags Eigen3::Eigen)

target_compile_definitions(main PRIVATE JUCE_USE_CURL=0 JUCE_WEB_BROWSER=0)

target_link_options(main PUBLIC $<$<CXX_COMPILER_ID:AppleClang>:-Wl,-weak_reference_mismatches,weak>)

enable_testing()
add_test(NAME main COMMAND main)
