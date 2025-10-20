module App

using GenieFramework
@genietools

include("goodwin_model.jl")
using .GoodwinModel

@app begin
    # Input parameters
    @in sigma = 2.5
    @in alpha_growth = 0.02
    @in beta = 0.01
    @in gamma = 0.03
    @in rho = 0.04
    @in v0 = 0.9
    @in u0 = 0.6
    @in tspan_max = 200

    # Output data
    @out time_series_plot = PlotData[]
    @out phase_plot = PlotData[]
    @out u_star = 0.0
    @out v_star = 0.0

    # Initialize plots when ready
    @onchange isready begin
        isready || return
        println("\n📊 Initializing application...")

        # Calculate equilibrium
        u_eq, v_eq = GoodwinModel.calculate_equilibrium(
            sigma, alpha_growth, beta, gamma, rho
        )

        # Run simulation
        t, v_sim, u_sim = GoodwinModel.simulate_goodwin_model(
            sigma, alpha_growth, beta, gamma, rho,
            v0, u0,
            (0.0, Float64(tspan_max))
        )

        # Calculate profits
        profit_vec = (1.0 .- u_sim) ./ sigma

        # Update time series plot - create separate traces
        time_series_plot = [
            PlotData(
                x = t,
                y = v_sim,
                plot = StipplePlotly.Charts.PLOT_TYPE_SCATTER,
                name = "Employment (v)",
                mode = "lines"
            ),
            PlotData(
                x = t,
                y = u_sim,
                plot = StipplePlotly.Charts.PLOT_TYPE_SCATTER,
                name = "Wages (u)",
                mode = "lines"
            ),
            PlotData(
                x = t,
                y = profit_vec,
                plot = StipplePlotly.Charts.PLOT_TYPE_SCATTER,
                name = "Profits",
                mode = "lines"
            )
        ]

        # Update phase plot - create separate traces
        phase_plot = [
            PlotData(
                x = u_sim,
                y = v_sim,
                plot = StipplePlotly.Charts.PLOT_TYPE_SCATTER,
                name = "Trajectory",
                mode = "lines"
            ),
            PlotData(
                x = [u_eq],
                y = [v_eq],
                plot = StipplePlotly.Charts.PLOT_TYPE_SCATTER,
                name = "Equilibrium",
                mode = "markers",
                marker = Dict("size" => 15, "color" => "red", "symbol" => "star")
            )
        ]

        # Update equilibrium values
        u_star = round(u_eq, digits=4)
        v_star = round(v_eq, digits=4)

        println("✅ Initialization completed\n")
    end

    # Watch for any parameter change and recalculate
    @onchange sigma, alpha_growth, beta, gamma, rho, v0, u0, tspan_max begin
        println("\n📊 Parameters changed, running simulation...")

        # Calculate equilibrium
        u_eq, v_eq = GoodwinModel.calculate_equilibrium(
            sigma, alpha_growth, beta, gamma, rho
        )

        # Run simulation
        t, v_sim, u_sim = GoodwinModel.simulate_goodwin_model(
            sigma, alpha_growth, beta, gamma, rho,
            v0, u0,
            (0.0, Float64(tspan_max))
        )

        # Calculate profits
        profit_vec = (1.0 .- u_sim) ./ sigma

        # Update time series plot - create separate traces
        time_series_plot = [
            PlotData(
                x = t,
                y = v_sim,
                plot = StipplePlotly.Charts.PLOT_TYPE_SCATTER,
                name = "Employment (v)",
                mode = "lines"
            ),
            PlotData(
                x = t,
                y = u_sim,
                plot = StipplePlotly.Charts.PLOT_TYPE_SCATTER,
                name = "Wages (u)",
                mode = "lines"
            ),
            PlotData(
                x = t,
                y = profit_vec,
                plot = StipplePlotly.Charts.PLOT_TYPE_SCATTER,
                name = "Profits",
                mode = "lines"
            )
        ]

        # Update phase plot - create separate traces
        phase_plot = [
            PlotData(
                x = u_sim,
                y = v_sim,
                plot = StipplePlotly.Charts.PLOT_TYPE_SCATTER,
                name = "Trajectory",
                mode = "lines"
            ),
            PlotData(
                x = [u_eq],
                y = [v_eq],
                plot = StipplePlotly.Charts.PLOT_TYPE_SCATTER,
                name = "Equilibrium",
                mode = "markers",
                marker = Dict("size" => 15, "color" => "red", "symbol" => "star")
            )
        ]

        # Update equilibrium values
        u_star = round(u_eq, digits=4)
        v_star = round(v_eq, digits=4)

        println("✅ Update completed\n")
    end
end

# UI Definition using @page macro
function ui()
    [
        heading("Goodwin Growth Cycle Model")

        row([
            # Controls Panel - Left Side
            cell(class="col-12 col-md-4", [
                card([
                    card_section([
                        h6("Model Parameters")
                    ])

                    card_section([
                        p([
                            span("σ (Capital-Output): ", class="text-caption")
                            span("{{sigma.toFixed(2)}}")
                        ])
                        slider(0.5:0.1:5, :sigma, color="primary")

                        p([
                            span("α (Productivity): ", class="text-caption")
                            span("{{alpha_growth.toFixed(3)}}")
                        ])
                        slider(0:0.005:0.05, :alpha_growth, color="primary")

                        p([
                            span("β (Labor Supply): ", class="text-caption")
                            span("{{beta.toFixed(3)}}")
                        ])
                        slider(0:0.005:0.05, :beta, color="primary")

                        p([
                            span("γ (Wage Pressure): ", class="text-caption")
                            span("{{gamma.toFixed(3)}}")
                        ])
                        slider(0:0.005:0.1, :gamma, color="primary")

                        p([
                            span("ρ (Sensitivity): ", class="text-caption")
                            span("{{rho.toFixed(3)}}")
                        ])
                        slider(0.01:0.005:0.1, :rho, color="primary")
                    ])
                ])

                card(class="q-mt-md", [
                    card_section([
                        h6("Initial Conditions")
                    ])

                    card_section([
                        p([
                            span("v₀ (Initial Employment): ", class="text-caption")
                            span("{{v0.toFixed(2)}}")
                        ])
                        slider(0.5:0.05:1.5, :v0, color="primary")

                        p([
                            span("u₀ (Initial Wages): ", class="text-caption")
                            span("{{u0.toFixed(2)}}")
                        ])
                        slider(0.3:0.05:1.0, :u0, color="primary")

                        p([
                            span("Simulation Time: ", class="text-caption")
                            span("{{tspan_max}}")
                        ])
                        slider(50:10:500, :tspan_max, color="primary")
                    ])
                ])

                card(class="q-mt-md", [
                    card_section([
                        h6("Equilibrium Point")
                        p([
                            strong("u*: ")
                            span("{{u_star}}")
                        ])
                        p([
                            strong("v*: ")
                            span("{{v_star}}")
                        ])
                    ])
                ])
            ])

            # Plots Panel - Right Side
            cell(class="col-12 col-md-8", [
                card(class="q-mb-md", [
                    card_section([
                        h6("Time Dynamics")
                    ])
                    card_section([
                        plot(:time_series_plot, layout="{height: 400, xaxis: {title: 'Time'}, yaxis: {title: 'Value'}}")
                    ])
                ])

                card([
                    card_section([
                        h6("Phase Diagram")
                    ])
                    card_section([
                        plot(:phase_plot, layout="{height: 400, xaxis: {title: 'Wages (u)'}, yaxis: {title: 'Employment (v)'}}")
                    ])
                ])
            ])
        ])
    ]
end

@page("/", ui)

end
