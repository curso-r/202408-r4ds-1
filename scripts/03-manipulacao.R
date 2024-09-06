# Pacotes -----------------------------------------------------------------
library(tidyverse)

# Base de dados -----------------------------------------------------------

imdb <- read_rds("dados/imdb.rds") # readr

# Jeito de ver a base -----------------------------------------------------

# R base
names(imdb)
View(imdb) # Cuidado com bases muito grandes!
head(imdb, n = 10)
tail(imdb, n = 10)

# tidyverse
slice_sample(imdb, n = 10)
glimpse(imdb)


sorteio <- imdb |> 
  rowid_to_column() |>  # tibble
  slice_sample(n = 10)
# Pergunta para pesquisar: como usar o seed com o slice_sample()?


# SKIM - relatório da base
skimr::skim(imdb)

imdb_skim <- skimr::skim(imdb)

# DICA: padronizar nomes das colunas

iris

names(iris)

iris_limpo <- janitor::clean_names(iris)

names(iris_limpo)

# dplyr: 6 verbos principais -------------------------------------------
# select()    # seleciona colunas do data.frame
# arrange()   # reordena as linhas do data.frame
# filter()    # filtra linhas do data.frame
# mutate()    # cria novas colunas no data.frame (ou atualiza as colunas existentes)
# summarise() + group_by() # sumariza o data.frame
# left_join   # junta dois data.frames

# select ------------------------------------------------------------------

# Selecionando uma coluna da base
select(imdb, id_filme) # retorna uma base de dados!

# imdb$id_filme # retorna vetor

select(imdb, titulo)

# A operação NÃO MODIFICA O OBJETO imdb

imdb

# para modificar, precisa usar <- e salvar em um objeto!
imdb_titulos <- select(imdb, titulo)


# Selecionando várias colunas

select(imdb, titulo, ano, orcamento) # respeita a ordem

select(imdb, orcamento, ano, titulo) # respeita a ordem

# relocate() # falar depois --------------------

1:10 # sequencia

select(imdb, titulo:generos)

select(imdb, 2:5) # selecionar por posicao, meu não gosto

# Pergunta: Dá pra criar um vetor com nome de colunas e 
# passar esse vetor como argumento?

colunas_selecionar <- c("generos", "orcamento", "receita", "oscar")

select(imdb, all_of(colunas_selecionar)) # todas as colunas que estão no vetor

select(imdb, any_of(colunas_selecionar)) # apenas as colunas que existem


# Funções auxiliares - detectar padroes de texto no nome das colunas!

select(imdb, starts_with("num")) # nome da coluna começa com o texto ....

select(imdb, ends_with("cao")) # nome da coluna termina com o texto ...

select(imdb, contains("cri")) # nome da coluna contém o texto ...


# podemos combinar várias regras!

colunas_selecionar <- c("generos", "orcamento", "receita", "oscar")
select(imdb, titulo, starts_with("num"), any_of(colunas_selecionar))


# Principais funções auxiliares

# starts_with(): para colunas que começam com um texto padrão
# ends_with(): para colunas que terminam com um texto padrão
# contains():  para colunas que contêm um texto padrão

# Dúvida ----
exemplo <- tibble(
  bia_milz = "1",
  milz_bia = "2",
  bia_milz_x = "3",
  bia_trecenti = "4"
)

select(exemplo, starts_with("milz")) 
select(exemplo, ends_with("milz")) 
select(exemplo, contains("milz")) 


# dúvida 2: onde tiver milz, substituir por reis

# renomear a coluna bia_milz_x para bia_milz_trecenti
rename(exemplo, bia_milz_trecenti = bia_milz_x) 

# stringr - pacote para lidar com textos
str_replace_all(string = c("beatriz milz"), 
                pattern = "milz",
                replacement = "reis")

# criamos uma função para isso!
milz_para_reis <- function(texto) {
  str_replace_all(string = texto,
                  pattern = "milz",
                  replacement = "reis")
}

# o rename_with permite aplicar uma função no nome das colunas
rename_with(exemplo, 
            .cols = everything(),
            .fn = milz_para_reis
            )



# colunas que atendam duas regras
# termina com "cao"
# comece com "d"

# nomes das colunas
nome_colunas <- names(imdb)

# detectando: quais colunas comecam com 'cao'
termina_com_sao <- str_ends(nome_colunas, "cao")

# detectando: quais colunas comecam com 'd'
comeca_com_d <- str_starts(nome_colunas, "d")

# teste lógico: quais colunas cumprem os dois requisitos?
colunas_que_quero_trazer <- termina_com_sao & comeca_com_d

