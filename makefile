.PHONY: cori cori_prof boltz
#directories
DIR=$(PWD)/
EXECDIR=$(DIR)
OBJDIR=$(DIR)obj/
SRCDIR=$(DIR)src/
FFTW_DIR=/project/projectdirs/m3118/fftw3_3.3.3_gcc/
MAPLIB =$(DIR)allinea-profiler.ld

# GNU C compiler 
CC=mpicc
MPICC=mpicc
WEIGHTCC=mpicc

# Compiler flags
CFLAGS= -O2 -fopenmp -Wall
FFTFLAGS = -lgsl -lgslcblas -lfftw3_omp -lfftw3 -lm

WEIGHTCFLAGS = -O2 -fopenmp -Wall 
WEIGHTFFTFLAGS = -lgsl -lgslcblas -lfftw3 -lm 

# Command definition
RM=rm -f

# sources for main
sources = $(SRCDIR)main.c $(SRCDIR)initializer.c $(SRCDIR)restart.c

objects = weights.o collisions.o output.o input.o gauss_legendre.o momentRoutines.o conserve.o transportroutines.o boundaryConditions.o mesh_setup.o species.o aniso_weights.o

weight_sources = $(SRCDIR)MPIWeightGenerator.c $(SRCDIR)MPIcollisionroutines.c $(SRCDIR)gauss_legendre.c

pref_objects = $(addprefix $(OBJDIR), $(objects))

# linking step
boltz: $(pref_objects) $(sources)
	@echo "Building Boltzmann deterministic solver"
	$(CC) $(CFLAGS) -o $(EXECDIR)boltz_ $(sources) $(pref_objects) $(FFTFLAGS)

weights: $(weight_sources)
	@echo "Building Anisotropic weight generator"
	$(MPICC) $(WEIGHTCFLAGS) -o $(EXECDIR)WeightGen_ $(weight_sources) $(WEIGHTFFTFLAGS)

$(OBJDIR)MPIWeightGenerator.o : $(SRCDIR)MPIWeightgenerator.c
	@echo "Compiling  $< ... " ; \
	if [ -f  $@ ] ; then \
		rm $@ ;\
	fi ; \
	$(WEIGHTCC)  -c $(WEIGHTCFLAGS)  $< -o $@ 2>&1 ;

$(OBJDIR)MPIcollisionroutines.o : $(SRCDIR)MPIcollisionroutines.c
	@echo "Compiling  $< ... " ; \
	if [ -f  $@ ] ; then \
		rm $@ ;\
	fi ; \
	$(WEIGHTCC)  -c $(WEIGHTCFLAGS)  $< -o $@ 2>&1 ;

$(OBJDIR)collisions.o: $(SRCDIR)collisions.c 
	@echo "Compiling  $< ... " ; \
	if [ -f  $@ ] ; then \
		rm $@ ;\
	fi ; \
	$(CC)  -c $(CFLAGS)  $< -o $@ 2>&1 ;

$(OBJDIR)output.o: $(SRCDIR)output.c 
	@echo "Compiling  $< ... " ; \
	if [ -f  $@ ] ; then \
 		rm $@ ;\
	fi ; \
	$(CC)  -c $(CFLAGS)  $< -o $@ 2>&1 ;

$(OBJDIR)input.o: $(SRCDIR)input.c
	@echo "Compiling  $< ... " ; \
	if [ -f  $@ ] ; then \
 		rm $@ ;\
	fi ; \
	$(CC)  -c $(CFLAGS)  $< -o $@ 2>&1 ;

$(OBJDIR)weights.o: $(SRCDIR)weights.c 
	@echo "Compiling  $< ... " ; \
	if [ -f  $@ ] ; then \
		rm $@ ;\
	fi ; \
	$(CC)  -c $(CFLAGS)  $< -o $@ 2>&1 ;

$(OBJDIR)gauss_legendre.o: $(SRCDIR)gauss_legendre.c
	@echo "Compiling  $< ... " ; \
	if [ -f  $@ ] ; then \
		rm $@ ;\
	fi ; \
	$(CC)  -c $(CFLAGS)  $< -o $@ 2>&1 ;

