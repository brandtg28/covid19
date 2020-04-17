library(ggplot2)
library(plotly)
library(tidyverse)
library(RColorBrewer)
library(lubridate)

cty_data = read.csv("us-counties-clean.csv", stringsAsFactors = F)
# single county ####
# nyc only day / conf_cases / daily new cases / color by 3-day growth rate

fig_data = cty_data %>% filter(fips == 36124)
fig <- plot_ly(fig_data)
fig <- fig %>% add_trace(x = ~day_num, y = ~conf_cases, type = 'scatter', mode = 'lines+markers', name = 'Confirmed Cases', 
                         line = list(color = 'Red', width = 3),
                         marker = list(color = 'Red'),
                         hoverinfo = "text",
                         text = ~paste('day', day_num, ':', conf_cases, 'Cumulative Cases'))

fig <- fig %>% add_trace(x = ~day_num, y = ~new_cases, type = 'bar', name = 'New Cases',
                         hoverinfo = "text",
                         text = ~paste(new_cases, ' New Cases'))

fig = fig %>% add_trace(x = ~day_num, y = ~new_case_rate3, type = 'scatter', mode = 'lines', name = 'Growth Rate', 
                        yaxis = 'y2', line = list(color = 'Blue', width = 1), hoverinfo = "text",
                        text = ~paste(sprintf("%.2f", new_case_rate3), 'avg new case daily growth'))


fig <- fig %>% layout(title = 'NYC Covid-19 Cases',
                      legend = list(x = 0.1, y = 0.9),
                      margin = list(l = 50, r = 50, b = 50, t = 50, pad = 4),
                      xaxis = list(title = "Days Since 1st Confirmed Case", 
                                   dtick = 2, 
                                   tick0 = 0, 
                                   tickmode = "linear"),
                      yaxis = list(side = 'left', title = 'Cases', dtick = 5000, showgrid = T, zeroline = T), 
                      yaxis2 = list(side = 'right', 
                                    overlaying = 'y',
                                    range = c(0, 10),
                                    dtick = .75,
                                    #dtick = .05,
                                    tick0 = 0, 
                                    tickmode = "linear",
                                    title = 'New Cases Growth, 3-Day',
                                    showgrid = F, zeroline = F))

#x = fig_data$day_num
#y = fig_data$conf_cases
#df = data.frame(x, y)
#plot(y ~ x)
#fit <- nls(y ~ SSlogis(x, Asym, xmid, scal), data = fig_data)
#summary(fit) 
#plot(x,y, col="red")
#lines(x,predict(fit), col="blue")

fig

#same as above but focus on yaxis2   
fig_data = cty_data %>% filter(fips == 36124)
fig <- plot_ly(fig_data)
fig <- fig %>% add_trace(x = ~day_num, y = ~conf_cases, type = 'scatter', mode = 'lines+markers', name = 'Confirmed Cases', 
                         line = list(color = 'Red', width = 3),
                         marker = list(color = 'Red'),
                         hoverinfo = "text",
                         text = ~paste('day', day_num, ':', conf_cases, 'Cumulative Cases'))

fig <- fig %>% add_trace(x = ~day_num, y = ~new_cases, type = 'bar', name = 'New Cases',
                         hoverinfo = "text",
                         text = ~paste(new_cases, ' New Cases'))

fig = fig %>% add_trace(x = ~day_num, y = ~new_case_rate3, type = 'scatter', mode = 'lines', name = 'Growth Rate', 
                        yaxis = 'y2', line = list(color = 'Blue', width = 1), hoverinfo = "text",
                        text = ~paste(sprintf("%.2f", new_case_rate3), 'avg new case daily growth'))


fig <- fig %>% layout(title = 'NYC Covid-19 Cases',
                      legend = list(x = 0.7, y = 0.9),
                      margin = list(l = 50, r = 50, b = 50, t = 50, pad = 4),
                      xaxis = list(title = "Days Since 1st Confirmed Case", 
                                   dtick = 2, 
                                   tick0 = 0, 
                                   tickmode = "linear"),
                      yaxis = list(side = 'left', title = 'Cases', dtick = 250, showgrid = F, zeroline = F), 
                      yaxis2 = list(side = 'right', 
                                    overlaying = 'y',
                                    #range = c(0, 10),
                                    dtick = .75,
                                    dtick = .05,
                                    tick0 = 0, 
                                    tickmode = "linear",
                                    title = 'New Cases Growth, 3-Day',
                                    showgrid = T, zeroline = T))
