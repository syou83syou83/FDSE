# A script to explore Rossby wave propagation and nonlinear behavior using Oceananigans

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
                    #    topology = (Periodic, Bounded, Flat)
                    topology = (Bounded, Bounded, Flat)
)
######### On each plane, you can only specify velocity existing on that plane. 
######### For example, on "top" you can only specify u and v, on east you can only specify v and w!!!!!!!
######### no flux: tracer and momentum fluxes are conservative or "zero flux" by default. 
v_bcs_1 = FieldBoundaryConditions(east = FluxBoundaryCondition(nothing),   # no flux, default 
                                west = FluxBoundaryCondition(nothing))
######### A "no-slip" BoundaryCondition 
######### specifies that velocity components tangential to Bounded directions decay to 0 at the boundary, leading to a viscous loss of momentum.
v_bcs_2 = FieldBoundaryConditions(east = ValueBoundaryCondition(0.0),   #ValueBoundaryCondition(0.0) is no slip
                                west = ValueBoundaryCondition(0.0))
# Set up a model for Rossby waves
model = NonhydrostaticModel(; grid,
              advection = UpwindBiasedFifthOrder(),   # Specify the advection scheme.  Another good choice is WENO() which is more accurate but slower
            timestepper = :RungeKutta3,   # Set the timestepping scheme, here 3rd order Runge-Kutta
                tracers = :c,
                # boundary_conditions = (v = v_bcs_1,  ),  # no flux
                boundary_conditions = (v = v_bcs_2, ),  # no slip
                coriolis = BetaPlane(rotation_rate = 7.292115e-5, latitude = 45, radius = 6371e3)   # set Coriolis parameter using the Beta-plane approximation 
)

# Set wavenumbers associated with the initial condition
k = 2 * pi / 200kilometers 
l = 2 * pi / 200kilometers

# Define functions for the initial conditions
u₀ = 0.03   # units: 0.001m/s
U₀(x, y, z) = model.coriolis.β / (k^2 + l^2)    #u₀ * tanh((y - Ly/2) / Ly * 5)        ######### mean flow 
uᵢ(x, y, z) = U₀(x, y, z) + u₀ * sin(k * x) * sin(l * y)    #u₀ * sin(k * x) * sin(l * y)
vᵢ(x, y, z) = u₀ * (k / l) * cos(k * x) * cos(l * y)
wᵢ(x, y, z) = 0
cᵢ(x, y, z) = sin(k * x) * cos(l * y) # Here, we set the function for c so that it is proportional to the streamfunction associated with (u,v)

# Send the initial conditions to the model to initialize the variables
set!(model, u = uᵢ, v = vᵢ, w = wᵢ, c = cᵢ)

# Create a 'simulation' to run the model for a specified length of time
simulation = Simulation(model, Δt = 10hours, stop_iteration = 1000)

# Add callback that prints progress message during simulation
progress(sim) = @info string("Iter: ", iteration(sim),
                             ", time: ", prettytime(sim))

simulation.callbacks[:progress] = Callback(progress, IterationInterval(10))

# Save output from the simulation
# filename = "rossbywave_graveyard_1"# no flux, default 
filename = "rossbywave_graveyard_2_u003"# no slip, default 

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