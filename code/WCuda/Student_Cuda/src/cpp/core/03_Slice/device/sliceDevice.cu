#include "Indice2D.h"
#include "Indice1D.h"
#include "cudaTools.h"

#include <stdio.h>
#include "reductionADD.h"
/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

//__global__ void addVector(float* ptrDevV1, float* ptrDevV2, float* ptrDevW, int n);
__global__ void slice(int nbSlice, float* ptrDevResult);
__device__ void reduceIntraThread(float* tabSM, int nbSlice);

__device__ float fctPI(float x);
/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/
__global__ void slice(int nbSlice, float* ptrDevResult)
    {
    extern __shared__ float tabSM[];
    reduceIntraThread(tabSM, nbSlice);

    __syncthreads();

    reductionADD<float>(tabSM, ptrDevResult);

    }
/**
 * output : void required !!
 */

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

__device__ void reduceIntraThread(float* tabSM, int nbSlice)
    {
    //int sumThread = 0;
//    int nbrSlice= ??
    const int NB_THREAD = Indice1D::nbThread();
    const int TID_LOCAL = Indice1D::tidLocal();
//    const int NB_THREAD_LOCAL = Indice1D::nbThreadLocal();
    const int TID = Indice1D::tid();

    const float DX = 1.0 / (float) nbSlice;

//    int s = TID_LOCAL;
    int s = TID;
    float derp = 0;

    while (s < nbSlice)
	{
//	sumThread += aire (,);
	derp += fctPI(s * DX);

	s += NB_THREAD;
	}

    tabSM[TID_LOCAL] = derp;
//    tabSM[TID_LOCAL] = TID ; //n*(n-1)/2=>523'776
    //tabSM[TID_LOCAL]=1; => 1024
    }

__device__ float fctPI(float x)
    {
    return 4.0f / (1.0f + (x * x));
    }
//
//__device__ float aire()
//    {
//    return
//    }
/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

