cmake_minimum_required(VERSION 2.6)

# Name and version
project("RSBProtocol")
string(TOLOWER "${CMAKE_PROJECT_NAME}" PROJECT_NAME_LOWERCASE)

option(EXPORT_TO_CMAKE_PACKAGE_REGISTRY "If set to ON, ${CMAKE_PROJECT_NAME} will be exported to the CMake user package registry so that downstream projects automatically find the workspace location in find_package calls." OFF)

set(RSB_PROTOCOL_WIRE_FORMAT_VERSION "8")

set(RSB_PROTOCOL_VERSION_MAJOR "0")
set(RSB_PROTOCOL_VERSION_MINOR "11")
set(RSB_PROTOCOL_VERSION_PATCH "${RSB_PROTOCOL_WIRE_FORMAT_VERSION}")
set(RSB_PROTOCOL_VERSION "${RSB_PROTOCOL_VERSION_MAJOR}.${RSB_PROTOCOL_VERSION_MINOR}.${RSB_PROTOCOL_VERSION_PATCH}")
set(VERSION_SUFFIX "${RSB_PROTOCOL_VERSION_MAJOR}.${RSB_PROTOCOL_VERSION_MINOR}")

set(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS TRUE)

find_package(RSC "${RSB_PROTOCOL_VERSION_MAJOR}.${RSB_PROTOCOL_VERSION_MINOR}" REQUIRED)
list(APPEND CMAKE_MODULE_PATH ${RSC_CMAKE_MODULE_PATH})
include(InstallFilesRecursive)

math(EXPR WIRE_FORMAT_VERSION_FIELD_NUMBER
     "100 + ${RSB_PROTOCOL_WIRE_FORMAT_VERSION}")

# configre all files so that they are all in the build tree. This makes handling
# protocol buffers easier because there is only one single root

set(PROTO_DIR "${CMAKE_CURRENT_SOURCE_DIR}/proto/")
set(ALL_SOURCE_PROTOS "${PROTO_DIR}/rsb/protocol/Notification.proto"
                      "${PROTO_DIR}/rsb/protocol/EventId.proto"
                      "${PROTO_DIR}/rsb/protocol/EventMetaData.proto"
                      "${PROTO_DIR}/rsb/protocol/FragmentedNotification.proto"

                      "${PROTO_DIR}/rsb/protocol/collections/EventsByScopeMap.proto"

                      "${PROTO_DIR}/rsb/protocol/operatingsystem/__package.proto"
                      "${PROTO_DIR}/rsb/protocol/operatingsystem/Process.proto"

                      "${PROTO_DIR}/rsb/protocol/introspection/__package.proto"
                      "${PROTO_DIR}/rsb/protocol/introspection/Hello.proto"
                      "${PROTO_DIR}/rsb/protocol/introspection/Bye.proto")

set(ALL_BINARY_PROTOS)
set(ALL_REL_PROTOS)
foreach(PROTO ${ALL_SOURCE_PROTOS})

    file(RELATIVE_PATH REL_PATH ${PROTO_DIR} ${PROTO})
    set(BIN_PATH "${CMAKE_CURRENT_BINARY_DIR}/${REL_PATH}")
    list(APPEND ALL_REL_PROTOS ${REL_PATH})
    list(APPEND ALL_BINARY_PROTOS ${BIN_PATH})

    configure_file(${PROTO} ${BIN_PATH} @ONLY)

endforeach()

install_files_recursive("share/${PROJECT_NAME_LOWERCASE}${VERSION_SUFFIX}"
                        ALL_BINARY_PROTOS)

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
