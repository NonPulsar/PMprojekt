# Główny program do obliczania położenia ciał ( dla dwóch obiektów )
using Plots

# Ważne stałe
G = 6.6732*10^(-11)     # stała grawitacji 

# Konstruktor planety
mutable struct My_planet
    name::String
    mass::BigFloat
    coord::Array{Float64,1}
    v_vec::Array{Float64,1}
    a_vec::Array{Float64,1}
end

# Układ słoneczny ze Słońcem w centrum
Ziemia = My_planet("Ziemia", 5.972*BigFloat(10)^24, [0, 150*10^9], [29.78*10^3, 0], [0, 0])
Słońce = My_planet("Słońce", 1.989*BigFloat(10)^30, [0, 0], [0, 0], [0, 0])
Merkury = My_planet("Merkury", 3.285*BigFloat(10)^23, [0, -58*10^9], [-48*10^3, 0], [0, 0])
Wenus = My_planet("Wenus", 4.867*BigFloat(10)^24, [108.141*10^9, 0], [0, -35.02*10^3], [0, 0])
Mars = My_planet("Mars", 6.4171*BigFloat(10)^23, [-227.923*10^9, 0], [0, 24.07*10^3], [0, 0])

lista_solar = [Ziemia, Słońce, Merkury, Wenus, Mars]

# 1 Układ symulacyjny 
planeta1 = My_planet("1", 10^17, [0,10^4], [5,0], [0,0])
planeta2 = My_planet("2", 10^17, [0,-10^4], [-5,0], [0,0])
planeta3 = My_planet("3", 10^17, [0,0], [35,0], [0,0])

lista_symulacja1 = [planeta1, planeta2]

# 2 Układ symulacyjny


#---------------------------------------------------------------------------------------------
#       FUNKCJE DO OBLICZEŃ 
#---------------------------------------------------------------------------------------------

dist_vec(coord1::Array{Float64,1},coord2::Array{Float64,1}) = coord2 .- coord1
"""Wylicza wektor odległości z coord1 do coord2"""

vec_length(v::Array{Float64,1}) = sqrt(sum(v.^2))
"""Wylicza długość wektora"""

F_gravity(M1::BigFloat,M2::BigFloat,r::Array) = (G*M1*M2/vec_length(r)^3).*r
"""Wylicza wektor siły grawitacji"""

function Skalowanie(planeta::My_planet)
    return (planeta.mass/Ziemia.mass)^(1/10)*6
end

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
        lista[i].a_vec = FG./lista[i].mass      # ustawia wektor przyspieszenia planety 
    end
    for i in 1:length(lista)
        lista[i].v_vec += T.*lista[i].a_vec
        lista[i].coord += T.*lista[i].v_vec  
    end
end

function the_farthest(lista_planet::Array)
    """Funkcja do obliczania najdalszej planety od środka układu"""
    wynik = 0
    for i in lista_planet
        if wynik < vec_length(i.coord)
            wynik = vec_length(i.coord)
        end
    end
    return wynik      
end

function Symulacja(lista_planet::Array, t::Int64, n::Int64, fps::Int64, T::Int64,Scale::Bool)

    dist_limit = the_farthest(lista_planet)*1.2
    list_length = length(lista_planet)

    if Scale == true
        lista_skalowanie = []
        for i in lista_planet
            push!(lista_skalowanie,Skalowanie(i))
        end
        @time symulation = @animate for i in 1:t
        
            scatter([lista_planet[1].coord[1]], [lista_planet[1].coord[2]],
            xlim = (-dist_limit, dist_limit),
            ylim = (-dist_limit, dist_limit), 
            markersize = lista_skalowanie[1])
    
            for i in 2:list_length
                scatter!([lista_planet[i].coord[1]], [lista_planet[i].coord[2]],
                markersize = lista_skalowanie[i])
            end
    
            for i in 1:n
                MainFunction(lista_planet,T)
            end
    
        end
    end

    if Scale == false
        @time symulation = @animate for i in 1:t
        
            scatter([lista_planet[1].coord[1]], [lista_planet[1].coord[2]],
            xlim = (-dist_limit, dist_limit),
            ylim = (-dist_limit, dist_limit), 
            markersize = 6)
    
            for i in 2:list_length
                scatter!([lista_planet[i].coord[1]], [lista_planet[i].coord[2]],
                markersize = 6)
            end
    
            for i in 1:n
                MainFunction(lista_planet,T)
            end
    
        end
    end

    gif(symulation,"animacja.gif",fps=fps)

end

#-------------------------------------------------------------------------------------------
#               RYSOWANIE WYKRESU
#-------------------------------------------------------------------------------------------

# PARAMETRY
t = 1000          # ilość klatek 
n = 20              # ilość przeliczeń na każdą klatkę symulacji (zwiększa szybkość sumulacji, ale i długość obliczeń)
fps = 40            # ilość klatek na sekundę w symulacji
T = 2000           # przedział czasowy pomiędzy każdym kolejnym przeliczeniem pozycji ( zwiększa szybkość symulacji kosztem dokładności )


# Symulacja(lista_solar,t,n,fps,T,false)

Symulacja(lista_symulacja1, 600, 10, 40, 1, false)