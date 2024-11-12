include_guard(GLOBAL)

function(morpheus_utils_configure_indicators)
  list(APPEND CMAKE_MESSAGE_CONTEXT "indicators")

  morpheus_utils_assert_cpm_initialized()
  set(INDICATORS_VERSION "2.3" CACHE STRING "Version of indicators to use")

  rapids_cpm_find(indicators ${INDICATORS_VERSION}
    GLOBAL_TARGETS
      indicators indicators::indicators
    BUILD_EXPORT_SET
      ${PROJECT_NAME}-exports
    INSTALL_EXPORT_SET
      ${PROJECT_NAME}-exports
    CPM_ARGS
      GIT_REPOSITORY https://github.com/p-ranav/indicators.git
      GIT_TAG "v${INDICATORS_VERSION}"
      GIT_SHALLOW TRUE
      OPTIONS "INDICATORS_INSTALL ON"
              "INDICATORS_TEST OFF"
  )

  list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endfunction()
