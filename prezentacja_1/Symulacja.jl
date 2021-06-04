# Symulajca układu planetarnego 

using Plots, AstroLib

# Pobranie planet z AstroLib
planety = AstroLib.planets

# Pewne stałe
G = 6.6732*10^(-11)     # stała grawitacyjna 

# Parametry początkowe obiektów
Planeta1 = Dict("mass" => 10^16, "coord" => [0,10000], "v_vec" => [3,0])
Planeta2 = Dict("mass" => 10^16, "coord" => [0,0], "v_vec" => [-3,0])



#--------------------------------------------------------
#       FUNKCJE 
#--------------------------------------------------------

dist_vec(coord1,coord2) = coord2 .- coord1
"""Wylicza wektor odległości z coord1 do coord2"""

vec_length(v::Array) = sqrt(sum(v.^2))
"""Wylicza długość wektora"""

F_gravity(M1::Number,M2::Number,r::Array) = (G*M1*M2/vec_length(r)^3)*r
"""Wylicza wektor siły grawitacji"""

# Funkcja wyliczająca położenie ciała w czasie

function count_location(P1::Dict,P2::Dict)
    """Wylicza nowe położenie planety1 w opraciu na prawie powszechnego ciążenia"""

    r = dist_vec(get(P1,"coord",1),get(P2,"coord",1))   # wektor odległości z P1 do P2
    F1 = F_gravity(get(P1,"mass",1),get(P2,"mass",1),r)       # oblicza wektory siły grawitacji

    P1["v_vec"] = F1/P1["mass"]  + P1["v_vec"]                  # nowy wektor prędkości planet

    P1["coord"] = P1["coord"] + P1["v_vec"]                   # nowe położenia planet

    return P1["coord"]
end


plot(count_location(Planeta1,Planeta2)[1],count_location())