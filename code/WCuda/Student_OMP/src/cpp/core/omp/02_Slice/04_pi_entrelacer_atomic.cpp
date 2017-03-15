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

bool isPiOMPEntrelacerAtomic_Ok(int n);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

static double piOMPEntrelacerAtomic(int n);

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool isPiOMPEntrelacerAtomic_Ok(int n)
    {
    return isAlgoPI_OK(piOMPEntrelacerAtomic,  n, "Pi OMP Entrelacer atomic");
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/**
 * Bonne performance, si!
 */
double piOMPEntrelacerAtomic(int n)
    {
	const int THREADS=OmpTools::setAndGetNaturalGranularity();
	const double DX=1/(double)n;
        double globSum=0;
        #pragma omp parallel shared(globSum) //le shared est useless car c'est le comportement par defaut
           {
	    const int TID = OmpTools::getTid();
    	    int s =TID;
    	    double localSum=0;
    	    while(s<n)
    	    {
    		double xs=s*DX;
    		localSum+=fpi(xs);
    		s+=THREADS;
    	    }

    	    #pragma omp atomic
	    globSum+=localSum;

           }//barrière de synchronisation implicite


           //REDUCTION SEQUENTIELLE
           return globSum*DX;
    }

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

