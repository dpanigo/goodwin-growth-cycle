---
title: Goodwin Growth Cycle Model
emoji: 📊
colorFrom: blue
colorTo: green
sdk: docker
app_port: 7860
---

# Goodwin Growth Cycle Model (1965)

Lightweight interactive web application implementing Richard M. Goodwin's growth cycle model.

## Features

- **Pure Julia implementation** with custom RK4 integrator (no DifferentialEquations.jl)
- **Minimal dependencies** - only HTTP.jl and JSON3.jl
- **Static HTML frontend** with Plotly.js for visualization
- **Real-time parameter adjustment**
- **Time series and phase diagram plots**
- **Equilibrium point calculation**

## Technical Details

### Model Equations

The Goodwin model describes economic cycles through a predator-prey system:

```
dv/dt = v * [(1/σ - (α + β)) - u/σ]
du/dt = u * [ρ*v - (α + γ)]
```

Where:
- **v** = employment rate
- **u** = workers' share of output
- **σ** = capital-output ratio
- **α** = labor productivity growth rate
- **β** = labor force growth rate
- **γ** = constant in wage adjustment function
- **ρ** = sensitivity of wages to employment level

### Architecture

- **Backend**: Julia HTTP server with JSON API
- **Frontend**: Static HTML with Plotly.js
- **Solver**: Custom Runge-Kutta 4th order integrator
- **Memory footprint**: ~50-100 MB (vs 500-700 MB with full stack)

## Local Development

### Prerequisites
- Julia 1.10 or newer
- Docker (optional, for containerized deployment)

### Run Locally

```bash
cd GoodwinLite
julia --project=. -e 'using Pkg; Pkg.instantiate()'
julia --project=. server.jl
```

Open browser at: http://localhost:7860

### Run with Docker

```bash
docker build -t goodwin-lite .
docker run -p 7860:7860 goodwin-lite
```

## Parameters

### Model Parameters
- **σ** (0.5-2.0): Capital-output ratio
- **α** (0.001-0.1): Labor productivity growth rate
- **β** (0.001-0.1): Labor force growth rate
- **γ** (0.001-0.1): Wage adjustment constant
- **ρ** (0.001-0.2): Wage sensitivity to employment

### Initial Conditions
- **v₀** (0.1-1.0): Initial employment rate
- **u₀** (0.1-1.0): Initial workers' share
- **Time** (50-500): Simulation duration

## Deployment

This lightweight version is optimized for free hosting platforms:

- **Memory**: ~50-100 MB (fits in 512 MB free tiers)
- **Build time**: ~2-3 minutes (vs 15-20 minutes)
- **Dependencies**: Only 2 packages (vs 50+)

Suitable for: Render.com, Railway.app, Fly.io free tiers

## References

Goodwin, R. M. (1965). "A Growth Cycle". Presented at the First World Congress of the Econometric Society, Rome, 1965.

## License

MIT License

## Author

Demian Panigo (UNLP) - Educational use in macroeconomics courses
