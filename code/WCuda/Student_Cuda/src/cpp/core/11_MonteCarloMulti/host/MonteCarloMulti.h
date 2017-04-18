#include <curand_kernel.h>
#include "Device.h"

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

class MonteCarloMulti
    {
    public:

	MonteCarloMulti(const Grid& grid, int nbFlechettes, float m);

	virtual ~MonteCarloMulti();

    public:

	void process();
	float getResult();

private:
	void reduce(int* tab);

    private:


	Grid grid;

	int nbFlechette;
	float m;
	int nbDevice;


	float result;
	int* tabResult;
	int nbFlechTot;


    };


/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
