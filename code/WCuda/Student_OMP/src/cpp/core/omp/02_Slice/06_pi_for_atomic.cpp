#include <omp.h>
#include "OmpTools.h"
#include "../02_Slice/00_pi_tools.h"

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/



/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool isPiOMPforAtomic_Ok(int n);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

static double piOMPforAtomic(int n);

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool isPiOMPforAtomic_Ok(int n)
    {
    return isAlgoPI_OK(piOMPforAtomic, n, "Pi OMP for atomic");
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/**
 * synchronisation couteuse!
 */
double piOMPforAtomic(int n)
    {
	double sum=0.0;
	double const DX=1/(double)n;
	double xi;

	//plus le bloc blanc, le compilateur choisis le patern à appliquer
	//pour la boucle for.
    	#pragma omp parallel for private(xi)
	for(int i=0;i<=n;i++)
	{
	    xi=i*DX;

	    #pragma omp atomic
	    sum+=fpi(xi);

	}

	return sum*DX;
    }

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