fig




                 
                      
# NYC Metro ####

nycmetro = cty_data %>% 
  filter(fips == 36059 |fips == 36103|fips == 36119|fips == 36087| fips == 36124)

fig = plot_ly(nycmetro, x = ~day_num, y = ~conf_cases_p1M, color = ~county, 
                colors = 'Dark2', type = 'scatter', mode = 'lines', text = ~paste('Date: ',date))

fig = fig %>% layout(title = 'NYC Metro Region Confirmed Cases',
                     legend = list(x = 0.05, y = 0.95),
                     margin = list(l = 50, r = 50, b = 50, t = 50, pad = 4),
                     xaxis = list(title = "Days Since County's 1st Confirmed Case", 
                                    dtick = 2, 
                                    tick0 = 0, 
                                    tickmode = "linear"),
                      yaxis = list(side = 'left', 
                                    title = 'Cases per 1M Pop', 
                                    overlaying = 'y',
                                    range = c(0, 25000),
                                    dtick = 2500,
                                    tick0 = 0, 
                                    tickmode = "linear",
                                    showgrid = T, zeroline = T))
fig


fig = plot_ly(nycmetro, x = ~date, y = ~new_case_rate3, color = ~county, 
              colors = 'Dark2', type = 'scatter', mode = 'lines')

fig = fig %>% layout(title = 'NYC Metro Region 3-Day Rolling Avg Growth Rate',
                     legend = list(x = 0.05, y = 0.05),
                     margin = list(l = 50, r = 50, b = 50, t = 50, pad = 4),
                     xaxis = list(title = "Date", 
                                  dtick = 1, 
                                  tick0 = 0, 
                                  tickmode = "linear"),
                     yaxis = list(side = 'right', 
                                  title = 'Growth Rate of New Cases', 
                                  overlaying = 'y',
                                  range = c(.8, 2.2),
                                  dtick = .05,
                                  tick0 = .8, 
                                  tickmode = "linear",
                                  showgrid = T, zeroline = T))
fig


# minutephysics ripoff ####
fig_data = cty_data %>% 
  select(date, day_num, county, fips, conf_cases, new_cases)

fig_data = fig_data[order(fig_data$fips),]  

fig_data = fig_data %>% 
  group_by(fips) %>% 
  summarise(., "maxconf_case" = (max(conf_cases))) %>% 
  filter(maxconf_case > 50) %>% 
  left_join(y = cty_data, by = "fips") %>% 
  select(-maxconf_case)
  
fig_data = fig_data %>% 
  mutate(conf_last7 = ifelse(day_num == 0 | day_num == 1 | day_num == 2 | day_num == 3 | 
                              day_num == 4 | day_num == 5 | day_num == 6, 0, conf_cases - lag(conf_cases, n=7)))

sum(is.na(fig_data))
















fig
#add bar plots to NYC metro conf cases (not by pop, but by count of conf cases), ####
#have bars show daily cases stacked by same color as lines 
                      
#                      
                      
                      
x = nyc_data$day_num
y = nyc_data$conf_cases
df = data.frame(x, y)
plot(y ~ x)
fit <- nls(y ~ SSlogis(x, Asym, xmid, scal), data = df)
summary(fit) 

plot(x,y, col="red")
lines(x,predict(fit), col="blue")





























fig <- fig %>% add_trace(x = ~day_num, y = ~new_cases, type = 'bar', name = 'New Cases',
                         hoverinfo = "text",
                         text = ~paste(new_cases, ' New Cases'))



casesvsdensity = cty_data %>% 
  group_by(county) %>% filter(day_num == max(day_num))
fig = plot_ly(casesvsdensity, x = ~pop_density, y = ~conf_cases, color = ~day_num, type = 'scatter')


