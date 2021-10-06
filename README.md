I am tracking Covid-19 down to the county level, where I will add daily cumulative reports as released by NY Times. I am plotting this data, to evaluate current state of the virus as it pertains to total cases and deaths, as well as what impact population density has on overall spread of the virus. 

data categories: date, county, fips, day_num, cty_day0, conf_cases, new_cases, conf_cases_p1M, new_cases_p1M, new_case_rate, new_case_rate3, new_case_rate7, conf_deaths, new_deaths, conf_deaths_p1M, new_deaths_p1M, county_pop, land_sqmi, pop_density, pop_den_cat, state

Population Density Category (1-5) is definited by ranges used by the US Census Bureau. 

Data on cumulative coronavirus cases and deaths can be found in county-data-clean.csv.

Files contain FIPS codes, a standard geographic identifier, in order to make it easier to compare to other data at the county level, in this case from the US Census data, where I used FIPS codes to obtain population and land area at the County level.

In some cases, the geographies where cases are reported do not map to standard county boundaries. 
Exceptions include:

5 Boroughs of NYC are combined into one based on NYC level reporting not being separated into Counties

In LA, the term "Parish" has effectively been used to mean "County"

Spelling or naming inconsistencies by FIPS numbers have been resolved
