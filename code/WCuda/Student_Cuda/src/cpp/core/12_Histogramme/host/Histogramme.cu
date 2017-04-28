#include <iostream>

#include "Device.h"
#include "Histogramme.h"
#include "AleaTools.h"
#include "DataCreator.h"

using std::cout;
using std::endl;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

extern __global__ void histogramme(int* tabDevInput, int* tabDevHisto, int nbData,int dataMax);

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

/**
 * tabData[i] in [0,255] */

Histogramme::Histogramme(const Grid& grid, int* ptrtabFrequence, int dataMax)
    {

    this->dg = grid.dg;
    this->db = grid.db;
    this->dataMax = dataMax;
    this->ptrTabFrequence = ptrtabFrequence;

    // init(tabFrequence, 256, 0);

    //Data
	{
	DataCreator dataCreator(dataMax);

	this->tabData = dataCreator.getTabData();
	this->nbData = dataCreator.getLength();

	this->sizeOctetHisto = sizeof(int) * dataMax;
	this->sizeOctetData = sizeof(int) * this->nbData;
	}

    //mem management
	{
	Device::malloc(&ptrTabIn, sizeOctetData);
	Device::memclear(ptrTabIn, sizeOctetData);
	Device::memcpyHToD(ptrTabIn, tabData, sizeOctetData);

	Device::malloc(&ptrTabOut, sizeOctetHisto);
	Device::memclear(ptrTabOut, sizeOctetHisto);
	}

    }

Histogramme::~Histogramme(void)
    {
//    delete[] tabData;
//    delete[] ptrTabFrequence;

    Device::free(ptrTabIn);
    Device::free(ptrTabOut);

    }

/*--------------------------------------*\
 |*		Methode			*|
 \*-------------------------------------*/

void Histogramme::run()
    {
    Device::lastCudaError("Histogramme (before)"); // temp debug
//    histogramme<<<dg, db, sizeOctetHisto>>>(tabData, tabFrequence, n);
    histogramme<<<dg, db, sizeOctetHisto>>>(ptrTabIn, ptrTabOut,nbData,dataMax);
    Device::lastCudaError("Histogramme (after)"); // temp debug

    // MM (Device -> Host)
	{
	//HANDLE_ERROR(cudaMemcpy(tabHisto, tabDevHisto, sizeOctetHisto, cudaMemcpyDeviceToHost)); // barriere synchronisation implicite
	}
    Device::synchronize();
    Device::memcpyDToH(ptrTabFrequence, ptrTabOut, sizeOctetHisto);
    }

int* Histogramme::getHistogramme()
    {
    return ptrTabFrequence;
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
