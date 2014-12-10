INMET_DATA_ORDER
                 #Rafael Tieppo
                 #tiepporc@unemat.br
                 #10-12-2014
#Orientações para uso da função:
# 1. Essa função ordena os dados climáticos oriundos do INMET.
# 2. Os dados devem estar na seguinte ordem para a função executar corretamente:
    # Estacao;Data;Hora;Precipitacao;TempMaxima;TempMinima;
    # Insolacao;Umidade Relativa Media;Velocidade do Vento Media;
# 3. Todos as dados supracitados devem constar no arquivo.
# 4. Após inserir (criar objeto) a função no ambiente R, basta executar
    # a função conforme exemplo:
# 5. Exemplo

#PASSO 1 - Para ler dados do GITHUB (local dos dados do exemplo)
library(RCurl)
#1.1
EXAMPLE <-  getURL("https://raw.githubusercontent.com/rafatieppo/INMET_DATA_ORDER/master/INMET_DATA_EXAMPLE.csv")
#1.2
EXAMPLE_DATA <- read.csv(text = EXAMPLE, sep=";")
#1.3 verifique seus dados
edit(EXAMPLE_DATA)
 
#obs: provavelvelmente seus dados estarão no seu computador, dessa forma
      #basta usar a função "read.csv("caminho do arquivo, sep=";)"
        
#PASSO 2
#2.1 execute a função
EXAMPLE_ONELINE <- one_line(EXAMPLE_DATA)
#2.2 verifique seus dados agora
edit(EXAMPLE_ONELINE)

#PASSO 3
#3.1 Se necessário exporte seus dados
write.table(EXAMPLE_ONELINE, "EXAMPLE_DONE.csv", sep=";", col.names = TRUE, row.names = FALSE)
