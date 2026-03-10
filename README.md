World-Layoffs-Data-Analysis

# World Layoffs Data Cleaning & Analysis

## Project Overview
This project involves a comprehensive data cleaning and exploratory data analysis (EDA) process on a global layoffs dataset. Using MySQL, I transformed raw, unstructured data into a structured format ready for analysis, and then performed various queries to uncover trends in layoffs across industries, countries, and time periods.

## Data Source
The raw data was sourced from a CSV file containing information on company layoffs, including location, industry, total laid off, percentage, date, stage, and funds raised.

## Tools Used
* **SQL:** MySQL Workbench (Data Cleaning & EDA)
* **Git/GitHub:** Version Control

## 1. Data Cleaning Process
The goal was to make the data more reliable and usable for analysis. Key steps included:

* **Staging Environment:** Created a staging table (`layoffs_staging2`) to keep the raw data intact while performing transformations.
* **Duplicate Removal:** Used `ROW_NUMBER()` and Common Table Expressions (CTEs) to identify and remove duplicate entries based on unique combinations of all columns.
* **Standardization:**
    * Trimmed whitespace from company names.
    * Standardized the 'Industry' column (e.g., merging "Crypto", "Crypto Currency", and "CryptoCurrency" into one category).
    * Cleaned country names (removing trailing periods).
    * Converted the `date` column from a string format to a proper SQL `Date` type.
* **Handling Nulls:** * Populated missing industry values by joining the table to itself where the same company had the data elsewhere.
    * Identified rows with critical missing values (total and percentage laid off) that were not useful for the final analysis.

## 2. Exploratory Data Analysis (EDA)
With a clean dataset, I explored the data to find meaningful insights. Notable queries included:

* **Top Companies:** Identifying which companies had the highest total layoffs and those that went completely out of business (100% layoffs).
* **Industry & Geography:** Summing layoffs by industry and country to see where the economic impact was most significant.
* **Temporal Trends:** * Analyzing layoffs by year to see the progression of the job market.
    * Using a **Rolling Total** calculation to visualize the cumulative layoffs over months.
* **Company Rankings:** Using CTEs and `DENSE_RANK()` to find the top 5 companies per year with the highest layoffs.

## Key Insights
* **Industry Impact:** Certain sectors (like Retail and Consumer) showed significantly higher layoff volumes during specific years.
* **Time Period:** The data covers a span of several years, showing clear "spikes" in layoff events that align with global economic shifts.
* **Total Volume:** Amazon, Google, and Meta appear as some of the companies with the highest total layoffs in the dataset.

## How to Use This Repo
1.  **Data Cleaning:** Run `Data Cleaning.sql` on the `layoffs.csv` data to create the cleaned table.
2.  **Analysis:** Run `EDA.sql` to replicate the findings mentioned above.