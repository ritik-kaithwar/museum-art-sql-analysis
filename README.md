# PostgreSQL Analysis of a Famous Paintings & Museum Dataset

This repository contains a comprehensive SQL-based data analysis project focused on understanding a Famous Paintings & Museum dataset. The project was executed using SQL within a PostgreSQL environment to clean, analyze, and derive actionable insights from the dataset.

---

## Project Scope & Objectives
The primary objective of this project is to gain insights from a dataset of famous paintings and museums to answer key business questions related to:

- **Painting & Artist Analysis**: Identify the most popular artists, painting styles, and subjects.  
- **Museum Performance**: Understand which museums are the most popular, their operational hours, and geographical distribution.  
- **Price and Product Analysis**: Analyze painting prices, canvas sizes, and their relationship to sales.  
- **Data Quality**: Identify and clean duplicate or invalid data entries.  

---

## Dataset
The analysis is based on a dataset containing multiple tables related to famous paintings and museums, including:

- `artist`  
- `canvas_size`  
- `image_link`  
- `museum_hours`  
- `museum`  
- `product_size`  
- `subject`  
- `work`  

---

## Methodology
The project followed a structured data analysis workflow:

1. **Data Wrangling & Setup**  
   - A database was set up in PostgreSQL using a Python script to connect and load the CSV data.  
   - The script uses the **SQLAlchemy** and **pandas** libraries to create an engine and load each CSV file into its corresponding table.  

2. **Data Cleaning**  
   - Duplicate records were deleted from the `work`, `product_size`, `subject`, and `image_link` tables.  
   - One invalid entry in the `museum_hours` table was identified and removed.  
   - Museums with invalid city information (e.g., cities containing numbers) were identified.  

3. **Exploratory Data Analysis (EDA)**  
   - SQL queries were executed to answer **22 specific business questions** related to the dataset.  
   - The analysis covered various aspects, including identifying popular artists, museums, and painting styles, as well as analyzing pricing and operational data.  

---

## Key Findings & Insights

- **Museums & Operations**  
  - Identified the country and city with the most museums.  
  - Found museums open on both **Sunday and Monday**.  
  - Noted a small number of museums open **every single day of the week**.  

- **Paintings & Artists**  
  - Determined the most famous painting subjects.  
  - Identified the **top 5 most popular artists** based on painting counts.  
  - Identified the **top 5 most popular museums** based on the number of paintings displayed.  

- **Pricing & Product**  
  - Found some paintings with asking prices higher than their regular prices.  
  - Identified the painting with the **highest sale price** and the one with the **lowest sale price**, along with their associated artists, museums, and canvas sizes.  

---

## Tools Used
- PostgreSQL  
- SQL  
- Python (Pandas & SQLAlchemy for data loading)  

---

## Queries & Documentation
- `analysis-queries.sql`: Contains all the SQL queries used for data cleaning and exploratory analysis.  
- `connection-script.ipynb`: Provides the Python code used to connect to the database and load the data.  

---

## Author
**Ritik Kaithwar**
