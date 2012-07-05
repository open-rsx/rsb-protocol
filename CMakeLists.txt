CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

# Name and version
PROJECT("RSBProtocol")

OPTION(EXPORT_TO_CMAKE_PACKAGE_REGISTRY "If set to ON, RSBProtocol will be exported to the CMake user package registry so that downstream projects automatically find the workspace location in find_package calls." OFF)

SET(RSB_PROTOCOL_VERSION_MAJOR "0")
SET(RSB_PROTOCOL_VERSION_MINOR "7")
SET(RSB_PROTOCOL_VERSION_PATCH "0")
SET(RSB_PROTOCOL_VERSION "${RSB_PROTOCOL_VERSION_MAJOR}.${RSB_PROTOCOL_VERSION_MINOR}.${RSB_PROTOCOL_VERSION_PATCH}")
SET(RSB_PROTOCOL_WIRE_FORMAT_VERSION "8")

SET(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS TRUE)

FIND_PACKAGE(RSC "${RSB_PROTOCOL_VERSION_MAJOR}.${RSB_PROTOCOL_VERSION_MINOR}" REQUIRED)
LIST(APPEND CMAKE_MODULE_PATH ${RSC_CMAKE_MODULE_PATH})
INCLUDE(InstallFilesRecursive)

MATH(EXPR WIRE_FORMAT_VERSION_FIELD_NUMBER
     "100 + ${RSB_PROTOCOL_WIRE_FORMAT_VERSION}")

# configre all files so that they are all in the build tree. This makes handling
# protocol buffers easier because there is only one single root

SET(ALL_SOURCE_PROTOS "${CMAKE_CURRENT_SOURCE_DIR}/rsb/protocol/Notification.proto"
                      "${CMAKE_CURRENT_SOURCE_DIR}/rsb/protocol/EventId.proto"
                      "${CMAKE_CURRENT_SOURCE_DIR}/rsb/protocol/EventMetaData.proto"
                      "${CMAKE_CURRENT_SOURCE_DIR}/rsb/protocol/FragmentedNotification.proto"
                      "${CMAKE_CURRENT_SOURCE_DIR}/rsb/protocol/collections/EventsByScopeMap.proto")

SET(ALL_BINARY_PROTOS)
SET(ALL_REL_PROTOS)
FOREACH(PROTO ${ALL_SOURCE_PROTOS})

    FILE(RELATIVE_PATH REL_PATH ${CMAKE_CURRENT_SOURCE_DIR} ${PROTO})
    SET(BIN_PATH "${CMAKE_CURRENT_BINARY_DIR}/${REL_PATH}")
    LIST(APPEND ALL_REL_PROTOS ${REL_PATH})
    LIST(APPEND ALL_BINARY_PROTOS ${BIN_PATH})

    CONFIGURE_FILE(${PROTO} ${BIN_PATH} @ONLY)

ENDFOREACH()

INSTALL_FILES_RECURSIVE(share/rsbprotocol ALL_BINARY_PROTOS)

IF(EXPORT_TO_CMAKE_PACKAGE_REGISTRY)
    MESSAGE(STATUS "Exported RSBProtocol to CMake package registry")
    EXPORT(PACKAGE RSBProtocol)
ENDIF()

CONFIGURE_FILE(RSBProtocolBuildTreeSettings.cmake.in
               ${CMAKE_CURRENT_BINARY_DIR}/RSBProtocolBuildTreeSettings.cmake
               @ONLY)
CONFIGURE_FILE(RSBProtocolConfig.cmake.in
               ${CMAKE_CURRENT_BINARY_DIR}/RSBProtocolConfig.cmake
               @ONLY)
CONFIGURE_FILE(RSBProtocolConfig-version.cmake.in
               ${CMAKE_CURRENT_BINARY_DIR}/RSBProtocolConfig-version.cmake
               @ONLY)
INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/RSBProtocolConfig.cmake
              ${CMAKE_CURRENT_BINARY_DIR}/RSBProtocolConfig-version.cmake
        DESTINATION share/rsbprotocol)
        
INSTALL(FILES COPYING.txt DESTINATION share/doc/rsbprotocol RENAME copyright)

# Package
SET(CPACK_PACKAGE_VERSION_MAJOR ${RSB_PROTOCOL_VERSION_MAJOR})
SET(CPACK_PACKAGE_VERSION_MINOR ${RSB_PROTOCOL_VERSION_MINOR})
SET(CPACK_PACKAGE_VERSION_PATCH ${RSB_PROTOCOL_VERSION_PATCH})

SET(CPACK_PACKAGE_VENDOR "CoR-Lab Bielefeld University")
SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/COPYING.txt")

INCLUDE(ProvideFlexibleCPack)
