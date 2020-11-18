cmake_minimum_required(VERSION 3.9)

project(zenoh_pico_vendor)

find_package(ament_cmake REQUIRED)

set(ZENOH_PICO_REV "034c57bfec721d7b51bd767d28d2ce02588ac35e")
macro(build_zenoh_pico)
  set(extra_cmake_args)

  get_property(multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
  if(NOT multi_config AND DEFINED CMAKE_BUILD_TYPE)
    list(APPEND extra_cmake_args -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE})
  endif()

  include(ExternalProject)
  externalproject_add(zenoh-pico-${ZENOH_PICO_REV}
    GIT_REPOSITORY https://github.com/eclipse-zenoh/zenoh-pico.git
    GIT_TAG ${ZENOH_PICO_REV}
    GIT_SHALLOW ON
    TIMEOUT 60
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/zenoh-pico_install
      ${extra_cmake_args}
  )

  # The external project will install to the build folder, but we'll install that on make install.
  install(
    DIRECTORY
      ${CMAKE_CURRENT_BINARY_DIR}/zenoh-pico_install/
    DESTINATION
      ${CMAKE_INSTALL_PREFIX}
  )
endmacro()

build_zenoh_pico()

install(DIRECTORY cmake DESTINATION share/${PROJECT_NAME})

ament_package(CONFIG_EXTRAS zenoh_pico_vendor-extras.cmake)
