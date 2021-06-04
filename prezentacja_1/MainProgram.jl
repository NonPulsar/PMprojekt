# Główny program do obliczania położenia ciał ( dla dwóch obiektów )

# Ważne stałe
G = 6.6732*10^(-11)     # stała grawitacyjna 

# Parametry początkowe obiektów
Planeta1 = Dict("M" => 10^15, "coord" => [0,1000], "v_vec" => [10,0])
Planeta2 = Dict("M" => 10^16, "coord" => [0,0], "v_vec" => [0,0])

#---------------------------------------------------------------------------------------------
#       FUNKCJE DO OBLICZEŃ 
#---------------------------------------------------------------------------------------------

dist_vec(coord1,coord2) = coord2 - coord1
"""Wylicza wektor odległości z coord1 do coord2"""

vec_length(v::Array) = sqrt(sum(v.^2))
"""Wylicza długość wektora"""

F_gravity(M1::Number,M2::Number,r::Array) = (G*M1*M2/vec_length(r)^3)*r
"""Wylicza wektor siły grawitacji"""



function MainFunction(P1::Dict,P2::Dict,t::Number)
    """Pobiera słowniki dwóch planet i ustala ich nowe pozycje i prędkości 
    po czasie t oraz nadpisuje je w słownikach """

    r = dist_vec(get(P1,"coord",1),get(P2,"coord",1))   # wektor odległości z P1 do P2
    F1 = F_gravity(get(P1,"M",1),get(P2,"M",1),r)       # oblicza wektory siły grawitacji
    F2 = F1.*(-1)                                      
    a_vec1 = F1/get(P1,"M",1)                           # oblicza wektory przyspieszania
    a_vec2 = F2/get(P2,"M",1)

    P1["v_vec"] = a_vec1.*t + P1["v_vec"]                  # nowy wektor prędkości planet
    P2["v_vec"] = a_vec2.*t + P2["v_vec"]

    P1["coord"] = P1["coord"] + P1["v_vec"]                   # nowe położenia planet
    P2["coord"] = P2["coord"] + P2["v_vec"]

end

for t in 1:100
    MainFunction(Planeta1,Planeta2,1)
    println(Planeta1["coord"],"  ",Planeta1["v_vec"])
end
