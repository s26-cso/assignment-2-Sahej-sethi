#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h> 
#include <string.h>

int main() {
    char op[6]; 
    int a, b;
    void *handle = NULL; 
    char last_op[6] = ""; 

    while(scanf("%5s %d %d", op, &a, &b) == 3){
      
        char lib_name[15];
        sprintf(lib_name, "./lib%s.so", op);

        if(handle != NULL && strcmp(op, last_op) != 0){
            dlclose(handle);
            handle = NULL;
        }

        if(handle == NULL){
            handle = dlopen(lib_name, RTLD_LAZY); 
            if(handle == NULL){ 
                fprintf(stderr, "%s\n", dlerror());
                continue;
            }
            strcpy(last_op, op);
        }

        int (*func)(int, int); 
        func = (int (*)(int, int)) dlsym(handle, op);

        char *error = dlerror(); 
        
        if(error != NULL){
            fprintf(stderr, "%s\n", error);
        }else{
            printf("%d\n", func(a, b));
        }
    }

    if(handle != NULL){
        dlclose(handle);
    }

    return 0;
}