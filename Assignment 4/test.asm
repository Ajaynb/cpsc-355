

        // Allocate 2d Array of table
        mulAll(x_loc, x_row,  x_col, int)
        alloc(x_loc)
        print(outstr, x_loc)

        addAll(x11, 10, 90, 200, 300)
        print(outstr, x11)

        mov     x_arr,  sd
        alloc(x_arr)
        struct(x_arr, sd_occ, sd_frq, sd_ind)

        writeStruct(13, x_arr, sd_frq)
        readStruct(x11, x_arr, sd_frq)
        print(outstr, x11)

        // Test for Arrays
        mulAll(x9, x_row, x_col)
        mulAll(x_ar2, x_row, x_col, int)
        alloc(x_ar2)
        array(x_ar2, x9, int)

        writeArray(69, x_ar2, int, 23)
        readArray(x11, x_ar2, int, 23)
        print(outstr, x11)
        readArray(x11, x_ar2, int, 10)
        print(outstr, x11)


