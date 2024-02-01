from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMakeDeps, CMake, cmake_layout


class MyProject(ConanFile):
    requires = [
        "fmt/10.1.0",
        "boost-ext-ut/2.0.0",
        "range-v3/0.12.0",
        "eigen/3.4.0",
        "etl/20.38.6",
        "ms-gsl/4.0.0",
        "sml/1.1.9",
        "juce/7.0.5@juce/release",
    ]
    settings = "os", "arch", "compiler", "build_type", "compiler"

    def layout(self):
        cmake_layout(self)

    def generate(self):
        toolchain = CMakeToolchain(self)
        toolchain.generate()
        dependencies = CMakeDeps(self)
        dependencies.generate()

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()
