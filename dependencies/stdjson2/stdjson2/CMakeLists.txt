cmake_minimum_required(VERSION 3.20)
project(StdJson2Wrapper LANGUAGES C)

add_library(${PROJECT_NAME}
    src/stdjson2_string_escape.c
    src/stdjson2_utils.c
)

set_target_properties(${PROJECT_NAME} PROPERTIES POSITION_INDEPENDENT_CODE ON)

if (CMAKE_C_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(${PROJECT_NAME} PRIVATE
        -Wall                   # Enables standard compiler warnings for code quality
        -Wdate-time             # Warns if macros like __DATE__ are used, prevents non-reproducible builds
        -fsigned-char           # Forces char to be signed, avoids ABI inconsistencies across platforms
        -pipe                   # Uses OS pipes instead of temporary files, speeds up compilation
        -fno-common             # Places uninitialized globals in BSS, improves compile times and symbol resolution
        -fno-strict-aliasing    # Prevents aggressive optimizations that break type-punning (e.g., JSON unions/void*)
        -fno-omit-frame-pointer # Keeps the frame pointer, aids profiling/debugging deep call stacks (minor perf cost)
        -fstack-protector-all   # Adds stack canaries to all functions for security (slight runtime overhead)
    )

    if (MINGW)
        target_compile_options(${PROJECT_NAME} PRIVATE
            -m64          # Forces 64-bit x86_64 target, overrides defaults for cross-compile safety
            -Wa,-mbig-obj # Required for large object files on Windows
        )
        target_link_options(${PROJECT_NAME} PRIVATE
            -Wl,--no-insert-timestamp # Improves build cache hits by removing timestamp from PE headers
        )

        find_program(LLD_PATH lld${CMAKE_EXECUTABLE_SUFFIX})
        if(LLD_PATH)
            message(STATUS "Found lld: ${LLD_PATH}. Using lld.")
            file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/toolchain/)
            file(CREATE_LINK ${LLD_PATH} ${CMAKE_BINARY_DIR}/toolchain/ld.lld${CMAKE_EXECUTABLE_SUFFIX} SYMBOLIC)
            target_link_options(${PROJECT_NAME} PRIVATE -B${CMAKE_BINARY_DIR}/toolchain/ -fuse-ld=lld)
        endif()
    elseif(NOT APPLE)
        if(CMAKE_BUILD_TYPE MATCHES "Release")
            target_compile_options(${PROJECT_NAME} PRIVATE
                -D_FORTIFY_SOURCE=2 # Replaces libc calls with secure, faster bounds-checking variants
                -O2                 # Standard optimizations
            )
        endif()

        target_link_options(${PROJECT_NAME} PRIVATE
            -Wl,-z,relro       # Hardens ELF binaries against memory corruption attacks
            -Wl,-z,now         # Disables lazy binding, resolving all symbols at startup
            -Wl,-z,noexecstack # Marks the stack as non-executable to prevent stack-based shellcode exploits
        )
    endif()

elseif (MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE
        /EHsc- # Disables C++ exceptions
        /O2    # Maximizes speed
    )
    target_compile_definitions(${PROJECT_NAME} PRIVATE _HAS_EXCEPTIONS=0)
endif()
