library(rio)
library(tidyverse)

path = '~/Documents/klsh-ntn/fmt_2022/fmt_2022_results.xlsx'

res = import(path, sheet = 1)
res
glimpse(res)

res_clean = filter(res, day > 0.5)
res_clean2 = select(res_clean, day, team_a, team_b, res_a10x, res_b10x, sum_a, sum_b)
res_clean2a = select(res_clean2, day, team_a, res_a10x, sum_a)
res_clean2b = select(res_clean2, day, team_b, res_b10x, sum_b)
res_clean2au = rename(res_clean2a, team = team_a, res_10x = res_a10x, sum = sum_a)
res_clean2bu = rename(res_clean2b, team = team_b, res_10x = res_b10x, sum = sum_b)
res_clean2unif = bind_rows(res_clean2au, res_clean2bu)

group_by(res_clean2unif, day) %>% summarise(n = n())
sorted = group_by(res_clean2unif, team) %>% 
  summarise(n = n(), 
            res_10 = sum(res_10x), res_corrected = sum(sum)) %>% 
  arrange(-res_10, -res_corrected)

export(sorted, file = '~/Documents/klsh-ntn/fmt_2022/fmt_2022_main_results.xlsx')

