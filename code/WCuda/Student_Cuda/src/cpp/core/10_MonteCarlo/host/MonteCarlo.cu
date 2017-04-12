#include "Device.h"
#include "MonteCarlo.h"

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/
extern __global__ void monteCarlo(curandState* tabDevGeneratorGM, int nbFlechettes, float m,int* ptrDevNx);
extern __global__ void setup_kernel_rand(curandState* tabDevGenerator, int deviceId);

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
    this->sizeOctetSM = grid.db.x * grid.db.y * grid.db.z* sizeof(int);
    this->sizeOctetGM = sizeof(int);

    int nbThreads = grid.threadCounts();
    size_t sizeGen = sizeof(curandState) * nbThreads;

    Device::malloc(&ptrDevNx, sizeOctetGM);
    Device::memclear(ptrDevNx, sizeOctetGM);

    Device::malloc(&ptrDevGenerator, sizeGen);
    Device::memclear(ptrDevGenerator, sizeGen);

    setup_kernel_rand<<<dg,db>>>(ptrDevGenerator, Device::getDeviceId());

}

MonteCarlo::~MonteCarlo(void)
{
//MM (device free)
    {
    Device::free(ptrDevNx);
    Device::free(ptrDevGenerator);
    }
}

void MonteCarlo::process()
{
    monteCarlo<<<dg,db,sizeOctetSM>>>(ptrDevGenerator,nbFlechette, m,ptrDevNx);

    Device::memcpyDToH(&nbThrowRes, ptrDevNx, sizeOctetGM);

    result = (float)nbThrowRes / (float)nbFlechette *m;
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

