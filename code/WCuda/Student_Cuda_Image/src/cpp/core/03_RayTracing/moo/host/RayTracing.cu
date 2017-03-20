#include <iostream>
#include <assert.h>

#include "Device.h"
#include "RayTracing.h"
#include "SphereCreator.h"
#include "SphereMath.h"
#include <assert.h>

#include "DomaineMath_GPU.h"
#include "IndiceTools_GPU.h"

using namespace gpu;
using std::cout;
using std::endl;
/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/
extern __global__ void rayTracing(uchar4* ptrDevPixels,uint w, uint h, int nbSphere,float dt, Sphere* ptrDevTabSphere);

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
	Animable_I<uchar4>(grid, w, h, "RayTracig_CUDA_RGBA_uchar4")
    {

    this->nbSphere = nbSphere;
//    this->ptrTabSphere = new Sphere[nbSphere];
//    this->w = w;
//    this->h = h;
    this->dt = dt; // protected dans Animable

    SphereCreator sphereCreator(nbSphere, w, h);
    Sphere* ptrTabSphere = sphereCreator.getTabSphere();

    // toGM(ptrTabSphere);
    this->sizeOctet = nbSphere * sizeof(Sphere);

    Device::malloc(&ptrDevTabSphere, sizeOctet);
    Device::memclear(ptrDevTabSphere, sizeOctet);

    Device::memcpyHToD(ptrDevTabSphere, ptrTabSphere, sizeOctet);

    //  toCM(ptrTabSphere);
    //???

    //TODO: verifier les pointeurs et sense des allocation
    }

RayTracing::~RayTracing()
    {
    Device::free(ptrDevTabSphere);
//    Device::free(ptrTabSphere);
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
    Device::lastCudaError("fractale rgba uchar4 (before)"); // facultatif, for debug only, remove for release

    rayTracing<<<dg,db>>>(ptrDevPixels, w, h, nbSphere, dt, ptrDevTabSphere);
    // le kernel est importer ci-dessus (ligne 19)

    Device::lastCudaError("fractale rgba uchar4 (after)"); // facultatif, for debug only, remove for release

//    Device::memcpyDToH(ptrTabSphere, ptrDevTabSphere, sizeOctet);
    }

/**
 * Override
 * Call periodicly by the API
 */
void RayTracing::animationStep()
    {
    t += dt;
//    n = variateurAnimation.varierAndGet();
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

