# A script to explore Rossby wave propagation and nonlinear behavior using Oceananigans
# Rossby waves on a zonal mean flow & Zonal jets 
# Load some packages that we will need
using Oceananigans
using Printf
using Oceananigans.Units
using JLD2

# Set the domain size in dimensional coordinates
Lx = 1000kilometers  
Ly = 1000kilometers

# Set the grid size
Nx = 128   # number of grid points in x-direction
Ny = 128   # number of grid points in y-direction

# Construct a rectilinear grid that is periodic in x-direction and bounded in y-direction
grid = RectilinearGrid(size = (Nx, Ny),
                       x = (0, Lx), y = (0, Ly),
                       topology = (Periodic, Bounded, Flat)
)

# Set up a model for Rossby waves
model = NonhydrostaticModel(; grid,
              advection = UpwindBiasedFifthOrder(),   # Specify the advection scheme.  Another good choice is WENO() which is more accurate but slower
            timestepper = :RungeKutta3,   # Set the timestepping scheme, here 3rd order Runge-Kutta
                tracers = :c,
                coriolis = BetaPlane(rotation_rate = 7.292115e-5, latitude = 45, radius = 69911e3)   # set Coriolis parameter using the Beta-plane approximation 
)  #Jupiter/Radius 69,911 km, earth 6371e3

# Set wavenumbers associated with the initial condition
k = 2 * pi / 200kilometers 
l = 2 * pi / 200kilometers

# Define functions for the initial conditions
u₀ = 0.05   # units: 0.001m/s
# U₀(x, y, z) = model.coriolis.β / (k^2 + l^2) * tanh((y - Ly/2) / Ly * 5)    #u₀ * tanh((y - Ly/2) / Ly * 5)        ######### mean flow 
U₀(x, y, z) = 0.05
uᵢ(x, y, z) = U₀(x, y, z) + u₀ * sin(k * x) * sin(l * y)    #u₀ * sin(k * x) * sin(l * y)
vᵢ(x, y, z) = u₀ * (k / l) * cos(k * x) * cos(l * y)
wᵢ(x, y, z) = 0
cᵢ(x, y, z) = sin(k * x) * cos(l * y) # Here, we set the function for c so that it is proportional to the streamfunction associated with (u,v)

# Send the initial conditions to the model to initialize the variables
set!(model, u = uᵢ, v = vᵢ, w = wᵢ, c = cᵢ)

# Create a 'simulation' to run the model for a specified length of time
simulation = Simulation(model, Δt = 10hours, stop_iteration = 3000)

# Add callback that prints progress message during simulation
progress(sim) = @info string("Iter: ", iteration(sim),
                             ", time: ", prettytime(sim))

simulation.callbacks[:progress] = Callback(progress, IterationInterval(10))

# Save output from the simulation
# filename = "rossbywave_U_1"    # model.coriolis.β / (k^2 + l^2) : phase speed is zero throughout the domain 
# filename = "rossbywave_U_2"  # model.coriolis.β / (k^2 + l^2) * tanh((y - Ly/2) / Ly * 5) : phase speed is zero at the top 
# filename = "rossbywave_U_u001"# model.coriolis.β / (k^2 + l^2) * tanh((y - Ly/2) / Ly * 5) with u₀=0.01: transport and eddy 
filename = "rossbywave_U2_Jupiter" #  U=0.16m/s on earth 
u, v, w = model.velocities
c = model.tracers.c
ω = ∂x(v) - ∂y(u) + model.coriolis.f₀ # The relative vorticity + coriolis
# f₀ = model.coriolis.f₀
simulation.output_writers[:jld2] = JLD2OutputWriter(model, (; u, v, w, c, ω),
                                                    schedule = IterationInterval(10),
                                                    filename = filename * ".jld2",
                                                    overwrite_existing = true
)

# Run the simulation                                                  
run!(simulation)

# Make a plot of u at y=Ly/2 and save a movie
include("plot_rossbywave_me.jl")