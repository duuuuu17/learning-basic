#include<stdio.h>

int compare(int x,int y){
    int result=0;
    if(x>=y){
        result=x-y;
        return result;
    }
    else{
        result=y-x;
        return result;
    }
}
int main()
{   
    int x=0;int y=0;
    compare(x,y);
    return 0;
}