# selecionando no vetor os valores que são verdadeiros
colunas_que_cumprem_os_criterios <- nome_colunas[colunas_que_quero_trazer]

# usando esses valores no select
select(imdb, any_of(colunas_que_cumprem_os_criterios))

# all_of()
# any_of()

# Selecionando colunas por exclusão

select(imdb, -titulo)
select(imdb, !titulo)

select(imdb, -starts_with("num"), -titulo, -ends_with("ao"))

select(imdb, -c(titulo, id_filme, ano))

# Treinando esse conceito

# combinar regras
select(imdb, titulo, starts_with("num"), orcamento:receita_eua)

# sequencia de colunas com :
select(imdb, id_filme:num_avaliacoes)

# salvar o resultado do select em um objeto
imdb_selecionado <- select(imdb, titulo, ano, generos)


# arrange -----------------------------------------------------------------

# nome_verbo(nome_base, regras)

arrange(imdb, ano)
arrange(imdb, desc(ano))


# View(....)

# Ordenando linhas de forma crescente de acordo com
# os valores de uma coluna

# por padrao é ordenacao crescente
View(arrange(imdb, orcamento))

# Agora de forma decrescente

View(arrange(imdb, desc(orcamento)))

# só vai mudar a ordem no objeto se salvar, com a <-
imdb_ordenado <- arrange(imdb, desc(orcamento))

# ordem das colunas que usamos no arrange importa!
View(arrange(imdb, desc(ano), desc(nota_imdb)))
# ano e desempate pela nota



# nota, desempate pelo ano
View(arrange(imdb, desc(nota_imdb), desc(ano)))

# por padrao, ordenacao por texto será em ordem alfabetica
View(arrange(imdb, direcao))

# Ordenando de acordo com os valores
# de duas colunas

View(arrange(imdb, desc(ano), orcamento))

# Respeitar os acentos em português
View(arrange(imdb, direcao, .locale = "pt_BR"))


# O que acontece com o NA? Sempre fica no final!

df <- tibble(x = c(NA, 2, 1), y = c(1, 2, 3))

arrange(df, x)
arrange(df, desc(x))

# ---------

# FORMAS PARA CRIAR UMA TABELA
# COM AS COLUNAS TITULO E NOTA,
# COM AS NOTAS DECRESCENTES

# FORMA 1
imdb_notas <- select(imdb, titulo, nota_imdb)

arrange(imdb_notas, desc(nota_imdb))

# FORMA 2
# CODIGO ANINHADO - NÃO É LEGAL
# dificil de ler
arrange(select(imdb, titulo, nota_imdb), desc(nota_imdb))

# PIPE ---------------------
# forma 3
# forma mais usada
# pipe - cano
# conecta as operações
# é um operador
# tidyverse %>%
# R base |>

imdb |>
  select(titulo, nota_imdb)

# Mais legível!
imdb |>
  select(titulo, nota_imdb) |> 
  arrange(desc(nota_imdb))

# Atalho: CTRL + SHIFT + M

# |> # pipe disponível no R base a partir de 4.1

# %>% # pipe do tidyverse, só funciona se a gente carregar o tidyverse
# ou o magrittr

# tools -> global options -> code -> selecionar a opcao "use native pipe operator"

imdb %>% 
  select(titulo, nota_imdb) %>% 
  arrange(desc(nota_imdb))


# select(imdb, titulo, nota_imdb)

# salvar em um objeto
imdb_pipe <- imdb |> # usando a base do IMDB
  # quero selecionar as colunas titulo e nota
  select(titulo, nota_imdb) |>
  # ordenar de forma decrescente pela nota
  arrange(desc(nota_imdb))

# ATALHO DO |>: CTRL (command) + SHIFT + M


# pipe nativo - Atalho: CTRL SHIFT M
imdb |>
  select(titulo, ano, nota_imdb, num_avaliacoes) |>
  arrange(desc(nota_imdb))

# pipe do tidyverse - Atalho: CTRL SHIFT M
imdb %>%
  select(titulo, ano, nota_imdb, num_avaliacoes) %>%
  arrange(desc(nota_imdb))



# PREPARATORIO PRO FILTER: DISTINCT -----------

# olhar as categorias de uma variável:

# Retorna uma tabela

distinct(imdb, direcao) # deixa apenas valores unicos!
# retorna uma tabela com 1 coluna

unique(imdb$direcao) # retorna vetor


imdb |>
  distinct(ano, idioma) |>
  arrange(ano) |>
  View()


imdb |> 
  select(titulo, ano, generos) |> 
  # separar coluna, usando um delimitador, e empilhar (longer)
  separate_longer_delim(generos, delim = ", ") |> 
  distinct(ano, generos) |> 
  arrange(ano)


