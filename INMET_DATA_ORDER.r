#=================================================================
                                             #Rafael Tieppo
                                             #tiepporc@unemat.br
                                             #10-12-2014
#=================================================================
#Orientações para uso da função:
# 1. Essa função ordena os dados climáticos oriundos do INMET.
# 2. Os dados devem estar na seguinte ordem para a função executar corretamente:
    # Estacao;Data;Hora;Precipitacao;TempMaxima;TempMinima;
    # Insolacao;Umidade Relativa Media;Velocidade do Vento Media;
# 3. Todos as dados supracitados devem constar no arquivo.
# 4. Após inserir (criar objeto) a função (o código está mais abaixo) no ambiente R, basta executar
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
#============================================================


#INÍCIO DA FUNÇÃO
one_line <- function (DAT)
{

TIME_INI <- proc.time()


NUM_ROW <- nrow(DAT)
NUM_COL <- ncol(DAT)

#DATE
DATE_COUNT <- 0
FIRST_DAY <- as.Date(DAT[1,2], format("%d/%m/%Y") )
#_____

ICOUNT <- 0
COUNT_R <- 1

MATRIX_BASE <- matrix (0,NUM_ROW, NUM_COL) 

#Temp_min MAtrix with min temperatures without NA cells
TEMP_MIN_NA_FRAME <- data.frame(STAT = DAT[,1], DAY = as.character(DAT[,2], format("%d/%m/%Y") ), T_F = is.na(DAT[,6]) + 1, T_MIN = DAT[,6] )
TEMP_MIN_NA_FRAME <- subset(TEMP_MIN_NA_FRAME, T_F == 1)

#Temp_max MAtrix with max temperatures without NA cells
TEMP_MAX_NA_FRAME <- data.frame(STAT = DAT[,1], DAY = as.character(DAT[,2], format("%d/%m/%Y") ), T_F = is.na(DAT[,5]) + 1, T_MAX = DAT[,5] )
TEMP_MAX_NA_FRAME <- subset(TEMP_MAX_NA_FRAME, T_F == 1)

#Insol MAtrix with insol without NA cells
INSOL_NA_FRAME <- data.frame(STAT = DAT[,1], DAY = as.character(DAT[,2], format("%d/%m/%Y") ), T_F = is.na(DAT[,7]) + 1, T_MAX = DAT[,7] )
INSOL_NA_FRAME <- subset(INSOL_NA_FRAME, T_F == 1)

#UR MAtrix with UR  without NA cells
UR_NA_FRAME <- data.frame(STAT = DAT[,1], DAY = as.character(DAT[,2], format("%d/%m/%Y") ), T_F = is.na(DAT[,8]) + 1, T_MAX = DAT[,8] )
UR_NA_FRAME <- subset(UR_NA_FRAME, T_F == 1)

#UR MAtrix with PRECIP  without NA cells
PRECI_NA_FRAME <- data.frame(STAT = DAT[,1], DAY = as.character(DAT[,2], format("%d/%m/%Y") ), T_F = is.na(DAT[,4]) + 1, T_MAX = DAT[,4] )
PRECI_NA_FRAME <- subset(PRECI_NA_FRAME, T_F == 1)

#WIND SPEED MAtrix with WIND_SPEED  without NA cells
WIND_SPEED_NA_FRAME <- data.frame(STAT = DAT[,1], DAY = as.character(DAT[,2], format("%d/%m/%Y") ), T_F = is.na(DAT[,9]) + 1, T_MAX = DAT[,9] )
WIND_SPEED_NA_FRAME <- subset(WIND_SPEED_NA_FRAME, T_F == 1)




#Create MATRIX_BASE WITH ALL DATE and SUBSET until the LAST DATE

for (COUNT in 1:NUM_ROW )
	{
		#Station 
		STATION <- DAT[1, 1] 
		MATRIX_BASE[COUNT_R, 1] <- STATION
		
		#Date
		MATRIX_BASE[COUNT_R, 2] <- as.character( (FIRST_DAY + DATE_COUNT ) , "%d/%m/%Y" )#Data
		
		#Date COrta
		MATRIX_BASE[COUNT_R, 3] <- as.numeric(as.Date(FIRST_DAY + DATE_COUNT, "%d/%m/%Y"))#Data
		DATE_COUNT <- DATE_COUNT + 1
		
		COUNT_R <- COUNT_R + 1
		#ICOUNT <- ICOUNT + 2
		
	}

FRAME_BASE <- data.frame(STATION = as.numeric(MATRIX_BASE[,1]), DATE = as.character(MATRIX_BASE[,2]), DATE_CORTA = as.numeric(MATRIX_BASE[,3]), TEMP_MIN = rep(0,nrow(MATRIX_BASE)), TEMP_MAX = rep(0,nrow(MATRIX_BASE)), INSOL = rep(0,nrow(MATRIX_BASE)), UR = rep(0,nrow(MATRIX_BASE)), PRECI = rep(0,nrow(MATRIX_BASE)), WIND_SPEED = rep(0,nrow(MATRIX_BASE)) )	


LAST_LINE_DAT <- nrow(DAT)
LAST_DATA <-  (as.Date (DAT[LAST_LINE_DAT,2], "%d/%m/%Y"))
LAST_DATA <-  as.numeric(LAST_DATA)

#FRAME_BASE is a data frame  with all dates from DAT
FRAME_BASE <- subset (FRAME_BASE, DATE_CORTA <= LAST_DATA)
#_____________________________________________________________________________	
	
COUNT_R <- 1

	
for (COUNT in 1:(nrow(FRAME_BASE))) #(nrow(FRAME_BASE))
	{	
	
	SEARCH <- as.character(FRAME_BASE[COUNT_R,"DATE"], "%d/%m/%Y" )
	TESTA_NA <-  FALSE		
	
	##as.character(PONTAPORA_ONELINE$DAY, "%d/%m/%Y") ==  as.character( as.Date("01/10/2013", "%d/%m/%Y"), "%d/%m/%Y")
			
			#Temp Min
			TEMP_MIN_NA_FRAME_TF <- ( as.character( as.Date(SEARCH, "%d/%m/%Y"), "%d/%m/%Y") == as.character(TEMP_MIN_NA_FRAME[, "DAY"], "%d/%m/%Y"))
			
			TEMP_MIN_NA_FRAME_FILT <- data.frame(TEMP_MIN_NA_FRAME, T_MIN_TF = TEMP_MIN_NA_FRAME_TF)
			
			TEMP_MIN_NA_FRAME_FILT <- subset(TEMP_MIN_NA_FRAME_FILT, T_MIN_TF == 1)
			
			FRAME_BASE[COUNT_R, "TEMP_MIN"]  <- TEMP_MIN_NA_FRAME_FILT[1, "T_MIN"]
			#_______________________________
			
    		#Temp Max
			TEMP_MAX_NA_FRAME_TF <- ( as.character( as.Date(SEARCH, "%d/%m/%Y"), "%d/%m/%Y") == as.character(TEMP_MAX_NA_FRAME[, "DAY"], "%d/%m/%Y"))
			
			TEMP_MAX_NA_FRAME_FILT <- data.frame(TEMP_MAX_NA_FRAME, T_MAX_TF = TEMP_MAX_NA_FRAME_TF)
			
			TEMP_MAX_NA_FRAME_FILT <- subset(TEMP_MAX_NA_FRAME_FILT, T_MAX_TF == 1)
			
			FRAME_BASE[COUNT_R, "TEMP_MAX"]  <- TEMP_MAX_NA_FRAME_FILT[1, "T_MAX"]
			#_______________________________
			
			#Insol
			INSOL_NA_FRAME_TF <- ( as.character( as.Date(SEARCH, "%d/%m/%Y"), "%d/%m/%Y") == as.character(INSOL_NA_FRAME[, "DAY"], "%d/%m/%Y"))
			
			INSOL_NA_FRAME_FILT <- data.frame(INSOL_NA_FRAME, T_MAX_TF = INSOL_NA_FRAME_TF)
			
			INSOL_NA_FRAME_FILT <- subset(INSOL_NA_FRAME_FILT, T_MAX_TF == 1)
			
			FRAME_BASE[COUNT_R, "INSOL"]  <- INSOL_NA_FRAME_FILT[1, "T_MAX"]
			#_______________________________
			
			#UR
			UR_NA_FRAME_TF <- ( as.character( as.Date(SEARCH, "%d/%m/%Y"), "%d/%m/%Y") == as.character(UR_NA_FRAME[, "DAY"], "%d/%m/%Y"))
			
			UR_NA_FRAME_FILT <- data.frame(UR_NA_FRAME, T_MAX_TF = UR_NA_FRAME_TF)
			
			UR_NA_FRAME_FILT <- subset(UR_NA_FRAME_FILT, T_MAX_TF == 1)
			
			FRAME_BASE[COUNT_R, "UR"]  <- UR_NA_FRAME_FILT[1, "T_MAX"]
			#_______________________________
			
			#PRECI
			PRECI_NA_FRAME_TF <- ( as.character( as.Date(SEARCH, "%d/%m/%Y"), "%d/%m/%Y") == as.character(PRECI_NA_FRAME[, "DAY"], "%d/%m/%Y"))
			
			PRECI_NA_FRAME_FILT <- data.frame(PRECI_NA_FRAME, T_MAX_TF = PRECI_NA_FRAME_TF)
			
			PRECI_NA_FRAME_FILT <- subset(PRECI_NA_FRAME_FILT, T_MAX_TF == 1)
			
			FRAME_BASE[COUNT_R, "PRECI"]  <- PRECI_NA_FRAME_FILT[1, "T_MAX"]
			#_______________________________
			
			#WIND SPEED
			WIND_SPEED_NA_FRAME_TF <- ( as.character( as.Date(SEARCH, "%d/%m/%Y"), "%d/%m/%Y") == as.character(WIND_SPEED_NA_FRAME[, "DAY"], "%d/%m/%Y"))
			
			WIND_SPEED_NA_FRAME_FILT <- data.frame(WIND_SPEED_NA_FRAME, T_MAX_TF = WIND_SPEED_NA_FRAME_TF)
			
			WIND_SPEED_NA_FRAME_FILT <- subset(WIND_SPEED_NA_FRAME_FILT, T_MAX_TF == 1)
			
			FRAME_BASE[COUNT_R, "WIND_SPEED"]  <- WIND_SPEED_NA_FRAME_FILT[1, "T_MAX"]
			#_______________________________
			
			
			
			
		
		
		#MATRIX_BASE[COUNT_R, 8] <- DAT[1 + ICOUNT, 9] #VEl vent
		
		COUNT_R <- COUNT_R + 1
		#ICOUNT <- ICOUNT + 1
	}
	
	
#	print(SEARCH)
#	print("ref")	
#print(as.character(TEMP_MIN_NA_FRAME[1, "DAY"], "%d/%m/%Y"))
		
#COUNT_R <- 1

TIME_END <- proc.time()

TIME_TOT <- TIME_END - TIME_INI

#print("length FRAME_BASE")
#print(nrow(FRAME_BASE))

#print("length TEMP_MIN_NA_FRAME")
#print(nrow(TEMP_MIN_NA_FRAME))

print("Total Time")
print (TIME_TOT)


 #print(TEMP_MAX_NA_FRAME)
 #return(TEMP_MIN_NA_FRAME_FILT)

return(FRAME_BASE)

}
#FIM DA FUNÇÃO




