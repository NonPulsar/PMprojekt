# Główny program do obliczania położenia ciał ( dla dwóch obiektów )

using Plots


# Ważne stałe stała grawitacyjna 
G = 6.6732*10^(-11)     #

# Parametry początkowe obiektów
Planeta1 = Dict("M" => 10^16, "coord" => [0,10000,0], "v_vec" => [0,0,0])
Planeta2 = Dict("M" => 10^17, "coord" => [0,0,0], "v_vec" => [1,0,0])
Planeta3 = Dict("M" => 10^16, "coord" => [0,-10000,0],"v_vec" =>[0,0,0])
Planeta4 = Dict("M" => 10^16, "coord" => [10000,10000,10000],"v_vec" =>[0,0,0])
lista=[Planeta1, Planeta2, Planeta3, Planeta4]
#---------------------------------------------------------------------------------------------
#       FUNKCJE DO OBLICZEŃ 
#---------------------------------------------------------------------------------------------

dist_vec(coord1,coord2) = coord2 .- coord1
"""Wylicza wektor odległości z coord1 do coord2"""

vec_length(v::Array) = sqrt(sum(v.^2))
"""Wylicza długość wektora"""

F_gravity(M1::Number,M2::Number,r::Array) = (G*M1*M2/vec_length(r)^3).*r
"""Wylicza wektor siły grawitacji"""


function MainFunction(l,t::Number)
    for i in 1:length(lista)
        FG=[0.0,0.0,0.0]
        for j in 1:length(lista)
            if j!=i
                r=dist_vec(get(lista[i],"coord",1),get(lista[j],"coord",1))
                F=F_gravity(get(lista[i],"M",1),get(lista[j],"M",1),r)
                FG .+= F
            end
        end
        a_vec=FG./lista[i]["M"]
        lista[i]["v_vec"]=a_vec.*t.+lista[i]["v_vec"]
    end
    for i in 1:length(lista)
        lista[i]["coord"]=lista[i]["coord"].+lista[i]["v_vec"]
    end
        

 #   r = dist_vec(get(P1,"coord",1),get(P2,"coord",1))   # wektor odległości z P1 do P2
 #   F1 = F_gravity(get(P1,"M",1),get(P2,"M",1),r)       # oblicza wektory siły grawitacji
 #   F2 = (-1).*F1

 #   a_vec1 = F1/P1["M"]                          # oblicza wektory przyspieszania
 #   a_vec2 = F2/P2["M"]

 #   P1["v_vec"] = a_vec1.*t + P1["v_vec"]                  # nowy wektor prędkości planet
 #   P2["v_vec"] = a_vec2.*t + P2["v_vec"]

 #  P1["coord"] = P1["coord"] + P1["v_vec"]                   # nowe położenia planet
 #  P2["coord"] = P2["coord"] + P2["v_vec"]
end

#-------------------------------------------------------------------------------------------
#               RYSOWANIE WYKRESU
#-------------------------------------------------------------------------------------------

t = 0:300         # ilość elementów/klatek
T = 1              # przedział czasowy 
n = 10             # ilość przeliczeń na każdą klatkę symulacji
fps = 30           # ilość kaltek na sekundę w symulacji

"""
coordx_P1 = []
coordy_P1 = []

coordx_P2 = []
coordy_P2 = []

coordx_P3 = []
coordy_P3 = []

for i in t
    append!(coordx_P1, Planeta1["coord"][1])
    append!(coordy_P1, Planeta1["coord"][2])
    append!(coordx_P2, Planeta2["coord"][1])
    append!(coordy_P2, Planeta2["coord"][2])
    append!(coordx_P2, Planeta2["coord"][1])
    append!(coordy_P2, Planeta2["coord"][2])
    MainFunction(Planeta1,Planeta2,T)
end

plot(coordx_P1,coordy_P1)
plot!(coordx_P2,coordy_P2)
"""


symulation = @animate for i in t
    scatter([Planeta1["coord"][1]],[Planeta1["coord"][2]],[Planeta1["coord"][3]],
    xlim = (-20000,20000),
    ylim = (-20000,20000),
    zlim = (-20000,20000),
    markersize = 5, xlabel="X",
    ylabel="Y", zlabel="Z", title = "Planetary system")
    scatter!([Planeta2["coord"][1]],[Planeta2["coord"][2]],[Planeta2["coord"][3]],
    markersize = 10)
    scatter!([Planeta3["coord"][1]],[Planeta3["coord"][2]],[Planeta3["coord"][3]],
    markersize = 5)
    scatter!([Planeta4["coord"][1]],[Planeta4["coord"][2]],[Planeta4["coord"][3]],
    markersize = 3)
    for z in 1:n
        MainFunction(lista,T)
    end
end

gif(symulation,"animacja.gif",fps=fps)

