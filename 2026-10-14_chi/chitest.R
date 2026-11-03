// chi-übungen
library(tidyverse)  
daten <- read_csv("2026-10-14_chi/betriebsdaten.csv") |>
  mutate(iok = if_else(is.na(masse_mm), NA,
              if_else(abs(masse_mm - 10) > 0.15,
                      "ausserhalb", "in_Toleranz")))

tab <- table(daten$maschine, daten$iok)

tab
