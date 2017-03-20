#include "Indice2D.h"
#include "cudaTools.h"
#include "Device.h"

#include "SphereMath.h"
#include "RayTracing.h"
#include "SphereCreator.h"

#include "IndiceTools_GPU.h"
#include "DomaineMath_GPU.h"

using namespace gpu;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/
__global__ void rayTracing(uchar4* ptrDevPixels, uint w, uint h, int nbSphere, float t, Sphere* ptrDevTabSphere);
/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/
__global__ void rayTracing(uchar4* ptrDevPixels, uint w, uint h, int nbSphere, float t, Sphere* ptrDevTabSphere)
    {

    //math
//    size_t sizeOctet = nbSphere * sizeof(Sphere);
//    Device::memcpyHToD(ptrTabSphere, ptrDevTabSphere, sizeOctet);
    SphereMath sphereMath = SphereMath(w, h, nbSphere, ptrDevTabSphere); // ici pour preparer cuda

    const int TID = Indice2D::tid();
    const int NB_THREAD = Indice2D::nbThread();
    const int WH = w * h;

    int i;
    int j;

    int s = TID; // in [0,...
    while (s < WH)
	{
	IndiceTools::toIJ(s, w, &i, &j); // s[0,W*H[ --> i[0,H[ j[0,W[

//	domainMath.toXY(i, j, &x, &y);
	sphereMath.colorIJ(&ptrDevPixels[s], i, j, t);

	s += NB_THREAD;
	}

    }
/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

//    }
/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
