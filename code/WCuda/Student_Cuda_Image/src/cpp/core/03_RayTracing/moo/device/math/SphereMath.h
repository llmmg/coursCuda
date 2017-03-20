#pragma once

#include <math.h>
#include "MathTools.h"
#include "Sphere.h"

#include "ColorTools_GPU.h"
using namespace gpu;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

class SphereMath
    {

	/*--------------------------------------*\
	|*		Constructor		*|
	 \*-------------------------------------*/

    public:

	__device__ SphereMath(int w, int h, int nbSpheres, Sphere* ptrDevTabSphere)
	    {
	    this->nbSpheres = nbSpheres;
	    this->ptrDevTabSphere = ptrDevTabSphere;
	    }

	// constructeur copie automatique car pas pointeur dans VagueMath

	__device__
	        virtual ~SphereMath()
	    {
	    // rien
	    }

	/*--------------------------------------*\
	|*		Methodes		*|
	 \*-------------------------------------*/

    public:

	__device__
	void colorIJ(uchar4* ptrColor, int i, int j, float t)
	    {

	    float2 xySol;
	    xySol.x = j;
	    xySol.y = i;

	    float hCarre;
	    float dz;
	    float distance;
	    float minDist = 5000;

	    float h, b;

	    //boucle for qui parcours toute les sphere, regarde si elles sont au dessus

	    //	    Sphere sphereK;

	    for (int k = 0; k < nbSpheres; k++)
		{
//		sphereK = ptrDevTabSphere[k];
//		hCarre = sphereK.hCarre(xySol);

		hCarre = ptrDevTabSphere[k].hCarre(xySol);
		if (ptrDevTabSphere[k].isEnDessous(hCarre))
		    {
		    dz = ptrDevTabSphere[k].dz(hCarre);
		    distance = ptrDevTabSphere[k].distance(dz);

		    if (minDist > distance)
			{
			minDist = distance;
//			*ptrColor-> = sphereK.brightness(dz);
			b = ptrDevTabSphere[k].brightness(dz);
//			h = f(sphereK.getHueStart(), t);
			h = ptrDevTabSphere[k].hue(t);
			ColorTools::HSB_TO_RVB(h, 1, b, ptrColor);

			}else
			    {
			    ptrColor->x=50;
			    ptrColor->y=50;
			    ptrColor->z=50;
			    }
		    }

		}

	    ptrColor->w = 255; // opaque
	    }

    private:

	__device__
	float f(float hStart, float t)
	    {
	    float T = asinf(2 * hStart - 1) - 3 * PI_FLOAT / 2;
	    return 1 / 2 + 1 / 2 * sinf(t + (3 * PI_FLOAT / 2) + T);

	    }

	/*--------------------------------------*\
	|*		Attributs		*|
	 \*-------------------------------------*/

    private:

	// inputs
	Sphere* ptrDevTabSphere;
	int nbSpheres;

    };

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
