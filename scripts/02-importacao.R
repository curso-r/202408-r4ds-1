library(tidyverse)

# Caminhos até o arquivo --------------------------------------------------

# csv
# .xlsx / excel
# dta do stata

# Caminho: texto que indica onde o arquivo está salvo
"dados/imdb.csv"


# diretório de trabalho - onde o R vai buscar ou salvar arquivos.
# wd - working directory (diretório de trabalho)
getwd()
# com projetos, o diretorio de trabalho é a pasta do projeto!
# "/Users/beatrizmilz/Desktop/material_do_curso_r4ds1"

# setwd() - melhor não usar!
# setwd("/Users/beatrizmilz/Documents/....")

# Caminhos absolutos - Não é uma boa prática
"/home/william/Documents/Curso-R/main-r4ds-1/dados/imdb.csv"

# imdb <- leitura("~/Desktop/material_do_curso-r-para-ciencia-de-dados/dados/imdb.csv")

# Caminhos relativos - partem do diretório de trabalho
"dados/imdb.csv"
"dados/imdb.csv"
"dados/imdb.xlsx"

# (cara(o) professora(o), favor lembrar de falar da dica
# de navegação entre as aspas)

"dados/por_ano/imdb_1920.rds"


# Tibbles -----------------------------------------------------------------

airquality

iris

class(airquality)
class(iris)

as_tibble(airquality)

class(as_tibble(airquality))


t_airquality <- as_tibble(airquality)

class(t_airquality)


# Lendo arquivos de texto -------------------------------------------------

# Quais formatos vocês costumam usar?





# readr - pacote para importacao

# CSV, valores separado por vírgula-  comma separated values
imdb_csv <- read_csv("dados/imdb.csv")

# read.csv() -> R base
# read_csv() -> tidyverse

# Rows: 28490 Columns: 20                                                                                
# ── Column specification ────────────────────────────────────────────
# Delimiter: ","
# chr (11): id_filme, titulo, data_lancamento, generos, pais, idio...
# dbl  (9): ano, duracao, orcamento, receita, receita_eua, nota_im...
# 
# ℹ Use `spec()` to retrieve the full column specification for this data.
# ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.


# CSV, separado por ponto-e-vírgula -> ;
imdb_csv2 <- read_csv2("dados/imdb2.csv")

# isso aqui não funciona, carrega errado!
read_csv("dados/imdb2.csv")


# TXT, separado por tabulação (tecla TAB)
imdb_txt <- read_delim("dados/imdb.txt", delim = "\t") # \t representa o tab

# A função read_delim funciona para qualquer tipo de separador
imdb_delim <- read_delim("dados/imdb.csv", delim = ",")
imdb_delim2 <- read_delim("dados/imdb2.csv", delim = ";")

# direto da internet
imdb_csv_url <- read_csv("https://raw.githubusercontent.com/curso-r/main-r4ds-1/master/dados/imdb.csv")

mananciais <- read_csv2("https://raw.githubusercontent.com/beatrizmilz/mananciais/master/inst/extdata/mananciais.csv")

# Interface point and click do RStudio também é útil!
# Environment -> Import Dataset -> From text (readr)
# IMPORTANTE: COPIAR O CÓDIGO!!

imdb2 <- read_delim(
  "dados/imdb2.csv",
  delim = ";",
  escape_double = FALSE,
  trim_ws = TRUE
)


deputados <- read_delim(
  "https://dadosabertos.camara.leg.br/arquivos/deputados/csv/deputados.csv",
  delim = ";",
  escape_double = FALSE,
  trim_ws = TRUE
)
# Fonte, link, data de acesso



# Lendo arquivos do Excel -------------------------------------------------

library(readxl)

imdb_excel <- read_excel("dados/imdb.xlsx")

imdb_abas <- excel_sheets("dados/imdb.xlsx")

abas_excel <- excel_sheets("~/Documents/Pesquisa/icolmaData/data-raw/original_data/Brazil.xlsx")

# > abas_excel
#  [1] "Respondents"                
#  [2] "Map Questions"              
#  [3] "Geo point geo-point-10 p.12"
#  [4] "Geo point geo-point-11 p.12"
#  [5] "Geo point geo-point-12 p.12"
#  [6] "Geo point geo-point-13 p.12"
#  [7] "Geo point geo-point-16 p.12"
#  [8] "Geo point geo-point-9 p.12" 
#  [9] "Geo point geo-point-19 p.13"
# [10] "Geo point geo-point-20 p.13"
# [11] "Geo point geo-point-21 p.13"
# [12] "Geo point geo-point-22 p.13"
# [13] "Geo point geo-point-25 p.13"
# [14] "Geo point geo-point-14 p.13"
# [15] "Geo point geo-point-1 p.14" 
# [16] "Geo point geo-point-2 p.14" 
# [17] "Geo point geo-point-3 p.14" 
# [18] "Geo point geo-point-4 p.14" 
# [19] "Geo point geo-point-6 p.14" 
# [20] "Geo point geo-point-15 p.14"


imdb_excel <- read_excel("dados/imdb.xlsx", sheet = "Sheet1")

# Import dataset - excel  ----
# Carrega o pacote readxl
library(readxl)

# cria um objeto com o nome do link de acesso da tabela
url <- "https://dadosabertos.camara.leg.br/arquivos/proposicoes/xlsx/proposicoes-2024.xlsx"

# cria um objeto com o caminho e nome do arquivo a ser salvo
destfile <- "dados/proposicoes_2024.xlsx"

# faz o download do arquivo
curl::curl_download(url, destfile)

# ler o arquivo excel 
proposicoes_2024 <- read_excel(destfile)

# abre com o View
View(proposicoes_2024)  
  
# Google Sheets -----------------------------------------

library(googlesheets4)

url_sheet <- "https://docs.google.com/spreadsheets/d/1D8rh2frRvQ_YSLDrljpiqDCcTJdCjoyMb3rfoEwjPjE/edit?gid=0#gid=0"

tabela_leitura <- read_sheet(url_sheet)

sheet_names(url_sheet)

autoria <- read_sheet(url_sheet, sheet = "autoria")

# Precisamos ter acesso ao arquivo para abrir!


# read -> importar
# write -> escrever, salvar no computador

# Salvando dados ----------------------------------------------------------

# As funções iniciam com 'write'

imdb <- read_csv("dados/imdb.csv")

# criando uma pasta para salvar os arquivos
library(fs)
dir_create("dados_output")

# CSV
write_csv(imdb, "dados_output/imdb.csv")

write_csv2(imdb, "dados_output/imdb2.csv")

# Excel
library(writexl)
write_xlsx(imdb, "dados_output/imdb.xlsx")

write_xlsx(tabela_leitura, "dados_output/livros.xlsx")


# O formato rds -----------------------------------------------------------


# factor - variáveis categóricas 

# .rds são arquivos binários do R
# Você pode salvar qualquer objeto do R em formato .rds

imdb_rds <- read_rds("dados/imdb.rds")
write_rds(imdb_rds, "dados_output/imdb_rds.rds")


# Dúvida -----------------------
# Artur: Como importar todas as abas do Excel de uma vez? ----
# Outra opção: e quando tenho vários arquivos parecidos?