imdb |>
  distinct(direcao)

# Retorna um vetor
unique_direcao <- unique(imdb$direcao)


# pergunta ---
# É possível encontrar o último filme de cada diretor, após ordenar pelo ano?

filmes_recentes_por_direcao <- imdb |> 
  # agrupar por diretor
  group_by(direcao) |> 
  # trazer uma linha por diretor (pq ta agrupado), 
  # com o maior valor encontrado na coluna ano
  slice_max(order_by = ano, n = 1) |> 
  # SE NAO QUISER QUE TRAGA OS EMPATES: with_ties = FALSE
  # desagrupar
  ungroup() |>
  # ordenar por ano
  arrange(ano)

filmes_recentes_por_direcao |> 
  distinct(direcao) |> 
  arrange(direcao) |> 
  View() # o NA é mantido como um grupo
  

# Contagem ----

imdb |>
  count(direcao)

imdb |>
  count(direcao) |> 
  arrange(desc(n))

imdb |> 
  count(direcao, ano) |> 
  arrange(desc(n))


imdb |> 
  count(direcao, ano, sort = TRUE)

count(imdb, direcao, ano) |> View()

diretores_ordenados <- imdb |>
  count(direcao, sort = TRUE)

imdb |> 
  filter(direcao == "Quentin Tarantino") |> 
  count(producao)


# NÃO FUNCIONA SE O PIPE ESTIVER NO COMEÇO DA LINHA,
# ELE PRECISA ESTAR APÓS A OPERACAO, NA MESMA LINHA
## imdb 
## |> filter(direcao == "Quentin Tarantino")


# FINAL DA AULA 4 --------------
# filter ------------------------------------------------------------------

# nome_da_funcao(base_de_dados, regra)

# filter() - filtrar linhas da base --------

# Aqui falaremos de Conceitos importantes para filtros,
# seguindo de exemplos!

## Comparações lógicas -------------------------------

# comparacao logica
# == significa: uma coisa é igual a outra?
x <- 1
# x = 1 - igual sozinho é uma atribuicao

# Teste com resultado verdadeiro
x == 1

# Teste com resultado falso
x == 2

# Exemplo com filtros!
# Filtrando uma coluna da base: O que for TRUE (verdadeiro)
# será mantido!

# filter(imdb, comparacoes_para_filtrar)


filter(imdb, direcao == "Quentin Tarantino") |> View()

# reescrever com pipe

imdb |>
  filter(direcao == "Quentin Tarantino") |>
  arrange(ano) |> # decrescente: desc(ano)
  select(titulo, ano, nota_imdb) 


imdb |>
  filter(direcao == "Quentin Tarantino") |>
  View()

# o filter permite que a gente coloque mais regras
imdb |>
  filter(
    direcao == "Quentin Tarantino",
    producao == "Miramax"
  ) |>
  View()


## Comparações lógicas -------------------------------

# maior
x > 3
x > 0
# menor
x < 3
x < 0


x > 1
x >= 1 # # Maior ou igual
x < 1
x <= 1 # menor ou igual

# Exemplo com filtros!

imdb |>
  filter(nota_imdb >= 9) |>
  View()



## Recentes e com nota alta
imdb |>
  filter(nota_imdb >= 9, num_avaliacoes > 10000) |>
  View()


# Dúvida Rubens:
imdb |> 
  filter(nota_imdb > 5, nota_imdb < 9) |> View()





imdb |>
  filter(ano > 2010, nota_imdb > 8.5, num_avaliacoes > 1000) |>
  View()

# & - AND
imdb |> filter(ano > 2010 & nota_imdb > 8.5)

## Gastaram menos de 100 mil, faturaram mais de 1 milhão
imdb |>
  filter(orcamento < 100000, receita > 1000000) |>
  View()


# Ana Carla R.
# caso ele nao encontre o filtro que colocou, aparece qual msg de erro?
imdb |>
  filter(orcamento == 0, receita > 1000000) # não tem nenhum filme que cumpra
# esse filtro. entao a tabela resultante tem 0 linhas


## Lucraram
imdb |>
  # aceita operacoes
  filter(receita - orcamento > 0) |>
  View()

# outra forma: com uma etapa a mais
imdb |> 
  select(titulo, producao, ano, receita, orcamento) |> 
  mutate(lucrou = receita - orcamento) |> 
  filter(lucrou > 0) |> 
  arrange(desc(lucrou))


imdb |> 
  filter(is.na(ano)) # todos os filmes cujo ano é NA



