library(lubridate)
library(readr)
library(tidyverse)
library(zoo)

# import ####
fips_key = read.csv("source-data/fips-key.csv", stringsAsFactors = F)


daily_counties = read.csv("source-data/us-counties.csv", stringsAsFactors = F) 
daily_counties$fips = ifelse(grepl("New York City", daily_counties$county), 36124, daily_counties$fips)
  

daily_counties = daily_counties %>% filter((!is.na(fips)))
daily_counties$county = na_if(x = daily_counties$county, y = "Unknown")
daily_counties$date = as.Date(daily_counties$date, "%Y-%m-%d")
daily_counties$state = state.abb[match(daily_counties$state, state.name)]
daily_counties$state = replace_na(data = daily_counties$state, replace = "DC")
daily_counties$county = paste(daily_counties$county, daily_counties$state, sep=", ")
daily_counties$county = gsub(pattern = ", DC", replacement = "", x = daily_counties$county, ignore.case = FALSE, fixed = FALSE, useBytes = FALSE)
#daily_counties = daily_counties %>% select(-state) 



census_area = read.csv("source-data/county-landarea.csv", stringsAsFactors = F) %>% 
  select(., fips = FIPS, land_sqmi = LND110210D)


census_pop = read.csv("source-data/county-population.csv", stringsAsFactors = F) %>% 
  select(county = CTYNAME, state = STNAME, county_pop = POPESTIMATE2019) %>% 
  mutate_if(is.character, str_replace_all, pattern = ' County', replacement = '') %>% 
  mutate_if(is.character, str_replace_all, pattern = ' Parish', replacement = '') %>% 
  mutate_if(is.character, str_replace_all, pattern = ' Borough', replacement = '') %>% 
  mutate_if(is.character, str_replace_all, pattern = ' city', replacement = '') %>% 
  mutate_if(is.character, str_replace_all, pattern = ' Municipality', replacement = '')

census_pop$state = state.abb[match(census_pop$state, state.name)]
census_pop$state = replace_na(data = census_pop$state, replace = "DC")
census_pop$county = paste(census_pop$county, census_pop$state, sep=", ")
census_pop$county = gsub(pattern = ", DC", replacement = "", x = census_pop$county, ignore.case = FALSE, fixed = FALSE, useBytes = FALSE)
census_pop$county = gsub(pattern = " Census Area", replacement = "", x = census_pop$county, ignore.case = FALSE, fixed = FALSE, useBytes = FALSE)
census_pop$county = gsub(pattern = "Juneau City and", replacement = "Juneau", x = census_pop$county, ignore.case = FALSE, fixed = FALSE, useBytes = FALSE)


census_pop = census_pop %>% 
  select(county, county_pop) %>% 
  left_join(., y = fips_key, by = "county") %>% 
  select(-county) %>% 
  filter(!is.na(fips))




daily_counties = daily_counties %>% 
  group_by(fips) %>% 
  summarise(., "cty_day0" = as.Date(first(x = date))) %>% 
  left_join(x = daily_counties, ., by = "fips") %>% 
  left_join(., y = census_area, by = "fips") %>% 
  left_join(., y = census_pop, by = "fips")
class(daily_counties$cty_day0)




daily_counties = daily_counties %>% 
  rename(., "conf_cases" = "cases") %>% rename(., "conf_deaths" = "deaths") %>% 
  mutate(pop_density = county_pop / land_sqmi) %>% 
  mutate(day_num = date - cty_day0) %>% 
  mutate_if(is.numeric, ~round(., 1)) %>% 
  mutate(conf_cases_p1M = sprintf("%.2f", conf_cases * 1000000 / county_pop)) %>% 
  mutate(conf_deaths_p1M = sprintf("%.2f", conf_deaths * 1000000 / county_pop)) %>% 
  mutate(pop_den_cat = if_else(between(pop_density, 0, .9), 1, 
                          if_else(between(pop_density, 1, 19.9), 2, 
                          if_else(between(pop_density, 20, 88.3), 3, 
                          if_else(between(pop_density, 88.4, 499.9), 4,
                          if_else(between(pop_density, 500, 1999.9), 5, 6)))))) 




cty_data = as.data.frame(daily_counties %>% filter(fips<100))
#rowstobind = as.data.frame(daily_counties %>% filter(fips<100))
distinct_ctys = daily_counties %>% distinct(county) %>% arrange(county)


for (i in 1:nrow(distinct_ctys)) {
  rowstobind = daily_counties %>% 
    filter(county == distinct_ctys$county[i]) %>% 
    mutate(new_cases=(conf_cases-(lag(conf_cases, default=0)))) %>%
    mutate(new_deaths=(conf_deaths-(lag(conf_deaths, default=0)))) %>% 
    mutate(new_case_rate = ifelse(day_num == 0, 0, conf_cases / (conf_cases-new_cases))) %>% 
    mutate(new_case_rate3 = ifelse(day_num == 0 | day_num == 1, 0, 
                            (new_case_rate + lag(new_case_rate) + lag(new_case_rate, n = 2)) / 3)) %>% 
    mutate(new_case_rate7 = ifelse(day_num == 0 | day_num == 1 | day_num == 2 | day_num == 3 | day_num == 4 | day_num == 5 | day_num == 6, 0, 
                                   (new_case_rate + lag(new_case_rate) + lag(new_case_rate, n = 2) + lag(new_case_rate, n = 3) + 
                                    lag(new_case_rate, n = 4) + lag(new_case_rate, n = 5) + lag(new_case_rate, n = 6)) / 7)) %>% 
    mutate(new_cases_p1M = sprintf("%.2f", new_cases * 1000000 / county_pop)) %>% 
    mutate(new_deaths_p1M = sprintf("%.2f", new_deaths * 1000000 / county_pop)) 
    cty_data = bind_rows(cty_data, rowstobind)
}



cty_data = cty_data %>% 
  select(date, county, fips, day_num, cty_day0, conf_cases, new_cases,  
         conf_cases_p1M, new_cases_p1M, new_case_rate, new_case_rate3, 
         new_case_rate7, conf_deaths, new_deaths, conf_deaths_p1M, new_deaths_p1M,
         county_pop, land_sqmi, pop_density, pop_den_cat, state)

cty_data = cty_data[order(cty_data$date),]

#ADD TESTING DATA####
#STACK TESTS WITH NEW CASES ON 
  
write.csv(cty_data, file = "us-counties-clean.csv", na ="NA", row.names = F)



  

sum(is.na(daily_counties))
sum(is.na(cty_data$date))
sum(is.na(cty_data$county))
sum(is.na(cty_data$fips))
sum(is.na(cty_data$day_num))
sum(is.na(cty_data$cty_day0))
sum(is.na(cty_data$conf_cases))
sum(is.na(cty_data$new_cases))
sum(is.na(cty_data$conf_cases_p1M))
sum(is.na(cty_data$new_cases_p1M))
sum(is.na(cty_data$new_case_rate))
sum(is.na(cty_data$new_case_rate3))
sum(is.na(cty_data$new_case_rate7))
sum(is.na(cty_data$conf_deaths_p1M))
sum(is.na(cty_data$new_deaths_p1M))
sum(is.na(cty_data$county_pop))
sum(is.na(cty_data$land_sqmi))
sum(is.na(cty_data$pop_density))
sum(is.na(cty_data$pop_den_cat))
sum(is.na(cty_data$state))

nas = cty_data %>% 
  filter(is.na(new_case_rate7))
#from gaps in reporting on ctys with low counts
