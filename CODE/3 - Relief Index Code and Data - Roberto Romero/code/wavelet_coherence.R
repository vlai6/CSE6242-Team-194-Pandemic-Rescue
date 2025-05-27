library(biwavelet)
# Import your data


tech = read.csv("C:/Users/RobertoArturoRomoRiv/Downloads/sub_tech_sector_sp_model_data (covid).csv")
econ = read.csv("C:/Users/RobertoArturoRomoRiv/Downloads/econ_sector_sp_model_data (covid).csv")
health = read.csv("C:/Users/RobertoArturoRomoRiv/Downloads/health_sector_sp_model_data (covid).csv")



a <- health
attach(a)


t1 = cbind(1:nrow(a), communication)
t2 = cbind(1:nrow(a), health_relief_index)
t1_interpolated <- approx(t1[,1], t1[,2], n = nrow(a))
t2_interpolated <- approx(t2[,1], t2[,2], n = nrow(a))
t1_new <- cbind(1:nrow(a), t1_interpolated$y)
t2_new <- cbind(1:nrow(a), t2_interpolated$y)
t1_diff <- diff(t1_new[, 2])
t2_diff <- diff(t2_new[, 2])
wtc.AB <- wtc(cbind(1:(length(t1_diff)), t1_diff), cbind(1:(length(t2_diff)), t2_diff), nrands = 20)




par(oma = c(0, 0, 0, 1), mar = c(5, 4, 5, 5) + 0.1)
plot(wtc.AB, plot.phase = TRUE, lty.coi = 1, col.coi = "grey", lwd.coi = 2, 
     lwd.sig = 2, arrow.lwd = 0.03, arrow.len = 0.12, ylab = "Scale", xlab = "Period", 
     plot.cb = TRUE, main = "Wavelet Coherence Communication Sector vs Health Relief Index")

# Adding grid lines
n = length(t1_new[, 1])  # Assuming t1_new is the time series data for A
abline(v = seq(260, n, 260), h = 1:16, col = "brown", lty = 1, lwd = 1)

# Defining x labels
axis(side = 3, at = c(seq(0, n, 260)), labels = c(seq(1999, 2015, 1)))


plot(wtc.AB, lty.coi = 1, col.coi = "grey", lwd.coi = 2, 
     lwd.sig = 2, arrow.lwd = 0.03, arrow.len = 0.12, ylab = "Scale", xlab = "Period", 
     main = "Wavelet Coherence Communication Sector vs Economic Relief Index")
