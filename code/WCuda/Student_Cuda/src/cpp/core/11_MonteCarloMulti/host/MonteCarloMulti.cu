#include "MonteCarloMulti.h"

#include "Device.h"
#include "MonteCarlo.h"

#include "Chrono.h"
#include "cudaTools.h"

#include <iostream>
using std::cout;
using std::endl;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/
//extern __global__ void monteCarloMulti(curandState* tabDevGeneratorGM, int nbFlechettes, float m,int* ptrDevNx);
//extern __global__ void setup_kernel_rand(curandState* tabDevGenerator, int deviceId);
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
MonteCarloMulti::MonteCarloMulti(const Grid& grid, int nbFlechettes, float m)
    {
    this->grid = grid;

    this->nbFlechette = nbFlechettes;
    this->m = m;

    this->nbDevice = Device::getDeviceCount();
    this->tabResult = new int[nbDevice];

    }

MonteCarloMulti::~MonteCarloMulti(void)
    {
    delete[] tabResult;
    }

void MonteCarloMulti::process()
    {
    Chrono chrono;
//#pragma omp parallel for
    for (int deviceId = 0; deviceId < nbDevice; deviceId++)
	{
	Device::setDevice(deviceId);

	MonteCarlo montecarlo(grid, nbFlechette / nbDevice, m);

	montecarlo.process();
	//getCountFlechettesSousCourbe dans MonteCarlo (pas la multi)
	int r = montecarlo.getCountFlechettesSousCourbe();

	tabResult[deviceId] = r;

	Device::printCurrent();
	}
    reduce(tabResult);

    result = (float) nbFlechTot / (float) nbFlechette * m;

    chrono.stop();
    cout << "ElapseTime: " << chrono.getElapseTimeS() << " (s)" << endl;
    //para: 0.149814s
    //seq: 0.42455s
    }

float MonteCarloMulti::getResult()
    {
    return this->result;
    }
/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/
void MonteCarloMulti::reduce(int* tab)
    {
    this->nbFlechTot = 0;
    for (int i = 0; i < nbDevice; i++)
	{
	nbFlechTot += tab[i];
	}

    }
/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

