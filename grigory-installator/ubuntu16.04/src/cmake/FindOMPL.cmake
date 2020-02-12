# - Try to find the OMPL library
# Once done this will define:
#
# OMPL_FOUND - OMPL was found
# OMPL_INCLUDE_DIRS - The OMPL include directory
# OMPL_LIBRARIES - The OMPL library
# OMPLAPP_LIBRARIES - The OMPL.app libraries
# OMPL_VERSION - The OMPL version in the form <major>.<minor>.<patchlevel>
# OMPL_MAJOR_VERSION - Major version
# OMPL_MINOR_VERSION - Minor version
# OMPL_PATCH_VERSION - Patch version

include(FindPackageHandleStandardArgs)

# user can set OMPL_PREFIX to specify the prefix path of the OMPL library
# and include directory, either as an environment variable or as an
# argument to cmake ("cmake -DOMPL_PREFIX=...")
if (NOT OMPL_PREFIX)
    set(OMPL_PREFIX $ENV{OMPL_PREFIX})
endif()

if (OMPL_FIND_VERSION)
    set(OMPL_SUFFIX "-${OMPL_FIND_VERSION}")
else()
    set(OMPL_SUFFIX "")
endif()

#MESSAGE(STATUS "OMPL_PREFIX ->       " ${OMPL_PREFIX})
#MESSAGE(STATUS "OMPL_FIND_VERSION -> " ${OMPL_FIND_VERSION})
#MESSAGE(STATUS "OMPL_SUFFIX ->      " ${OMPL_SUFFIX})

# user can set OMPL_LIB_PATH to specify the path for the OMPL library
# (analogous to OMPL_PREFIX)
if (NOT OMPL_LIB_PATH)
    set(OMPL_LIB_PATH $ENV{OMPL_LIB_PATH})
    if (NOT OMPL_LIB_PATH)
        set(OMPL_LIB_PATH ${OMPL_PREFIX})
    endif()
endif()

# user can set OMPL_INCLUDE_PATH to specify the path for the OMPL include
# directory (analogous to OMPL_PREFIX)
if (NOT OMPL_INCLUDE_PATH)
    set(OMPL_INCLUDE_PATH $ENV{OMPL_INCLUDE_PATH})
    if (NOT OMPL_INCLUDE_PATH)
        set(OMPL_INCLUDE_PATH ${OMPL_PREFIX})
    endif()
endif()

# find the OMPL library
find_library(OMPL_LIBRARY ompl
    PATHS ${OMPL_LIB_PATH}
    PATH_SUFFIXES lib lib/x86_64-linux-gnu lib/arm-linux-gnueabihf
    NO_DEFAULT_PATH
        )
#MESSAGE(STATUS "OMPL_LIB_PATH ->       " ${OMPL_LIB_PATH})
#MESSAGE(STATUS "OMPL_LIBRARY ->       " ${OMPL_LIBRARY})
if (OMPL_LIBRARY)
    if (OMPL_FIND_VERSION)
        get_filename_component(libpath ${OMPL_LIBRARY} PATH)
        #MESSAGE(STATUS "OMPL_LIBRARY ->       " ${OMPL_LIBRARY})
        #MESSAGE(STATUS "libpath ->      " ${libpath})
        file(GLOB OMPL_LIBS "${libpath}/libompl.so.${OMPL_FIND_VERSION}")
        #MESSAGE(STATUS "VAL_OMPL_LIBS ->      " "${libpath}/libompl.so.${OMPL_FIND_VERSION}")
        #MESSAGE(STATUS "OMPL_LIBS ->      " ${OMPL_LIBS})
        list(GET OMPL_LIBS -1 OMPL_LIBRARY)
    endif()
    set(OMPL_LIBRARIES "${OMPL_LIBRARY}" CACHE FILEPATH "Path to OMPL library")
endif()
# find the OMPL.app libraries
find_library(OMPLAPPBASE_LIBRARY ompl_app_base
    PATHS ${OMPL_LIB_PATH}
    PATH_SUFFIXES lib build/lib)
find_library(OMPLAPP_LIBRARY ompl_app
    PATHS ${OMPL_LIB_PATH}
    PATH_SUFFIXES lib build/lib)
if (OMPLAPPBASE_LIBRARY AND OMPLAPP_LIBRARY)
    if (OMPL_FIND_VERSION)
        get_filename_component(libpath ${OMPLAPPBASE_LIBRARY} PATH)
        #MESSAGE(STATUS "libpath ->      " ${libpath})
        file(GLOB OMPLAPPBASE_LIBS "${libpath}/libompl_app_base.so.${OMPL_FIND_VERSION}")
        list(GET OMPLAPPBASE_LIBS -1 OMPLAPPBASE_LIBRARY)
        get_filename_component(libpath ${OMPLAPP_LIBRARY} PATH)
        file(GLOB OMPLAPP_LIBS "${libpath}/libompl_app.so.${OMPL_FIND_VERSION}")
        list(GET OMPLAPP_LIBS -1 OMPLAPP_LIBRARY)
    endif()
    set(OMPLAPP_LIBRARIES "${OMPLAPPBASE_LIBRARY};${OMPLAPP_LIBRARY}" CACHE STRING "Paths to OMPL.app libraries")
endif()

# find include path
find_path(OMPL_INCLUDE_DIRS SpaceInformation.h
    PATHS ${OMPL_INCLUDE_PATH}
    PATH_SUFFIXES base "ompl${OMPL_SUFFIX}/base" "include/ompl${OMPL_SUFFIX}/base" ompl/base include/ompl/base src/ompl/base)
if (OMPL_INCLUDE_DIRS)
    string(REGEX REPLACE "/ompl/base$" "" OMPL_INCLUDE_DIRS ${OMPL_INCLUDE_DIRS})
else()
    set(OMPL_INCLUDE_DIRS "")
endif()

# find version
find_file(OMPL_CONFIG config.h
    PATHS ${OMPL_INCLUDE_DIRS}
    PATH_SUFFIXES ompl
    NO_DEFAULT_PATH)
if(OMPL_CONFIG)
    file(READ ${OMPL_CONFIG} OMPL_CONFIG_STR)
    string(REGEX REPLACE ".*OMPL_VERSION \"([0-9.]+)\".*" "\\1"
        OMPL_VERSION
        "${OMPL_CONFIG_STR}")
    string(REGEX REPLACE "([0-9]+).([0-9]+).([0-9]+)" "\\1" OMPL_MAJOR_VERSION "${OMPL_VERSION}")
    string(REGEX REPLACE "([0-9]+).([0-9]+).([0-9]+)" "\\2" OMPL_MINOR_VERSION "${OMPL_VERSION}")
    string(REGEX REPLACE "([0-9]+).([0-9]+).([0-9]+)" "\\3" OMPL_PATCH_VERSION "${OMPL_VERSION}")
endif()

find_package_handle_standard_args(OMPL DEFAULT_MSG OMPL_LIBRARIES OMPL_INCLUDE_DIRS)
