
valor objetivo=110.0


Lineas nuevas
--------------

t=Stage1,s=Medio

  [3, 5]  =  1
  [4, 6]  =  3
costo plan= 110.0


Racionamientos
--------------

t=Stage1,s=Medio
6×2 DataFrames.DataFrame
│ Row │ Barra │ Base │
│     │ Any   │ Any  │
├─────┼───────┼──────┤
│ 1   │ BUS_1 │ 0.0  │
│ 2   │ BUS_2 │ 0.0  │
│ 3   │ BUS_3 │ 0.0  │
│ 4   │ BUS_4 │ 0.0  │
│ 5   │ BUS_5 │ 0.0  │
│ 6   │ BUS_6 │ 0.0  │


Detalle total
--------------

t=Stage1,c=Base,s=Medio
Barras
6×4 DataFrames.DataFrame
│ Row │ Barra │ gen     │ dem   │ theta    │
│     │ Any   │ Any     │ Any   │ Any      │
├─────┼───────┼─────────┼───────┼──────────┤
│ 1   │ BUS_1 │ 146.667 │ 80.0  │ 0.0      │
│ 2   │ BUS_2 │ 0.0     │ 240.0 │ -9.16732 │
│ 3   │ BUS_3 │ 313.333 │ 40.0  │ 2.29183  │
│ 4   │ BUS_4 │ 0.0     │ 160.0 │ 13.751   │
│ 5   │ BUS_5 │ 0.0     │ 240.0 │ -7.63944 │
│ 6   │ BUS_6 │ 300.0   │ 0.0   │ 30.9397  │
g(total)=760.0
d(total)=760.0
racionamiento=0.0

Lineas
15×5 DataFrames.DataFrame
│ Row │ linea            │ n0  │ n   │ flujo0  │ flujo  │
│     │ Any              │ Any │ Any │ Any     │ Any    │
├─────┼──────────────────┼─────┼─────┼─────────┼────────┤
│ 1   │ (:BUS_1, :BUS_2) │ 1   │ 0   │ 40.0    │ 0.0    │
│ 2   │ (:BUS_1, :BUS_3) │ 0   │ 0   │ 0.0     │ 0.0    │
│ 3   │ (:BUS_1, :BUS_4) │ 1   │ 0   │ -40.0   │ 0.0    │
│ 4   │ (:BUS_1, :BUS_5) │ 1   │ 0   │ 66.6667 │ 0.0    │
│ 5   │ (:BUS_1, :BUS_6) │ 0   │ 0   │ 0.0     │ 0.0    │
│ 6   │ (:BUS_2, :BUS_3) │ 1   │ 0   │ -100.0  │ 0.0    │
│ 7   │ (:BUS_2, :BUS_4) │ 1   │ 0   │ -100.0  │ 0.0    │
│ 8   │ (:BUS_2, :BUS_5) │ 0   │ 0   │ 0.0     │ 0.0    │
│ 9   │ (:BUS_2, :BUS_6) │ 0   │ 0   │ 0.0     │ 0.0    │
│ 10  │ (:BUS_3, :BUS_4) │ 0   │ 0   │ 0.0     │ 0.0    │
│ 11  │ (:BUS_3, :BUS_5) │ 1   │ 1   │ 86.6667 │ 86.667 │
│ 12  │ (:BUS_3, :BUS_6) │ 0   │ 0   │ 0.0     │ 0.0    │
│ 13  │ (:BUS_4, :BUS_5) │ 0   │ 0   │ 0.0     │ 0.0    │
│ 14  │ (:BUS_4, :BUS_6) │ 0   │ 3   │ 0.0     │ -300.0 │
│ 15  │ (:BUS_5, :BUS_6) │ 0   │ 0   │ 0.0     │ 0.0    │
4 Nuevas lineas