imdb |>
  # é NA na receita OU é NA no orçamento
  # OU - satisfazer pelo menos uma das comparacoes/condicoes
  filter(is.na(receita) | is.na(orcamento)) |>
  # nrow()
  View()


# Como saber quantos NA's temos em cada coluna?
skim_imdb <- skimr::skim(imdb)

skim_imdb |> 
  select(skim_variable, n_missing)

naniar::gg_miss_var(imdb)

# NA é not available, missing value. 
# célula vazia


## Comparações lógicas -------------------------------

x != 2
x != 1

# Exemplo com filtros!
imdb |>
  filter(direcao != "Quentin Tarantino") |>
  View()

## Comparações lógicas -------------------------------

# operador %in%
# o x é igual à 1
# o x faz parte do conjunto 1, 2 e 3? SIM
x %in% c(1, 2, 3)
# o x faz parte do conjunto 2, 3 e 4? NÃO
x %in% c(2, 3, 4)

# Exemplo com filtros!


# O operador %in%

imdb |>
  filter(direcao %in% c("Matt Reeves", "Christopher Nolan")) |>
  View()

# dá pra reescrever com o OU
imdb |>
  filter(
    direcao == "Matt Reeves" | direcao == "Christopher Nolan"
  )


# ISSO NAO FUNCIONA
# imdb |>
#  filter(direcao == c("..", '...'))





diretores_favoritos_do_will <- imdb |>
  filter(
    direcao %in% c(
      "Quentin Tarantino",
      "Christopher Nolan",
      "Matt Reeves",
      "Steven Spielberg",
      "Francis Ford Coppola"
    )
  ) |>
  view()


# <-


## Operadores lógicos -------------------------------
## operadores lógicos - &, | , !

## & - E - Para ser verdadeiro, os dois lados
# precisam resultar em TRUE
x <- 5

x >= 3 # verdadeiro

x <= 7 # verdadeiro

x >= 3 & x <= 7 #

x >= 3 & x <= 4

# no filter, a virgula funciona como o &!
imdb |>
  filter(ano > 2010, nota_imdb > 8.5) |>
  View()


# menos frequente de ser usado, mas funciona!
imdb |>
  filter(ano > 2010 & nota_imdb > 8.5)



# 5 >= x >= 10 - usamos assim na matematica

# x <= 5 , x <= 10

## Operadores lógicos -------------------------------

## | - OU - Para ser verdadeiro, apenas um dos
# lados precisa ser verdadeiro

# operador |


y <- 2
y >= 3 # FALSO
y <= 7 # VERDADEIRO

# & - Resultado falso, VERDADEIRO + FALSO = FALSO
## | - Resultado verdadeiro, VERDADEIRO + FALSO = VERDADEIRO

y >= 3 | y <= 7

y >= 3 | y <= 0

# Exemplo com filter

## Lucraram mais de 500 milhões OU têm nota muito alta
imdb |>
  filter(receita - orcamento > 500000000 | nota_imdb > 9) |>
  View()


imdb |> 
  mutate(lucro = receita - orcamento, .after = receita_eua) |> 
  filter(lucro > 500000000 | nota_imdb > 9) |> 
  View()



# O que esse quer dizer?
imdb |>
  filter(ano > 2010 | nota_imdb > 8.5) |>
  View()



## Operadores lógicos -------------------------------

## ! - Negação - É o "contrário"
# NOT

# operador de negação !
# é o contrario

!TRUE

!FALSE

# Exemplo com filter

imdb |>
  filter(!direcao %in% c(
    "Quentin Tarantino",
    "Christopher Nolan",
    "Matt Reeves",
    "Steven Spielberg",
    "Francis Ford Coppola"
  )) |>
  View()


# função que testa se algo é um valor faltante - NA
is.na("bia")
is.na(NA)

imdb |>
  filter(!is.na(orcamento)) |>
  View()



imdb |>
  filter(!is.na(orcamento), !is.na(receita)) |>
  View()


# remover NA's de colunas específicas
imdb |> 
  drop_na(orcamento, receita)



# # Intervalo ---


imdb |> 
  mutate(direcao = str_to_lower(direcao)) |>
  filter(str_detect(direcao, "chris|cris")) |> 
  View()

# str_starts() # detecta texto no começo
# str_ends() # detecta texto no final

imdb |>
  mutate(descricao_minusculo = str_to_lower(descricao)) |>
  filter(str_detect(descricao_minusculo, "woman|hero|friend")) |>
  View()


imdb |>
  mutate(descricao_minusculo = str_to_lower(descricao)) |>
  filter(
    str_detect(descricao_minusculo, "woman"),
    str_detect(descricao_minusculo, "friend")
  ) |>
  View()



