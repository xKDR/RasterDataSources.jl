layers(::Type{EarthEnv{LandCover}}) = 1:12

"""
    getraster(T::Type{EarthEnv{LandCover}}, [layer::Union{AbstractArray,Tuple,Integer}]; discover::Bool=false) => Union{Tuple,String}
    getraster(T::Type{EarthEnv{LandCover}}, layer::Integer, discover::Bool) => String

Download [`EarthEnv`](@ref) landcover data.

# Arguments
- `layer`: `Integer` or tuple/range of `Integer` from `$(layers(EarthEnv{LandCover}))`. 
    Without a `layer` argument, all layers will be downloaded, and a tuple of paths returned.

# Keywords
- `discover::Bool` use the dataset that integrates the DISCover model.

Returns the filepath/s of the downloaded or pre-existing files.
"""
function getraster(T::Type{EarthEnv{LandCover}}, layer::Integer; discover::Bool=false)
    getraster(T, layer, discover)
end
function getraster(T::Type{EarthEnv{LandCover}}, layer::Integer, discover::Bool)
    _check_layer(T, layer)
    url = rasterurl(T, layer; discover)
    path = rasterpath(T, layer; discover)
    return _maybe_download(url, path)
end

rasterpath(T::Type{EarthEnv{LandCover}}, layer::Integer; discover::Bool=false) =
    joinpath(rasterpath(T), rastername(T, layer; discover))
function rastername(::Type{EarthEnv{LandCover}}, layer::Integer; discover::Bool=false)
    filetype = discover ? "complete" : "partial"
    "landcover_$(filetype)_$(layer).tif"
end
function rasterurl(T::Type{EarthEnv{LandCover}}, layer::Integer; discover::Bool=false)
    stem = discover ? "with_DISCover/consensus_full_class_$(layer).tif" :
                      "without_DISCover/Consensus_reduced_class_$(layer).tif"
    joinpath(rasterurl(T), stem)
end

_pathsegment(::Type{LandCover}) = "consensus_landcover"
