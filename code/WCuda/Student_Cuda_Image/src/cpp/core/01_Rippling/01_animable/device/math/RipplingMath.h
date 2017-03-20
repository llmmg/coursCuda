#pragma once

#include <math.h>
#include "MathTools.h"

#include "ColorTools_GPU.h"
using namespace gpu;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

class RipplingMath
    {
	/*--------------------------------------*\
	|*		Constructeur		*|
	 \*-------------------------------------*/

    public:
__device__
	RipplingMath(uint w)
	    {
	    this->dim2 = w / 2;
	    }

	// constructeur copie: pas besoin car pas attribut ptr
__device__
	virtual ~RipplingMath(void)
	    {
	    // rien
	    }

	/*--------------------------------------*\
	|*		Methode			*|
	 \*-------------------------------------*/

    public:
__device__
	void colorIJ(uchar4* ptrColorIJ, int i, int j, float t)
	    {
	    uchar levelGris;

	    f(j, i, t, &levelGris); //levegris output a cause du &

	    ptrColorIJ->x = levelGris;
	    ptrColorIJ->y = levelGris;
	    ptrColorIJ->z = levelGris;

	    ptrColorIJ->w = 255; //opaque
	    }

    private:
__device__
	void f(int i, int j, float t, uchar* ptrlevelGris)
	    {
	    // TODO cf fonction math pdf
	    // use focntion dij ci-dessous
	    float dij1;
	    dij(i, j, &dij1);
	    *ptrlevelGris = 128 + 127 * (cos(dij1 / 10 - t / 7) / (dij1 / 10 + 1));
	    }
__device__
	void dij(int i, int j, float* ptrResult)
	    {
	    double fi = i - dim2;
	    double fj = j - dim2;
	    *ptrResult = sqrt((fi * fi) + (fj * fj));
	    }
	/*--------------------------------------*\
	|*		Attribut			*|
	 \*-------------------------------------*/

    private:

	// Tools
	double dim2;

    };

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
