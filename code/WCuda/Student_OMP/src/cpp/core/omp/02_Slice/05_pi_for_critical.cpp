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

bool isPiOMPforCritical_Ok(int n);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

static double piOMPforCritique(int n);

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool isPiOMPforCritical_Ok(int n)
    {
    return isAlgoPI_OK(piOMPforCritique, n, "Pi OMP for critique");
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/**
 * synchronisation couteuse!
 */
double piOMPforCritique(int n)
 {
    //v1
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

	    #pragma omp critical(lel)
            {
		sum+=fpi(xi);
	    }
    	}

        return sum*DX;
    }
    //v2
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

    	    #pragma omp critical(lel)
	    {
    		sum+=fpi(xi);
    	    }
	}

    return sum*DX;
    }
 }

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

