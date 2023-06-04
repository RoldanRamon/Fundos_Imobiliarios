library(tidyverse)

# Definir os pesos e ranges por segmento
pesos <- list(
  "Títulos e Val. Mob." = list(
    cotacao = 0.1,
    ffo_yield = 0.1,
    dividend_yield = 0.1,
    p_vp = 0.1,
    valor_de_mercado = 0.1,
    liquidez = 0.05,
    qtd_de_imoveis = 0.05,
    preco_do_m2 = 0.05,
    aluguel_por_m2 = 0.05,
    cap_rate = 0.05,
    vacancia_media = 0.05,
    endereco = 0.05
  ),
  "Shoppings" = list(
    cotacao = 0.1,
    ffo_yield = 0.1,
    dividend_yield = 0.15,
    p_vp = 0.15,
    valor_de_mercado = 0.1,
    liquidez = 0.05,
    qtd_de_imoveis = 0.05,
    preco_do_m2 = 0.05,
    aluguel_por_m2 = 0.05,
    cap_rate = 0.05,
    vacancia_media = 0.05,
    endereco = 0.05
  ),
  # Adicione os outros segmentos e seus pesos e ranges correspondentes
  # ...
)

# Função para calcular a nota de um determinado critério
calcular_nota <- function(valor, min_range, max_range) {
  if (valor < min_range) {
    nota <- 1
  } else if (valor > max_range) {
    nota <- 5
  } else {
    nota <- ceiling((valor - min_range) / ((max_range - min_range) / 4)) + 1
  }
  nota
}

# Calcular as notas por critério e segmento
fiis_notas <- fiis %>%
  mutate(
    nota_cotacao = calcular_nota(cotacao, min_range = 0, max_range = 100),
    nota_ffo_yield = calcular_nota(ffo_yield, min_range = 0, max_range = 30),
    nota_dividend_yield = calcular_nota(dividend_yield, min_range = 0, max_range = 20),
    nota_p_vp = calcular_nota(p_vp, min_range = 0.5, max_range = 1.1),
    nota_valor_de_mercado = calcular_nota(valor_de_mercado, min_range = 0, max_range = 1000000000),
    nota_liquidez = calcular_nota(liquidez, min_range = 0, max_range = 1000000),
    nota_qtd_de_imoveis = calcular_nota(qtd_de_imoveis, min_range = 0, max_range = 100),
    nota_preco_do_m2 = calcular_nota(preco_do_m2, min_range = 0, max_range = 10000),
    nota_aluguel_por_m2 = calcular_nota(aluguel_por_m2, min_range = 0, max_range = 1000),
    nota_cap_rate = calcular_nota(cap_rate, min_range = 0, max_range = 30),
    nota_vacancia_media = calcular_nota(vacancia_media, min_range = 0, max_range = 10),
    nota_endereco = calcular_nota(ifelse(endereco == "", 0, 1), min_range = 0, max_range = 1)
  )

# Calcular a nota ponderada por segmento
fiis_pontuacao <- fiis_notas %>%
  mutate(
    pontuacao = sum(across(starts_with("nota_")) * unlist(pesos[segmento])) / sum(unlist(pesos[segmento]))
  )
