#include <iostream>
#include "Grid.h"
#include "Device.h"

#include "MonteCarlo.h"

using std::cout;
using std::endl;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/



/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool useMonteCarlo(void);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool useMonteCarlo()
    {
    int nbFlech = 3000000;
    float m = 100;
    // Grid cuda
//    int mp = Device::getMPCount();
//    int coreMP = Device::getCoreCountMP();

    dim3 dg = dim3(24, 1, 1);  		// disons, a optimiser selon le gpu, peut drastiqument ameliorer ou baisser les performances
    dim3 db = dim3(128, 1, 1);   	// disons, a optimiser selon le gpu, peut drastiqument ameliorer ou baisser les performances
    Grid grid(dg, db);

    MonteCarlo montecarlo(grid, nbFlech, m);
    montecarlo.process();
    float pi= montecarlo.getResult();

    cout << "---------------" << endl;
    cout << "pi= " << pi << endl;
    cout << "---------------" << endl;

    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
