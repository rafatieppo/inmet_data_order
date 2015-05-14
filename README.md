# Orientações para uso da função:
1. Essa função ordena os dados climáticos oriundos do INMET.
2. Os dados devem estar na seguinte ordem para a função executar corretamente:
 
`Estacao; Data; Hora; Precipitacao; TempMaxima; TempMinima; Insolacao; Umidade Relativa Media; Velocidade do Vento Media;`

3. Todos as dados supracitados devem constar no arquivo.

4. Após inserir (criar objeto) a função no ambiente R, basta executar a função conforme exemplo:

# Exemplo

## PASSO 1 - Para ler dados do GITHUB (local dos dados do exemplo)
library(RCurl)

`EXAMPLE <-  getURL("https://raw.githubusercontent.com/rafatieppo/INMET_DATA_ORDER/master/INMET_DATA_EXAMPLE.csv")`

`EXAMPLE_DATA <- read.csv(text = EXAMPLE, sep=";")`

### Verifique seus dados

`edit(EXAMPLE_DATA)`
 
obs: provavelvelmente seus dados estarão no seu computador, dessa forma basta usar a função

`"read.csv ("caminho do arquivo, sep=(";")`

## PASSO 2
execute a função

`EXAMPLE_ONELINE <- one_line(EXAMPLE_DATA)`

### Verifique seus dados agora

`edit(EXAMPLE_ONELINE)`

## PASSO 3

Se necessário exporte seus dados

`write.table(EXAMPLE_ONELINE, "EXAMPLE_DONE.csv", sep=";", col.names = TRUE, row.names = FALSE)`

Acesse
[Filtrar dados INMET](https://sistemasagricolas.wordpress.com/2014/12/11/ordenar-dados-inmet/) para acessar um exemplo.

Obrigado.
