#Importo il dataset all'interno dell'ambiente di lavoro R, inserendolo in un dataframe
library(readxl)
dataset <- read_excel("C:/Users/mario/Downloads/dataset.xlsx")
View(dataset)

listaNazioni <- c("Australia","Austria","Belgio","Bulgaria","Svizzera","Germania","Danimarca","Spagna","Finlandia","Francia","UK","Grecia","Croazia","Ungheria","Italia","Olanda","Norvegia","Polonia","Portogallo","Romania","Svezia")

#Per mostrare i valori per intero,senza notazione scientifica
options(scipen = 999)

#Per mostrare i valori ridotti, con notazione scientifica
options(scipen = 0)

#Trattandosi di numeri molto grandi, quest'istruzione permettere di aumentare il margine nel plot in modo da visualizzare correttamente tutti i valori
par(mar=c(5,6,4,1)+.1)

#così facendo inserisco nella variabile riga la prima riga del dataset
riga <- as.numeric(dataset[1,-1])

#Il parametro las = 1 viene utilizzato per porre i valori sull'asse delle Y in orizzontale per una corretta visualizzazione
plot(anni,riga, las = 1, main = "Popolazione Australia", ylab="", xlab = "Anno")

#utilizzato per inserire successivamente il valore ylabel e posizionarlo più a sinistra rispetto i valori per evitare l'overlap
mtext("Abitanti", side = 2, line = 5)

#Codice per salvare i grafici in pdf in una cartella specifica
percorso <- 'C:\\Users\\mario\\Desktop\\Statistica e analisi dei dati\\Immagini e grafici\\Serie Temporali//Serie1.pdf'
#CODICE PER GENERARE IL GRAFICO
dev.off()

generaTS <- function(posizione){
  percorso <- sprintf('C:\\Users\\mario\\Desktop\\Statistica e analisi dei dati\\Immagini e grafici\\Serie Temporali//Serie%s.pdf',posizione)
  pdf(file = percorso)
  rigaAttuale <- as.numeric(dataset[posizione,-1])
  mainString <- sprintf("Serie Temporale %s",listaNazioni[posizione]) 
  
  timeSeries <- ts(rigaAttuale, start = 2000, frequency = 1)
  par(mar=c(5,6,4,1)+.1)
  plot.ts(timeSeries, main = mainString, ylab = "", xlab= "", type = "o", las = 1, col = "blue", xaxt="n")
  axis(1, at = seq(2000, 2021, by = 1), las = 2)
  mtext("Popolazione", side = 2, line = 5)
  
  dev.off()
}
sapply(c(1:21),generaTS)

#Confronto serie temporale tra uk e norvegia
tsConfronto <- data.frame("1"=as.numeric(dataset[11,-1]),"2"=as.numeric(dataset[17,-1]))
plot.ts(tsConfronto, main = "Confronto tra Norvegia e UK", ylab = "", xlab= "", type = "o", col = "blue", xaxt = "n")
axis(1, at = c(1:22), labels = c(2000:2021),las = 2)

generateBarplot <- function(anno){
  percorso <- sprintf('C:\\Users\\mario\\Desktop\\Statistica e analisi dei dati\\Immagini e grafici\\Barplot//Barplot%s.pdf',anno)
  pdf(file = percorso)
  
  annoString <- as.character(anno)
  colonna <- dataset[[annoString]]
  mainString <- sprintf("Demografia del %s",anno)
  par(mar=c(6,6,4,1)+.1)
  barplot(colonna, main = mainString, las = 2, col = rainbow(21), names.arg = listaNazioni, yaxt="n")
  
  axis(2, at = c(0,5000000,10000000,20000000,30000000,40000000,50000000,60000000,70000000,80000000), labels = c(0,5000000,10000000,20000000,30000000,40000000,50000000,60000000,70000000,80000000), las = 2)
  abline(h = min(colonna), lty = 2, lwd = 3, col = "red")
  abline(h = max(colonna), lty = 2, lwd = 3, col = "red")
  
  dev.off()
}
sapply(c(2000:2021),generateBarplot)

#Scatterplot (i punti vengono rappresentati da delle linee)
plot(factor(listaNazioni), colonna2000, xlab = "", ylab = "", main = "Popolazione in funzione della nazione", las = 2)

