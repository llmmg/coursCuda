#include <curand_kernel.h>

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

class MonteCarlo
    {
    public:

	MonteCarlo(const Grid& grid, int nbFlechettes, float m);

	virtual ~MonteCarlo();

    public:

	void process();
	float getResult();

    private:

	dim3 dg;
	dim3 db;

	int nbFlechette;
	float m;

	int* ptrDevNx;
	curandState* ptrDevGenerator=NULL;

	size_t sizeOctetSM;
	size_t sizeOctetGM;

	float result;

    };


/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
