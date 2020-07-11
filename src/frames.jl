function leeDframe(DF,nombres, tipos,olb,data,cad,ff)  # dataframe, campos, tipos, struc, archivo, variable, true: lineas

    nn = length(nombres)
    for i in 1:nn push!(DF, nombres[i]=>Dict{olb, tipos[i]}()) end

    i=findall(x->x==cad, data)[][1]
    rstrip(lstrip(data[i,2])) != "[" ? data[i]=lstrip(rstrip(lstrip(data[i,2])),'[') : i +=1
    ilb=[]
    while (isempty(findall(x->x==']', data[i])))
        t = Meta.parse.(split(data[i]))
        #println(t)
        for j in 1:nn  ff ? push!(DF[nombres[j]],olb(t[1],t[2])=>t[j]) : push!(DF[nombres[j]],olb(t[1])=>t[j])  end
        ff ? push!(ilb,olb(t[1],t[2])) : push!(ilb,olb(t[1]))  #vector contenido
        i += 1
    end
    return ilb    #devuelve el rango del DF
end

function leeDframe2D(DF, ol, data,cad,cont)   # lee las contingencias en lineas 2D [lineas][contin]
    i=findall(x->x==cad, data)[][1]
    rstrip(lstrip(data[i,2])) != "[" ? data[i]=lstrip(rstrip(lstrip(data[i,2])),'[') : i +=1

    while (isempty(findall(x->x==']', data[i])))
        t = Meta.parse.(split(data[i]))
        #println(t)
        l= 3
        for j in cont DF[ol(t[1],t[2]),j]=t[l]; l +=1  end
        i += 1
    end
    return DF
end


function leeDframe3D(DF, olb,data,cad,escen)  #para barras matrix 3D [etapas][barras][escenarios]
    i=findall(x->x==cad, data)[][1]
    rstrip(lstrip(data[i,2])) != "[" ? data[i]=lstrip(rstrip(lstrip(data[i,2])),'[') : i +=1

    while (isempty(findall(x->x==']', data[i])))
        t = Meta.parse.(split(data[i]))
        #println(t)
        l= 3
        for j in escen  DF[olb(t[1]),olb(t[2]),j]=t[l]; l +=1  end
        i += 1
    end
    return DF
end
