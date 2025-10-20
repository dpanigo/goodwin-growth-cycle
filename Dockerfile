FROM julia:1.10

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /app

# Install and precompile packages (separate layer for caching)
RUN julia -e 'using Pkg; Pkg.add(["GenieFramework", "DifferentialEquations"]); Pkg.precompile()'

# Copy application files
COPY run.jl /app/
COPY app.jl /app/
COPY goodwin_model.jl /app/

# Set environment variables for Hugging Face Spaces
ENV PORT=7860
ENV HOST=0.0.0.0

# Expose port 7860 (Hugging Face Spaces standard)
EXPOSE 7860

# Command to start the application
CMD ["julia", "--project=/app", "run.jl"]
