#Exemplo Web Scrapping - Chance de Gol (do site http://material.curso-r.com/scrape/) 

#Bibliotecas utilizadas
library(tibble)
library(httr)
library(rvest)
library(dplyr)
library(ggplot2)

#Parte 1: acessando a página de um ano
ano <- 2019
cdg_url <- sprintf('http://www.chancedegol.com.br/br%02d.htm', ano - 2000)

cdg_html <- cdg_url %>%
  httr::GET() %>%
  httr::content('text', encoding = 'latin1') %>%
  xml2::read_html() %>%
  rvest::html_node('table')

#Parte 2: cores da tabela
cores <- cdg_html %>%
  html_nodes(xpath = '//font[@color="#FF0000"]') %>%
  html_text()

#Parte 3: nomes e estrutura da tabela
cdg_data <- cdg_html %>%
  html_table(header = TRUE) %>%
  setNames(c('dt_jogo', 'mandante', 'placar', 'visitante',
             'p_mandante', 'p_empate', 'p_visitante')) %>% 
  mutate(p_vitorioso = cores) %>% 
  as_tibble() %>% 
  mutate(result = 'OK')

#Parte 4: colocando dentro de uma função
cdg_ano <- function(ano) {
  cdg_url <- sprintf('http://www.chancedegol.com.br/br%02d.htm', ano - 2000)
  
  cdg_html <- cdg_url %>%
    GET() %>%
    content('text', encoding = 'latin1') %>%
    read_html() %>%
    html_node('table')
  
  cores <- cdg_html %>%
    html_nodes(xpath = '//font[@color="#FF0000"]') %>%
    html_text()
  
  cdg_data <- cdg_html %>%
    html_table(header = TRUE) %>%
    setNames(c('dt_jogo', 'mandante', 'placar', 'visitante',
               'p_mandante', 'p_empate', 'p_visitante')) %>% 
    mutate(p_vitorioso = cores) %>% 
    as_tibble() %>% 
    mutate(result = 'OK')
  
  cdg_data
}

#Parte 5: vetorizando anos
cdg_anos <- function(anos) {
  cdg_ano_safe <- failwith(tibble(result = 'erro'), cdg_ano)
  anos %>% 
    setNames(anos) %>% 
    purrr::map_df(cdg_ano_safe, .id = 'ano')
}

d_cdg <- cdg_anos(c(2018, 2019))






