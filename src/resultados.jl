using SparseArrays,CSV

function escriberesultados(arch_barras="barras_res.csv", arch_lineas= "lineas_res.csv")

ff = open(split(arch,'.')[1]*"_xS.res", "w")
z=objective_value(m)
println(ff,"\nvalor objetivo=$(z)")
println("\n\nRESULTADOS\n-------------\nvalor objetivo=$(z)")

println(ff,"\n\nLineas nuevas\n--------------")
println("\nLineas nuevas\n--------------")

for t in T,s in S
    Mtemp = sparse([l.be for l in Ol],[l.br for l in Ol],[sum(Int.(round.(value.(w[l,y,t,s]))) for y in Y) for l in Ol])


    println(ff,"\nt=$(dfetapas["nomT"][t]),s=$(dfescen["nomS"][s])\n", dropzeros(Int.(Mtemp))) #DataFrame(Int.(Matrix(Mtemp)), [string(i) for i in 1:size(Mtemp)[2]]))
    println("\nt=$(dfetapas["nomT"][t]),s=$(dfescen["nomS"][s])\n", dropzeros(Int.(Mtemp)) )  #DataFrame(Int.(Matrix(Mtemp)), [string(i) for i in 1:size(Mtemp)[2]]))
    println("costo plan= ",sum(sum(value.(w[l,y,t,s]) for y in Y)*dflineas["cst"][l] for l in Ol))
    println(ff,"costo plan= ",sum(sum(value.(w[l,y,t,s]) for y in Y)*dflineas["cst"][l] for l in Ol))
end


println(ff,"\n\nRacionamientos\n--------------")
for t in T, s in S
 global resRac
 resRac= DataFrame([[string(dfbarras["nombre"][i]) for i in Ob] [value.(r[i,t,c,s]) for i in Ob, c in C]]
    , pushfirst!([string(dfcont["nomC"][c]) for c in C], "Barra"))
 println(ff, "\nt=$(dfetapas["nomT"][t]),s=$(dfescen["nomS"][s])\n", resRac)

end

println(ff,"\n\nDetalle total\n--------------")
 for c in C, t in T,s in S

    resB = DataFrame([[dfbarras["nombre"][i] for i in Ob] [value.(g[i,t,c,s]) for i in Ob]  [d[i,t,s] for i in Ob] [value.(th[i,t,c,s]*180/π) for i in Ob]], ["Barra", "gen","dem","theta"])
    println(ff,"\nt=$(dfetapas["nomT"][t]),c=$(dfcont["nomC"][c]),s=$(dfescen["nomS"][s])\nBarras\n", resB )
    gtotal= sum(value.(g[i,t,c,s]) for i in Ob)
    dtotal= sum(d[i,t,s]   for i in Ob)
    println(ff,"g(total)=$(round(gtotal,digits=3))\nd(total)=$(round(dtotal,digits=3))\nracionamiento=$(round(dtotal-gtotal,digits=3))\n")

    resL=DataFrame([[(dfbarras["nombre"][ob(l.be)],dfbarras["nombre"][ob(l.br)]) for l in Ol] [dflineas["n0"][l] for l in Ol] [Int.(sum(Int.(round.(value.(w[l,y,t,s]))) for y in Y)) for l in Ol] [value.(f0[l,t,c,s]) for l in Ol] [sum(round.(value.(f[l,y,t,c,s]),digits=3) for y in Y) for l in Ol]],
    ["linea", "n0","n","flujo0", "flujo"])
    println(ff,"Lineas\n", resL )
    nuevastotal=sum(Int.(sum(Int.(round.(value.(w[l,y,t,s]))) for y in Y)) for l in Ol)
    println(ff,"$(nuevastotal) Nuevas lineas\n" )
 end
close(ff)

dfresultadobarras = DataFrame(BarraId = Int[], Nombre = Symbol[],etp=Symbol[],cont=Symbol[], esce=Symbol[],
    variable=String[],valor=Float64[])
for  i in Ob, t in T,c in C,s in S
    push!(dfresultadobarras,(dfbarras["id"][i],dfbarras["nombre"][i],dfetapas["nomT"][t],dfcont["nomC"][c],
            dfescen["nomS"][s],"Generacion",value.(g[i,t,c,s])))
    push!(dfresultadobarras,(dfbarras["id"][i],dfbarras["nombre"][i],dfetapas["nomT"][t],dfcont["nomC"][c],
            dfescen["nomS"][s],"Theta",value.(th[i,t,c,s])))
    push!(dfresultadobarras,(dfbarras["id"][i],dfbarras["nombre"][i],dfetapas["nomT"][t],dfcont["nomC"][c],
            dfescen["nomS"][s],"racionamiento", value.(r[i,t,c,s])))
    push!(dfresultadobarras,(dfbarras["id"][i],dfbarras["nombre"][i],dfetapas["nomT"][t],dfcont["nomC"][c],
            dfescen["nomS"][s],"demanda", (d[i,t,s])))
    push!(dfresultadobarras,(dfbarras["id"][i],dfbarras["nombre"][i],dfetapas["nomT"][t],dfcont["nomC"][c],
            dfescen["nomS"][s],"GenMax", (gmax[i,t,s])))
end

CSV.write(arch_barras,  dfresultadobarras )

dfresultadolineas = DataFrame(LineaId = ol[], BarraEn = Symbol[],BarraRe = Symbol[],etp=Symbol[],cont=Symbol[],
    esce=Symbol[], variable=String[],valor=Float64[])
for  l in Ol, t in T,c in C,s in S

    #[value.(f0[l,t,c,s]) for l in Ol] [sum(round.(value.(f[l,y,t,c,s]),digits=3) for y in Y) for l in Ol]
    push!(dfresultadolineas,(l ,dfbarras["nombre"][ob(l.be)],dfbarras["nombre"][ob(l.br)],dfetapas["nomT"][t],
            dfcont["nomC"][c], dfescen["nomS"][s],"Flujo0",value.(f0[l,t,c,s])))
    push!(dfresultadolineas,(l ,dfbarras["nombre"][ob(l.be)],dfbarras["nombre"][ob(l.br)],dfetapas["nomT"][t],
            dfcont["nomC"][c], dfescen["nomS"][s],"FlujoNue",sum(round.(value.(f[l,y,t,c,s]),digits=3) for y in Y)))

end

CSV.write(arch_lineas,  dfresultadolineas );
return
end
