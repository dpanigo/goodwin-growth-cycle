FROM julia:1.10-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /app

# Copy Project.toml first for better caching
COPY Project.toml /app/

# Install lightweight Julia packages (only HTTP.jl and JSON3.jl)
RUN julia --project=/app -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()'

# Copy application files
COPY goodwin_model.jl /app/
COPY server.jl /app/
COPY index.html /app/

# Set environment variables for deployment
ENV PORT=7860
ENV HOST=0.0.0.0

# Expose port
EXPOSE 7860

# Start server
CMD ["julia", "--project=/app", "server.jl"]
