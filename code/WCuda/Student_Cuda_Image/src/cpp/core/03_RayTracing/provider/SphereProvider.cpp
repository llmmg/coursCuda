#include "SphereProvider.h"
#include "Sphere.h"

#include "RayTracing.h"

#include "MathTools.h"
#include "Grid.h"

#include "ImageAnimable_GPU.h"
#include "DomaineMath_GPU.h"
using namespace gpu;

Animable_I<uchar4>* SphereProvider::createAnimable(void)
    {
    // Animation;
//    float dt = 2 * PI / 800;
    float dt = 0.01;

    int nbSphere = 100;

    // Dimension
    int dw = 16 * 50;
    int dh = 16 * 50;

    // Grid Cuda
    int mp = Device::getMPCount();
    int coreMP = Device::getCoreCountMP();

    dim3 dg = dim3(mp, 2, 1);  		// disons, a optimiser selon le gpu, peut drastiqument ameliorer ou baisser les performances
    dim3 db = dim3(coreMP, 2, 1);   	// disons, a optimiser selon le gpu, peut drastiqument ameliorer ou baisser les performances

    Grid grid(dg, db);

//    Sphere* ptrTabSphere= new Sphere[nbSphere];
    return new RayTracing(grid, dw, dh, nbSphere, dt/*, ptrTabSphere*/);
    }

Image_I* SphereProvider::createImageGL(void)
    {
    ColorRGB_01 colorTexte(1, 0, 0); // black
    return new ImageAnimable_RGBA_uchar4(createAnimable(), colorTexte);
    }
