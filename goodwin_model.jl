"""
Lightweight Goodwin Growth Cycle Model (1967)
Pure Julia implementation with RK4 integrator
No heavy dependencies
"""

"""
    goodwin_rhs!(du, u, params, t)

Right-hand side of Goodwin's differential equations.

System:
- dv/dt = v * [(1/σ - (α + β)) - u/σ]
- du/dt = u * [ρ*v - (α + γ)]

where:
- v = employment rate
- u = workers' share
- σ = capital-output ratio
- α = labor productivity growth rate
- β = labor force growth rate
- γ = constant in wage adjustment
- ρ = sensitivity of wages to employment
"""
function goodwin_rhs!(du, u, params, t)
    v, w = u
    σ, α, β, γ, ρ = params

    # dv/dt
    du[1] = v * ((1.0/σ - (α + β)) - w/σ)

    # du/dt (workers' share)
    du[2] = w * (ρ*v - (α + γ))

    return du
end

"""
    rk4_step(f!, u, params, t, dt)

Single Runge-Kutta 4th order step.
"""
function rk4_step(f!, u, params, t, dt)
    k1 = zeros(length(u))
    k2 = zeros(length(u))
    k3 = zeros(length(u))
    k4 = zeros(length(u))
    temp = zeros(length(u))

    # k1 = f(t, u)
    f!(k1, u, params, t)

    # k2 = f(t + dt/2, u + k1*dt/2)
    @. temp = u + 0.5*dt*k1
    f!(k2, temp, params, t + 0.5*dt)

    # k3 = f(t + dt/2, u + k2*dt/2)
    @. temp = u + 0.5*dt*k2
    f!(k3, temp, params, t + 0.5*dt)

    # k4 = f(t + dt, u + k3*dt)
    @. temp = u + dt*k3
    f!(k4, temp, params, t + dt)

    # u_new = u + dt/6 * (k1 + 2*k2 + 2*k3 + k4)
    @. u = u + (dt/6.0) * (k1 + 2.0*k2 + 2.0*k3 + k4)

    return u
end

"""
    solve_goodwin(params, u0, tspan, dt=0.01)

Solve Goodwin model using RK4 integrator.

Returns:
- t: time vector
- v: employment rate over time
- u: workers' share over time
"""
function solve_goodwin(params, u0, tspan, dt=0.01)
    t_start, t_end = tspan
    n_steps = Int(ceil((t_end - t_start) / dt))

    # Preallocate solution arrays
    t = collect(range(t_start, t_end, length=n_steps+1))
    v = zeros(n_steps+1)
    w = zeros(n_steps+1)

    # Initial conditions
    u = copy(u0)
    v[1] = u[1]
    w[1] = u[2]

    # Integrate
    for i in 1:n_steps
        u = rk4_step(goodwin_rhs!, u, params, t[i], dt)
        v[i+1] = u[1]
        w[i+1] = u[2]
    end

    return t, v, w
end

"""
    equilibrium_point(params)

Calculate equilibrium point of Goodwin model.

Returns (v*, u*) where:
- v* = (α + γ) / ρ
- u* = (1/σ - (α + β)) / (1/σ)
"""
function equilibrium_point(params)
    σ, α, β, γ, ρ = params
    v_eq = (α + γ) / ρ
    u_eq = (1.0/σ - (α + β)) / (1.0/σ)
    return v_eq, u_eq
end

"""
    simulate(σ, α, β, γ, ρ, v0, u0, t_max)

Run full simulation and return results.

Returns Dict with:
- t: time vector
- v: employment rate
- u: workers' share
- profits: profit share (1 - u)
- v_eq: equilibrium employment
- u_eq: equilibrium workers' share
"""
function simulate(σ, α, β, γ, ρ, v0, u0, t_max)
    params = (σ, α, β, γ, ρ)
    u0_vec = [v0, u0]
    tspan = (0.0, t_max)

    # Solve ODE
    t, v, u = solve_goodwin(params, u0_vec, tspan, 0.1)

    # Calculate equilibrium
    v_eq, u_eq = equilibrium_point(params)

    # Calculate profits
    profits = 1.0 .- u

    return Dict(
        "t" => t,
        "v" => v,
        "u" => u,
        "profits" => profits,
        "v_eq" => v_eq,
        "u_eq" => u_eq
    )
end
