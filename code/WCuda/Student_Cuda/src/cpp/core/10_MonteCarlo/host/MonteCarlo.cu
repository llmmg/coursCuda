#include "Device.h"
#include "MonteCarlo.h"

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/
extern __global__ void monteCarlo(curandState* tabDevGeneratorGM, int nbFlechettes, float m,int* ptrDevNx);
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
 |*		Public			*|
 \*-------------------------------------*/
MonteCarlo::MonteCarlo(const Grid& grid, int nbFlechettes, float m)
    {
    this->dg = grid.dg;
    this->db = grid.db;

    this->nbFlechette = nbFlechettes;
    this->m = m;
    this->sizeOctetSM = grid.db.x * grid.db.y * sizeof(int);
    this->sizeOctetGM = sizeof(int);

    int nbThreads = grid.threadCounts();
    size_t sizeGen = sizeof(curandState) * nbThreads;

    Device::malloc(&ptrDevNx, sizeOctetGM);
    Device::memclear(ptrDevNx, sizeOctetGM);

    Device::malloc(&ptrDevGenerator, sizeGen);
    Device::memclear(ptrDevGenerator, sizeGen);

    }

MonteCarlo::~MonteCarlo(void)
    {
//MM (device free)
	{
	Device::free(ptrDevNx);
	}
    }

void MonteCarlo::process()
    {
    monteCarlo<<<dg,db,sizeOctetSM>>>(ptrDevGenerator,nbFlechette, m,ptrDevNx);

//    Device::memcpyDToH(&result, ptrDevNx, sizeOctetGM);
    }

float MonteCarlo::getResult()
    {
    return this->result;
    }
/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

