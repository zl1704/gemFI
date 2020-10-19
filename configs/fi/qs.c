#include <time.h>
#include <stdio.h>
#define NUM 100
int s[NUM];
void quick_sort( int l, int r)
{
    if (l < r)
    {
        int i = l, j = r, x = s[l];
        while (i < j)
        {
            while(i < j && s[j] >= x)
                j--;
            if(i < j)
                s[i++] = s[j];

            while(i < j && s[i] < x)
                i++;
            if(i < j)
                s[j--] = s[i];
        }
        s[i] = x;
        quick_sort( l, i - 1); 
        quick_sort( i + 1, r);
    }
}

void print(){
    for(int i=0;i<50;i++)
        printf("%d ",s[i]);
    printf("\n");

}
void init(){

    for(int i = 0;i<NUM;i++){

       s[i] = NUM-i;

    }

}

int main(int argc, char** argv) {
    //return lib_clang_main(argc,argv);
    printf("init ...\n");
    //clock_t startTime = clock();
    init();
    printf("sort ...\n");
    quick_sort(0,NUM-1);
    printf("print ...\n");
    print();


    //clock_t endTime = clock();

    //printf("运行时间： %f s\n" , (double)(endTime-startTime) /CLOCKS_PER_SEC);

    return 0;
}
