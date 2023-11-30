# from conan import ConanFile
# from conan.tools.cmake import CMakeToolchain, CMake, cmake_layout, CMakeDeps
#
# class MyProjectConan(ConanFile):
#     requires = [
#         "fmt/10.1.0",
#         "range-v3/0.12.0",
#         "eigen/3.3.9",
#         "ms-gsl/4.0.0",
#         "juce/7.0.5@juce/release"
#     ]
#     settings = "os", "arch", "compiler", "build_type"
#     default_options = {"*:shared": False, "juce/*:build_extras": True }
#
#     def layout(self):
#         cmake_layout(self)
#
#     # def generate(self): 
#     #     toolchain = CMakeToolchain(self)
#     #     toolchain.generate()
#     #     dependencies = CMakeDeps(self)
#     #     dependencies.generate()
#
#     def build(self):
#         cmake = CMake(self)
#         cmake.configure()
#         cmake.build()
#
#     def generate(self): 
#         toolchain = CMakeToolchain(self)
#         dependencies = CMakeDeps(self)
#
#         if self.settings.os == "Windows":
#             toolchain.generator = "Visual Studio 17 2022"
#         else:
#             toolchain.generator = "Ninja"
#
#         toolchain.generate()
#         dependencies.generate()


# conanfile.py
from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMakeDeps, CMake, cmake_layout

class MyProject(ConanFile):
    requires = [
        "fmt/10.1.0",
        "boost-ext-ut/2.0.0",
        "range-v3/0.12.0",
        "eigen/3.4.0",
        "ms-gsl/4.0.0",
        "juce/7.0.5@juce/release"
    ]
    name = "MyPlugin"
    version = "0.4.2"
    user = "octocat"
    channel = "testing"
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
