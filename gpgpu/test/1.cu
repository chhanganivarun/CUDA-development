#include<iostream>
#include<stdio.h>
#include<time.h>
#include<stdlib.h>
using namespace std;
//max no. of blocks 65535

__global__ void square(long long *d_in,long long *d_out,long long d_n,long long *d_get_blockDim)
{
	long long idx=1024*blockIdx.x+threadIdx.x;
	if(idx<d_n)
	{
		int temp=d_in[idx];
		d_out[idx]=temp*temp;
		d_out[idx]=idx;
	}
	*d_get_blockDim=blockDim.x;
//	cout<<threadIdx.x<<" "<<b[threadIdx.x]<<" ";
}

int main()
{
	long long n;
	cin>>n;
	long long *h_a;
	h_a=(long long *)malloc(n*sizeof(n));
	long long *h_b;
	h_b=(long long *)malloc(n*sizeof(long long));
	for(int i=0;i<n;i++)
		h_a[i]=i;
	long long *d_get_blockDim;
	
	long long *d_in;
	long long *d_out;
	long long d_n=n;
	cudaMalloc((void **)&d_in,n*sizeof(n));
	cudaMalloc((void **)&d_out,n*sizeof(long long));
	cudaMalloc((void **)&d_get_blockDim,sizeof(long long));
	
	cudaMemcpy(d_in,h_a,n*sizeof(n),cudaMemcpyHostToDevice);
	
	clock_t start,end;
	
	start=clock();
//	long long i=0;
	for(long long i=0;i<n;i+=67107840)
	{
		long long noBlocks=(n-i)/1024;
		if(noBlocks<(n-i)/1024.0)
			noBlocks++;
		square <<<noBlocks,1024>>> (d_in+i,d_out+i,d_n-i,d_get_blockDim);
	}

	end=clock();
	
	cudaMemcpy(h_b,d_out,n*sizeof(n),cudaMemcpyDeviceToHost);
/*	
	for(int i=0;i<n;i++)
		cout<<h_b[i]<<" ";
*/
	long long h_blockDim;
	cudaMemcpy(&h_blockDim,d_get_blockDim,sizeof(long long),cudaMemcpyDeviceToHost);
	cout<<h_b[n-1]<<"\n";
	cout<<"Block Dimension is:"<<h_blockDim<<endl;
	
	free(h_a);
	free(h_b);
	cudaFree(d_in);
	cudaFree(d_out);
	printf("It took %0.9f seconds\n",(end-start)*1.0/CLOCKS_PER_SEC);
}
