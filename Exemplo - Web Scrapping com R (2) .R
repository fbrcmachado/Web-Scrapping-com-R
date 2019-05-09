#Pacotes de Instalação
install.packages('selectr')
install.packages('xml2')
install.packages('rvest')
install.packages('jsonlite')

#Carregando Pacotes
library(xml2)
library(rvest)
library(stringr)
library(jsonlite)

#Capturando a página de teste
url <- 'https://www.amazon.in/dp/B07KLVNS4F/ref=dp_prsubs_3'
webpage <- read_html(url)

#Capturando o Título
title_html <- html_nodes(webpage, 'h1#title')
title <- html_text(title_html)
title <- str_replace_all(title, '[\r\n]' , '')
title <- str_trim(title)
head(title)

#Capturando o preço
price_html <- html_nodes(webpage, 'span#priceblock_ourprice')
price <- html_text(price_html)
head(price)
price <-str_replace_all(price, '[\r\n]' , '')
price <- str_trim(price)
head(price)

#Montando um data frame com os dados capturados
product_data <- data.frame(Title = title, Price = price)
str(product_data)

#Transformando em Json
json_data <- toJSON(product_data)
cat(json_data)
