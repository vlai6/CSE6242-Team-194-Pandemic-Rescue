# CSE6242-Team-194-Pandemic-Rescue
This project analyzes the impacts of COVID-19 on several U.S. economic indicators. By utilizing regression models and neural networks in R, the study develops 14 relief indexes to identify which economic sectors are most impacted and have the slowest rate of recovery.

This project uses R and D3.js. To install, follow the youtube videos linked below:

R Installation (recommend RStudio): https://www.youtube.com/watch?v=H9EBlFDGG4k
D3.js Installation: https://www.youtube.com/watch?v=lzxAKqoBhDY


Alternative Download option: Download all files directly on Github:
https://github.com/vlai6/CSE6242-Team-194-Pandemic-Rescue


INITIAL EXPLORATORY DATA ANALYSIS

Packages used:
tidyverse: Provides tools for data manipulation and visualization.
lubridate: Manages dates and times in R.

- analysis on pandemics on economic indicators
- This analysis was done in R
- Download the econ_indicators_analysis.R file and the csv data files (4 files)
CSV data:

	SP500: time series data of US S&P 500 market index
		https://www.kaggle.com/datasets/myungchankim/sp-500-daily-data-19281230-to-20210919
	[more recent data unaccessible]

		and

		https://www.nasdaq.com/market-activity/index/spx/historical?page=1&rows_per_page=10&timeline=y10
	[used to substitute missing data]

	EMRATIO: time series data of US employment ratio
		https://fred.stlouisfed.org/series/EMRATIO

	GDP: time series data of US GDP
		https://fred.stlouisfed.org/series/A939RX0Q048SBEA

Ensure the csv files are in the same folder as the R file.
R file: econ_indicators_analysis.R
csv files: 	A939RX0Q048SBEA.csv (GDP)
		EMRATIO.csv (Employment Ratio)
		HistoricalData_1711620498272.csv (S&P 500)
		SPX_500_Data.csv (S&P 500)

1. Put the econ_indicators_analysis.R file and the 4 csv files in the same folder.
2. Go to "Session" tab at the top of Rstudio and set working directory "To Source File Location"
3. Select all code (Ctrl + A) and then click Run (Ctrl + Enter)
4. Highlight specific code to run specific areas or plots


COVID-19 EXPLORATORY DATA ANALYSIS

Packages used:
corrplot: Visualizes correlation matrices.
readxl: Reads Excel files into R.
car: Provides tools for regression diagnostics and data analysis.
MASS: Includes functions for statistical methods like linear and nonlinear modeling.
ggplot2: Creates complex and customizable graphics.
glmnet: Implements penalized regression models.

2 Files only: covid19_research.R and pandemic_tech_dataset.csv
Download through the github: https://github.com/vlai6/CSE6242-Team-194-Pandemic-Rescue

1. Put covid19_research.R and pandemic_tech_dataset.csv in the same folder.
2. Go to "Session" tab at the top of Rstudio and set working directory "To Source File Location"
3. Select all code (Ctrl + A) and then click Run (Ctrl + Enter)
4. Highlight specific code to run specific areas or plots


RELIEF INDICES

This repository contains code for analyzing the interrelations between various economic sectors and relief indices during the COVID-19 pandemic. The code is divided into three main parts:

1) Data Acquisition (data_source.R):
The primary objective of this code is to gather data from different sources, focusing on stock prices and sector-specific data.

2) Index Creation and Storage (master_index.R):
In this section, relief indices are created based on the collected data. The code employs various data sources related to vaccine tests, economic relief, technology, and other sectors to construct these indices. The indices are stored in CSV format for further analysis.

3) Wavelet Coherence Analysis (wavelet_coherence.R):
The final part of the code conducts wavelet coherence analysis to investigate the interrelations between economic sectors and relief indices. It utilizes the biwavelet package to perform this analysis, visualizing the coherence between communication sectors and relief indices.

This code provides insights into the dynamics of different economic sectors and their relationships with relief measures during the pandemic. It offers a comprehensive approach to understanding the impact of various factors on economic resilience and recovery.

To run the code:
1. Put the code and the data csv files in the same folder.
2. Go to "Session" tab at the top of Rstudio and set working directory "To Source File Location"
3. Select all code (Ctrl + A) and then click Run (Ctrl + Enter)
4. Highlight specific code to run specific areas or plots



VISUALIZATIONS

To run the visualizations, first download all of the necessary files and save them to the file of your choice.
1. Open command prompt or terminal
2. Navigate to the project folder using "cd [FILE LOCATION]" where file location is the folder
	For example: C:\Users\laivi>cd C:\Users\laivi\CSE 6242\team194dashboard where cd C:\Users\laivi\CSE 6242\team194dashboard is the input.
3. Run "python -m http.server 8000" by typing the quote (without quotations) into the command prompt and hitting Enter
4. Open any browser then enter the url: "http://localhost:8000/index.html"






