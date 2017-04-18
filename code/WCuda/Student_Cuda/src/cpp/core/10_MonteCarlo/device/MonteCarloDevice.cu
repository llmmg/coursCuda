#include "Indice2D.h"
#include "Indice1D.h"
#include "cudaTools.h"
#include "reductionADD.h"

#include <curand_kernel.h>
#include <limits.h>
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

__global__ void monteCarlo(curandState* tabDevGeneratorGM, int nbFlechettes, float m);
__global__ void setup_kernel_rand(curandState* tabDevGenerator, int deviceId);
static __device__ float f(float x);
__device__ void reduceIntraThread(int* tab_SM, int nbFlechette, curandState* tabDevGeneratorGM, float m);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

/**
 * output : void required !!
 */
__global__ void monteCarlo(curandState* tabDevGeneratorGM, int nbFlechettes, float m, int* ptrDevNx)
    {
    extern __shared__ int tab_SM[];

    reduceIntraThread(tab_SM, nbFlechettes, tabDevGeneratorGM, m);
    __syncthreads();

    //Reduce
    //=>global mem
    reductionADD<int>(tab_SM, ptrDevNx);
    }

__device__ void reduceIntraThread(int* tab_SM, int nbFlechette, curandState* tabDevGeneratorGM, float m)
    {
    const int TID = Indice1D::tid();
    const int NB_THREAD = Indice1D::nbThread();
    const int TID_LOCAL = threadIdx.x;
    // Global Memory -> Register (optimization)

    curandState localGenerator = tabDevGeneratorGM[TID];
    float xAlea;
    float yAlea;
    float y;
    int nx = 0;
    for (int i = 1; i <= nbFlechette / NB_THREAD; i++)
	{
	xAlea = curand_uniform(&localGenerator);
	yAlea = curand_uniform(&localGenerator) * m;

	y = f(xAlea);
	if (y >= yAlea)
	    {
	    nx++;
	    }

	}

    //Register -> Global Memory
    //Necessaire si on veut utiliser notre generator
    // - dans dautre kernel
    // - avec dautres nombres aleatoires !

    tabDevGeneratorGM[TID] = localGenerator;

    tab_SM[TID_LOCAL] = nx;
    }

__device__ float f(float x)
    {
    return 4.0 / (1.0 + (x * x));
    }

__global__ void setup_kernel_rand(curandState* tabDevGenerator, int deviceId)
    { // Customisation du generator:
// Proposition, au lecteur de faire mieux !
// Contrainte : Doit etre différent d'un GPU à l'autre
// Contrainte : Doit etre différent dun thread à lautre
    const int TID = Indice1D::tid();
    int deltaSeed = deviceId * INT_MAX / 10000;
    int deltaSequence = deviceId * 100;
    int deltaOffset = deviceId * 100;
    int seed = 1234 + deltaSeed;
    int sequenceNumber = TID + deltaSequence;
    int offset = deltaOffset;
    curand_init(seed, sequenceNumber, offset, &tabDevGenerator[TID]);
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

