###############################################################################
#
# Make g_min and g_max control
#
###############################################################################
"""
    gsw_control!(
                canopyi::CanopyLayer{FT},
                envir::AirLayer{FT},
                ind::Int
    ) where {FT<:AbstractFloat}
    gsw_control!(
                canopyi::CanopyLayer{FT},
                envir::AirLayer{FT}
    ) where {FT<:AbstractFloat}

make sure g_sw is in its physiological range limited by diffusion, given
- `canopyi` [`CanopyLayer`](@ref) type struct
- `envir` [`AirLayer`] type struct
- `ind` Nth leaf

Note that this function is meant to use jointly with gas_exchange! when
    computing optimal stomtal conductance.
"""
function gsw_control!(
            canopyi::CanopyLayer{FT},
            envir::AirLayer{FT},
            ind::Int
) where {FT<:AbstractFloat}
    # if g_sw is low than g_min
    if canopyi.g_sw[ind] < canopyi.g_min
        gas_exchange!(canopyi, envir, GswDrive(), ind, canopyi.g_min);
    elseif canopyi.g_sw[ind] > canopyi.g_max
        gas_exchange!(canopyi, envir, GswDrive(), ind, canopyi.g_max);
    end

    return nothing
end




function gsw_control!(
            canopyi::CanopyLayer{FT},
            envir::AirLayer{FT}
) where {FT<:AbstractFloat}
    # if g_sw is low than g_min
    for i in eachindex(canopyi.g_sw)
        canopyi.ps.apar = canopyi.APAR[i];
        gsw_control!(canopyi, envir, i);
    end

    return nothing
end
