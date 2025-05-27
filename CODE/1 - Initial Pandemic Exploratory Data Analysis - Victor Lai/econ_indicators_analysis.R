#install.packages("tidyverse")
library(tidyverse)

#install.packages("lubridate")
library(lubridate)


# Exploratory analysis on economic indicators (SP500, Employment ratio, GDP) during pandemic periods.


##### LOAD SP500 DATA AS sp500_data #################################################
sp500_data <- read.csv("SPX_500_Data.csv")
sp500_update_data <- read.csv("HistoricalData_1711620498272.csv")

sp500_data$Date <- mdy(sp500_data$Date) 
sp500_update_data$Date <- mdy(sp500_update_data$Date)

names(sp500_update_data)[names(sp500_update_data) == "Close.Last"] <- "Close"

sp500_post_2021_data <- sp500_update_data %>%
  filter(Date >= as.Date("2021-1-1"))

full_sp500_data <- full_join(sp500_data, sp500_post_2021_data, by = "Date")
full_sp500_data <- full_sp500_data %>%
  mutate(Close = if_else(is.na(Close.x), Close.y, Close.x)) %>%
  select(Date, Close) %>%
  arrange(Date)
#just date and closing price of sp500

# start dates for each pandemic
pandemics <- tibble(
  pandemic = c("H2N2", "H3N2", "Russian Flu", "H1N1", "COVID"),
  start_date = mdy(c("6/1/1957", "9/1/1968", "1/1/1978", "4/1/2009", "1/1/2020"))
)

pandemic_sp500_data <- list()

for (i in 1:nrow(pandemics)) {
  temp_sp500_data <- full_sp500_data %>%
    filter(Date >= pandemics$start_date[i],
           Date < pandemics$start_date[i] + years(3)) # start to three years sp500_data used
  
  # set starting price to 0 to normalize sp500_data
  temp_sp500_data$Normalized_Close <- (temp_sp500_data$Close / first(temp_sp500_data$Close)) * 100
  temp_sp500_data$Days_Since_Pandemic_Start <- as.numeric(difftime(temp_sp500_data$Date, pandemics$start_date[i], units = "days"))
  
  temp_sp500_data$pandemic <- pandemics$pandemic[i]
  
  pandemic_sp500_data[[i]] <- temp_sp500_data
}


combined_sp500_data <- bind_rows(pandemic_sp500_data)

# NORMALIZED PLOT OF SP 500 #########################
ggplot(combined_sp500_data, aes(x = Days_Since_Pandemic_Start, y = Normalized_Close, color = pandemic)) +
  geom_line() +
  labs(title = "Normalized S&P 500 Performance from Pandemic Start (3 Year Period)",
       x = "Days Since Pandemic Start Date",
       y = "Normalized Close Price") +
  theme_minimal()


# Correlation Matrix for SP500 ##########################

spread_sp500_data <- combined_sp500_data %>%
  select(Days_Since_Pandemic_Start, pandemic, Normalized_Close) %>%
  spread(key = pandemic, value = Normalized_Close)

spread_sp500_data <- na.omit(spread_sp500_data)

correlation_matrix <- cor(spread_sp500_data[,-1]) # remove days since pandemic start column
print(correlation_matrix)

# Heatmap

correlation_sp500_data <- as.data.frame(as.table(correlation_matrix))