#Scatterplot con i puntini
plot(1:length(listaNazioni), colonna2000, main = "Popolazione in funzione della nazione", xlab = "", ylab = "", pch = 16, las = 1, xaxt = "n")
# Aggiungi etichette sull'asse x
axis(1, at = 1:length(listaNazioni), labels = listaNazioni, las = 2)
axis(2, at = c(0,5000000,10000000,20000000,30000000,40000000,50000000,60000000,70000000,80000000), labels = c(0,5000000,10000000,20000000,30000000,40000000,50000000,60000000,70000000,80000000), las = 2)
#axis(2, at = colonna2000, labels = colonna2000, las = 2)
# Trova la posizione del valore minimo
posizione_minimo <- which.min(colonna2000)
valore_minimo <- colonna2000[posizione_minimo]
symbols(posizione_minimo, valore_minimo, circles = 1, inches = 0.1, add = TRUE, col = "red", lty = 2)

generaGraficiFrequenze <- function(anno){
  percorso <- sprintf('C:\\Users\\mario\\Desktop\\Statistica e analisi dei dati\\Immagini e grafici\\BarplotFrequenze//BarplotFrequenza%s.pdf',anno)
  pdf(file = percorso)
  definizioneRange = c(0,5000000,10000000,20000000,60000000,100000000)
  
  annoString <- as.character(anno)
  colonna <- dataset[[annoString]]
  frequenza_assoluta <- table(cut(colonna, breaks= definizioneRange))
  names(frequenza_assoluta) <- c("0-5M", "5M-10M", "10M-20M","20M-60M","60M-100M")
  
  mainString <- sprintf("Frequenza Assoluta anno %s",anno)
  barplot(frequenza_assoluta, ylab = "Frequenza Assoluta", xlab = "Classi di popolazione",main = mainString,col = rainbow(5))
  dev.off()
  
  percorso <- sprintf('C:\\Users\\mario\\Desktop\\Statistica e analisi dei dati\\Immagini e grafici\\Torta//Torta%s.pdf',anno)
  pdf(file = percorso)
  
  frequenza_relativa <- round(frequenza_assoluta / length(colonna) * 100, 2)
  names(frequenza_relativa) <- c("0-5M", "5M-10M", "10M-20M","20M-60M","60M-100M")
  par(mar=c(5,5,4,5)+.1)
  mainPie = sprintf("Frequenza relativa Anno %s",anno)
  perc <- round(frequenza_relativa)
  labelP <- c("0-5M", "5M-10M", "10M-20M","20M-60M","60M-100M")
  labelP <- paste(labelP, " ","(",perc,"%)", sep="")
  pie(frequenze_assolute, label = labelP, col = rainbow(5), main= mainPie)
  
  dev.off()
}
sapply(c(2000:2021),generaGraficiFrequenze)

#Calcola i quartili di un campione (in questo caso la colonna 2000)
quantile(colonna2000)
#Calcola minimo, massimo, media e mediana di un campione (in questo caso la colonna 2000)
summary(colonna2000)

generateBoxplot <- function(anno){
  percorso <- sprintf('C:\\Users\\mario\\Desktop\\Statistica e analisi dei dati\\Immagini e grafici\\Boxplot//Box%s.pdf',anno)
  pdf(file = percorso)
  
  annoString <- as.character(anno)
  colonna <- dataset[[annoString]]
  mainString = sprintf("BoxPlot anno %s",anno)
  par(mar=c(5,6,4,1)+.1)
  boxplot(colonna, main = mainString, xlab = "", col = "orange", las = 2, yaxt="n")
  axis(2, at=c(5000000,10000000,20000000,30000000,40000000,50000000,60000000,70000000,80000000), labels = c(5000000,10000000,20000000,30000000,40000000,50000000,60000000,70000000,80000000), las = 2)
  
  dev.off()
}
sapply(c(2000:2021),generateBoxplot)

#CONFRONTO TRA BOXPLOT
par(mar=c(5,6,4,1)+.1)
boxplot(colonna2000,dataset$'2021', main = "BoxPlot confronto Anni 2000 e 2021", names = c("Anno 2000", "Anno 2021"), col = c("orange", "green"), las = 1, yaxt="n")
axis(2, at=c(5000000,10000000,20000000,30000000,40000000,50000000,60000000,70000000,80000000), labels = c(5000000,10000000,20000000,30000000,40000000,50000000,60000000,70000000,80000000), las = 2)
boxplot(colonna2000,dataset$'2010', dataset$'2021', main = "BoxPlot confronto Anni 2000,2010 e 2021", names = c("Anno 2000", "Anno 2010", "Anno 2021"), col = c("orange", "green", "blue"), las = 1)

