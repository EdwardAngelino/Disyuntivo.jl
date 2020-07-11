
function leedatostxt(archivo::String   )
#archivo = "sein.txt"
#archivo = "datos_disj_full.txt"
#archivo = "datos_disj2.txt"
data = readdlm(archivo,'=','\n'; comments=true, comment_char='#');
data[:,1]=rstrip.(data[:,1]);  #quitar espacios antes del igual
global arch=archivo

Y=collect(1:5) ; global Y
Sbase= data[findall(x->x=="Sbase", data)[][1],2] ; global Sbase
thmx= data[findall(x->x=="thmax", data)[][1],2] ; global thmx
cr= data[findall(x->x=="cr", data)[][1],2] ;  global cr

camposL = ["be","br","fmax","fmaxC","x", "cst", "n0", "nmax"]
tiposL = [Int, Int, Float64,Float64,Float64,Float64, Int, Int]
dflineas= Dict{String,Dict{ol,V} where V}()
Ol=leeDframe(dflineas,camposL, tiposL,ol,data,"lineas",true)
global dflineas; global Ol

camposB = ["id", "nombre", "tipo"]
tiposB = [Int, Symbol, Int ]
dfbarras= Dict{String,Dict{ob,V} where V}()
Ob=leeDframe(dfbarras,camposB, tiposB,ob,data,"barras",false)
global dfbarras; global Ob

dfetapas= Dict{String,Dict{ob,V} where V}()
T=leeDframe(dfetapas,["id", "nomT", "alpha"], [Int, Symbol, Float64 ],ob,data,"T",false)
global dfetapas; global T

dfescen= Dict{String,Dict{ob,V} where V}()
S=leeDframe(dfescen,["id", "nomS", "ProbS"], [Int, Symbol, Float64 ],ob,data,"S",false);
global dfescen; global S

dfcont= Dict{String,Dict{ob,V} where V}()
C=leeDframe(dfcont,["id", "nomC", "tipoC", "ProbC"], [Int, Symbol, Int, Float64 ],ob,data,"nomC",false);
global dfcont; global C
#matrices

d= Dict{Tuple{ob,ob,ob},Float64}()  # d[i,t,s]
leeDframe3D(d, ob, data, "dem", S);
global d

gmax= Dict{Tuple{ob,ob,ob},Float64}()
leeDframe3D(gmax, ob, data, "gmax", S);
global gmax

gmaxC= Dict{Tuple{ob,ob,ob},Float64}()
leeDframe3D(gmaxC, ob, data, "gmaxC", S);
global gmaxC

Ncont= Dict{Tuple{ol,ob},Int}()      #Ncont[l][c]
leeDframe2D(Ncont, ol, data, "Ncont", C);
global Ncont

datos = Dict(:Y => Y, :Sbase => Sbase, :thmx => thmx, :cr =>cr,
:lineas => dflineas, :Ol => Ol, :barras => dfbarras, :Ob => Ob,
:etapas =>dfetapas, :T =>T, :escen =>dfescen, :S =>S,
:cont =>dfcont, :C =>C, :demanda =>d, :gmax =>gmax,
:gmaxC =>gmaxC, :Ncont =>Ncont );

return datos
end
