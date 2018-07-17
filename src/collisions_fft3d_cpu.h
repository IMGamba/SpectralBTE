#ifndef _COLLISIONS_FFT3D_CPU_H
#define _COLLISIONS_FFT3D_CPU_H

void fft3D_cpu(const double (*in)[2], double (*out)[2], const double delta, const double L_start, const double L_end, const double sign, const double *var, const double *wtN);

void initialize_collisions_support_cpu(int nodes, double scale3);

void deallocate_collisions_support_cpu();

#endif