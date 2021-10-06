I am looking to track the Covid19 virus on a county level, starting with Nassau County which is a suburb of NYC. I wish to identify other suburban counties that are at risk or possibly on the same trajectery. 


Data on cumulative coronavirus cases and deaths can be found in two files for states and counties.

Each row of data reports cumulative counts based on our best reporting up to the moment we publish an update. We do our best to revise earlier entries in the data when we receive new information.

Both files contain FIPS codes, a standard geographic identifier, to make it easier for an analyst to combine this data with other data sets like a map file or population data.

Download all the data or clone this repository by clicking the green "Clone or download" button above.

State-Level Data
State-level data can be found in the states.csv file. (Raw CSV file here.)

date,state,fips,cases,deaths
2020-01-21,Washington,53,1,0
...
County-Level Data
County-level data can be found in the counties.csv file. (Raw CSV file here.)

date,county,state,fips,cases,deaths
2020-01-21,Snohomish,Washington,53061,1,0
...
In some cases, the geographies where cases are reported do not map to standard county boundaries. See the list of geographic exceptions for more detail on these.