imdb_disney <- imdb |> 
  filter(str_detect(producao, "Disney|disney"))

str_view(imdb_disney$producao, "Disney", html = TRUE)



##  NA ----

# exemplo com NA
is.na(imdb$orcamento)

imdb |>
  filter(!is.na(orcamento))

# tira toooodas as linhas que tenham algum NA
imdb |>
  drop_na()

# tira as linhas que tem NA nas colunas indicadas
imdb |>
  drop_na(orcamento, receita) |> View()


# o filtro por padrão tira os NAs!
df <- tibble(x = c(1, 2, 3, NA))
df


filter(df, x > 1)

filter(df, x < 2)

# NA == 1
# NA > 1
#
# NA == NA


# manter os NAs!
filter(df, x > 1 | is.na(x))
# Por padrão, a função filter retira os NAs.



# ISSO NÃO RETORNA NADA
# PRECISAMOS USAR O is.na()
filter(imdb, orcamento == NA)

1 == NA

NA == NA

# contar os NA quando a variavel é categórica/texto
imdb |> 
count(producao, sort = TRUE) |> View()

# para numéricos, assim é mais fácil
imdb |> 
filter(is.na(orcamento)) |>
  nrow()

# tambem funciona para texto
filter(imdb, is.na(producao)) |>
  nrow()



# filtrar textos sem correspondência exata

textos <- c("a", "aa", "abc", "bc", "A", NA)
textos

library(stringr) # faz parte do tidyverse

str_detect(textos, pattern = "a")

str_view(textos, "a")

# validacao do padrao usado
str_view(imdb$descricao[1:10], "woman|movie", html = TRUE)


## Pegando os seis primeiros valores da coluna "generos"
imdb$generos[1:6]


# detectar padrões
str_detect(
  string = imdb$generos[1:10],
  pattern = "Drama"
)

# ver os textos
str_view(
  string = imdb$generos[1:10],
  pattern = "Drama"
)


## Pegando apenas os filmes que
## tenham o gênero ação
imdb |>
  filter(str_detect(generos, "Action")) |>
  View()

# CUIDADOOOOOO -----
# filtra generos que contenha filmes que tenha "Crime" no texto
imdb |>
  filter(str_detect(generos, "Crime")) |>
  View()

# filtra generos que seja IGUAL e APENAS "Crime"
imdb |> filter(generos == "Crime") |> View()







# mutate ------------------------------------------------------------------

# mutate(base, nome_da_coluna_para_criar = operacao_que_tem_resultado,
# nome_da_coluna_para_criar_2 = operacao_que_tem_resultado)

# Modificando uma coluna
imdb |>
  mutate(duracao = duracao / 60) |>
  View()

# Criando uma nova coluna

imdb_2 <- imdb |>
  mutate(duracao_horas = duracao / 60) 

# util pra criar colunas em uma posicao especifica
imdb |>
  mutate(duracao_horas = duracao / 60, .after = duracao) |>
  View()

imdb |>
  mutate(duracao_horas = duracao / 60,
         duracao_horas = round(duracao_horas, 1), 
         .before = pais) |>
  View()


imdb |>
  mutate(duracao_horas = round(duracao / 60, 1),
         .before = pais) |>
  View()

# .before = antes de
# .after = depois de

imdb |>
  mutate(lucro = receita - orcamento, .after = receita) |>
  View()

# vários operações em 1 mutate
lucro_filmes <- imdb |>
  # removendo NAs das colunas orçamento e receita
  #drop_na(orcamento, receita) |>
 # selecionando colunas
  select(titulo, ano, receita, orcamento) |>
  mutate(
    # cria a coluna do lucro
    lucro = receita - orcamento,
    # verifica se o lucro é positivo
    lucrou = lucro > 0
  ) |>
  arrange(lucro)


lucro_filmes |> 
  count(lucrou)


# A função ifelse é uma ótima ferramenta
# para fazermos classificação binária (2 CATEGORIAS)

# if else
# SE A CONDICAO FOR VERDADEIRA, FACA TAL COISA,
# SE NAO, FACA OUTRA COISA

imdb |>
  select(titulo, ano, receita, orcamento) |> 
  drop_na(receita, orcamento) |> 
  mutate(
    lucro = receita - orcamento,
    houve_lucro = if_else(lucro > 0, "Sim", "Não")
  ) |>
  View()

imdb |> 
  select(titulo, ano, duracao) |> 
  mutate(
    duracao_horas = duracao/60,
    duracao_classe = case_when(
      duracao_horas >= 3 ~ "Longo",
      duracao_horas < 1.5 ~ "Curto",
      duracao_horas >= 1.5 & duracao_horas < 3 ~ "Comum"
     # .default = "Comum"
    )
  )


