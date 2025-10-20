"""
Lightweight HTTP server for Goodwin Model
Uses only HTTP.jl and JSON3.jl
"""

using HTTP
using JSON3

include("goodwin_model.jl")

"""
Serve static HTML file
"""
function serve_index(req::HTTP.Request)
    try
        html = read("index.html", String)
        return HTTP.Response(200, ["Content-Type" => "text/html"], body=html)
    catch e
        return HTTP.Response(404, "index.html not found")
    end
end

"""
API endpoint: /simulate
Accepts POST with JSON parameters
Returns simulation results as JSON
"""
function api_simulate(req::HTTP.Request)
    try
        # Parse request body
        body = String(req.body)
        params = JSON3.read(body)

        # Extract parameters with defaults
        σ = get(params, :sigma, 0.9)
        α = get(params, :alpha, 0.02)
        β = get(params, :beta, 0.02)
        γ = get(params, :gamma, 0.02)
        ρ = get(params, :rho, 0.04)
        v0 = get(params, :v0, 0.9)
        u0 = get(params, :u0, 0.7)
        t_max = get(params, :t_max, 200.0)

        println("Simulating with σ=$σ, α=$α, β=$β, γ=$γ, ρ=$ρ, v0=$v0, u0=$u0, t_max=$t_max")

        # Run simulation
        result = simulate(σ, α, β, γ, ρ, v0, u0, t_max)

        # Return JSON response
        json_response = JSON3.write(result)
        return HTTP.Response(200,
            ["Content-Type" => "application/json",
             "Access-Control-Allow-Origin" => "*"],
            body=json_response)

    catch e
        println("Error in simulation: $e")
        error_response = JSON3.write(Dict("error" => string(e)))
        return HTTP.Response(500,
            ["Content-Type" => "application/json"],
            body=error_response)
    end
end

"""
Handle CORS preflight requests
"""
function handle_cors(req::HTTP.Request)
    return HTTP.Response(200,
        ["Access-Control-Allow-Origin" => "*",
         "Access-Control-Allow-Methods" => "POST, GET, OPTIONS",
         "Access-Control-Allow-Headers" => "Content-Type"])
end

"""
Router function
"""
function router(req::HTTP.Request)
    # Handle CORS preflight
    if req.method == "OPTIONS"
        return handle_cors(req)
    end

    # Route requests
    if req.target == "/"
        return serve_index(req)
    elseif req.target == "/simulate" && req.method == "POST"
        return api_simulate(req)
    else
        return HTTP.Response(404, "Not Found")
    end
end

"""
Start server
"""
function start_server(host="0.0.0.0", port=7860)
    println("="^60)
    println("🚀 Starting Goodwin Model Server...")
    println("="^60)
    println("\n📊 Goodwin Growth Cycle Model")
    println("🌐 URL: http://$host:$port")
    println("⏹️  Press Ctrl+C to stop the server\n")

    HTTP.serve(router, host, port)
end

# Run server if executed directly
if abspath(PROGRAM_FILE) == @__FILE__
    host = get(ENV, "HOST", "0.0.0.0")
    port = parse(Int, get(ENV, "PORT", "7860"))
    start_server(host, port)
end
