# == DO NOT EDIT THE FOLLOWING LINES for the Raspberry Pi Pico VS Code Extension to work ==
if(WIN32)
    set(USERHOME $ENV{USERPROFILE})
else()
    set(USERHOME $ENV{HOME})
endif()
set(sdkVersion 2.3.0)
set(toolchainVersion 14_2_Rel1)
set(picotoolVersion 2.3.0)
set(picoVscode ${USERHOME}/.pico-sdk/cmake/pico-vscode.cmake)
if (EXISTS ${picoVscode})
    include(${picoVscode})
endif()
# ====================================================================================
cmake_minimum_required(VERSION 4.3.4)

# initialize the SDK based on PICO_SDK_PATH
# note: this must happen before project()
include(pico_sdk_import.cmake)

project(PICOLECO_cart)

set(PICO_BOARD_HEADER_DIRS ${CMAKE_SOURCE_DIR}) 
set(PICO_BOARD myboard)

# initialize the Raspberry Pi Pico SDK
pico_sdk_init()

add_custom_command(
    OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/waitforreset.bin"
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/waitforreset.asm
    COMMAND ${CMAKE_COMMAND} -E echo "assembling... waitforreset.asm"
    COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/../../CvBasicCompiler/cvbasic/gasm80.exe ${CMAKE_CURRENT_SOURCE_DIR}/waitforreset.asm 
        -o ${CMAKE_CURRENT_SOURCE_DIR}/waitforreset.bin 
    COMMAND ${CMAKE_COMMAND} -E echo "completed assembling... waitforreset.asm"
   COMMENT "Generating source code from script..."
    VERBATIM
)

add_custom_command(
    OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/waitforreset.h"
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/waitforreset.bin
    COMMAND ${CMAKE_COMMAND} -E echo "converting to header... waitforreset.asm"
    COMMAND ${CMAKE_COMMAND} 
        -DSOURCE_FILE=${CMAKE_CURRENT_SOURCE_DIR}/waitforreset.bin
        -DVARIABLE_NAME=_acwaitforreset
        -DHEADER_FILE=${CMAKE_CURRENT_SOURCE_DIR}/waitforreset.h
        -P "${CMAKE_CURRENT_SOURCE_DIR}/bin2h.cmake"
    COMMAND ${CMAKE_COMMAND} -E echo "completed converting to header... waitforreset.asm"
    COMMENT "Generating source code from script..."
    VERBATIM
)

add_custom_command(
    OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/waitforreset_pencil.bin"
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/waitforreset.asm
    COMMAND ${CMAKE_COMMAND} -E echo "assembling... waitforreset_pencil.asm"
    COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/../../CvBasicCompiler/cvbasic/gasm80.exe -dpencil=1 ${CMAKE_CURRENT_SOURCE_DIR}/waitforreset.asm 
        -o ${CMAKE_CURRENT_SOURCE_DIR}/waitforreset_pencil.bin 
    COMMAND ${CMAKE_COMMAND} -E echo "completed assembling... waitforreset_pencil.asm"
    COMMENT "Generating source code from script..."
    VERBATIM
)

add_custom_command(
    OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/waitforreset_pencil.h"
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/waitforreset.bin
    COMMAND ${CMAKE_COMMAND} -E echo "converting to header... waitforreset_pencil.asm"
    COMMAND ${CMAKE_COMMAND} 
        -DSOURCE_FILE=${CMAKE_CURRENT_SOURCE_DIR}/waitforreset_pencil.bin
        -DVARIABLE_NAME=_acwaitforreset
        -DHEADER_FILE=${CMAKE_CURRENT_SOURCE_DIR}/waitforreset_pencil.h
        -P "${CMAKE_CURRENT_SOURCE_DIR}/bin2h.cmake"
    COMMAND ${CMAKE_COMMAND} -E echo "completed converting to header... waitforreset_pencil.asm"
    COMMENT "Generating source code from script..."
    VERBATIM
)

add_custom_command(
    OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/rom.h"
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/../cvbasic/splash.bas
    COMMAND ${CMAKE_COMMAND} -E echo "compiling... splash.bas"
    COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR}/../../CvBasicCompiler/cvbasic
    COMMAND cvbasic.exe ${CMAKE_CURRENT_SOURCE_DIR}/../cvbasic/splash.bas 
        ${CMAKE_CURRENT_SOURCE_DIR}/../cvbasic/splash.asm
    COMMAND ${CMAKE_COMMAND} -E echo "assembling... splash.asm"
    COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/../../CvBasicCompiler/cvbasic/gasm80.exe 
        ${CMAKE_CURRENT_SOURCE_DIR}/../cvbasic/splash.asm 
        -o ${CMAKE_CURRENT_SOURCE_DIR}/../cvbasic/splash.bin
    COMMAND ${CMAKE_COMMAND} -E echo "Converting... splash.bin"
    COMMAND ${CMAKE_COMMAND} 
        -DSOURCE_FILE=${CMAKE_CURRENT_SOURCE_DIR}/../cvbasic/splash.bin
        -DVARIABLE_NAME=_acsplash
        -DHEADER_FILE=${CMAKE_CURRENT_SOURCE_DIR}/rom.h
        -P "${CMAKE_CURRENT_SOURCE_DIR}/bin2h.cmake"
    COMMAND ${CMAKE_COMMAND} -E echo "Conversion complete: rom.h generated"
    COMMENT "Generating source code from script..."
    VERBATIM
)