nota_categorizada <- imdb |>
  select(titulo, nota_imdb) |>
  mutate(
    categoria_nota = case_when(
      # quando essa condicao for verdadeira ~ salve esse valor,
      nota_imdb >= 8 ~ "Alta",
      nota_imdb >= 5 & nota_imdb < 8 ~ "Média",
      nota_imdb < 5 ~ "Baixa",
      .default = "Outros"
      #  TRUE ~ "CATEGORIZAR" # Em alguns lugares aparece assim
    )
  )



nota_categorizada |>
  count(categoria_nota)

# classificacao com mais de 2 categorias:
# usar a função case_when()

imdb |>
  mutate(
    categoria_nota = case_when(
      nota_imdb >= 8 ~ "Alta",
      nota_imdb < 8 & nota_imdb >= 5 ~ "Média",
      nota_imdb < 5 ~ "Baixa",
      TRUE ~ "Não classificado"
    )
  ) |>
  View()

# case_match

imdb |> 
  mutate(
    epoca_filmes = case_match(ano,
                              c(2010:2024) ~ "Muito recente",
                              c(2000:2009) ~ "década passada",
                              c(1900:1999) ~ "século passado", 
                              .default = "CATEGORIZAR")
  ) |> View()


# Jeferson: podemos usar mais que uma coluna no case_when?
imdb |> 
  mutate(
    potencial_filme_para_ver = case_when(
      str_detect(direcao, "Christopher Nolan") ~ "Direçao do Nolan",
      str_detect(producao, "Disney") ~ "Filmes da Disney",
      nota_imdb > 8 & num_avaliacoes > 10000 ~ "Nota boa"
    )
  ) |> 
  View()


# Aula 6 ----------
# Função interessante para lidar com as datas!

library(tidyverse)

imdb <- read_rds("dados/imdb.rds")

imdb_data <- imdb |> 
  mutate(
    data_lancamento_date = as.Date(data_lancamento),
         # Dúvida Rubens
         mes_ano_lancamento = floor_date(data_lancamento_date, "month"),
         .after = data_lancamento)

glimpse(imdb_data)  





# summarise ---------------------------------------------------------------


# summarise(base_de_dados,
# nome_coluna_criar = operacao_que_quer_fazer,
# ...
# )

# funcao que sumariza - é bom para summarise
min(imdb$nota_imdb)

max(imdb$nota_imdb)

mean(imdb$nota_imdb)

median(imdb$nota_imdb)

sd(imdb$nota_imdb)

var(imdb$nota_imdb)

# não sumariza - bom para mutate
round(imdb$nota_imdb)

# Sumarizando uma coluna

imdb |>
  summarise(media_orcamento = mean(orcamento, na.rm = TRUE),
            min_orcamento = min(orcamento, na.rm = TRUE),
            max_orcamento = max(orcamento, na.rm = TRUE))

# repare que a saída ainda é uma tibble


# Sumarizando várias colunas
imdb |> summarise(
  media_orcamento = mean(orcamento, na.rm = TRUE),
  media_receita = mean(receita, na.rm = TRUE),
  media_lucro = mean(receita - orcamento, na.rm = TRUE)
)

# Diversas sumarizações da mesma coluna
imdb |> summarise(
  media_orcamento = mean(orcamento, na.rm = TRUE),
  mediana_orcamento = median(orcamento, na.rm = TRUE),
  variancia_orcamento = var(orcamento, na.rm = TRUE),
  variancia_orcamento = var(orcamento, na.rm = TRUE),
  desvio_padrao_orcamento = sd(orcamento, na.rm = TRUE)
)

# Tabela descritiva
imdb |>
  summarise(
    media_orcamento = mean(orcamento, na.rm = TRUE),
    media_receita = mean(receita, na.rm = TRUE),
    qtd = n(),
    # Função n() retorna o número de linhas!
    
    # funcão n_distinct() retorna o número de valores distintos
    qtd_direcao = n_distinct(direcao)
  )

# n(imdb) não funciona fora do contexto do dplyr! 
nrow(imdb) # fora do contexto do dplyr, do R base

# como fazer o n_distinct com R base?
length(unique(imdb$direcao))

# n_distinct() é similar à:
imdb |>
  distinct(direcao) |>
  nrow()


# funcoes que transformam -> N valores; melhor para usar no mutate!
log(1:10)
sqrt(1:10)
str_detect(imdb$generos[1:10], "Comedy")

# funcoes que sumarizam -> 1 valor - FUNÇÕES BOAS PARA SUMMARISE
mean(c(1, NA, 2))
mean(c(1, NA, 2), na.rm = TRUE)
n_distinct()

