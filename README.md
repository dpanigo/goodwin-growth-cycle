---
title: Goodwin Growth Cycle Model
emoji: 📊
colorFrom: blue
colorTo: green
sdk: docker
app_port: 7860
---

# Goodwin Growth Cycle Model (1965)

Interactive web application that simulates Richard M. Goodwin's (1965) growth cycle model.

![Goodwin Model](https://img.shields.io/badge/Julia-1.10-9558B2?style=flat&logo=julia)
![License](https://img.shields.io/badge/license-MIT-green)

## Description

This application implements Goodwin's Marxian model that describes a growth cycle through a predator-prey style system of differential equations (Volterra). The model captures the dynamics between:

- **Employment rate (v)**: Share of the labor force that is employed
- **Workers' share (u)**: Fraction of output that goes to wages

### Key Features

- Faithful implementation of Goodwin's original 1965 paper
- Interactive interface with sliders for every parameter
- Real-time visualization of:
  - Time dynamics of employment, wages, and profits
  - Phase diagram (closed cycle in the u-v space)
  - System equilibrium point
- Automatic equilibrium point calculation
- Robust numerical simulation powered by DifferentialEquations.jl

## Online Usage

**[Open the application](https://huggingface.co/spaces/dpanigo/goodwin-growth-cycle)**

Simply launch the link in your browser and start exploring the model.

## Run Locally

### Prerequisites

- Julia 1.10 or newer
- Dependencies: GenieFramework, DifferentialEquations

### Installation

1. Clone this repository:

```bash
git clone https://github.com/dpanigo/goodwin-growth-cycle.git
cd goodwin-growth-cycle
```

2. Run the application:

```bash
julia run.jl
```

3. Open in your browser:

```
http://localhost:8000
```

## Model Parameters

### Core Parameters

- **sigma**: Capital-output ratio
- **alpha**: Labor productivity growth rate
- **beta**: Labor force growth rate
- **gamma**: Constant in the wage adjustment function (Phillips curve)
- **rho**: Sensitivity of wages to the employment level

### Initial Conditions

- **v0**: Initial employment rate
- **u0**: Initial workers' share
- **Simulation time**: Duration of the simulation in time units

## Mathematical Model

The system of differential equations is:

```
dv/dt = [(1/sigma - (alpha + beta)) - (1/sigma) * u] * v     (1)
du/dt = [-(alpha + gamma) + rho * v] * u                     (2)
```

**Equilibrium point:**

```
u* = (1/sigma - (alpha + beta)) / (1/sigma)
v* = (alpha + gamma) / rho
```

## References

Goodwin, R. M. (1965). "A Growth Cycle". Presented at the First World Congress of the Econometric Society, Rome, 1965.

## Educational Use

This application is ideal for:

- Macroeconomics courses
- Economic growth theory
- Dynamic systems in economics
- Economic cycle models
- History of economic thought

### Suggested Exercises

1. **Explore stability**: What happens when you change sigma?
2. **Productivity effect**: Increase alpha; how does the cycle respond?
3. **Wage sensitivity**: Vary rho and observe the cycle amplitude.
4. **Find cycles**: Can you identify parameters that produce a nearly circular cycle?

## Project Structure

```
.
|-- run.jl              # Entry point
|-- app.jl              # Web application + UI
|-- goodwin_model.jl    # Model implementation
|-- Project.toml        # Julia dependencies
|-- Dockerfile          # Deployment configuration
|-- README.md           # Original file
```

## Additional Documentation

- [VERIFICACION_MODELO.md](VERIFICACION_MODELO.md) - Verification against the original paper
- [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) - Online deployment guide
- [ESTRUCTURA_PROYECTO.md](ESTRUCTURA_PROYECTO.md) - Technical documentation

## License

MIT License - see the LICENSE file for details.

## Author

Demian Panigo (UNLP) - Developed for educational use in macroeconomics courses.

## Acknowledgements

- Julia community for outstanding tooling
- GenieFramework for enabling web development in Julia

---

**Questions or suggestions?** Open an issue on GitHub or contact the author.

