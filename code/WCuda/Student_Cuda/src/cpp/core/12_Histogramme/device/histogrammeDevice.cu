#include "Indice1D.h"
#include "Indice2D.h"
#include "cudaTools.h"
#include "MathTools.h"
#include "reductionADD.h"

#include <stdio.h>

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

__global__ void histogramme(int* tabDevInput, int* tabDevHisto, int n, int nbData);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

__device__ void initSM(int* tabSM, int n);
__device__ void reduceIntraThread(int* tabDevInput, int * tabSM, int nbData);
__device__ void reduceInterBlock(int* tabSM, int* tabDevHisto, int n);

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

/**
 * output : void required !!
 */
__global__ void histogramme(int* tabDevInput, int* tabDevHisto, int nbData,int dataMax)
    {
    extern __shared__ int tabSM[];

    //255=dataMax
    initSM(tabSM, dataMax);

    reduceIntraThread(tabDevInput, tabSM, nbData);
    __syncthreads();

    reduceInterBlock(tabSM, tabDevHisto, dataMax);
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

__device__ void initSM(int* tabSM, int n)
    {

    const int TID_LOCAL=Indice1D::tidLocal();
    const int NB_THREAD_LOCAL= Indice1D::nbThreadBlock();

    int s = TID_LOCAL;
    while (s < n)
	{
	tabSM[s] = 0;
	s += NB_THREAD_LOCAL;
	}
    }

__device__ void reduceIntraThread(int* tabDevInput, int* tabSM, int nbData)
    {
    const int NB_THREAD = Indice2D::nbThread();
    const int TID = Indice2D::tid();

    int s = TID;

    while (s < nbData)
	{
	int size = tabDevInput[s];
	atomicAdd(&tabSM[size], 1);
	s += NB_THREAD;
	}
    }

__device__ void reduceInterBlock(int* tabSM, int* tabGM, int dataMax)
    {

    if (Indice2D::tidLocal() == 0)
    	{
    	for (int i = 0; i < dataMax; i++)
    	    {
    	    atomicAdd(&tabGM[i], tabSM[i]);
    	    }
    	}
    }

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
