using JuMP, CPLEX

function optimizar()

m = Model(CPLEX.Optimizer)
set_optimizer_attribute(m, "CPX_PARAM_MIPDISPLAY", 4)
set_optimizer_attribute(m, "CPX_PARAM_SCRIND", 1)
global m

println("\nformando modelo...")
#variables
@variable(m,w[Ol,Y,T,S], Bin )  #nro de lineas a construir ?Pq no hya por escenario
@variable(m,g[Ob,T,C,S]>=0)          #generación en cada nodo
@variable(m,th[Ob,T,C,S])
@variable(m,f[Ol,Y,T,C,S])
@variable(m,f0[Ol,T,C,S])           #flujo en las lineas
@variable(m,r[Ob,T,C,S]>=0)

global w,g,th,f,f0,r
#Minimizar costo de inversión
@objective(m, Min,
  sum(dfetapas["alpha"][t]*sum(dflineas["cst"][l]
            *sum(w[l,y,t,s] for y in Y) for l in Ol, s in S) for t in T if dfetapas["id"][t] == 1)
 +sum(dfetapas["alpha"][t]*sum( dflineas["cst"][l]
            *sum(w[l,y,t,s]-w[l,y,ob(t.bi-1),s] for y in Y) for l in Ol,s in S) for t in T if dfetapas["id"][t] > 1)
 +cr*sum(dfescen["ProbS"][s]*sum(dfcont["ProbC"][c]*sum(r[i,t,c,s] for t in T,i in Ob) for c in C) for s in S)
 );


#Balance en barras
@constraint(m,balance[i in Ob, t in T, c in C, s in S],
      sum(f0[l,t,c,s] + sum(f[l,y,t,c,s] for y in Y) for l in Ol if l.br==i.bi)
    - sum(f0[l,t,c,s] + sum(f[l,y,t,c,s] for y in Y) for l in Ol if l.be==i.bi)  + g[i,t,c,s]
    + r[i,t,c,s]
    == d[i,t,s]
    );    # balance en barras

#Flujo existente

@constraint(m,fluxo_existen2[l in Ol,t in T,c in C ,s in S ; dfcont["tipoC"][c] != 1 ],
    f0[l,t,c,s]*dflineas["x"][l] - Sbase*dflineas["n0"][l]
    * (th[ob(l.be),t,c,s] - th[ob(l.br),t,c,s])    == 0 );


@constraint(m,fluxo_existen1[l in Ol,t in T,c in C,s in S;  dfcont["tipoC"][c] == 1],
    f0[l,t,c,s]*dflineas["x"][l] - Sbase*(dflineas["n0"][l]-Ncont[l,c])
    * (th[ob(l.be),t,c,s] - th[ob(l.br),t,c,s])   == 0 );


#Limite de flujo existente
@constraint(m,lim_fluxo_existen_1[l in Ol,t in T,c in C, s in S; dfcont["tipoC"][c] == 0 ],
   -dflineas["n0"][l]*dflineas["fmax"][l] <= f0[l,t,c,s] <= dflineas["n0"][l]*dflineas["fmax"][l] );


@constraint(m,lim_fluxo_existen_2[l in Ol,t in T,c in C, s in S; dfcont["tipoC"][c] == 1 ],
   -(dflineas["n0"][l]-Ncont[l,c])*dflineas["fmaxC"][l] <= f0[l,t,c,s]
        <= (dflineas["n0"][l]-Ncont[l,c])*dflineas["fmaxC"][l] );

