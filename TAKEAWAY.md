# Project 1
## gravity current base case
https://github.com/syou83syou83/FDSE/assets/14152233/a6ce3bfb-4b0a-4556-b71e-7742b6d38430

## gravity current collision

## gravity current slope

## gravity current stratify

## gravity current stratify immersed boundary condition (bottom hills)

# Project 2

LZ = 1    # The z-domain size
LX = 10   # The x-domain size (sets the range of wavenumbers to search)
h = 0.05     # Shear layer width 0.1
NZ = 100  # The number of gridpoints
dz = LZ / NZ  # The grid spacing - must be evenly spaced
nu = 1 / 5000  # Kinematic viscosity (or 1/Re)
kappa = nu    # Diffusivity
S0 = 10       # Maximum shear
N0 = sqrt(10)       # Maximum buoyancy frequency


Q1 
when h = 0.05  (k*,sigma*)=(8.58,1.12), the corresponding lamda = 2pi/8.58 = 0.73
when h = 0.1  (k*,sigma*)=(4.48,1.18), the corresponding lamda = 2pi/4.48 = 1.4
when h = 0.2  (k*,sigma*)=(2.2,), the corresponding lamda = 2pi/2.2 = 3
which means when h =0.1, wavelength = 1.4, that is the distance between two peaks of the billows.

# Project 3 

Q1 
omega = U -beta/(k^2+l^2) 

from BetaPlane(rotation_rate = 7.292115e-5, latitude = 0, radius = 6371e3), we obtain beta = 2.29e-11.
k = l = 200km. so omega =2.29*10^-11/(200k^2+200k^2) = 0.011 m/s

According to the heatmap of u at y=Ly/2 as a function of x and time, we can see that at one fixed location, it takes 200 days for the phase to return to its original(i.e. peak to peak), so the phase speed equals 200km/200days=0.011m/s consistent with the dispersion relation omega = U -beta/(k^2+l^2) . 




For BetaPlane(rotation_rate = 7.292115e-5, latitude = 45, radius = 6371e3) 
BetaPlane{Float64}(f₀=0.000103126, β=1.61868e-11). The period is about 300days. So the phase speed from two methods are about the same. 