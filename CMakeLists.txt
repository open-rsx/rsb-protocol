cmake_minimum_required(VERSION 2.6)

# Name and version
project("RSBProtocol" NONE)
string(TOLOWER "${CMAKE_PROJECT_NAME}" PROJECT_NAME_LOWERCASE)

option(EXPORT_TO_CMAKE_PACKAGE_REGISTRY "If set to ON, ${CMAKE_PROJECT_NAME} will be exported to the CMake user package registry so that downstream projects automatically find the workspace location in find_package calls." OFF)

set(RSB_PROTOCOL_WIRE_FORMAT_VERSION "8")

set(RSB_PROTOCOL_VERSION_MAJOR "0")
set(RSB_PROTOCOL_VERSION_MINOR "15")
set(RSB_PROTOCOL_VERSION_PATCH "${RSB_PROTOCOL_WIRE_FORMAT_VERSION}")
set(RSB_PROTOCOL_VERSION "${RSB_PROTOCOL_VERSION_MAJOR}.${RSB_PROTOCOL_VERSION_MINOR}.${RSB_PROTOCOL_VERSION_PATCH}")
set(VERSION_SUFFIX "${RSB_PROTOCOL_VERSION_MAJOR}.${RSB_PROTOCOL_VERSION_MINOR}")

set(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS TRUE)

find_package(RSC-CMake "${RSB_PROTOCOL_VERSION_MAJOR}.${RSB_PROTOCOL_VERSION_MINOR}" REQUIRED)
list(APPEND CMAKE_MODULE_PATH ${RSC_CMAKE_MODULE_PATH})
include(InstallFilesRecursive)

set(PROTOS "rsb/protocol/Notification.proto"
           "rsb/protocol/EventId.proto"
           "rsb/protocol/EventMetaData.proto"
           "rsb/protocol/FragmentedNotification.proto"

           "rsb/protocol/collections/EventsByScopeMap.proto"

           "rsb/protocol/operatingsystem/__package.proto"
           "rsb/protocol/operatingsystem/Process.proto"
           "rsb/protocol/operatingsystem/Host.proto"

           "rsb/protocol/introspection/__package.proto"
           "rsb/protocol/introspection/Hello.proto"
           "rsb/protocol/introspection/Bye.proto")

add_subdirectory(proto)

if(EXPORT_TO_CMAKE_PACKAGE_REGISTRY)
    message(STATUS "Exported ${CMAKE_PROJECT_NAME} to CMake package registry")
    export(PACKAGE RSBProtocol)
endif()

configure_file("${CMAKE_PROJECT_NAME}BuildTreeSettings.cmake.in"
               "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}BuildTreeSettings.cmake"
               @ONLY)
configure_file("${CMAKE_PROJECT_NAME}Config.cmake.in"
               "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake"
               @ONLY)
configure_file("${CMAKE_PROJECT_NAME}Config-version.cmake.in"
               "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config-version.cmake"
               @ONLY)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake"
              "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config-version.cmake"
        DESTINATION "share/${PROJECT_NAME_LOWERCASE}${VERSION_SUFFIX}")

install(FILES COPYING.txt
        DESTINATION "share/doc/${PROJECT_NAME_LOWERCASE}${VERSION_SUFFIX}"
        RENAME copyright)

# Package
set(CPACK_PACKAGE_VERSION_MAJOR ${RSB_PROTOCOL_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${RSB_PROTOCOL_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${RSB_PROTOCOL_VERSION_PATCH})

set(CPACK_PACKAGE_VENDOR "CoR-Lab Bielefeld University")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/COPYING.txt")

include(ProvideFlexibleCPack)
