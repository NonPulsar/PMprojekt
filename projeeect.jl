using AstroLib

day_sec = 86400

planet_names = ["earth", "mars", "venus", "jupiter"]

function get_mass(planet_names)
   [AstroLib.planets[i].mass for i in planet_names]
end

function get_mean_radius(planet_names)
    [AstroLib.planets[i].radius for i in planet_names]
end

function get_semi_ma_axis(planet_names)
    [AstroLib.planets[i].axis for i in planet_names]
end

function get_period(planet_names)
    [AstroLib.planets[i].period for i in planet_names]
end

function get_eccentricity(planet_names) # mimosrod 
    [AstroLib.planets[i].ecc for i in planet_names]
end


masses = get_mass(planet_names)
radiuses = get_radius(planet_names)
semi_maj_ax = get_semi_ma_axis(planet_names)
periods = get_period(planet_names)
ecc = get_eccentricity(planet_names)
m_anomaly = mean_anomaly(planet_names)