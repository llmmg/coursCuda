#include <omp.h>
#include "MathTools.h"
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

bool isPiOMPforPromotionTab_Ok(int n);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

static double piOMPforPromotionTab(int n);
static void syntaxeSimplifier(double* tabSumThread,int n);
static void syntaxeFull(double* tabSumThread,int n);

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool isPiOMPforPromotionTab_Ok(int n)
    {
    return isAlgoPI_OK(piOMPforPromotionTab, n, "Pi OMP for promotion tab");
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/**
 * De-synchronisation avec PromotionTab
 */
double piOMPforPromotionTab(int n)
    {
	const int THREADS=OmpTools::setAndGetNaturalGranularity();
    	double const DX=1/(double)n;
    	double xi;
    	double* tab=new double[THREADS];

	#pragma omp parallel for
    	for(int i=0;i<THREADS;i++)
    	{
    	    tab[i]=0;
    	}

    	//plus le bloc blanc, le compilateur choisis le patern à appliquer
    	//pour la boucle for.
	#pragma omp parallel for private(xi)
    	for(int i=0;i<=n;i++)
    	{
    	    const int TID=OmpTools::getTid();
    	    xi=i*DX;
    	    tab[TID]+=fpi(xi);

    	}
    	//reduction additive séquentielle
    	double globSum=0;
    	for(int i=1;i<THREADS;i++)
	{
    	    globSum+=tab[i];
	}
    	delete[] tab;
    	return globSum*DX;
    }



/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

