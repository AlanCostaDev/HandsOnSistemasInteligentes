
#==================================== Pacotes utilizados ===================================

require(ggplot2)
require(caret)
require(dplyr)

#====================== ================ Dataset ==========================================

dataset <- "https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/master/csv/MASS/biopsy.csv"

download.file(url = dataset, destfile="biopsy.csv")

bio <- read.csv("biopsy.csv", sep = ',')

bio <- na.omit(bio)

View(bio)

#====================== Treinamento de modelo (Cross Validation) ===========================

train_Index <- createDataPartition(bio$V1, p = 0.75, list = FALSE)

train <- bio[train_Index,]

test <- bio[-train_Index,]

cat("Dimens�o do dataframe: ", dim(bio), "\n")

cat("Dimens�o do treinamento: ", dim(train), "\n")

cat("Dimens�o do teste: ", dim(test), "\n")

train_Control <- trainControl(method = "cv", number = 10)

lm <- lm(V1 ~ V2 + V3 + V4 + V5 + V6 + V7 + V8 + V9, data = bio)

prediction <- predict(lm, select(test, V1, V2, V3, V4, V5, V6, V7, V8, V9))

lm_prediction <- data.frame(pred = prediction, obs = test$V1)


#============================ Gr�fico de Previs�o x Observado =============================

ggplot(lm_prediction, aes(x = pred, y = obs)) + 
      geom_point(alpha = 0.5, position = position_jitter(width = 0.2)) + 
            geom_abline(colour = "blue") + ggtitle("Grafico de Previs�o x Observado")

#=================================== Valor do RMSE ==========================================

round(defaultSummary(lm_prediction), digits = 2)

cat("Valor do RMSE (primeiro numero): ", round(defaultSummary(lm_prediction), digits = 2)) 