nome_irmaos <- c("Beatriz", "Andressa", "Vitor", "Daniel", "Gabriel")

knitr::combine_words(nome_irmaos, and = " e ", oxford_comma = FALSE)



# group_by + summarise ----------------------------------------------------

# Agrupando a base por uma variável.

imdb |> group_by(producao)


imdb |>
  group_by(direcao) |> 
  summarise(
    media_orcamento = mean(orcamento, na.rm = TRUE),
    media_receita = mean(receita, na.rm = TRUE),
    qtd = n(),
    qtd_direcao = n_distinct(direcao)
  ) |> 
  arrange(desc(qtd))


# Rubens Marinho
# 19:34
# Tem como usar o group_by com mutate, pra criar uma variável com o ID de cada grupo?
# Um número que identifica cada grupo

imdb |> 
  group_by(direcao) |> 
  mutate() # Pensar ---


imdb |> 
  mutate(direcao_fator = as.numeric(as.factor(direcao))) |> 
  distinct(direcao, direcao_fator) |> View()


# Pesquisar: função para desidentificar?



# Agrupando e sumarizando ------
imdb |>
  group_by(producao) |>
  summarise(
    media_orcamento = mean(orcamento, na.rm = TRUE),
    media_receita = mean(receita, na.rm = TRUE),
    qtd = n(),
    qtd_direcao = n_distinct(direcao)
  ) |>
  arrange(desc(qtd))

# Agrupando e sumarizando
imdb |>
  group_by(direcao) |>
  summarise(
    media_orcamento = mean(orcamento, na.rm = TRUE),
    media_receita = mean(receita, na.rm = TRUE),
    media_nota = mean(nota_imdb),
    qtd = n(),
    # paste é uma função mais simples, comarada com o combine words
    nome_filmes = paste(titulo, collapse = "; "),
  ) |>
  arrange(desc(qtd)) |> View()

paste(nome_irmaos, collapse = ", ")

paste0(nome_irmaos, collapse = "; ")

imdb |>
  separate_longer_delim(direcao, delim = ", ", ) |>
  group_by(direcao) |>
  summarise(
    media_orcamento = mean(orcamento, na.rm = TRUE),
    media_receita = mean(receita, na.rm = TRUE),
    media_nota = mean(nota_imdb),
    qtd = n(),
    nome_filmes = paste(titulo, collapse = "; "), # knitr::combine_words()
  ) |>
  arrange(desc(qtd)) |>
  View()

paste("x", "y") # cola valores com espaço

paste0("x", "y") # sem espaço

# Fazer uma tabela de resumo dos gêneros dos filmes

imdb |> 
  count(generos, sort = TRUE) 
# 874 combinações de GÊNEROS
# e não gêneros únicos

imdb_generos <- imdb |> 
  # separate - separar valores nas colunas
  # delim - vamos usar um delimitador (ex: vírgula)
  # longer - os valores serão empilhados na mesma coluna, logo,
  # a tabela terá mais linhas e ficará mais LONGA
  separate_longer_delim(cols = generos, delim = ", ")


glimpse(imdb_generos)

imdb_generos |> 
  count(generos, sort = TRUE)

imdb_generos |> 
  group_by(generos) |> 
  summarise(
    nota_media = mean(nota_imdb),
    nota_mediana = median(nota_imdb),
    quantidade = n(),
    media_lucro = mean(receita - orcamento, na.rm = TRUE)
  ) |> 
  filter(quantidade != 1) |> 
  arrange(desc(media_lucro))


# left join ---------------------------------------------------------------

# tem mais que uma tabela

# queremos unir em tabela única

# coluna chave serve pra unir as tabelas

# dados do pacote abjData
# install.packages("abjData")
library(abjData)

abjData::pnud_uf

library(tidyverse)
dados_pnud <- pnud_min

# install.packages("geobr")
library(geobr)

list_geobr() |> View()
?read_municipality

shape <- read_municipality("SP", year = 2022)
glimpse(shape)

shape_prep <- shape |> 
  mutate(code_muni = as.character(code_muni))


pnud_shape <- shape_prep |> 
  left_join(dados_pnud, by = c("code_muni" = "muni_id"))


pnud_shape |> 
  filter(ano == 2010) |> 
  ggplot() + 
  geom_sf(aes(fill = espvida)) +
  facet_wrap(vars(ano)) +
  theme_void() +
  scale_fill_viridis_c() +
  labs(title = "Esperança de vida",
       fill = "Esperança de vida",
       caption = "Fonte: Dados do Censo IBGE, obtidos no pacote abjData")


