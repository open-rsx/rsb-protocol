CMAKE_MINIMUM_REQUIRED(VERSION 2.6)
SET(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS TRUE)

MACRO(INSTALL_FILES_WITH_DIRECTORY FILE_LIST)

    FOREACH(HEADER ${${FILE_LIST}})
        STRING(REGEX MATCH "(.*)[/\\]" DIR ${HEADER})
        INSTALL(FILES ${HEADER} DESTINATION share/${DIR})
    ENDFOREACH(HEADER)

ENDMACRO()

SET(PROTOFILES rsbprotocol/Attachment.proto
               rsbprotocol/Notification.proto
               rsbprotocol/introspection/PortStateChange.proto)

INSTALL_FILES_WITH_DIRECTORY(PROTOFILES)

SET(MODULE_PATH ${CMAKE_INSTALL_PREFIX}/share/cmake/Modules)
MESSAGE(STATUS "installing cmake macros to: ${MODULE_PATH}")
INSTALL(FILES FindRSBProtocol.cmake
        DESTINATION ${MODULE_PATH})
