# https://dadosabertos.camara.leg.br/swagger/api.html?tab=staticfile#staticfile
# Proposições
# Temos 1 arquivo por ano
# Temos arquivo CSV ou Excel

library(tidyverse)


prop_2023 <- read_csv2("https://dadosabertos.camara.leg.br/arquivos/proposicoes/csv/proposicoes-2023.csv")


# Salvar os arquivos

baixar_proposicoes <- function(ano) {
  # URL a ser baixado
  nome_url <- paste0(
    "https://dadosabertos.camara.leg.br/arquivos/proposicoes/csv/proposicoes-",
    ano,
    ".csv"
  )
  
  # arquivo a ser salvo
  nome_arquivo <- paste0("pratica/proposicoes-", ano, ".csv")
  
  # fazer download
  curl::curl_download(nome_url, nome_arquivo)
  
}

# Testando se a função deu certo
baixar_proposicoes(2024)

# Criando um vetor com os anos que queremos baixar os dados
anos_baixar <- c(2010:2024)

# Para cada ano no vetor anos_baixar, executar a função
# baixar_proposicoes
map(anos_baixar, .f = baixar_proposicoes, .progress = TRUE)

# Baixamos!! eeee!

# Agora conseguimos importar esses dados.

# como abrir 1 arquivo
read_csv2("pratica/proposicoes-2010.csv")

# carrega o pacote que ajuda a lidar com os arquivos do 
# computador
library(fs)

# listar arquivos para abrir,
# da pasta pratica,
# e que terminam com .csv
arquivos_para_abrir <- dir_ls("pratica/", glob = "*.csv")

# abrimos cada um dos arquivos usando a função read_csv2
lista_arquivos <- map(arquivos_para_abrir, read_csv2) |>
  # empilha as tabelas
  list_rbind()

# DÚVIDAS: -----------------------------------

## |> Pipe: vamos falar na próxima aula!

list_rbind(map(arquivos_para_abrir, read_csv2))


# pipe: 
## %>% tidyverse
##  |> R base
