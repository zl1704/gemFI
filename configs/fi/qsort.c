#include <stdlib.h>
#include <stdio.h>

void exc(int*a,int i,int j){
  int temp=a[i];
  a[i]=a[j];
  a[j]=temp;
}
int partition(int *a,int lo, int hi){
  int i=lo , j=hi+1;
  int v = a[lo];
  while(1){
    while(a[++i]<v) if(i==hi) break;
    while(v<a[--j]) if(j==lo) break;
    if(i>=j) break;
    exc(a,i,j);
  }
  exc(a,lo,j);
  return j;
}
void find_err()
{
	printf("find control error!\n");
}
void sort(int*a,int lo,int hi){
  if(hi<=lo) return;
  int j=partition(a,lo,hi);
  sort(a,lo,j-1);
  sort(a,j+1,hi);
}

int main(int argc, char *argv[]) {
  int a[12]={2,64,1,23,425,64,2,14,9,2,5,7};
  int b[12]={2,64,1,23,425,64,2,14,9,2,5,7};
  int i;
  for(i=0;i<12;i++)
  { 
    if(a[i]!=b[i]){
        printf("error is detected!");
        exit(0);
     }
  }
  sort(a,0,11);
  sort(b,0,11);
  for(i=0;i<12;i++)
  { 
    if(a[i]!=b[i]){
        printf("error is detected!");
        exit(0);
     }
  }
  for(i=0;i<12;i++){
    printf("%d  ",a[i]);
  }
  printf("\n");
  return 0;
}
