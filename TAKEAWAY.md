# Project 1
## gravity current base case
https://github.com/syou83syou83/FDSE/assets/14152233/a6ce3bfb-4b0a-4556-b71e-7742b6d38430

## gravity current collision


https://github.com/syou83syou83/FDSE/assets/14152233/187c28ad-0bf5-4ac5-bcb3-d524a2f3d9d9


## gravity current slope


https://github.com/syou83syou83/FDSE/assets/14152233/88c598b9-7e49-4974-b235-606d16c9ef25


## gravity current stratify


https://github.com/syou83syou83/FDSE/assets/14152233/bac52bbe-093e-4364-9535-3791e8ae822d


## gravity current stratify immersed boundary condition (bottom hills)


https://github.com/syou83syou83/FDSE/assets/14152233/d4c4748b-cd9a-4421-b1f4-5987eefde81c


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



https://github.com/syou83syou83/FDSE/assets/14152233/1f455d94-2aea-4721-b5ce-c69209ee6d1c

Holmboe?

https://github.com/syou83syou83/FDSE/assets/14152233/a8b1923f-b6a5-436c-bdda-80e89719e129




# Project 3 

Q1 
omega = U -beta/(k^2+l^2) 

from BetaPlane(rotation_rate = 7.292115e-5, latitude = 0, radius = 6371e3), we obtain beta = 2.29e-11.
k = l = 200km. so omega =2.29*10^-11/(200k^2+200k^2) = 0.011 m/s

According to the heatmap of u at y=Ly/2 as a function of x and time, we can see that at one fixed location, it takes 200 days for the phase to return to its original(i.e. peak to peak), so the phase speed equals 200km/200days=0.011m/s consistent with the dispersion relation omega = U -beta/(k^2+l^2) . 




For BetaPlane(rotation_rate = 7.292115e-5, latitude = 45, radius = 6371e3) 
BetaPlane{Float64}(f₀=0.000103126, β=1.61868e-11). The period is about 300days. So the phase speed from two methods are about the same. 


https://github.com/syou83syou83/FDSE/assets/14152233/b71e6eb6-f0f5-4a7a-a804-20b187ecca81


https://github.com/syou83syou83/FDSE/assets/14152233/09d4e8a4-f6a5-4308-a5ab-6f9cf69a6208



https://github.com/syou83syou83/FDSE/assets/14152233/ed7b21ff-4fd7-4c4d-ac3b-be57a5aadbcf

# Project 4


https://github.com/syou83syou83/FDSE/assets/14152233/7397bddf-25ab-4328-bdd4-46ac54fef91b


[PZ_grow10_decay02_nodiffusion.pdf](https://github.com/syou83syou83/FDSE/files/12674554/PZ_grow10_decay02_nodiffusion.pdf)