generaPareto <- function(anno){
  percorso <- sprintf('C:\\Users\\mario\\Desktop\\Statistica e analisi dei dati\\Immagini e grafici\\Pareto//Pareto%s.pdf',anno)
  pdf(file = percorso)
  
  annoString <- as.character(anno)
  colonna <- dataset[[annoString]]
  frequenza_assoluta <- table(cut(colonna, breaks= definizioneRange))
  frequenza_relativa <- round(frequenza_assoluta / length(colonna) * 100, 2)
  names(frequenza_relativa) <- c("0-5M", "5M-10M", "10M-20M","20M-60M","60M-100M")
  
  freqRelativaSort <- sort(frequenza_relativa, decreasing=TRUE)
  mainString = sprintf("Diagramma di Pareto anno %s",anno)
  
  barplot <- barplot(freqRelativaSort, ylim=c(0,105), main = mainString, col = rainbow(5), las = 1)
  lines(barplot, cumsum(freqRelativaSort), type = "b", pch=16)
  text(barplot - 0.3, cumsum(freqRelativaSort) + 3.2, paste(format(cumsum(freqRelativaSort),digits=2),"%"))
  dev.off()
}
sapply(c(2000:2021),generaPareto)

#Diagramma di pareto considerando le frequenze relative calcolate in precedenza
barplot <- barplot(freRelativeSort, ylim=c(0,105), main = "Diagramma di Pareto Anno 2000", col = rainbow(5), las = 1)
lines(barplot, cumsum(freRelativeSort), type = "b", pch=16)
text(barplot - 0.3, cumsum(freRelativeSort) + 3.2, paste(format(cumsum(freRelativeSort),digits=2),"%"))

generaEmpiriche <- function(anno){
  percorso <- sprintf('C:\\Users\\mario\\Desktop\\Statistica e analisi dei dati\\Immagini e grafici\\Empiriche//Empirica%s.pdf',anno)
  pdf(file = percorso)
  
  annoString <- as.character(anno)
  colonna <- dataset[[annoString]]
  mainString <- sprintf("Funzione di distribuzione empirica continua anno %s",anno)
    
  frequenzaCumulata <- cumsum(table(cut(colonna, breaks= definizioneRange))) / length(colonna)
  frequenzaCumulata <- c(0,frequenzaCumulata)
  names(frequenzaCumulata) <- c("0","0-5M", "5M-10M", "10M-20M","20M-60M","60M-100M")
  
  par(mar=c(6,6,4,1)+.1)
  plot(definizioneRange,frequenzaCumulata,type="b",main=mainString,ylab="",xlab="",axes=FALSE)
  text(c(0,5000000,10000000,20000000,60000000,100000000), labels = c("0","0-5M", "5M-10M", "10M-20M","20M-60M","60M-100M"), xpd = TRUE, adj=1,par("usr")[3] - 0.05, srt = 45)
  axis(1, at = c(0, 5000000, 10000000, 20000000, 60000000, 100000000), labels = FALSE)
  axis(2,format(frequenzaCumulata,digits=2),las=1)
  mtext("Frequenze cumulate", side = 2, line = 4)
  mtext("Intervalli di popolazione", side = 1, line = 4)
  box()
  
  dev.off()
  }
sapply(c(2000:2021),generaEmpiriche)

#Funzione per calcolare la skewness
skw <-function (x){
  n<-length (x)
  m2 <-(n -1)*var(x)/n
  m3 <- (sum( (x-mean(x))^3))/n
  m3/(m2 ^1.5)
}

#Funzione per calcolare la curtosi
curt <-function (x){
  n<-length (x)
  m2 <-(n-1)*var (x)/n
  m4 <- (sum( (x-mean(x))^4) )/n
  m4/(m2^2) -3
}

#Funzione per calcolare il Coefficiente di correlazione campionario
cor(colonna2000,dataset$'2021')

