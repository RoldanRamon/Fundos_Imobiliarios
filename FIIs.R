rm(list = ls())
library(dplyr)
library(rvest)
library(janitor)
library(readr)
library(stringr)

# Url da página do Fundamentus
fiis_url <- 'https://fundamentus.com.br/fii_resultado.php'

# Lendo a tabela da página
fiis <- read_html(fiis_url) %>% 
  html_table() %>% 
  data.frame() %>% 
  clean_names() %>% 
  mutate(cotacao = parse_number(cotacao, locale = locale(decimal_mark = ',', grouping_mark = '.')),
         p_vp = parse_number(p_vp, locale = locale(decimal_mark = ',', grouping_mark = '.')),
         valor_de_mercado = parse_number(valor_de_mercado, locale = locale(decimal_mark = ',', grouping_mark = '.')),
         liquidez = parse_number(liquidez, locale = locale(decimal_mark = ',', grouping_mark = '.')),
         preco_do_m2 = parse_number(preco_do_m2, locale = locale(decimal_mark = ',', grouping_mark = '.')),
         aluguel_por_m2 = parse_number(aluguel_por_m2, locale = locale(decimal_mark = ',', grouping_mark = '.')),
         ffo_yield = str_replace_all(ffo_yield, '%', '') %>% parse_number(locale = locale(decimal_mark = ',', grouping_mark = '.')),
         dividend_yield = str_replace_all(dividend_yield, '%', '') %>% parse_number(locale = locale(decimal_mark = ',', grouping_mark = '.')),
         cap_rate = str_replace_all(cap_rate, '%', '') %>% parse_number(locale = locale(decimal_mark = ',', grouping_mark = '.')),
         vacancia_media = str_replace_all(vacancia_media, '%', '') %>% parse_number(locale = locale(decimal_mark = ',', grouping_mark = '.')),
         across(where(is.character), as.factor),
         data_atualizacao = format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  )

# Escrevendo o arquivo em disco
write.csv(fiis, file = "fiis.csv", row.names = FALSE)