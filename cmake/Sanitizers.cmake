function(enable_sanitizers project_name)

  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL
                                             "Clang")
    option(ENABLE_COVERAGE "Enable coverage reporting for gcc/clang" FALSE)

    if(ENABLE_COVERAGE)
      target_compile_options(project_options INTERFACE --coverage -O0 -g)
      target_link_libraries(project_options INTERFACE --coverage)
    endif()

    set(SANITIZERS "")

    option(ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" FALSE)
    if(ENABLE_SANITIZER_ADDRESS)
      list(APPEND SANITIZERS "address")
    endif()

    option(ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" FALSE)
    if(ENABLE_SANITIZER_MEMORY)
      list(APPEND SANITIZERS "memory")
    endif()

    option(ENABLE_SANITIZER_UNDEFINED_BEHAVIOR
           "Enable undefined behavior sanitizer" FALSE)
    if(ENABLE_SANITIZER_UNDEFINED_BEHAVIOR)
      list(APPEND SANITIZERS "undefined")
    endif()

    option(ENABLE_SANITIZER_THREAD "Enable thread sanitizer" FALSE)
    if(ENABLE_SANITIZER_THREAD)
      list(APPEND SANITIZERS "thread")
    endif()

    list(JOIN SANITIZERS "," LIST_OF_SANITIZERS)

  endif()
  
  
if (ENABLE_SANITIZER_ADDRESS AND (ENABLE_SANITIZER_THREAD OR ENABLE_SANITIZER_MEMORY))
    message(FATAL_ERROR "SANITIZER_ADDRESS is not compatible with "
        "SANITIZER_THREAD or SANITIZER_MEMORY.")
endif ()


if (ENABLE_SANITIZER_THREAD AND (ENABLE_SANITIZER_ADDRESS OR ENABLE_SANITIZER_MEMORY))
    message(FATAL_ERROR "ENABLE_SANITIZER_THREAD is not compatible with "
        "ENABLE_SANITIZER_ADDRESS or SANITIZER_MEMORY.")
endif ()


if (ENABLE_SANITIZER_MEMORY AND (ENABLE_SANITIZER_THREAD OR ENABLE_SANITIZER_ADDRESS))
    message(FATAL_ERROR "ENABLE_SANITIZER_MEMORY is not compatible with "
        "ENABLE_SANITIZER_ADDRESS or SANITIZER_MEMORY.")
endif ()

  if(LIST_OF_SANITIZERS)
    if(NOT "${LIST_OF_SANITIZERS}" STREQUAL "")
      target_compile_options(${project_name}
                             INTERFACE -fsanitize=${LIST_OF_SANITIZERS})
      target_link_libraries(${project_name}
                            INTERFACE -fsanitize=${LIST_OF_SANITIZERS})
    endif()
  endif()

endfunction()
