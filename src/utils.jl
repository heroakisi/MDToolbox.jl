#using .Bio3DView

"""
viewstruct

based on Bio3Dview.jl
"""
function viewstruc(ta::TrjArray; kwargs...)
    io = IOBuffer()
    writepdb(io, ta)
    return Bio3DView.view("data-type='pdb'", String(take!(io)); style=Bio3DView.defaultstyle("pdb"), kwargs...)
end

#cpu(m) = fmap(x -> adapt(Array, x), m)
#gpu(x) = use_cuda[] ? fmap(CuArrays.cu, x) : x

function gpu(ta::TrjArray{T, U}) where {T, U}
    TrjArray{T, U}(CuArray(ta.x), CuArray(ta.y), CuArray(ta.z), CuArray(ta.boxsize),
      ta.chainname, CuArray(ta.chainid),
      ta.resname, CuArray(ta.resid),
      ta.atomname, CuArray(ta.atomid),
      CuArray(ta.mass), CuArray(ta.charge),
      CuArray(ta.list_bond), CuArray(ta.list_angle), CuArray(ta.list_dihedral),
      CuArray(ta.list_improper), CuArray(ta.list_cmap))
end

function gpu32(ta::TrjArray)
    TrjArray{Float32, Int64}(CuArrays.cu(ta.x), CuArrays.cu(ta.y), CuArrays.cu(ta.z), CuArrays.cu(ta.boxsize),
      ta.chainname, CuArrays.cu(ta.chainid),
      ta.resname, CuArrays.cu(ta.resid),
      ta.atomname, CuArrays.cu(ta.atomid),
      CuArrays.cu(ta.mass), CuArrays.cu(ta.charge),
      CuArrays.cu(ta.list_bond), CuArrays.cu(ta.list_angle), CuArrays.cu(ta.list_dihedral),
      CuArrays.cu(ta.list_improper), CuArrays.cu(ta.list_cmap))
end

function cpu(ta::TrjArray{T, U}) where {T, U}
    TrjArray{T, U}(Array(ta.x), Array(ta.y), Array(ta.z), Array(ta.boxsize),
      ta.chainname, Array(ta.chainid),
      ta.resname, Array(ta.resid),
      ta.atomname, Array(ta.atomid),
      Array(ta.mass), Array(ta.charge),
      Array(ta.list_bond), Array(ta.list_angle), Array(ta.list_dihedral),
      Array(ta.list_improper), Array(ta.list_cmap))
end

function cpu64(ta::TrjArray)
    TrjArray{Float64, Int64}(Array{Float64}(ta.x), Array{Float64}(ta.y), Array{Float64}(ta.z), Array{Float64}(ta.boxsize),
      ta.chainname, Array{Int64}(ta.chainid),
      ta.resname, Array{Int64}(ta.resid),
      ta.atomname, Array{Int64}(ta.atomid),
      Array{Float64}(ta.mass), Array{Float64}(ta.charge),
      Array{Int64}(ta.list_bond), Array{Int64}(ta.list_angle), Array{Int64}(ta.list_dihedral),
      Array{Int64}(ta.list_improper), Array{Int64}(ta.list_cmap))
end
