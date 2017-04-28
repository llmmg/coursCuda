#include <iostream>
#include "Grid.h"
#include "Device.h"

using std::cout;
using std::endl;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

#include "Slice.h"

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool useSlice(void);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool useSlice()
    {
    int nbSlice = 400000000;
//
//    float* ptrV1 = VectorTools::createV1(n);
//    float* ptrV2 = VectorTools::createV2(n);
//    float* ptrW = new float[n];
//
//    // Partie interessante GPGPU
	{
	// Grid cuda
//	int mp = Device::getMPCount();
//	int coreMP = Device::getCoreCountMP();

	dim3 dg = dim3(24, 1, 1);  		// disons, a optimiser selon le gpu, peut drastiqument ameliorer ou baisser les performances
	dim3 db = dim3(128, 1, 1);   	// disons, a optimiser selon le gpu, peut drastiqument ameliorer ou baisser les performances
	Grid grid(dg, db);

//	AddVector addVector(grid, ptrV1, ptrV2, ptrW, n); // on passse la grille à AddVector pour pouvoir facilement la faire varier de l'extérieur (ici) pour trouver l'optimum
//	addVector.run();
	Slice s(grid, nbSlice);
	s.run();
	cout << "---Slice---" << endl;
	cout << s.getResult() << endl;
	cout << "---End Slice---" << endl;
	}

    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