@constraint(m,lim_fluxo_existen_3[l in Ol,t in T,c in C, s in S; dfcont["tipoC"][c] == 2 ],
   -dflineas["n0"][l]*dflineas["fmaxC"][l] <= f0[l,t,c,s] <= dflineas["n0"][l]*dflineas["fmaxC"][l] );

   #Flujo nuevos

   @constraint(m,flujo_a1[l in Ol,y in Y, t in T, c in C, s in S; dfcont["tipoC"][c] != 2  || ( dfcont["tipoC"][c] == 2 && y > 1)  ],
       f[l,y,t,c,s]*dflineas["x"][l]/Sbase - (th[ob(l.be),t,c,s] - th[ob(l.br),t,c,s]) <=  2*thmx*(1-w[l,y,t,s]));
   @constraint(m,flujo_a2[l in Ol,y in Y, t in T, c in C, s in S; dfcont["tipoC"][c] == 2  &&  y == 1  ],
       f[l,y,t,c,s]*dflineas["x"][l]/Sbase - (th[ob(l.be),t,c,s] - th[ob(l.br),t,c,s]) <=  2*thmx*(1-w[l,y,t,s]*(1-Ncont[l,c])));

   @constraint(m,flujo_b1[l in Ol,y in Y, t in T, c in C, s in S; dfcont["tipoC"][c] != 2  || ( dfcont["tipoC"][c] == 2 && y > 1)  ],
       f[l,y,t,c,s]*dflineas["x"][l]/Sbase - (th[ob(l.be),t,c,s] - th[ob(l.br),t,c,s]) >= -2*thmx*(1-w[l,y,t,s]));
   @constraint(m,flujo_b2[l in Ol,y in Y, t in T, c in C, s in S; dfcont["tipoC"][c] == 2  &&  y == 1  ],
       f[l,y,t,c,s]*dflineas["x"][l]/Sbase - (th[ob(l.be),t,c,s] - th[ob(l.br),t,c,s]) >= -2*thmx*(1-w[l,y,t,s]*(1-Ncont[l,c])));

   #limite de flujos nuevos

   @constraint(m,lim_fluxo_a1[l in Ol, y in Y, t in T,c in C, s in S; dfcont["tipoC"][c] == 0 ],
      f[l,y,t,c,s] <=  w[l,y,t,s]*dflineas["fmax"][l] );
   @constraint(m,lim_fluxo_b1[l in Ol, y in Y, t in T,c in C, s in S; dfcont["tipoC"][c] == 0 ],
      f[l,y,t,c,s] >= -w[l,y,t,s]*dflineas["fmax"][l] );


   @constraint(m,lim_fluxo_a2[l in Ol, y in Y, t in T,c in C, s in S; dfcont["tipoC"][c] == 1  || ( dfcont["tipoC"][c] == 2 && y > 1) ],
      f[l,y,t,c,s] <=  w[l,y,t,s]*dflineas["fmaxC"][l] );
   @constraint(m,lim_fluxo_b2[l in Ol, y in Y, t in T,c in C, s in S; dfcont["tipoC"][c] == 1  || ( dfcont["tipoC"][c] == 2 && y > 1) ],
      f[l,y,t,c,s] >= -w[l,y,t,s]*dflineas["fmaxC"][l] );


   @constraint(m,lim_fluxo_a3[l in Ol, y in Y, t in T,c in C, s in S; dfcont["tipoC"][c] == 2  && y == 1 ],
      f[l,y,t,c,s] <=  w[l,y,t,s]*dflineas["fmaxC"][l]*(1-Ncont[l,c]));
   @constraint(m,lim_fluxo_b3[l in Ol, y in Y, t in T,c in C, s in S; dfcont["tipoC"][c] == 2  && y == 1 ],
      f[l,y,t,c,s] >= -w[l,y,t,s]*dflineas["fmaxC"][l]*(1-Ncont[l,c]));

      #otras restricciones auxiliares

      #maxima generacion
      @constraint(m,g_lim_1[i in Ob, t in T, c in C, s in S; c.bi == 1], g[i,t,c,s] <= gmax[i,t,s]) ; # sin contingencias primero
      @constraint(m,g_lim_2[i in Ob, t in T, c in C, s in S; c.bi > 1], g[i,t,c,s] <= gmaxC[i,t,s]) ;

      @constraint(m,th_lim[i in Ob, t in T, c in C, s in S], -thmx <= th[i,t,c,s] <= thmx);
      @constraint(m,ang_ref[i in Ob, t in T, c in C, s in S ; dfbarras["tipo"][i] == 1], th[i,t,c,s] == 0);
      @constraint(m,limite_rac[i in Ob, t in T, c in C, s in S ], r[i,t,c,s] <= d[i,t,s]);

      @constraint(m,limite_n[l in Ol,  t in T, s in S], sum(w[l,y,t,s] for y in Y) <=   dflineas["nmax"][l]);
      @constraint(m,no_sol_igual[l in Ol,y in Y, t in T,s in S ; y > 1], w[l,y,t,s] <= w[l,y-1,t,s]);
      @constraint(m,contador_w_period[l in Ol,y in Y, t in T,s in S ; dfetapas["id"][t] > 1], w[l,y,ob(t.bi-1),s] <= w[l,y,t,s]);

      println("Inicio optimizacion...")
      status = optimize!(m)

      #escriberesultados("barras_res.csv", "lineas_res.csv")
      return  status
end
