library(neuralnet)
library(zoo)

vaccine_test_relief = read.csv("C:/Users/RobertoArturoRomoRiv/Downloads/vaccine_test_stringency.csv")
economic_relief = read.csv("C:/Users/RobertoArturoRomoRiv/Downloads/economic_relief1.csv")
  #https://fred.stlouisfed.org/series/FEDFUNDS
  #https://fred.stlouisfed.org/series/CURRCIR
tec_relief = read.csv("C:/Users/RobertoArturoRomoRiv/Downloads/tec_relief.csv")

ecommerce_relief = read.csv("C:/Users/RobertoArturoRomoRiv/Downloads/ecommerce.csv")
remote_work_relief = read.csv("C:/Users/RobertoArturoRomoRiv/Downloads/remote_work.csv")
cloud_computing_relief = read.csv("C:/Users/RobertoArturoRomoRiv/Downloads/cloud_computing.csv")
telemedicine_relief = read.csv("C:/Users/RobertoArturoRomoRiv/Downloads/telemedicine.csv")
streaming_relief = read.csv("C:/Users/RobertoArturoRomoRiv/Downloads/streaming.csv")
fintech_dpmt_relief = read.csv("C:/Users/RobertoArturoRomoRiv/Downloads/fintech_dpmt.csv")
cyber_relief = read.csv("C:/Users/RobertoArturoRomoRiv/Downloads/cyber.csv")
edtech_relief = read.csv("C:/Users/RobertoArturoRomoRiv/Downloads/edtech.csv")
healthcare_relief = read.csv("C:/Users/RobertoArturoRomoRiv/Downloads/healthcare.csv")
robotics_automation_relief = read.csv("C:/Users/RobertoArturoRomoRiv/Downloads/robotics_automation.csv")

create_index <- function(data) {
  # Convert date column to Date type
  data$date <- as.Date(data$date)
  
  # Create an empty dataframe to store index values
  index_df <- data.frame(date = data$date)
  
  # Selecting only the numeric columns
  numeric_cols <- sapply(data, is.numeric)
  


    for (col in colnames(data[, numeric_cols])) {
      # Create lagged dataset for neural network training
      lagged_data <- cbind(data[[col]], lag(data[[col]], 1))
      colnames(lagged_data) <- c("current", "lagged")
      
      # Drop rows with NA values after lagging
      lagged_data <- na.omit(lagged_data)
      
      # Normalize data
      lagged_data <- scale(lagged_data)
      
      # Train neural network
      nn_model <- neuralnet(current ~ lagged, data = lagged_data, hidden = 5)
      
      # Predict next value
      pred_values <- predict(nn_model, newdata = lagged_data)
      
      # Trim the last prediction to match the length of the data
      pred_values <- pred_values[-nrow(pred_values)]
      
      # Add predicted values to index dataframe
      index_df[[col]] <- c(NA, pred_values)
    }
    # Calculate index as sum of predicted values
    index_df$index <- rowSums(index_df[, -1], na.rm = TRUE)
  
  
  return(index_df)
}

# Example usage:
# Assume 'df' is your dataframe with a date column and time series columns
# Replace 'method' parameter with any of the methods: "simple_sum", "percentage_change", "z_score", "neural_network"
# index <- create_index(df, method = "neural_network")


data1<-create_index(vaccine_test_relief)
data2<-create_index(economic_relief)
data3<-create_index(tec_relief)

data4<-create_index(ecommerce_relief)

matrix1<-as.matrix(data1[2:nrow(data1),2:5])
matrix2<-as.matrix(data2[2:nrow(data2),2:4])
matrix3<-as.matrix(data3[2:nrow(data3),2:30])

matrix4<-as.matrix(data4[2:nrow(data4),2:7])

vars1<-apply(matrix1, 2, var)
vars2<-apply(matrix2, 2, var)
vars3<-apply(matrix3, 2, var)

vars4<-apply(matrix4, 2, var)


apply(matrix1, 2, var)/sum(apply(matrix1, 2, var))
apply(matrix2, 2, var)/sum(apply(matrix2, 2, var))
apply(matrix3, 2, var)/sum(apply(matrix3, 2, var))

apply(matrix4, 2, var)/sum(apply(matrix4, 2, var))

pca1 <- prcomp(as.matrix(data1[2:nrow(data1),2:4]), retx=T)
pca2 <- prcomp(as.matrix(data2[2:nrow(data2),2:3]), retx=T)
pca3 <- prcomp(as.matrix(data3[2:nrow(data3),2:29]), retx=T)

pca4 <- prcomp(as.matrix(data4[2:nrow(data4),2:7]), retx=T)

mx_transformed1 <- pca1$x
mx_transformed2 <- pca2$x
mx_transformed3 <- pca3$x

mx_transformed4 <- pca4$x

