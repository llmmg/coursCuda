#pragma once

#include "SphereMath.h"

#include "DomaineMath_GPU.h"

#include "Variateur_GPU.h"
#include "Animable_I_GPU.h"

using namespace gpu;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

class RayTracing: public Animable_I<uchar4>
    {

	/*--------------------------------------*\
	 |*		Constructeur		*|
	 \*-------------------------------------*/

    public:

	RayTracing(const Grid& grid, uint w, uint h,int nbSphere, float dt,Sphere* ptrTabSphere);

	virtual ~RayTracing(void);

	/*--------------------------------------*\
	 |*		Methode			*|
	 \*-------------------------------------*/

    public:

	/*-------------------------*\
	|*   Override Animable_I   *|
	 \*------------------------*/

	/**
	 * Call periodicly by the api
	 */
	virtual void process(uchar4* ptrDevPixels, uint w, uint h/*,int nbSphere,Sphere* ptrDevTabSphere*/,const DomaineMath& domaineMath);
	/**
	 * Call periodicly by the api
	 */
//	virtual void processForAutoOMP(uchar4* ptrTabPixels, uint w, uint h, const DomaineMath& domaineMath);
	/**
	 * Call periodicly by the api
	 */
	virtual void animationStep();

    private:

	/**
	 * i in [0,h[
	 * j in [0,w[
	 *
	 * code commun a:
	 * 	- entrelacementOMP
	 * 	- forAutoOMP
	 */
//	void workPixel(uchar4* ptrColorIJ, int i, int j, const DomaineMath& domaineMath, SphereMath* ptrSphereMath);
	/*--------------------------------------*\
	|*		Attribut		*|
	 \*-------------------------------------*/

    private:

//	Sphere* ptrTabSphere;

// Inputs
	float dt;

	//in/out ptr
	Sphere* ptrTabSphere;

	// Tools
	Sphere* ptrDevTabSphere;
	int nbSphere;
//	Variateur<float> variateurAnimation;
	size_t sizeOctet;

    };

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 /*----------------------------------------------------------------------*/