ggplot(correlation_sp500_data, aes(Var1, Var2, fill = Freq)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0, limit = c(-1,1), space = "Lab", name="Pearson\nCorrelation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = '', y = '', title = 'Correlation Heatmap of S&P 500 Performance During Pandemics', subtitle = 'Comparing the first 3 years since the start of each pandemic') +
  coord_fixed()

################################################################################
# EMPLOYMENT RATE ANALYSIS

# Employment Ratio data
employment_data <- read.csv("EMRATIO.csv")

employment_data$DATE <- mdy(employment_data$DATE)  # mdy for month date year

pandemic_emratio_data <- list()

for (i in 1:nrow(pandemics)) {
  temp_emratio_data <- employment_data %>%
    filter(DATE >= pandemics$start_date[i],
           DATE < pandemics$start_date[i] + years(3)) # 3 years since start
  
  #shift dates to start at origin of graph
  temp_emratio_data$Days_Since_Pandemic_Start <- as.numeric(difftime(temp_emratio_data$DATE, pandemics$start_date[i], units = "days"))
  
  temp_emratio_data$pandemic <- pandemics$pandemic[i]
  
  pandemic_emratio_data[[i]] <- temp_emratio_data
}

combined_emratio_data <- bind_rows(pandemic_emratio_data)

# EMPLOYMENT RATIO PLOT
ggplot(combined_emratio_data, aes(x = Days_Since_Pandemic_Start, y = EMRATIO, color = pandemic)) +
  geom_line() +
  labs(title = "Employment Ratio from Pandemic Start (3 Year Period)",
       x = "Days Since Pandemic Start Date",
       y = "Employment Ratio") +
  theme_minimal()


# CORRELATION MATRIX FOR EMPLOYMENT RATIO DATA

spread_emratio_data <- combined_emratio_data %>%
  select(Days_Since_Pandemic_Start, pandemic, EMRATIO) %>%
  spread(key = pandemic, value = EMRATIO)

spread_emratio_data <- na.omit(spread_emratio_data)

# correlation matrix for emratio data
correlation_matrix_emratio <- cor(spread_emratio_data[,-1])  # Excluding the first column which is Days_Since_Pandemic_Start

# Print the correlation matrix
print(correlation_matrix_emratio)

#Heat map development
correlation_data_emratio <- as.data.frame(as.table(correlation_matrix_emratio))

# Heatmap
ggplot(correlation_data_emratio, aes(Var1, Var2, fill = Freq)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0, limit = c(-1,1), space = "Lab", name="Pearson\nCorrelation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = '', y = '', title = 'Correlation Heatmap of Employment Ratios During Pandemics', subtitle = 'Comparing the first 3 years since the start of each pandemic') +
  coord_fixed()

################################################################################
# GDP ANALYSIS

# GDP data
gdp_data <- read.csv("A939RX0Q048SBEA.csv")

gdp_data$DATE <- mdy(gdp_data$DATE)  # mdy for month date year

pandemics <- tibble(
  pandemic = c("H2N2", "H3N2", "Russian Flu", "H1N1", "COVID"),
  start_date = mdy(c("4/1/1957", "7/1/1968", "1/1/1978", "4/1/2009", "1/1/2020"))
) #dates adjusted to match dataset (prevent empty start)

pandemic_gdp_data <- list()

for (i in 1:nrow(pandemics)) {
  temp_gdp_data <- gdp_data %>%
    filter(DATE >= pandemics$start_date[i],
           DATE < pandemics$start_date[i] + years(3)) # 3 years since start
  
  # days since pandemic start
  temp_gdp_data$Days_Since_Pandemic_Start <- as.numeric(difftime(temp_gdp_data$DATE, pandemics$start_date[i], units = "days"))
  
  # Normalize GDP
  base_value <- first(temp_gdp_data$GDP)
  temp_gdp_data$Normalized_GDP <- (temp_gdp_data$GDP / base_value) * 100
  
  temp_gdp_data$pandemic <- pandemics$pandemic[i]
  
  pandemic_gdp_data[[i]] <- temp_gdp_data
}

combined_gdp_data <- bind_rows(pandemic_gdp_data)

# Plot Normalized GDP
ggplot(combined_gdp_data, aes(x = Days_Since_Pandemic_Start, y = Normalized_GDP, color = pandemic)) +
  geom_line() +
  labs(title = "Normalized GDP from Pandemic Start (3 Year Period)",
       x = "Days Since Pandemic Start Date",
       y = "Normalized GDP (%)") +
  theme_minimal()


####  CONCLUSION #####################################
# COVID-19 had a major impact on all economic indicators while other pandemics had limited impact
# COVID-19 should be studied since other pandemics do not show strong influence on the economic indicators