fig = plot_ly(ny_data, x = ~day_num, y = ~conf_cases, color = ~county, type = 'scatter', mode = 'lines')
#fig = plot_ly(ny_data, x = ~day_num, y = ~conf_cases_p1M, color = ~pop_den_cat, type = 'scatter', mode = 'lines')
fig = plot_ly(ny_data, x = ~day_num, y = ~conf_cases_p1M, color = ~county, type = 'scatter', mode = 'lines')

fig

popdencat = ny_data %>% 
  group_by(day_num, pop_den_cat) %>% 
  summarise(conf_cases = sum(conf_cases))

fig = plot_ly(popdencat, x = ~day_num, y = ~conf_cases, color = ~pop_den_cat, type = 'scatter')
fig

rm(fig)




nyc = ny_data %>% 
  filter(fips == 36124) %>% 
  mutate(new_cases=(conf_cases-(lag(conf_cases, default=0))))


fig = plot_ly(nyc, x = ~day_num, y = ~conf_cases, colors = 'Blues', type = 'scatter', mode = 'lines')
fig


colors()

#plotly colors
#['Blackbody',
#  'Bluered',
#  'Blues',
#  'Earth',
#  'Electric',
  # 'Greens',
  # 'Greys',
  # 'Hot',
  # 'Jet',
  # 'Picnic',
  # 'Portland',
  # 'Rainbow',
  # 'RdBu',
  # 'Reds',
  # 'Viridis',
  # 'YlGnBu',
  # 'YlOrRd'












count_dayofweek = quotes %>%
  group_by(Created.DayOfWeek) %>%
  count()
View(count_dayofweek)

p = ggplot(data=count_dayofweek, aes(x = Created.DayOfWeek, y = n)) + 
  geom_col(fill="lightblue", color="black") +
  ggtitle("Number Created by Day of Week") +
  scale_x_continuous(name = "Day of the Week", breaks=seq(from = 1, to = 7), labels=c("Sun","Mon","Tue","Wed","Thu","Fri","Sat")) + 
  scale_y_continuous(name = "Count", breaks=seq(0,4000,200))
ggplotly(p)



rate_dayofweek = quotes %>%
  group_by(Created.DayOfWeek) %>%
  summarise(mean(Dispatched)) %>% 
  rename(Dispatch.Rate='mean(Dispatched)')
view(rate_dayofweek)

p = ggplot(data=rate_dayofweek, aes(x = Created.DayOfWeek, y = Dispatch.Rate)) + 
  geom_col(fill="lightblue", color="black") +
  ggtitle("Closure/Dispatch Rate by Day of Week") +
  scale_x_continuous(name = "Day of the Week", breaks=seq(from = 1, to = 7), labels=c("Sun","Mon","Tue","Wed","Thu","Fri","Sat")) + 
  scale_y_continuous(name = "Dispatch Rate", breaks=seq(.04,.10,.005)) +
  coord_cartesian(ylim = c(.04, .09))
ggplotly(p)





#dispatched by time lead came in ####
count_timeofday = quotes %>%  
  group_by(Created.Time.Blocks) %>% 
  count()
View(count_timeofday)


p = ggplot(data=count_timeofday, aes(x = Created.Time.Blocks, y = n)) + 
  geom_col(fill="lightblue", color="black") +
  ggtitle("Orders Created by Time of Day") +
  scale_x_continuous(name = "Time of Day", breaks=seq(from = 1, to = 6), labels=c("0-4am","4-8am","8am-12pm","12-4pm","4-8pm","8pm-0")) + 
  scale_y_continuous(name = "Count", breaks=seq(0,1e4,250))
ggplotly(p)


rate_timeofday = quotes %>%  
  group_by(Created.Time.Blocks) %>% 
  summarise(mean(Dispatched)) %>% 
  rename(Dispatch.Rate = 'mean(Dispatched)')
View(rate_timeofday)

p = ggplot(data=rate_timeofday, aes(x = Created.Time.Blocks, y = Dispatch.Rate)) + 
  geom_col(fill="lightblue", color="black") +
  ggtitle("Closure Rate by Time of Day") +
  scale_x_continuous(name = "Time of Day", breaks=seq(from = 1, to = 6), labels=c("0-4am","4-8am","8am-12pm","12-4pm","4-8pm","8pm-0")) + 
  scale_y_continuous(name = "Dispatch Rate", breaks=seq(0,.10,.005)) +
  coord_cartesian(ylim = c(.00, .085))