#Diagramma di Dispersione tra Popolazioni nel 2000 e 2021
par(mar=c(5,6,4,1)+.1)
plot(dataset$'2000', dataset$'2021', 
     xlab = "Popolazione nel 2000", ylab = "",
     main = "Diagramma di Dispersione tra Popolazioni nel 2000 e 2021",
     las = 1)

# Aggiunta di una retta di regressione lineare
abline(lm(dataset$'2021' ~ dataset$'2000'), col = "red")
mtext("Popolazione nel 2021", side = 2, line = 5)

#Calcolo di alpha e beta regressione lineare semplice
options(scipen=999)
beta <-(sd(colonna2000 )/sd(dataset$'2021'))*cor(dataset$'2021',colonna2000)
alpha <-mean(colonna2000)-beta*mean(dataset$'2021')
c(alpha ,beta)

#Calcolo dei valori stimati dalla retta di regressione
fitted(lm(colonna2000~dataset$'2021'))
#Funzione per visualizzare i residui
fitted(lm(colonna2000~dataset$'2021'))

#Diagramma dei residui
par(mar=c(5,6,4,2)+.1)
plot(fitted(lm(colonna2000~dataset$'2021')),resid(lm(colonna2000~dataset$'2021')), xlab = "Valori predetti", ylab = "Residui", main = "Diagramma dei Residui", las = 1)
abline(h = 0, col = "red")  # Aggiungi una linea orizzontale a 0 per aiutare a identificare i residui positivi e negativi

#Clustering gerarchico
distanceMatrix <- dist(dataset$'2021',method = "canberra")
tree <- hclust(distanceMatrix, method = "complete")
plot(tree,labels = listaNazioni,xlab="Metodo gerarchico agglomerativo legame completo", sub="relativo alla distanza di Canberra",main="Dendogramma clustering gerarchico", yaxt="n")
axis(2, at=seq(0.0,1.0,by=0.1),labels=seq(0,10,by=1))
axis(4,at=round(c(0,tree$height),2))
#Screeplot
plot(c(0,tree$height), seq(21,1), type="b", main="Screeplot", xlab="distanza di aggregazione", ylab="Numero di cluster", col="red",xaxt="n")
axis(1,at=seq(0.0,0.8,by=0.2),labels=seq(0,8,by=2))
#disegno il numero di cluster consigliati dallo screeplot sul dendogramma
rect.hclust(tree, k=3, border="red")

#Calcolo delle misure di non omogeneità statistiche
#Calcolo trH
X1 <- data.frame(dataset$'2021')
rownames(X1) <- listaNazioni
trH <- (nrow(X1)-1) * sum(apply(X1,2,var))
#Calcolo i trH per i singoli cluster
taglio <- cutree(tree, k=3, h=NULL)
numTaglio <- table(taglio)
taglioList <- list(taglio)
agvar <- aggregate(dataset$'2021', taglioList, var)[,-1]
trH1 <- (numTaglio[[1]]-1) * sum(agvar[1])
trH2 <- (numTaglio[[2]]-1) * sum(agvar[2])
trH3 <- (numTaglio[[3]]-1) * sum(agvar[3])
sumTrH <- trH1 + trH2 + trH3
trB <- trH - sumTrH
trB / trH

#Metodo del k-means
X1 <- data.frame(dataset$'2021')
rownames(X1) <- listaNazioni
km <- kmeans(X1, center=3, iter.max=10, nstart=1)
km$cluster
plot(X1, col= km$cluster, main="Metodo non gerarchico del K-means")

#Definisco il grafico per mostrare i cluster
kmeansData <- data.frame(Nazioni = listaNazioni, Abitanti = dataset$'2021', Cluster = km$cluster)
rownames(kmeansData) <- c(1:21)
kmeansData <- kmeansData[order(kmeansData$Abitanti),]
par(mar=c(5,6,4,1)+1)
options(scipen=999)
plotKMeans <- barplot(kmeansData$Abitanti, names.arg = kmeansData$Nazioni, col = kmeansData$Cluster,
        main = "Barplot dei cluster definiti dal metodo K-means",
        xlab = "", ylab = "", las = 2, ylim = c(0,88000000), yaxt="n")
axis(2, at=seq(0,80000000, by = 10000000), labels=seq(0,80000000, by = 10000000), las = 1)
mtext("Abitanti", side = 2, line = 5.3)
mtext("Nazioni", side = 1, line = 4.5)
text(plotKMeans, kmeansData$Abitanti + 2200000, label = kmeansData$Cluster)

