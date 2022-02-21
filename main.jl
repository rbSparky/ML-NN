using DifferentialEquations
using Plots
#r=rabbit w=wolf



sol = solve(prob)

function multi_noise(du,u,p,t)
    r,w = u
    du[1] = 0.3 * r
    du[2] = 0.3 * w
end

prob = SDEProblem(latka_volterra!,multi_noise,u₀,tspan,p)
sol = solve(prob)
plot(sol)

#ens_prob = EnsembleProblem(prob)
#sol = solve(ens_prob, -  - -)
τ = 1.0

function latka_volterra!(du,u,h,p,t)
    r,w = u
    cr = h(p,t - τ;idxs=1) #clock rabbit
    α,β,γ,δ = p
    du[1] = dr = α*cr-β*r*w
    du[2] = dw = γ*r*w-δ*w
    nothing
end


u₀ = [1.0,1.0]
tspan = (0.0,10.0)
h(p,t) = [1.0,1.0]
h(p,t;idxs=1) = 1.0

p = [1.5,1.0,3.0,1.0]
prob = DDEProblem(latka_volterra!,u₀,h,tspan,p,constant_lag = [τ])
sol = solve(prob)
plot(sol)

u′ = f(u)
u(0) = u₀

#population control!
fr_cond(u,t,integrator) = u[2] - 4 #fire rabbit
fr_affect!(integrator) = integrator.u[2] -= 1
fr_cb = ContinuousCallback(fr_cond, fr_affect!) # callback

sol = solve(prob,callback = fr_cb)

plot(sol)
