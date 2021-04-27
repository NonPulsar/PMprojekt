# Projekt testowy nr1 Wojciech Dwornik


# Pewne stałe

G = 6.6732*10^(-11)     # m^3 * kg^-1 * s^-2
M_ziemi = big(5.972*10)^24   # kg
M_słońca = big(1.989*10)^30  # kg
odległość_ziemia_słońce = 150.59*10^9 # m

# Funkcje do obliczeń

function długośćWektora(v::Array)
    return sqrt(sum(v.^2))
end

function wektorSiłyGrawitacji(M1::Number,M2::Number,r::Array)
    """Oblicza wekotr siły grawitacji
    ------------------------------------------
    M1, M2 - masy ciał
    r - wektor odległości między ich środkami
    """
    return (G*M1*M2/długośćWektora(r)^3)*r
end

function prędokośćOrbitowania(M::Number,r)
    """Ustala prędkość orbitowania kołowego ciała 
    (wyznaczone z zasady zachowania energii)
    ---------------------------------------------
    M - masa ciała wokół którego orbituje
    r - wektor odłegołości środków ciał
    """
    return sqrt(G*M/r)
end

prędokośćOrbitowania(M_słońca,odległość_ziemia_słońce)

