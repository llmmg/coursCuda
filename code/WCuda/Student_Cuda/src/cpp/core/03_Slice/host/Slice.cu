#include "Slice.h"

#include <iostream>

#include "Device.h"

using std::cout;
using std::endl;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

extern __global__ void slice(int nbSlice, float* ptrDevResult);

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Constructeur			*|
 \*-------------------------------------*/

Slice::Slice(const Grid& grid, int nbSlice)
    {

    this->sizeOctetSM = sizeof(float) * grid.db.x * grid.db.y;
    this->sizeOctetGM = sizeof(float);

    // MM
	{
	    {
	    //malloc modifie le contenu du ptr

	    Device::malloc(&ptrDevGMResult, sizeOctetGM);
	    Device::memclear(ptrDevGMResult, sizeOctetGM);

	    }
	Device::lastCudaError("bllblbll"); // temp debug, facultatif
	}

    // Grid
	{
	this->dg = grid.dg;
	this->db = grid.db;
	}
    }
//
Slice::~Slice(void)
    {
    //MM (device free)
	{
	Device::free(ptrDevGMResult);
//	Device::free(ptrDevV2);
//	Device::free(ptrDevW);

	Device::lastCudaError("AddVector MM (end deallocation)"); // temp debug, facultatif
	}
    }

/*--------------------------------------*\
 |*		Methode			*|
 \*-------------------------------------*/

void Slice::run()
    {
    Device::lastCudaError("addVecteur (before)"); // temp debug
    slice<<<dg,db,sizeOctetSM>>>(nbSlice,ptrDevGMResult); // assynchrone
    Device::lastCudaError("addVecteur (after)"); // temp debug

//    Device::synchronize(); // Temp,debug, only for printf in  GPU

    // MM(Device->Host)
	{
	Device::memcpyDToH(&result, ptrDevGMResult, sizeOctetGM); // barriere synchronisation implicite

	}

    result /= (float) nbSlice;
    }

float Slice::getResult()
    {
    return this->result;
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

