function(bin2h SOURCE_FILE VARIABLE_NAME HEADER_FILE)
    # Read the raw binary file as a hex string
    file(READ "${SOURCE_FILE}" HEX_CONTENT HEX)

    # Separate hex into C-style array commas (e.g., AABBCC -> 0xAA,0xBB,0xCC)
    string(REGEX REPLACE "([0-9a-fA-F][0-9a-fA-F])" "0x\\1," ARRAY_CONTENT "${HEX_CONTENT}")

    # Calculate exact array size by counting the elements
    string(LENGTH "${HEX_CONTENT}" HEX_LENGTH)
    math(EXPR ARRAY_SIZE "${HEX_LENGTH} / 2")

    # Generate the header layout
    set(HEADER_OUTPUT "/* Generated via CMake bin2h function */\n")
    string(APPEND HEADER_OUTPUT "const unsigned char ${VARIABLE_NAME}[] = {\n    ${ARRAY_CONTENT}\n};\n\n")
    string(APPEND HEADER_OUTPUT "const unsigned int ${VARIABLE_NAME}_size = ${ARRAY_SIZE};\n")

    # Write the file if it changed (avoids unnecessary recompiles)
    file(CONFIGURE OUTPUT "${HEADER_FILE}" CONTENT "${HEADER_OUTPUT}" @ONLY)
endfunction()

bin2h("${SOURCE_FILE}" "${VARIABLE_NAME}" "${HEADER_FILE}")