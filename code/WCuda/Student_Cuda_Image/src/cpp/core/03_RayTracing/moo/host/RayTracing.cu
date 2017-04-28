#include <iostream>
#include <assert.h>

#include "Device.h"
#include "RayTracing.h"
#include "SphereCreator.h"
#include "SphereMath.h"
#include <assert.h>

#include "DomaineMath_GPU.h"
#include "IndiceTools_GPU.h"

#include "length_cm.h"

using namespace gpu;
using std::cout;
using std::endl;
/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/
//extern __global__ void rayTracing(uchar4* ptrDevPixels,uint w, uint h, int nbSphere,float dt, Sphere* ptrDevTabSphere);
extern __global__ void rayTracingGM(uchar4* ptrDevPixels,uint w, uint h, int nbSphere,float dt, Sphere* ptrDevTabSphere);
extern __global__ void rayTracingCM(uchar4* ptrDevPixels, uint w, uint h, float t);
extern __global__ void rayTracingSM(uchar4* ptrDevPixels,uint w, uint h, int nbSphere,float dt, Sphere* ptrDevTabSphere);

extern __host__ void uploadGPU(Sphere* tabValue);
/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

/*-------------------------*\
 |*	Constructeur	    *|
 \*-------------------------*/
RayTracing::RayTracing(const Grid& grid, uint w, uint h, int nbSphere, float dt/*, Sphere* ptrTabSphere*/) :
	Animable_I<uchar4>(grid, w, h, "RayTracig_CUDA_RGBA_uchar4"), variateurAnimation(Interval<float>(0.0, 1.0), dt)
    {

    this->nbSphere = nbSphere;
//    this->ptrTabSphere = new Sphere[nbSphere];
    this->wlocal = w;
    this->hlocal = h;
    this->dt = dt; // protected dans Animable

    SphereCreator sphereCreator(nbSphere, w, h);
    Sphere* ptrTabSphere = sphereCreator.getTabSphere();

    // toGM(ptrTabSphere);
    this->sizeOctet = nbSphere * sizeof(Sphere);

    Device::malloc(&ptrDevTabSphere, sizeOctet);
    Device::memclear(ptrDevTabSphere, sizeOctet);

    Device::memcpyHToD(ptrDevTabSphere, ptrTabSphere, sizeOctet);

    //  toCM(ptrTabSphere);
    uploadGPU(ptrTabSphere);

    }
//TODO:
//void RayTracing::toGm(Sphere* ptrTabSphere)
//    {
//
//    // toGM(ptrTabSphere);
//    this->sizeOctet = nbSphere * sizeof(Sphere);
//
//    Device::malloc(&ptrDevTabSphere, sizeOctet);
//    Device::memclear(ptrDevTabSphere, sizeOctet);
//
//    Device::memcpyHToD(ptrDevTabSphere, ptrTabSphere, sizeOctet);
//    }

RayTracing::~RayTracing()
    {
    Device::free(ptrDevTabSphere);
    }

/*-------------------------*\
 |*	Methode		    *|
 \*-------------------------*/

/**
 * Override
 * Call periodicly by the API
 *
 * Note : domaineMath pas use car pas zoomable
 */
void RayTracing::process(uchar4* ptrDevPixels, uint w, uint h/*, int nbSphere, Sphere* ptrTabSphere*/, const DomaineMath& domaineMath)
    {
//    Device::lastCudaError("fractale rgba uchar4 (before)"); // facultatif, for debug only, remove for release
    static int i = 2;

    if (i % 3 == 0)
	{
	rayTracingGM<<<dg,db>>>(ptrDevPixels, w, h, nbSphere, dt, ptrDevTabSphere);
	}
	else if (i % 3 == 1)
	{
	rayTracingCM<<<dg,db>>>(ptrDevPixels, w, h, dt);
	}
	else if (i % 3 == 2)
	{
	rayTracingSM<<<dg,db,sizeOctet>>>(ptrDevPixels, w, h, nbSphere, dt, ptrDevTabSphere);
	}
     //    Device::lastCudaError("fractale rgba uchar4 (after)"); // facultatif, for debug only, remove for release
//    i++;
}

/**
 * Override
 * Call periodicly by the API
 */
void RayTracing::animationStep()
{
//    t += dt;
dt = variateurAnimation.varierAndGet();
}

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

