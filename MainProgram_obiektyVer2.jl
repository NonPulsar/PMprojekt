# Główny program do obliczania położenia ciał ( dla dwóch obiektów )
using AstroLib
using Plots


# Ważne stałe
G = 6.6732*10^(-11)     # stała grawitacyjna 

# Planety z AstroLib
Mercury = AstroLib.planets["mercury"]

# Konstruktor plantety
mutable struct My_planet
    name::String
    mass::BigFloat
    coord::Array{Float64,1}
    v_vec::Array{Float64,1}
end

# Układ słoneczny ze Słońcem w centrum
Ziemia = My_planet("Ziemia", 5.972*BigFloat(10)^24, [0, 150*10^9], [29.78*10^3, 0])
Słońce = My_planet("Słońce", 1.989*BigFloat(10)^30, [0, 0],[0, 0])

lista_solar = [Ziemia,Słońce]


# Parametry początkowe obiektów
Planeta1 = Dict("M" => 10^24, "coord" => [0,10^6], "v_vec" => [15,0])
Planeta2 = Dict("M" => 10^30, "coord" => [0,0], "v_vec" => [0,0])
Planeta3 = Dict("M" => 10^24, "coord" => [0,-10^6],"v_vec" =>[-15,0])

lista_planet=[Planeta1, Planeta2, Planeta3]

#---------------------------------------------------------------------------------------------
#       FUNKCJE DO OBLICZEŃ 
#---------------------------------------------------------------------------------------------

dist_vec(coord1::Array{Float64,1},coord2::Array{Float64,1}) = coord2 .- coord1
"""Wylicza wektor odległości z coord1 do coord2"""

vec_length(v::Array{Float64,1}) = sqrt(sum(v.^2))
"""Wylicza długość wektora"""

F_gravity(M1::BigFloat,M2::BigFloat,r::Array) = (G*M1*M2/vec_length(r)^3).*r
"""Wylicza wektor siły grawitacji"""


function MainFunction(lista::Array,T::Int64)
    for i in 1:length(lista)
        FG=[0.0, 0.0]
        for j in 1:length(lista)
            if j != i
                r = dist_vec(lista[i].coord, lista[j].coord)
                F = F_gravity(lista[i].mass, lista[j].mass, r)
                FG += F
            end
        end
        a_vec = FG./lista[i].mass
        lista[i].v_vec = (T^2).*a_vec + lista[i].v_vec
    end
    for i in 1:length(lista)
        lista[i].coord =lista[i].coord + lista[i].v_vec
    end
end

#-------------------------------------------------------------------------------------------
#               RYSOWANIE WYKRESU
#-------------------------------------------------------------------------------------------

# PARAMETRY
t = 0:1000          # ilość klatek 
n = 20              # ilość przeliczeń na każdą klatkę symulacji
fps = 40            # ilość klatek na sekundę w symulacji
T = 5000            # zwiększa błąd obliczeniowy, ale pozwala zwiększyć szybkość symulacji

for i in lista_solar
    i.v_vec = i.v_vec.*T
end

@time symulation = @animate for i in t
    scatter([Ziemia.coord[1]],[Ziemia.coord[2]],
    xlim = (-250*10^9, 250*10^9),
    ylim = (-250*10^9, 250*10^9),
    markersize = 5)
    scatter!([Słońce.coord[1]],[Słońce.coord[2]],
    markersize = 12)

    for z in 1:n
        MainFunction(lista_solar,T)
    end
end

gif(symulation,"animacja.gif",fps=fps)


