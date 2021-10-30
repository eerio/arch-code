#include<stddef.h> /* size_t */
#include<stdlib.h> /* malloc */
#include<sys/types.h> /* ssize_t */
#include<errno.h> /* errno */

#define _POSIX_C_SOURCE 200809L
#define __STDC_WANT_LIB_EXT2__ (1U)
#include<stdio.h> /* fprintf, getline */


#include "signatures.h" /* LineSignature */
#include "util.h" /* error_code */

void failwith2(ErrorCode err) {
    switch (err) {
        case (GETLINE_ERR):
            perror("Error: unable to get line from stdin");
            exit(1);
        case (MALLOC_ERR):
            perror("Error: unable to allocate memory");
            exit(1);
    }
}

