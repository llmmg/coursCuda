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

bool isPiOMPEntrelacerPromotionTab_Ok(int n);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

static double piOMPEntrelacerPromotionTab(int n);

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool isPiOMPEntrelacerPromotionTab_Ok(int n)
    {
    return isAlgoPI_OK(piOMPEntrelacerPromotionTab,  n, "Pi OMP Entrelacer promotionTab");
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/**
 * pattern cuda : excellent!
 */
double piOMPEntrelacerPromotionTab(int n)
    {
    const int THREADS=OmpTools::setAndGetNaturalGranularity();
    const double DX=1/(double)n;
    double tabSum[THREADS];

    #pragma omp parallel
    {
	const int TID = OmpTools::getTid();
	int s =TID;
	tabSum[s]=0;
	while(s<n)
	{
	    double xs=s*DX;
	    tabSum[TID]+=fpi(xs);
	    s+=THREADS;
	}
    }//barrière de synchronisation implicite


    //REDUCTION SEQUENTIELLE
    double globSum=0;
    for(int i=0;i<THREADS;i++)
	{
	globSum+=tabSum[i];
	}
    return globSum*DX;
    }

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

