#!/usr/bin/env julia

println("Loading Goodwin application...")
include("app.jl")

using GenieFramework
using .App

Genie.config.websockets_server = true
Genie.config.server_host = get(ENV, "HOST", "0.0.0.0")
port = parse(Int, get(ENV, "PORT", "8000"))

println("\n" * "="^60)
println("🚀 Starting Genie server...")
println("="^60)
println("\n📊 Goodwin Growth Cycle Model")
println("🌐 URL: http://localhost:$(port)")
println("⏹️  Press Ctrl+C to stop the server\n")

up(port, async=false)
