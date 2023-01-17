cmake_minimum_required(VERSION 3.22)

project(EmbedPythonDemo CXX)

# Find Python.
find_package(Python REQUIRED COMPONENTS Development.Embed)
message("Python include dir: ${Python_INCLUDE_DIRS}")
message("Python library dir: ${Python_LIBRARY_DIRS}")
message("Python libraries: ${Python_LIBRARIES}")
message("Python version: ${Python_VERSION}")
include_directories(${Python_INCLUDE_DIRS})
link_directories(${Python_LIBRARY_DIRS})

# Create the C++ executable that will embed Python.
add_executable(EmbedPythonDemo main.cpp)

# Link against CPython.
target_link_libraries(
  EmbedPythonDemo
  ${Python_LIBRARIES}
)

# On Windows, we need `python.dll` in the same directory as our
# executable.  The officially supported mechanism for this is to
# download the Python Embeddable Package, extract all its contents
# and package that as part of our installation process.  Let's do
# this for the test suite.
if (WIN32)
  # Compute the URL to the embeddable package based on the Python
  # version and the executable's hardward architecture.
  if ("${CMAKE_SIZEOF_VOID_P}" EQUAL "8")
    set(PYTHON_EMBEDDABLE_PACKAGE_URL
      "https://www.python.org/ftp/python/${Python_VERSION}/python-${Python_VERSION}-embed-amd64.zip"
    )
  else()
    set(PYTHON_EMBEDDABLE_PACKAGE_URL
      "https://www.python.org/ftp/python/${Python_VERSION}/python-${Python_VERSION}-embed-win32.zip"
    )
  endif()
  # Download the embeddable package.
  file(DOWNLOAD
    ${PYTHON_EMBEDDABLE_PACKAGE_URL}
    ${CMAKE_CURRENT_BINARY_DIR}/python.zip
    TLS_VERIFY ON
  )
  # Extract its contents into the binrary directory.
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E tar xzf
    ${CMAKE_CURRENT_BINARY_DIR}/python.zip
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  )
endif()

# Add simple test to confirm that the program works.
enable_testing()
add_test(
  NAME HelloWorld
  COMMAND EmbedPythonDemo
)
set_tests_properties(HelloWorld PROPERTIES
  PASS_REGULAR_EXPRESSION "Hello, world!"
)
