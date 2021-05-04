# Główny program do obliczania położenia ciał ( dla dwóch obiektów )
using Plots


# Ważne stałe
G = 6.6732*10^(-11)     # stała grawitacyjna 

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
Merkury = My_planet("Merkury", 3.285*BigFloat(10)^23, [0, -58*10^9], [-48*10^3, 0])
Wenus = My_planet("Wenus", 4.867*BigFloat(10)^24, [108.141*10^9, 0], [0, -35.02*10^3])
Mars = My_planet("Mars", 6.4171*BigFloat(10)^23, [-227.923*10^9, 0], [0, 24.07*10^3])

lista_solar = [Ziemia,Słońce,Merkury, Wenus, Mars]

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
n = 30              # ilość przeliczeń na każdą klatkę symulacji
fps = 40            # ilość klatek na sekundę w symulacji
T = 2000            # zwiększa błąd obliczeniowy, ale pozwala zwiększyć szybkość symulacji

for i in lista_solar
    i.v_vec = i.v_vec.*T
end

@time symulation = @animate for i in t
    scatter([Ziemia.coord[1]],[Ziemia.coord[2]],
    xlim = (-250*10^9, 250*10^9),
    ylim = (-250*10^9, 250*10^9),
    markersize = 6)
    scatter!([Słońce.coord[1]],[Słońce.coord[2]],
    markersize = 12)
    scatter!([Merkury.coord[1]],[Merkury.coord[2]],
    markersize = 4)
    scatter!([Wenus.coord[1]],[Wenus.coord[2]],
    markersize = 6)
    scatter!([Mars.coord[1]],[Mars.coord[2]],
    markersize = 5)

    for z in 1:n
        MainFunction(lista_solar,T)
    end
end

gif(symulation,"animacja.gif",fps=fps)