# INTERVALO ----


dados_pnud_2010 <- dados_pnud |>
  filter(ano == 2010) |>
  mutate(
    code_muni = muni_id,
    abbrev_state = uf_sigla
  )

# queremos fazer uma base que tenha os dados do shape
# junto com dados do pnud

shape_ce_pnud <- shape |>
  mutate(code_muni = as.character(code_muni)) |>
  left_join(dados_pnud_2010, by = c("code_muni", "abbrev_state"))


shape_ce_pnud |>
  ggplot() +
  geom_sf(aes(fill = idhm))


# A função left join serve para juntarmos duas
# tabelas a partir de uma chave.
# Vamos ver um exemplo bem simples.

band_members 
band_instruments

band_members |>
  left_join(band_instruments)

# # A tibble: 3 × 2
#   name  band    plays
#   <chr> <chr>  
# 1 Mick  Stones    NA
# 2 John  Beatles.  guitar
# 3 Paul  Beatles   bass



band_instruments |>
  left_join(band_members, by = "name")

# # A tibble: 3 × 2
#   name  plays   band
#   <chr> <chr> 
# 1 John  guitar. Beatles
# 2 Paul  bass    Beatles
# 3 Keith guitar  NA 

# name | plays | band

# A ordem do left_join() importa!


# o argumento 'by'
band_members |>
  left_join(band_instruments, by = "name")


instruments2 <- band_instruments |> 
  add_row(
    name = "Paul", 
    plays = "drums"
  )

band_members |> 
  left_join(instruments2)

band_members |> 
  left_join(instruments2, relationship = "one-to-one")

# ?left_join() - argumento relationship
# relationship	
# Handling of the expected relationship between the keys of x and y. If the expectations chosen from the list below are invalidated, an error is thrown.
# 
# NULL, the default, doesn't expect there to be any relationship between x and y. However, for equality joins it will check for a many-to-many relationship (which is typically unexpected) and will warn if one occurs, encouraging you to either take a closer look at your inputs or make this relationship explicit by specifying "many-to-many".
# 
# See the Many-to-many relationships section for more details.
# 
# "one-to-one" expects:
# 
# Each row in x matches at most 1 row in y.
# 
# Each row in y matches at most 1 row in x.
# 
# "one-to-many" expects:
# 
# Each row in y matches at most 1 row in x.
# 
# "many-to-one" expects:
# 
# Each row in x matches at most 1 row in y.
# 
# "many-to-many" doesn't perform any relationship checks, but is provided to allow you to be explicit about this relationship if you know it exists.
# 
# relationship doesn't handle cases where there are zero matches. For that, see unmatched.



# OBS: existe uma família de joins ----------------------

band_instruments |>
  left_join(band_members)

band_instruments |>
  full_join(band_members) # mantem todos os dados das duas tabelas


# A tibble: 3 × 2
#   name  plays  band
#   <chr> <chr>  
# 1 John  guitar. Beatles
# 2 Paul  bass    Beatles
# 3 Keith guitar  NA
# 4 Mick  NA      Stones








band_instruments |>
  inner_join(band_members) # só vai aparecer o que tem em comum

# A tibble: 3 × 2
#   name  plays  band
#   <chr> <chr> 
# 1 John  guitar  Beatles
# 2 Paul  bass    Beatles





band_instruments |> 
  anti_join(band_members) # só vai aparecer o que NÃO tem em comum

# A tibble: 3 × 2
#   name  plays 
#   <chr> <chr> 
# 3 Keith guitar


# possiveis problemas ====
# nome de coluna diferente - renomear ou usar o by
# classe de coluna diferente - arrumar no mutate
# valores de chave que não estão iguais (ex: "são paulo" e "SÃO PAULO")

instruments_3 <- band_instruments |> 
  add_row(name = "MICK", plays = "drums")
  
band_members |> 
  full_join(instruments_3)


band_instruments |>
  right_join(band_members) # sao poucos casos onde é util!


# # A tibble: 3 × 2
#   name  band      plays
#   <chr> <chr>  
# 1 Mick  Stones      NA
# 2 John  Beatles.  Guitar
# 3 Paul  Beatles.   bass


# eu acho mais fácil usar o left join!
band_members |> 
  left_join(band_instruments)



# Um exemplo usando a outra base do imdb ----------

imdb <- read_rds("dados/imdb.rds")
imdb_avaliacoes <- read_rds("dados/imdb_avaliacoes.rds")

imdb |>
  left_join(imdb_avaliacoes, by = "id_filme") |>
  View()

imdb |>
  full_join(imdb_avaliacoes, by = "id_filme") |>
  View()