ggplotly(p)




#Route Combos####
route_count = quotes %>% group_by(Route) %>%
  count() %>% 
  arrange(desc(n)) %>% 
  head(n=50)
View(route_count)

p = ggplot(route_count, aes(x = reorder(Route, -n), y = n)) + 
  geom_col(fill="lightblue", color="black") +
  ggtitle("Quote Count by Route Combination") +
  xlab(label = "Route") + 
  scale_y_continuous(name = "Quote Count", breaks=seq(0,500,25)) +
  theme(axis.text.x=element_text(angle=90, vjust=.5))
ggplotly(p)



route_dispatched = quotes %>% 
  filter(Dispatched == 1) %>% 
  group_by(Route) %>%
  count() %>% 
  arrange(desc(n)) %>% 
  head(n=30)
View(route_dispatched)

p = ggplot(route_dispatched, aes(x = reorder(Route, -n), y = n)) + 
  geom_col(fill="lightblue", color="black") +
  ggtitle("Dispatch Count by Route Combination") +
  xlab(label = "Route") + 
  ylab("Dispatch Count") +
  theme(axis.text.x=element_text(angle=90))
ggplotly(p)

#rate_route = quotes %>%  
#  group_by(Route) %>% 
#  summarise(mean(Dispatched)) %>% 
#  rename(Dispatch.Rate = 'mean(Dispatched)')
#View(rate_route)
#p = ggplot(data=rate_timeofday, aes(x = Created.Time.Blocks, y = Dispatch.Rate)) + 
#  geom_col(fill="lightblue", color="black") +
#  ggtitle("Closure Rate by Route") +



#Route Origin/Destination####
origin_count = quotes %>% group_by(Origin.State) %>% 
  count() %>% 
  arrange(desc(n))
View(origin_count)

p = ggplot(origin_count, aes(x = reorder(Origin.State, -n), y = n)) + 
  geom_col(fill="lightblue", color="black") +
  ggtitle("Quote Count by Origin State") +
  scale_x_discrete(name = "State") + 
  scale_y_continuous(name = "Quote Count", breaks=seq(0,3500,250)) +
  theme(axis.text.x=element_text(angle=90, vjust=.5))
ggplotly(p)

origin_dispatched = quotes %>% 
  filter(Dispatched == 1) %>% 
  group_by(Origin.State) %>%
  count() %>% 
  arrange(desc(n))
View(origin_dispatched)

p = ggplot(origin_dispatched, aes(x = reorder(Origin.State, -n), y = n)) + 
  geom_col(fill="lightblue", color="black") +
  ggtitle("Dispatch Count by Origin State") +
  xlab(label = "Origin State") + 
  scale_y_continuous(name = "Dispatched Count", breaks=seq(0,250,20)) +
  theme(axis.text.x=element_text(angle=90, vjust=.5))
ggplotly(p)


origin_rate = quotes %>%
  group_by(Origin.State) %>%
  summarise(mean(Dispatched)) %>% 
  rename(Dispatch.Rate = 'mean(Dispatched)')
View(origin_rate)


p = ggplot(origin_rate, aes(x = reorder(origin_rate$Origin.State, -origin_rate$Dispatch.Rate), y = origin_rate$Dispatch.Rate)) + 
  geom_col(fill="lightblue", color="black") +
  ggtitle("Dispatch Rate by Origin State") +
  xlab(label = "Origin State") + 
  coord_cartesian(ylim = c(.00, .15)) +
  scale_y_continuous(name = "Dispatch Rate", breaks=seq(0,.15,.01)) +
  theme(axis.text.x=element_text(angle=90, vjust=.5))
ggplotly(p)



destination_count = quotes %>% 
  group_by(Destination.State) %>% 
  count() %>% 
  arrange(desc(n))
View(destination_count)



sigmoid = function(x) {
  1 / (1 + exp(-x))
}
x = seq(0,50,1)
y = sigmoid(x) * 100000
plot(x, y, col='blue', ylim = c(0,200000))