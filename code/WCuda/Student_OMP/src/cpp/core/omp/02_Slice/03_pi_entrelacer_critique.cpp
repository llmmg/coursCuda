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

bool isPiOMPEntrelacerCritical_Ok(int n);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

static double piOMPEntrelacerCritical(int n);

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool isPiOMPEntrelacerCritical_Ok(int n)
    {
    return isAlgoPI_OK(piOMPEntrelacerCritical, n, "Pi OMP Entrelacer critical");
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

double piOMPEntrelacerCritical(int n)
    {
    const int THREADS=OmpTools::setAndGetNaturalGranularity();
       const double DX=1/(double)n;
       double globSum=0;
       #pragma omp parallel
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
	    #pragma omp critical (bla)
	    {
		globSum+=localSum;
	    }
       }//barrière de synchronisation implicite


       //REDUCTION SEQUENTIELLE
       /*for(int i=0;i<THREADS;i++)
	{
	   globSum+=tabSum[i];
	}*/
       return globSum*DX;
    }

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

