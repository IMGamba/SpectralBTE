/************************************************

collisions.h - contains frontend for evaluating the collision operator. 

Requires weights generated by weights.h

Requires linking of conserve.h

Requires linking of momentRoutines.h

**************************************************/

#ifndef _COLLISIONS_H
#define _COLLISIONS_H
#include <fftw3.h>

/*******************
function initialize_coll
Initializes the collision routine parameters and allocates needed memory
==============
Inputs:
modes: number of velocity nodes in each direction
length: semi-length size of computational domain: [-L,L]
vel: vector of the velocity grid points
zeta: vector of the fourier space grid pts
********************/
void initialize_coll(int modes, double length, double *vel, double *zeta);

/*********************
function dealloc_coll
deallocates all dynamically allocated memory for the collisions module
 ********************/
void dealloc_coll();


//Internal routines

void ComputeQ(double *f, double *g, double *Q, double **conv_weights);

void ComputeQ_maxPreserve(double *f, double *g, double *Q, double **conv_weights);

void fft3D(fftw_complex *in, fftw_complex *out);

void ifft3D(fftw_complex *in, fftw_complex *out);

#endif
