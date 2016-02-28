# ----------------------------------------------------------------------------
# GitSubmodule CMake automation.
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# GIT_SUBMODULES global for storing the submodules we want to automate on
# build.
# ----------------------------------------------------------------------------
macro (git_submodules_init VENDOR_DIR)
    set (GIT_VENDOR_DIR "${PROJECT_SOURCE_DIR}/${VENDOR_DIR}")

    ### First, get all submodules in
    if (${GIT_SUBMODULE_CHECKOUT_QUIET})
        execute_process (
            COMMAND             git submodule update --init --recursive
            WORKING_DIRECTORY   ${PROJECT_SOURCE_DIR}
            OUTPUT_QUIET
            ERROR_QUIET
        )
    else ()
        execute_process (
            COMMAND             git submodule update --init --recursive
            WORKING_DIRECTORY   ${PROJECT_SOURCE_DIR}
        )
    endif ()
endmacro (git_submodules_init)

# ----------------------------------------------------------------------------
# GetAddSubmodule adds the specified submodule at the specified version.
# Optionally appends the cmake module path.
# ----------------------------------------------------------------------------
macro (git_add_submodule SUBMODULE REMOTE)
    set ("GIT_SUBMODULE_${SUBMODULE}_REMOTE" ${REMOTE})

    # ARGV1 is the branch to checkout to
    if (${ARGC} GREATER "2")
        message (STATUS "Setting `${SUBMODULE}' to branch `${ARGV2}'")
        set ("GIT_SUBMODULE_${SUBMODULE}_VERSION" ${ARGV2})
    else ()
        message (STATUS "Setting `${SUBMODULE}' to branch `master'")
        set ("GIT_SUBMODULE_${SUBMODULE}_VERSION" "master")
    endif ()

    # ARGV3 is the path to the CMake includes directory. Simply
    # having this set will first search the string give, but will
    # also search for submodule/cmake/ directory.
    if (${ARGC} GREATER "3")
        message (STATUS "Setting `${SUBMODULE}' cmake path to `${ARGV3}' or `cmake'")
        set ("GIT_SUBMODULE_${SUBMODULE}_CMAKE" ${ARGV3})
    endif ()


    ### Then, checkout each submodule to the specified commit
    # Note: Execute separate processes here, to make sure each one is run,
    # should one crash (because of branch not existing, this, that ... whatever)
    if (NOT EXISTS "${GIT_VENDOR_DIR}/${SUBMODULE}")
        if (${GIT_SUBMODULE_CHECKOUT_QUIET})
            execute_process(
                COMMAND git submodule add ${GIT_SUBMODULE_${SUBMODULE}_REMOTE} "${GIT_VENDOR_DIR}/${SUBMODULE}"
                WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                OUTPUT_QUIET
                ERROR_QUIET
            )
        else ()
            message (STATUS "Submodule currently not in .gitmodules.")
            execute_process(
                COMMAND git submodule add ${GIT_SUBMODULE_${SUBMODULE}_REMOTE} "${GIT_VENDOR_DIR}/${SUBMODULE}"
                WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
            )
        endif ()
    endif ()

    if (${GIT_SUBMODULE_CHECKOUT_QUIET})
        execute_process(
            COMMAND             git checkout ${GIT_SUBMODULE_${SUBMODULE}_VERSION}
            WORKING_DIRECTORY   ${GIT_VENDOR_DIR}/${SUBMODULE}
            OUTPUT_QUIET
            ERROR_QUIET
        )
    else ()
        message(STATUS "Checking out `${SUBMODULE}'s commit/tag/branch `${GIT_SUBMODULE_${SUBMODULE}_VERSION}'")
        execute_process(
            COMMAND             git checkout ${GIT_SUBMODULE_${SUBMODULE}_VERSION}
            WORKING_DIRECTORY   ${GIT_VENDOR_DIR}/${SUBMODULE}
        )
    endif()

    if (${GIT_SUBMODULE_${SUBMODULE}_CMAKE})
        if (NOT ${GIT_SUBMODULE_CHECKOUT_QUIET})
            message(STATUS "Appending CMake module path.")
        endif ()

        if (EXISTS "${GIT_VENDOR_DIR}/${SUBMODULE}/${GIT_SUBMODULE_${SUBMODULE}_CMAKE}")
            list (APPEND CMAKE_MODULE_PATH "${GIT_VENDOR_DIR}/${SUBMODULE}/${GIT_SUBMODULE_${SUBMODULE}_CMAKE}")
        elseif (EXISTS "${GIT_VENDOR_DIR}/${SUBMODULE}/cmake")
            list (APPEND CMAKE_MODULE_PATH "${GIT_VENDOR_DIR}/${SUBMODULE}/cmake")
        else ()
            message (SEND_ERROR "Looked for cmake directory in `${SUBMODULE}', but could not find it.")
        endif ()
    endif ()
endmacro (git_add_submodule)

