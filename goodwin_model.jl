module GoodwinModel

using DifferentialEquations
using Statistics

export goodwin_model!, simulate_goodwin_model, calculate_equilibrium, calculate_time_averages

"""
Goodwin Growth Cycle Model (1965)

System of differential equations describing Goodwin's model:
- v = l/n (employment rate)
- u = w/a (workers' share)

Equations from original paper (pages 3-4):
    v̇ = [(1/σ - (α + β)) - (1/σ)u]v     (1)
    u̇ = [-(α + γ) + ρv]u                 (2)

Parameters:
- σ (sigma): capital-output ratio
- α (alpha): productivity growth rate
- β (beta): labor force growth rate
- γ (gamma): wage adjustment function constant
- ρ (rho): wage sensitivity to employment
"""
function goodwin_model!(du, u_state, p, t)
    v, u = u_state  # v = employment rate, u = workers' share
    sigma, alpha_growth, beta, gamma, rho = p

    # Equation (1): dv/dt
    du[1] = ((1 / sigma) - (alpha_growth + beta)) * v - (1 / sigma) * u * v

    # Equation (2): du/dt
    du[2] = (-(alpha_growth + gamma) + rho * v) * u
end

"""
Simulates Goodwin's model for a given set of parameters.

Arguments:
- sigma: capital-output ratio (σ)
- alpha_growth: productivity growth rate (α)
- beta: labor force growth rate (β)
- gamma: wage adjustment constant (γ)
- rho: wage sensitivity to employment (ρ)
- v0: initial condition for employment rate
- u0: initial condition for workers' share
- tspan: tuple (t_start, t_end) for simulation
- num_points: number of time points to evaluate

Returns:
- t: time vector
- v: employment rate vector
- u: workers' share vector
"""
function simulate_goodwin_model(sigma, alpha_growth, beta, gamma, rho, v0, u0, tspan, num_points=1000)
    println("  [GoodwinModel] Starting simulation...")
    println("    Parameters: σ=$sigma, α=$alpha_growth, β=$beta, γ=$gamma, ρ=$rho")
    println("    Conditions: v0=$v0, u0=$u0, tspan=$tspan")

    try
        u0_vec = [v0, u0]
        p = [sigma, alpha_growth, beta, gamma, rho]

        t_eval = range(tspan[1], tspan[2], length=num_points)

        println("  [GoodwinModel] Creating ODE problem...")
        prob = ODEProblem(goodwin_model!, u0_vec, tspan, p)

        println("  [GoodwinModel] Solving ODE...")
        sol = solve(prob, Tsit5(), saveat=t_eval, maxiters=1e7)

        println("  [GoodwinModel] ODE solved, extracting results...")
        t_result = collect(sol.t)
        v_result = collect(sol[1,:])
        u_result = collect(sol[2,:])

        println("  [GoodwinModel] ✓ Simulation completed")
        return t_result, v_result, u_result

    catch e
        println("  [GoodwinModel] ❌ ERROR in simulation: $e")
        showerror(stdout, e, catch_backtrace())
        # Return fallback data to avoid breaking the app
        t_fallback = collect(0.0:1.0:100.0)
        v_fallback = ones(101) .* v0
        u_fallback = ones(101) .* u0
        return t_fallback, v_fallback, u_fallback
    end
end

"""
Calculates the equilibrium point of Goodwin's model.

Equilibrium is obtained by setting v̇ = 0 and u̇ = 0 in equations (1) and (2):
- u* = (1/σ - (α + β))/(1/σ) = 1 - σ(α + β)
- v* = (α + γ)/ρ

These are the long-run values around which the system oscillates.

Arguments:
- sigma: capital-output ratio (σ)
- alpha_growth: productivity growth rate (α)
- beta: labor force growth rate (β)
- gamma: wage adjustment constant (γ)
- rho: wage sensitivity to employment (ρ)

Returns:
- u_star: workers' share at equilibrium
- v_star: employment rate at equilibrium
"""
function calculate_equilibrium(sigma, alpha_growth, beta, gamma, rho)
    u_star = (1/sigma - (alpha_growth + beta)) / (1/sigma)
    v_star = (alpha_growth + gamma) / rho
    return u_star, v_star
end

"""
Calculates time averages of v and u, excluding an initial 'warmup' phase.

As mentioned in Goodwin's paper (page 8), the system has constant long-run
averages (η₁/θ₁ for u and η₂/θ₂ for v) that are independent of initial
conditions. This function calculates those averages empirically.

Arguments:
- t: time vector
- v: employment rate vector
- u: workers' share vector
- warmup_fraction: initial fraction of simulation to discard (default: 0.2)

Returns:
- avg_v: average employment rate
- avg_u: average workers' share
"""
function calculate_time_averages(t, v, u, warmup_fraction=0.2)
    n_skip = Int(floor(length(t) * warmup_fraction))
    avg_v = mean(v[n_skip:end])
    avg_u = mean(u[n_skip:end])
    return avg_v, avg_u
end

end # module