add_custom_command(
    OUTPUT "${CMAKE_CURRENT_SOURCE_DIR}/rom_pencil.h"
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/../cvbasic/splash.bas
    COMMAND ${CMAKE_COMMAND} -E echo "compiling... splash.bas for pencil"
    COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR}/../../CvBasicCompiler/cvbasic
    COMMAND cvbasic.exe --pencil ${CMAKE_CURRENT_SOURCE_DIR}/../cvbasic/splash.bas 
        ${CMAKE_CURRENT_SOURCE_DIR}/../cvbasic/splash_pencil.asm
    COMMAND ${CMAKE_COMMAND} -E echo "assembling... splash_pencil.asm"
    COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/../../CvBasicCompiler/cvbasic/gasm80.exe 
        ${CMAKE_CURRENT_SOURCE_DIR}/../cvbasic/splash_pencil.asm 
        -o ${CMAKE_CURRENT_SOURCE_DIR}/../cvbasic/splash_pencil.bin
    COMMAND ${CMAKE_COMMAND} -E echo "Converting... splash_pencil.bin"
    COMMAND ${CMAKE_COMMAND} 
        -DSOURCE_FILE=${CMAKE_CURRENT_SOURCE_DIR}/../cvbasic/splash_pencil.bin
        -DVARIABLE_NAME=_acsplash
        -DHEADER_FILE=${CMAKE_CURRENT_SOURCE_DIR}/rom_pencil.h
        -P "${CMAKE_CURRENT_SOURCE_DIR}/bin2h.cmake"
    COMMAND ${CMAKE_COMMAND} -E echo "Conversion complete: rom_pencil.h generated"
    COMMENT "Generating source code from script..."
    VERBATIM
)

add_executable(PICOLECO_cart)
add_executable(PICOLECO_cart_Pencil)

# 16megs of flash on purple pico clones
target_compile_definitions(PICOLECO_cart PRIVATE
    PICO_FLASH_SIZE_BYTES=16777216
)
target_compile_definitions(PICOLECO_cart_Pencil PRIVATE
    PICO_FLASH_SIZE_BYTES=16777216
    pencil=1
)
#target_compile_options(PICOLECO_cart PRIVATE "-Os")
#target_compile_options(PICOLECO_cart_Pencil PRIVATE "-Os")
add_compile_options(-Os)

add_definitions(-DUSE_TINYUSB -DCFG_TUSB_RHPORT0_MODE) 

#pico_set_linker_script(PICOLECO_cart ${CMAKE_CURRENT_SOURCE_DIR}/memmap_custom.ld)

target_sources(PICOLECO_cart PUBLIC 
    ${CMAKE_CURRENT_LIST_DIR}/rom.h
    ${CMAKE_CURRENT_LIST_DIR}/waitforreset.h
    ${CMAKE_CURRENT_LIST_DIR}/main.c 
    ${CMAKE_CURRENT_LIST_DIR}/coleco_cart.c 
    ${CMAKE_CURRENT_LIST_DIR}/msc_disk.c 
    ${CMAKE_CURRENT_LIST_DIR}/usb_descriptors.c 
    ${CMAKE_CURRENT_LIST_DIR}/fatfs_disk.c 
    ${CMAKE_CURRENT_LIST_DIR}/flash_fs.c 
    ${CMAKE_CURRENT_LIST_DIR}/fatfs/ff.c 
    ${CMAKE_CURRENT_LIST_DIR}/fatfs/ffunicode.c 
    ${CMAKE_CURRENT_LIST_DIR}/fatfs/diskio.c
)

target_sources(PICOLECO_cart_Pencil PUBLIC 
    ${CMAKE_CURRENT_LIST_DIR}/rom_pencil.h
    ${CMAKE_CURRENT_LIST_DIR}/waitforreset_pencil.h
    ${CMAKE_CURRENT_LIST_DIR}/main.c
    ${CMAKE_CURRENT_LIST_DIR}/coleco_cart.c
    ${CMAKE_CURRENT_LIST_DIR}/msc_disk.c
    ${CMAKE_CURRENT_LIST_DIR}/usb_descriptors.c
    ${CMAKE_CURRENT_LIST_DIR}/fatfs_disk.c
    ${CMAKE_CURRENT_LIST_DIR}/flash_fs.c
    ${CMAKE_CURRENT_LIST_DIR}/fatfs/ff.c
    ${CMAKE_CURRENT_LIST_DIR}/fatfs/ffunicode.c
    ${CMAKE_CURRENT_LIST_DIR}/fatfs/diskio.c
) 

target_include_directories(PICOLECO_cart PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}
    ${CMAKE_CURRENT_LIST_DIR}/fatfs
)
target_include_directories(PICOLECO_cart_Pencil PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}
    ${CMAKE_CURRENT_LIST_DIR}/fatfs
)

# Enable usb output, disable uart output
pico_enable_stdio_usb(PICOLECO_cart 1)
pico_enable_stdio_uart(PICOLECO_cart 0)
pico_enable_stdio_usb(PICOLECO_cart_Pencil 1)
pico_enable_stdio_uart(PICOLECO_cart_Pencil 0)

# In addition to pico_stdlib required for common PicoSDK functionality, add dependency on tinyusb_device
# for TinyUSB device support
target_link_libraries(PICOLECO_cart PUBLIC pico_stdlib pico_runtime_init hardware_flash tinyusb_device pico_multicore)
target_link_libraries(PICOLECO_cart_Pencil PUBLIC pico_stdlib pico_runtime_init hardware_flash tinyusb_device pico_multicore)

# create map/bin/hex/uf2 file in addition to ELF.
pico_add_extra_outputs(PICOLECO_cart)
pico_add_extra_outputs(PICOLECO_cart_Pencil)