$(OBJDIR)momentRoutines.o : $(SRCDIR)momentRoutines.c
	@echo "Compiling  $< ... " ; \
	if [ -f  $@ ] ; then \
		rm $@ ;\
	fi ; \
	$(CC)  -c $(CFLAGS)  $< -o $@ 2>&1 ;

$(OBJDIR)conserve.o : $(SRCDIR)conserve.c
	@echo "Compiling  $< ... " ; \
	if [ -f  $@ ] ; then \
		rm $@ ;\
	fi ; \
	$(CC)  -c $(CFLAGS)  $< -o $@ 2>&1 ;

$(OBJDIR)transportroutines.o : $(SRCDIR)transportroutines.c
	@echo "Compiling  $< ... " ; \
	if [ -f  $@ ] ; then \
		rm $@ ;\
	fi ; \
	$(CC)  -c $(CFLAGS)  $< -o $@ 2>&1 ;


$(OBJDIR)boundaryConditions.o : $(SRCDIR)boundaryConditions.c
	@echo "Compiling  $< ... " ; \
	if [ -f  $@ ] ; then \
		rm $@ ;\
	fi ; \
	$(CC)  -c $(CFLAGS)  $< -o $@ 2>&1 ;

$(OBJDIR)mesh_setup.o : $(SRCDIR)mesh_setup.c
	@echo "Compiling  $< ... " ; \
	if [ -f  $@ ] ; then \
		rm $@ ;\
	fi ; \
	$(CC)  -c $(CFLAGS)  $< -o $@ 2>&1 ;

$(OBJDIR)species.o : $(SRCDIR)species.c
	@echo "Compiling  $< ... " ; \
	if [ -f  $@ ] ; then \
		rm $@ ;\
	fi ; \
	$(CC)  -c $(CFLAGS)  $< -o $@ 2>&1 ;

$(OBJDIR)aniso_weights.o : $(SRCDIR)aniso_weights.c
	@echo "Compiling  $< ... " ; \
	if [ -f  $@ ] ; then \
		rm $@ ;\
	fi ; \
	$(CC)  -c $(CFLAGS)  $< -o $@ 2>&1 ;

clean:
	$(RM) $(OBJDIR)*.o 
	$(RM) $(EXECDIR)*_


cori: CFLAGS += -I${FFTW_DIR}/include -L${FFTW_DIR}/lib ${GSL} -dynamic -L${PWD}
cori: FFTFLAGS += -dynamic -L${PWD}
cori: WEIGHTFLAGS += -dynamic -L${PWD}
cori: WEIGHTFFTFLAGS += -dynamic -L${PWD}
cori: boltz

cori_map: CFLAGS += -g -lmap-sampler-pmpi -lmap-sampler -Wl,--eh-frame-hdr
cori_map: FFTFLAGS += -g -lmap-sampler-pmpi -lmap-sampler -Wl,--eh-frame-hdr
cori_map: WEIGHTFLAGS += -g -lmap-sampler-pmpi -lmap-sampler -Wl,--eh-frame-hdr
cori_map: WEIGHTFFTFLAGS += -g -lmap-sampler-pmpi -lmap-sampler -Wl,--eh-frame-hdr
cori_map: cori


profile: CFLAGS += -g
profile: CFLAGS:=$(filter-out -O2,$(CFLAGS))
profile: CFLAGS += -O0
profile: FFTFLAGS += -g
profile: FFTFLAGS:=$(filter-out -O2,$(FFTFLAGS))
profile: FFTFLAGS += -O0
profile: WEIGHTFLAGS += -g
profile: WEIGHTFLAGS:=$(filter-out -O2,$(WEIGHTFLAGS))
profile: WEIGHTFLAGS += -O0
profile: WEIGHTFFTFLAGS += -g
profile: WEIGHTFFTFLAGS:=$(filter-out -O2,$(WEIGHTFFTFLAGS))
profile: WEIGHTFFTFLAGS += -O0
profile: boltz
