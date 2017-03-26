#include "Indice2D.h"
#include "cudaTools.h"
#include "Device.h"

#include "SphereMath.h"
#include "RayTracing.h"
#include "SphereCreator.h"

#include "IndiceTools_GPU.h"
#include "DomaineMath_GPU.h"

#include "length_cm.h"

using namespace gpu;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

__constant__ Sphere TAB_CM[LENGTH_CM];

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/
//__global__ void rayTracing(uchar4* ptrDevPixels, uint w, uint h, int nbSphere, float t, Sphere* ptrDevTabSphere);
//__global__ void rayTracingGM(uchar4* ptrDevPixels, uint w, uint h, int nbSphere, float dt, Sphere* ptrDevTabSphere);
__global__ void rayTracingSM(uchar4* ptrDevPixels, uint w, uint h, int nbSphere, float dt, Sphere* ptrDevTabSphere);
__device__ void copyGMtoSM(Sphere* ptrDevTabSphere, Sphere* tab_SM);
/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/
__host__ void uploadGPU(Sphere* tabValue)
    {
    size_t size = LENGTH_CM * sizeof(Sphere);
    int offset = 0;
    HANDLE_ERROR(cudaMemcpyToSymbol(TAB_CM, tabValue, size, offset, cudaMemcpyHostToDevice));
    }

__device__ void work(uchar4* ptrDevPixels, uint w, uint h, int nbSphere, float t, Sphere* ptrDevTabSphere)
    {

    SphereMath sphereMath = SphereMath(w, h, nbSphere, ptrDevTabSphere); // ici pour preparer cuda

    const int TID = Indice2D::tid();
    const int NB_THREAD = Indice2D::nbThread();
    const int WH = w * h;

    int i;
    int j;

    int s = TID; // in [0,...
    while (s < WH)
	{
	// the algorithme
	IndiceTools::toIJ(s, w, &i, &j); // s[0,W*H[ --> i[0,H[ j[0,W[

	//	domainMath.toXY(i, j, &x, &y);
	sphereMath.colorIJ(&ptrDevPixels[s], i, j, t);

	s += NB_THREAD;
	}
    }

__device__ void copyGMtoSM(Sphere* ptrDevTabSphere, Sphere* tab_SM)
    {
    const int TID_LOCAL = Indice2D::tidLocal();
    const int NB_THREAD_LOCAL = Indice2D::nbThreadLocal();

    int s = TID_LOCAL;

    //pour la comprehenssion...
    int NB_SPHERE = LENGTH_CM;

    while (s < NB_SPHERE)
	{
	tab_SM[s] = ptrDevTabSphere[s];
	s += NB_THREAD_LOCAL;
	}
    }

__global__ void rayTracingCM(uchar4* ptrDevPixels, uint w, uint h, float t)
    {
    work(ptrDevPixels, w, h, LENGTH_CM, t, TAB_CM);
    }
/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/
//---rayTracingGM
__global__ void rayTracingGM(uchar4* ptrDevPixels, uint w, uint h, int nbSphere, float t, Sphere* ptrDevTabSphere)
    {
    work(ptrDevPixels, w, h, nbSphere, t, ptrDevTabSphere);
    }

__global__ void rayTracingSM(uchar4* ptrDevPixels, uint w, uint h, int nbSphere, float t, Sphere* ptrDevTabSphere)
    {
    extern __shared__ Sphere tab_SM[];
    copyGMtoSM(ptrDevTabSphere, tab_SM);

    __syncthreads();
    work(ptrDevPixels, w, h, nbSphere, t, tab_SM);
    }
/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

//    }
/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
