library(corrplot)
library(readxl)
library(car)
library(MASS)
library(ggplot2)
library(glmnet)

##### Import Data ############################################################
file_path <- "pandemic_tech_dataset.xlsx"
data <- read_excel(file_path)


##### Setup and clean data ######################################################
cols_of_interest <- c('Percent Change to RGDP', 'Estimated Total Store and Non-store Sales',
                      'Total E-commerce', 'E-Commerce Over Total Sales', 'Percent Total Employed',
                      'Median Age of Employed', 'Digital Ad Spending', 'Hospitalized COVID-19 Patients',
                      'Weekly % Test Positivity for COVID-19')

# data of only columns of interest
cor_data <- data[, cols_of_interest]
data_complete <- na.omit(cor_data, cols = "Hospitalized COVID-19 Patients")

# correlation matrix
cor_matrix <- cor(data_complete, use = "complete.obs")  # use="complete.obs" handles missing values by using only complete observations

# correlation heatmap
corrplot(cor_matrix, method = "color", type = "upper", order = "hclust",
         tl.col = "black", tl.srt = 45, addCoef.col = "black", tl.cex = 0.55, number.cex = 0.75)
# Hospitalized COVID-19 patients is highly correlated with Weekly Test Positivity.
# Total E-commerce is highly correlated with E-commerce over Total Sales.
#   These are expected due to COVID-19 being the direct factor for hospitzalizations from COVID-19 and test postivity

# We will use Total E-commerce, Digital Ad spending, Hospitalized COVID-19 Patients, and Weekly % Test Positivity
#   to as our test factors because they represent the use of technology in business and economic impact of a pandemic


##### Real GDP linear regression model ##############################################
RGDP_model <- lm(`Percent Change to RGDP` ~ `Total E-commerce` + `Digital Ad Spending` + `Hospitalized COVID-19 Patients` + `Weekly % Test Positivity for COVID-19`, data = data_complete)
summary(RGDP_model)
# stat significant:
#   total e-commerce (-2.794e-05)

# calculate VIF to look for multicollinearity issues
vif_model <- vif(RGDP_model)
print(vif_model)
# all are less than 10, so multicollinearity should not be an issue.

##### Real GDP LASSO Regression Model ############################################
# LASSO model because stepwise regression does not make sense since the original did not have statisitcally significant columns
# We will try a Ridge Regression model to see what variables may be statistically significant.

x <- model.matrix(`Percent Change to RGDP` ~ `Total E-commerce` + `Digital Ad Spending` + `Hospitalized COVID-19 Patients` + `Weekly % Test Positivity for COVID-19`, data = data_complete)
y <- data_complete$`Percent Change to RGDP`

# alpha=1 indicates Lasso regression
lasso_model <- glmnet(x, y, alpha = 0.05)
cv_lasso <- cv.glmnet(x, y, alpha = 0.05)

rgdp_lasso_coef <- coef(cv_lasso, s = "lambda.min")
print(rgdp_lasso_coef)
# stat significant:
#   Total e-commerce (-4.477084e-06)


##### Percent Total Employed (Employment Rate) Linear regression model ###########################
em_model <- lm(`Percent Total Employed` ~ `Total E-commerce` + `Digital Ad Spending` + `Hospitalized COVID-19 Patients` + `Weekly % Test Positivity for COVID-19`, data = data_complete)
summary(em_model) #due to inability to separate online employees to in person employees, we should be cautious
# If data of the online workforce is found, we will have more insight on its effect to RGDP.
# We could determine whether certain market sectors had a shift in employment and if an online workforce is effective in maintaining economic function.
# stat significant factors: 
#                           `Total E-commerce` (-1.101e-07)

# calculate VIF to look for multicollinearity issues
vif_model <- vif(em_model)
print(vif_model)
# all are less than 10, so multicollinearity should not be an issue.

##### Percent Total Employed (Employment Rate) Stepwise regression model ####################
null_model <- lm(`Percent Total Employed` ~ 1, data = data_complete)
stepwise_model_forward <- step(null_model, scope = list(lower = null_model, upper = em_model), direction = "forward")
summary(stepwise_model_forward)
# stat significant factors: 
#                           `Total E-commerce` (-1.090e-07)


##### Percent Total Employed (Employment Rate) LASSO regression model ####################
# LASSO model for employment rate
x <- model.matrix(`Percent Total Employed` ~ `Total E-commerce`  + `Digital Ad Spending` + 
                    `Hospitalized COVID-19 Patients` + `Weekly % Test Positivity for COVID-19`, data = data_complete)
y <- data_complete$`Percent Total Employed`


lasso_model <- glmnet(x, y, alpha = 0.05)
cv_lasso <- cv.glmnet(x, y, alpha = 0.05)

best_lambda <- cv_lasso$lambda.min
emp_lasso_coef <- coef(cv_lasso, s = "lambda.min")
print(emp_lasso_coef)

# stat significant factors: 
#                           `Total E-commerce` (-6.178909e-08)


##### Plot of E-commerce by Market Sector Data preparation ##############################
# 'Date' to Date format and 'Market Sector' to factor
data$Date <- as.Date(data$Date)
data$`Market Sector` <- as.factor(data$`Market Sector`)


# Plot of Total E-commerce by Market Sector
ggplot(data, aes(x = Date, y = `Total E-commerce`, group = `Market Sector`, color = `Market Sector`)) +
  geom_line() + 
  geom_vline(xintercept = as.Date("2020-01-20"), color = "red", size = 1, linetype = "dashed") +  # Adding the vertical line
  geom_text(aes(x = as.Date("2020-01-20"), y = Inf, label = "Start of COVID-19"), vjust = -0.5, color = "red", angle = 90, hjust = 1) +
  theme_minimal() + 
  labs(x = "Date", 
       y = "Total E-commerce", 
       title = "Total E-commerce Over Time by Market Sector",
       color = "Market Sector") +  # Legend title
  scale_x_date(date_breaks = "1 month", date_labels = "%b %Y") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1),  
        legend.position = "right",  
        legend.title = element_text(size = 12),  
        legend.text = element_text(size = 10),  
        legend.background = element_rect(fill = "white", colour = "black"))


# The plot shows a spike in e-Commerce for all market sectors during the start of COVID-19.
# This makes sense since consumers will want to purchase items without exposing themselves to the virus by going outside.
# For each market sector other than Health and Personal Care, e-Commerce grew over the course of the pandemic.
# This makes sense because Health and Personal Care is an industry that would have grown during a pandemic
# due to consumers associating that industry with ways to stay healthy from the pandemic.

# Businesses should partake in E-commerce since it grows during a pandemic.

##### Conclusion #############################################################
# All models show Total E-commerce to be statistically significant in affecting RGDP and employment rate.
# Businesses should partake in E-commerce since it grows during a pandemic and will allow them to continue gaining revenue.

# While the coefficients of E-commerce in the RGDP model are extremely tiny, US RGDP is multiple trillion, which amounts to millions of dollars in RGDP change.
# On the other hand, the coefficients for E-commerce in the employment rate model are also extremely small.
#   Since the US population is in 100s of millions, the changes to employment rate are small.

# Future teams can find more data, which will help in drawing more accurate conclusions.