#VARIABILI ALEATORIE
incrementi_decrementi = diff(as.numeric(dataset[15,-1]))
#inferiore a 400k
pnorm(400000, mean = mean(incrementi_decrementi), sd = sd(incrementi_decrementi))
#superiore a 400k
1 - pnorm(400000, mean = mean(incrementi_decrementi), sd = sd(incrementi_decrementi))

#plot con numeri casuali
# Creazione di dati casuali da una distribuzione normale
set.seed(123)  # Imposta il seme per la riproducibilità
dati_casuali <- rnorm(1000, mean = mean(incrementi_decrementi), sd = sd(incrementi_decrementi))
# Creazione di un grafico di densità
densità <- density(dati_casuali)
plot(densità, main = "Grafico di densità dei 1000 valori casuali", xlab = "Incrementi/Decrementi", ylab = "Densità")
indici <- densità$x <= 400000
polygon(c(densità$x[indici], rev(densità$x[indici])), c(densità$y[indici], rep(0, sum(indici))), col = "skyblue", border = NA)

#calcolo intervallo di confidenza
campnorm <- diff(as.numeric(dataset[6,-1]))
alpha <- 1-0.99
n <- length(campnorm)
IClower <- mean(campnorm) - qnorm(1-alpha/2,mean=0,sd=1)*sd(campnorm)/sqrt(n)
ICupper <- mean(campnorm) + qnorm(1-alpha/2,mean=0,sd=1)*sd(campnorm)/sqrt(n)

#Plot intervallo di confidenza
densityIC <- density(campnorm)
plot(densityIC, main="Density Plot Italia con Intervallo di Confidenza", xlab="Incrementi/decrementi")

indice1 <- densityIC$x < IClower
indice2 <- densityIC$x > ICupper

polygon(c(densityIC$x[indice1], rev(densityIC$x[indice1])), c(densityIC$y[indice1], rep(0, sum(indice1))),  col="red", border=NA, density=15,angle=0)
polygon(c(densityIC$x[indice2], rev(densityIC$x[indice2])), c(densityIC$y[indice2], rep(0, sum(indice2))), col="red", border=NA, density=15,angle=0)

#confronto tra popolazioni
campItalia <- diff(as.numeric(dataset[15,-1]))
campGermania <- diff(as.numeric(dataset[6,-1]))

alpha <- 1-0.99
nI <- length(campItalia)
nG <- length(campGermania)
mediaI<- mean(campItalia)
mediaG <- mean(campGermania)
sdI <- sd(campItalia)
sdG <- sd(campGermania)

mediaI-mediaG-qnorm(1-alpha/2,mean=0,sd=1) * sqrt(sdI*2/nI+sdG*2/nG)
mediaI-mediaG+qnorm(1-alpha/2,mean=0,sd=1) * sqrt(sdI*2/nI+sdG*2/nG)

#Test unilaterale destro italia
alpha <- 0.05
mu0 <- 350000
sigma <- 95490.46
n <- 21

qnorm(alpha,mean=0,sd=1)

meancamp <- 319614.3
z0 <- (meancamp - mu0) / (sigma / sqrt(n))
z0

pvalue <- pnorm(z0,mean=0,sd=1)
pvalue

#Criterio del chi-quadrato
uk <- diff(as.numeric(dataset[11,-1]))
n <- length(uk)
m <- mean(uk)
s <- sd(uk)

a <- numeric(4)
for(i in 1:4)
  a[i]<- qnorm(0.2*i, mean=m, sd=s)
a

r <- 5
nint <- numeric(r)
nint[1] <- length(which(uk<a[1]))
nint[2] <- length(which((uk >=a [1]) & (uk < a[2])))
nint[3] <- length(which((uk >= a[2]) & (uk < a[3])))
nint[4] <- length(which((uk >= a[3]) & (uk < a[4])))
nint[5] <- length(which(uk >= a[4]))
nint

chi2 <- sum(((nint - n *0.2)/sqrt(n*0.2))^2)
chi2

r <- 5
k <- 2
alpha <- 0.05
qchisq(alpha/2,df=r-k-1)
qchisq(1-alpha/2,df=r-k-1)