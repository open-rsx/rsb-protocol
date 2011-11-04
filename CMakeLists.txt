CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

# Name and version
PROJECT("RSBProtocol")

SET(RSB_PROTOCOL_VERSION_MAJOR "0")
SET(RSB_PROTOCOL_VERSION_MINOR "6")
SET(RSB_PROTOCOL_VERSION_PATCH "0")
SET(RSB_PROTOCOL_VERSION "${RSB_PROTOCOL_VERSION_MAJOR}.${RSB_PROTOCOL_VERSION_MINOR}.${RSB_PROTOCOL_VERSION_PATCH}")
SET(RSB_PROTOCOL_WIRE_FORMAT_VERSION "8")

SET(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS TRUE)

MATH(EXPR WIRE_FORMAT_VERSION_FIELD_NUMBER
     "100 + ${RSB_PROTOCOL_WIRE_FORMAT_VERSION}")
CONFIGURE_FILE(rsb/protocol/Notification.proto.in
               "${CMAKE_CURRENT_BINARY_DIR}/rsb/protocol/Notification.proto"
               @ONLY)

INSTALL(FILES "${CMAKE_CURRENT_BINARY_DIR}/rsb/protocol/Notification.proto"
              rsb/protocol/EventId.proto
              rsb/protocol/EventMetaData.proto
              rsb/protocol/FragmentedNotification.proto
        DESTINATION share/rsbprotocol/rsb/protocol/)
INSTALL(FILES rsb/protocol/collections/EventsByScopeMap.proto
        DESTINATION share/rsbprotocol/rsb/protocol/collections)

SET(PROTOFILES rsb/protocol/Notification.proto
               rsb/protocol/EventId.proto
               rsb/protocol/EventMetaData.proto
               rsb/protocol/FragmentedNotification.proto
               rsb/protocol/collections/EventsByScopeMap.proto)
CONFIGURE_FILE(RSBProtocolConfig.cmake.in
               ${CMAKE_CURRENT_BINARY_DIR}/RSBProtocolConfig.cmake
               @ONLY)
CONFIGURE_FILE(RSBProtocolConfig-version.cmake.in
               ${CMAKE_CURRENT_BINARY_DIR}/RSBProtocolConfig-version.cmake
               @ONLY)
INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/RSBProtocolConfig.cmake
              ${CMAKE_CURRENT_BINARY_DIR}/RSBProtocolConfig-version.cmake
        DESTINATION share/rsbprotocol)

# Package
SET(CPACK_GENERATOR "STGZ;TGZ;TZ")
SET(CPACK_PACKAGE_VENDOR "CoR-Lab Bielefeld University")
SET(CPACK_PACKAGE_VERSION_MAJOR ${RSB_PROTOCOL_VERSION_MAJOR})
SET(CPACK_PACKAGE_VERSION_MINOR ${RSB_PROTOCOL_VERSION_MINOR})
SET(CPACK_PACKAGE_VERSION_PATCH ${RSB_PROTOCOL_VERSION_PATCH})
SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/COPYING.txt")

IF(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    SET(CPACK_GENERATOR "${CPACK_GENERATOR};DEB")
    SET(CPACK_DEBIAN_PACKAGE_NAME "rsbprotocol")
    SET(CPACK_DEBIAN_PACKAGE_VERSION ${RSB_PROTOCOL_VERSION_MAJOR}.${RSB_PROTOCOL_VERSION_MINOR}.${RSB_PROTOCOL_VERSION_PATCH})
    SET(CPACK_DEBIAN_PACKAGE_MAINTAINER "Sebastian Wrede (swrede@techfak.uni-bielefeld.de)")
    SET(CPACK_DEBIAN_PACKAGE_DESCRIPTION "RSB Protocol Definitions")
    SET(CPACK_DEBIAN_PACKAGE_PRIORITY "optional")
    SET(CPACK_DEBIAN_PACKAGE_SECTION "devel")
    SET(CPACK_DEBIAN_ARCHITECTURE ${CMAKE_SYSTEM_PROCESSOR})
    SET(CPACK_DEBIAN_PACKAGE_DEPENDS "libc6, libprotoc-dev, protobuf-compiler, rsc")
    SET(CPACK_DEBIAN_PACKAGE_SUGGESTS "doxygen, sloccount, cppcheck, lcov")
ENDIF(CMAKE_SYSTEM_NAME STREQUAL "Linux")
INCLUDE(CPack)
