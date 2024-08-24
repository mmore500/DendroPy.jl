import PythonCall

const MAX_RETRIES = 3
const RETRY_DELAY = 5  # Delay in seconds between retries

function install_dendropy()
    @info("Attempting to install DendroPy Python package from the development-main branch.")
    for attempt in 1:MAX_RETRIES
        try
            run(`pip install git+https://github.com/jeetsukumaran/DendroPy@development-main`)
            @info("DendroPy installation successful.")
            return
        catch e
            @error("DendroPy installation failed on attempt $attempt. Error: $e")
            if attempt < MAX_RETRIES
                @info("Retrying installation in $RETRY_DELAY seconds...")
                sleep(RETRY_DELAY)  # Wait before retrying
            else
                @error("Exceeded maximum retry attempts. Please check your internet connection and the repository URL.")
                throw(e)  # Re-throw the error after final attempt
            end
        end
    end
end

@info("Ensure DendroPy package for DendroPy.jl...")
try
    PythonCall.pyimport("dendropy")
    @info("DendroPy package is already installed.")
catch e
    @info("DendroPy package not found. Installing...")
    install_dendropy()
end
@info("... done!")

@assert(false)
