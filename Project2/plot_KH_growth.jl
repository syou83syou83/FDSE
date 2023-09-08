
# This script reads in output from KH.jl, makes a plot, and saves an animation

using Oceananigans, JLD2, Plots, Printf, Statistics

# Set the filename (without the extension)
filename = "KH_h01"

# Read in the first iteration.  We do this to load the grid
# filename * ".jld2" concatenates the extension to the end of the filename
u_ic = FieldTimeSeries(filename * ".jld2", "u", iterations = 0)
v_ic = FieldTimeSeries(filename * ".jld2", "v", iterations = 0)
w_ic = FieldTimeSeries(filename * ".jld2", "w", iterations = 0)
b_ic = FieldTimeSeries(filename * ".jld2", "b", iterations = 0)
ω_ic = FieldTimeSeries(filename * ".jld2", "ω", iterations = 0)
χ_ic = FieldTimeSeries(filename * ".jld2", "χ", iterations = 0)
ϵ_ic = FieldTimeSeries(filename * ".jld2", "ϵ", iterations = 0)
# Rig_ic = FieldTimeSeries(filename * ".jld2", "Rig", iterations = 0)
## Load in coordinate arrays
## We do this separately for each variable since Oceananigans uses a staggered grid
xu, yu, zu = nodes(u_ic)
xv, yv, zv = nodes(v_ic)
xw, yw, zw = nodes(w_ic)
xb, yb, zb = nodes(b_ic)
xω, yω, zω = nodes(ω_ic)
xχ, yχ, zχ = nodes(χ_ic)
xϵ, yϵ, zϵ = nodes(ϵ_ic)
# xRig, yRig, zRig = nodes(Rig_ic)
## Now, open the file with our data
file_xz = jldopen(filename * ".jld2")

## Extract a vector of iterations
iterations = parse.(Int, keys(file_xz["timeseries/t"]))
perturbation_energy = []
Rig_mean = []

for (i, iter) in enumerate(iterations)
    u_xz = file_xz["timeseries/u/$iter"][:, 1, :]
    w_xz = file_xz["timeseries/w/$iter"][:, 1, :]
    b_xz = file_xz["timeseries/b/$iter"][:, 1, :]
    u_xz_perturbation = u_xz - repeat(mean(u_xz, dims = 1), size(u_xz)[1], 1)
    w_xz_perturbation = w_xz - repeat(mean(w_xz, dims = 1), size(w_xz)[1], 1)
    push!(perturbation_energy, 0.5 * sum(u_xz_perturbation.^2) + 0.5 * sum(w_xz_perturbation.^2))

    u_xz_mean = mean(u_xz, dims = 1)
    b_xz_mean = mean(b_xz, dims = 1)
    dz = zu[2]-zu[1]   # same as zb 
    Rig = (b_xz_mean[2:end]-b_xz_mean[1:end-1])/dz./((u_xz_mean[2:end]-u_xz_mean[1:end-1])/dz).^2  # Rig = dbdz ./ (dudz .^ 2)
    push!(Rig_mean,Rig)
    # push!(Rig_mean, file_xz["timeseries/Rig/$iter"][1, 1, :])
    # global Rig_mean=[Rig_mean mean(file_xz["timeseries/Rig/$iter"][:, 1, :],dims=1)[:]]
end
################## compare growth rate 
plot(0.2*[0:1:length(perturbation_energy)-1],log.(perturbation_energy), legend=:bottomright,
    title=filename*", the slope of the curve should be σ", label="Perturbation kinetic energy from velocity field",
    xlabel="Time", ylabel="log(Perturbation kinetic energy)")
σ = 1.18  # h=0.1,σ=1.18; h=0.2,σ=0.819; h=0.3,σ=0.2; 
plot!(0.2*[0:1:length(perturbation_energy)-1],0.2*[0:1:length(perturbation_energy)-1]*σ, legend=:topright,
        label="growth rate σ from linstab.jl")
