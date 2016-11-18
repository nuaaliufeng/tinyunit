if(DEFINED TINYUNIT_ADD_TEST_CMAKE_HELPER_)
  return()
else()
  set(TINYUNIT_ADD_TEST_CMAKE_HELPER_ 1)
endif()

set(TINYUNIT_TEST_WRAPPER_CMAKE "${CMAKE_CURRENT_LIST_DIR}/tinyunit_run_test_wrapper.cmake")

function (tinyunit_add_test TINYUNIT_TEST_NAME TINYUNIT_TEST_CODE)
  if (ARGC GREATER 2)
    set (TINYUNIT_TEST_DEPS "${ARGV2}")
  else ()
    set (TINYUNIT_TEST_DEPS "")
  endif ()
  if (ARGC GREATER 3)
    set (TINYUNIT_TEST_COMPILE_DEFS "${ARGV3}")
  else ()
    set (TINYUNIT_TEST_COMPILE_DEFS "")
  endif ()
  if (ARGC GREATER 4)
    set (TINYUNIT_TEST_LINK_FLAGS "${ARGV4}")
  else ()
    set (TINYUNIT_TEST_LINK_FLAGS "")
  endif ()
  set (TINYUNIT_TEST_TARGET_NAME "test_${TINYUNIT_TEST_NAME}")
  add_executable (${TINYUNIT_TEST_TARGET_NAME} ${TINYUNIT_TEST_CODE})
  target_link_libraries (
    ${TINYUNIT_TEST_TARGET_NAME}
    tinyunit
    ${TINYUNIT_TEST_DEPS}
  )
  target_compile_definitions (
    ${TINYUNIT_TEST_TARGET_NAME}
    PRIVATE
    ${TINYUNIT_TEST_COMPILE_DEFS}
  )
  set_target_properties (
    ${TINYUNIT_TEST_TARGET_NAME}
    PROPERTIES
    LINK_FLAGS "${TINYUNIT_TEST_LINK_FLAGS}"
  )
  set (TINYUNIT_TEST_RETVAL 0)
  if (DEFINED ${TINYUNIT_TEST_NAME}_retval)
    set (TINYUNIT_TEST_RETVAL ${${TINYUNIT_TEST_NAME}_retval})
  endif ()
  add_test (
    NAME "${TINYUNIT_TEST_TARGET_NAME}"
    COMMAND "${CMAKE_COMMAND}"
    "-DTINYUNIT_TEST_CMD=$<TARGET_FILE:${TINYUNIT_TEST_TARGET_NAME}>"
    "-DTINYUNIT_TEST_RETVAL=${TINYUNIT_TEST_RETVAL}"
    "-P" "${TINYUNIT_TEST_WRAPPER_CMAKE}"
  )
endfunction ()
