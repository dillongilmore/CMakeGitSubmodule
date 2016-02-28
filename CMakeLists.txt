# ----------------------------------------------------------------------------
# Test/Entrypoint for the GitSubmodules CMake Module.
# ----------------------------------------------------------------------------
cmake_minimum_required (VERSION 3.2)
project (GitSubmodule C)

list (APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR})

# Setup
if (EXISTS "${PROJECT_SOURCE_DIR}/test/.gitmodules")
    configure_file (
        "${PROJECT_SOURCE_DIR}/test/.gitmodules"
        "${PROJECT_SOURCE_DIR}/.gitmodules"
    )
else ()
    
endif ()

include (GitSubmodule)

git_submodules_init (".gitvendor")

git_add_submodule ("llvm" "https://github.com/llvm-mirror/llvm" "release_38" "cmake")
git_add_submodule ("clang" "https://github.com/llvm-mirror/clang" "release_38" "true")
git_add_submodule ("lldb" "https://github.com/llvm-mirror/lldb" "release_38")
git_add_submodule ("lighttpd2" "https://github.com/lighttpd/lighttpd2")
git_add_submodule ("lighttpd1.4" "https://github.com/lighttpd/lighttpd1.4")

# Test

# Destroy
if (EXISTS "${PROJECT_SOURCE_DIR}/.gitmodules")
    file (REMOVE "${PROJECT_SOURCE_DIR}/.gitmodules")
endif ()

