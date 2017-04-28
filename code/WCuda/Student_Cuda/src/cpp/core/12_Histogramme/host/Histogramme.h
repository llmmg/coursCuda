#pragma once

#include "cudaTools.h"

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

class Histogramme
    {
	/*--------------------------------------*\
	|*		Constructor		*|
	 \*-------------------------------------*/

    public:

	/**
	 * update w by v1+v2
	 */
//	Histogramme(int n);
//	Histogramme(unsigned char* tabData, long n, unsigned int* tabFrequence)

	Histogramme(const Grid& grid, int* ptrtabFrequence, int dataMax);

	virtual ~Histogramme(void);

	/*--------------------------------------*\
	|*		Methodes		*|
	 \*-------------------------------------*/

    public:

	void run();
	int* getHistogramme();

	/*--------------------------------------*\
	|*		Attributs		*|
	 \*-------------------------------------*/

    private:

	// Inputs
//	long n;

	// output
	//int* tabHisto;

	// Tools
	dim3 dg;
	dim3 db;
	int dataMax;

	//length
	int nbData;
	int* tabData;

	//in/out
	int* ptrTabFrequence;
//	int* ptrRes;
	int* ptrTabOut;
	int* ptrTabIn;

	size_t sizeOctetData;
	//reslut
	size_t sizeOctetHisto;

    };

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
