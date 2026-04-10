#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h> // This is Dynamic Linking library -> Allows a program to load code into its memory 
// while its already running, rather than linking which happens at compile time
// Open → Locate → Execute → Close (4 step way to use the library)
#include <string.h>

int main() {
    char op[6]; // stores current operation name
    int a, b; // operands
    void *handle = NULL; // Pointer to the library currently open (void* since dont know what kind of data in library)
    char last_op[6] = ""; // if two consecutive commands same, then no need to close and open again so store prev

    // Loop to continuously take command line input, while format is this keep taking ip
    // scanf returns the count of ips taken before error or endline
    while(scanf("%5s %d %d", op, &a, &b) == 3){
        
        // formating the library name in the format
        char lib_name[15];
        sprintf(lib_name, "./lib%s.so", op);

        //  the idea is that
        //  Each library is ~1.5GB. If the user calls a different operation,
        //  we must close the previous handle to free up memory before 
        //  loading a new 1.5GB library.
        
        if(handle != NULL && strcmp(op, last_op) != 0){
            dlclose(handle);
            handle = NULL;
        }

        // Load the library if it's not already loaded
        if(handle == NULL){
            handle = dlopen(lib_name, RTLD_LAZY); // find the library  stored at the path lib_name
            // map it into programs memory
            if(handle == NULL){ // if dlopen fails it returns NULL
                fprintf(stderr, "%s\n", dlerror()); // printf always to stdout, but to print to stderr
                continue;
            }
            strcpy(last_op, op);
        }

        // Get the function pointer from the library
        // The function name is the same as the operation name 'op'
        int (*func)(int, int); // function pointer, points to a snippet of code returns an int, takes 2 int ips
        func = (int (*)(int, int)) dlsym(handle, op);
        // dlsym -> goes inside library stored in handle, look for a function with name op and returns its memory address
        // (int (*)(int, int)) this is type converion, dlsym returns void *

        char *error = dlerror(); 
        // dlerror finds error in functions like dlopen and dlsym, but we checked for dlopen error
        // it returns pointer to string if something went wrong during calls
        // if null  => dlsym found the function
        if (error != NULL) {
            fprintf(stderr, "%s\n", error);
        } else {
            // Execute and print the result
            printf("%d\n", func(a, b));
        }
    }

    // Clean up before exiting if any open
    if (handle != NULL) {
        dlclose(handle);
    }

    return 0;
}