# savefig(filename*"growth"*".pdf")
##################

################## plot Rig vs depth and time, heatmap
Rig_matrix = zeros(length(Rig_mean),length(Rig_mean[1]))
for i in 1:length(Rig_mean)
    Rig_matrix[i,:] = Rig_mean[i]
end
heatmap(0.2*(1:length(Rig_mean)),zu[2:64], Rig_matrix',xlabel="Time",ylabel="z",title="Rig, "*filename,
        clim=(0,1))
# savefig(filename*"_Rig"*".pdf")
##################

################## plot Rig vs depth and time, traditonal methods 
# tt = 0.2*(1:102)
# plot(zu[2:64],Rig_mean[1],title = filename,label="Time: "*string(tt[1]),xlabel="z",ylabel="Rig",ylims=(0,10))
# plot!(zu[2:64],Rig_mean[20],label="Time: "*string(tt[20]))
# plot!(zu[2:64],Rig_mean[60],label="Time: "*string(tt[60]))
# plot!(zu[2:64],Rig_mean[100],label="Time: "*string(tt[100]))
##################






# @info "Making an animation from saved data..."

# # Here, we loop over all iterations
# anim = @animate for (i, iter) in enumerate(iterations)

#     @info "Drawing frame $i from iteration $iter..."

#     u_xz = file_xz["timeseries/u/$iter"][:, 1, :];
#     v_xz = file_xz["timeseries/v/$iter"][:, 1, :];
#     w_xz = file_xz["timeseries/w/$iter"][:, 1, :];
#     b_xz = file_xz["timeseries/b/$iter"][:, 1, :];
#     ω_xz = file_xz["timeseries/ω/$iter"][:, 1, :];
#     χ_xz = file_xz["timeseries/χ/$iter"][:, 1, :];
#     ϵ_xz = file_xz["timeseries/ϵ/$iter"][:, 1, :];

#     t = file_xz["timeseries/t/$iter"];

#         b_xz_plot = heatmap(xb, zb, b_xz'; color = :thermal, xlabel = "x", ylabel = "z", aspect_ratio = :equal, xlims = (0, Lx), ylims = (0, Lz)); 
#         ω_xz_plot = heatmap(xω, zω, ω_xz'; color = :thermal, xlabel = "x", ylabel = "z", aspect_ratio = :equal, xlims = (0, Lx), ylims = (0, Lz)); 
#         χ_xz_plot = heatmap(xχ, zχ, χ_xz'; color = :thermal, xlabel = "x", ylabel = "z", aspect_ratio = :equal, xlims = (0, Lx), ylims = (0, Lz)); 
#         ϵ_xz_plot = heatmap(xϵ, zϵ, ϵ_xz'; color = :thermal, xlabel = "x", ylabel = "z", aspect_ratio = :equal, xlims = (0, Lx), ylims = (0, Lz)); 

#     u_title = @sprintf("u, t = %s", round(t));
#     v_title = @sprintf("v, t = %s", round(t));
#     w_title = @sprintf("w, t = %s", round(t));
#     b_title = @sprintf("b, t = %s", round(t));
#     ω_title = @sprintf("vorticity (ω), t = %s", round(t));
#     ϵ_title = @sprintf("KE dissipation (ϵ), t = %s", round(t));
#     χ_title = @sprintf("buoyancy variance dissipation (χ), t = %s", round(t));

# # Combine the sub-plots into a single figure
#     # plot(b_xz_plot, ω_xz_plot, ϵ_xz_plot, χ_xz_plot, layout = (4, 1), size = (1200, 800),
#     # title = [b_title ω_title ϵ_title χ_title])
#     plot(b_xz_plot, size = (1200, 800), title = [b_title])
#     iter == iterations[end] && close(file_xz)
# end

# # Save the animation to a file
# mp4(anim, filename*".mp4", fps = 20) # hide