apply(mx_transformed1, 2, var)/sum(apply(mx_transformed1, 2, var))
apply(mx_transformed2, 2, var)/sum(apply(mx_transformed2, 2, var))
apply(mx_transformed3, 2, var)/sum(apply(mx_transformed3, 2, var))

apply(mx_transformed4, 2, var)/sum(apply(mx_transformed4, 2, var))






#############
#############
#############

data5<-create_index(ecommerce_relief)
data6<-create_index(remote_work_relief)
data7<-create_index(cloud_computing_relief)
data8<-telemedicine_relief
data9<-create_index(streaming_relief)
data10<-create_index(fintech_dpmt_relief)
data11<-create_index(cyber_relief)
data12<-create_index(edtech_relief)
data13<-create_index(healthcare_relief)
data14<-create_index(robotics_automation_relief)


matrix5<-as.matrix(data5[3:nrow(data5),3:ncol(data5)])
matrix6<-as.matrix(data6[3:nrow(data6),3:ncol(data6)])
matrix7<-as.matrix(data7[3:nrow(data7),3:ncol(data7)])
matrix8<-as.matrix(data8[,2])
matrix9<-as.matrix(data9[3:nrow(data9),3:ncol(data9)])
matrix10<-as.matrix(data10[3:nrow(data10),3:ncol(data10)])
matrix11<-as.matrix(data11[3:nrow(data11),3:ncol(data11)])
matrix12<-as.matrix(data12[3:nrow(data12),3:ncol(data12)])
matrix13<-as.matrix(data13[3:nrow(data13),3:ncol(data13)])
matrix14<-as.matrix(data14[3:nrow(data14),3:ncol(data14)])

apply(matrix5, 2, var)/sum(apply(matrix5, 2, var))
apply(matrix6, 2, var)/sum(apply(matrix6, 2, var))
apply(matrix7, 2, var)/sum(apply(matrix7, 2, var))
apply(matrix8, 2, var)/sum(apply(matrix8, 2, var))
apply(matrix9, 2, var)/sum(apply(matrix9, 2, var))
apply(matrix10, 2, var)/sum(apply(matrix10, 2, var))
apply(matrix11, 2, var)/sum(apply(matrix11, 2, var))
apply(matrix12, 2, var)/sum(apply(matrix12, 2, var))
apply(matrix13, 2, var)/sum(apply(matrix13, 2, var))
apply(matrix14, 2, var)/sum(apply(matrix14, 2, var))


pca5 <- prcomp(as.matrix(data5[3:nrow(data5),3:ncol(data5)-1]), retx=T)
pca6 <- prcomp(as.matrix(data6[3:nrow(data6),3:ncol(data6)-1]), retx=T)
pca7 <- prcomp(as.matrix(data7[3:nrow(data7),3:ncol(data7)-1]), retx=T)
#pca8 <- prcomp(as.matrix(data5[3:nrow(data5),3:ncol(data5)-1]), retx=T)
pca9 <- prcomp(as.matrix(data9[3:nrow(data9),3:ncol(data9)-1]), retx=T)
pca10 <- prcomp(as.matrix(data10[3:nrow(data10),3:ncol(data10)-1]), retx=T)
pca11 <- prcomp(as.matrix(data11[3:nrow(data11),3:ncol(data11)-1]), retx=T)
pca12 <- prcomp(as.matrix(data12[3:nrow(data12),3:ncol(data12)-1]), retx=T)
pca13 <- prcomp(as.matrix(data13[3:nrow(data13),3:ncol(data13)-1]), retx=T)
pca14 <- prcomp(as.matrix(data14[3:nrow(data14),3:ncol(data14)-1]), retx=T)


mx_transformed5 <- pca5$x
mx_transformed6 <- pca6$x
mx_transformed7 <- pca7$x
#mx_transformed8 <- pca4$x
mx_transformed9 <- pca9$x
mx_transformed10 <- pca10$x
mx_transformed11 <- pca11$x
mx_transformed12 <- pca12$x
mx_transformed13 <- pca13$x
mx_transformed14 <- pca14$x

apply(mx_transformed5, 2, var)/sum(apply(mx_transformed5, 2, var))
apply(mx_transformed6, 2, var)/sum(apply(mx_transformed6, 2, var))
apply(mx_transformed7, 2, var)/sum(apply(mx_transformed7, 2, var))
#apply(mx_transformed4, 2, var)/sum(apply(mx_transformed4, 2, var))
apply(mx_transformed9, 2, var)/sum(apply(mx_transformed9, 2, var))
apply(mx_transformed10, 2, var)/sum(apply(mx_transformed10, 2, var))
apply(mx_transformed11, 2, var)/sum(apply(mx_transformed11, 2, var))
apply(mx_transformed12, 2, var)/sum(apply(mx_transformed12, 2, var))
apply(mx_transformed13, 2, var)/sum(apply(mx_transformed13, 2, var))
apply(mx_transformed14, 2, var)/sum(apply(mx_transformed14, 2, var))
