#include<iostream>
#include<stdio.h>
#include<time.h>
#include<stdlib.h>
using namespace std;

void square(int *a,int *b,int n)
{
	for(int i=0;i<n;i++)
		b[i]=a[i]*a[i];
}

int main()
{
	int n;
	cin>>n;
	int *a;
	a=(int *)malloc(n*sizeof(n));
	int *b;
	b=(int *)malloc(n*sizeof(n));
	for(int i=0;i<n;i++)
		a[i]=i;
	clock_t start,end;
	start=clock();
	square(a,b,n);
	end=clock();
	for(int i=0;i<n;i++)
		cout<<a[i]<<" ";
	cout<<"\n";
	free(a);
	free(b);
	cout<<"It took "<<(end-start)*1.0/CLOCKS_PER_SEC<<" seconds\n";
}
