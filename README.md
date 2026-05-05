London Air Quality Analysis 2023
> A comprehensive end-to-end data analytics project exploring hourly pollution patterns across London — using Excel, SQL, and Python to uncover annual trends, hourly peaks, seasonal dynamics, and public health implications.
---
📋 Project Overview

This project analyses 8,760 hourly air quality readings from London across the full calendar year 2023. The dataset covers six key pollutants — CO, NO₂, SO₂, O₃, PM2.5, and PM10 — alongside a composite AQI score.
The objective was to build a portfolio-grade, stakeholder-ready analysis that demonstrates:
Proficiency across the Excel → SQL → Power BI analytics stack
Ability to extract narrative insights from raw environmental data
Understanding of public health context and WHO guideline benchmarking
Data storytelling from cleaning through to polished visualisation
---
📁 Repository Structure
```
london-air-quality-2023/
│
├── data/
│   ├── raw/
│   │   └── London_Air_Quality.csv          # Original dataset (8,760 rows × 11 cols)
│   └── processed/
│       └── London_AQ_Cleaned.xlsx          # Cleaned Excel workbook with pivot tables
│
├── sql/
│   ├── 01_annual_averages.sql              # AAM per pollutant
│   ├── 02_hourly_patterns.sql              # Avg concentration by hour of day
│   ├── 03_monthly_trends.sql               # Monthly aggregations
│   ├── 04_seasonal_analysis.sql            # Season-level averages
│   ├── 05_aqi_categorisation.sql           # AQI band distribution
│   ├── 06_peak_days.sql                    # Top 10 worst AQI days
│   └── 07_correlation_prep.sql             # Data prep for correlation analysis
│
│
└── README.md
```
---
📊 Dataset Description

Column	Type	Description
dates	string	Date of reading (YYYY-MM-DD)
hours	string	Hour of reading (HH:MM:SS)
city	string	City name (London throughout)
CO	integer	Carbon monoxide concentration (µg/m³)
NO2	float	Nitrogen dioxide concentration (µg/m³)
SO2	float	Sulphur dioxide concentration (µg/m³)
O3	integer	Ozone concentration (µg/m³)
PM25	float	Fine particulate matter ≤ 2.5µm (µg/m³)
PM10	float	Coarse particulate matter ≤ 10µm (µg/m³)
AQI	float	Composite Air Quality Index
months	string	Month name (January–December)
Rows: 8,760 | Nulls: 0 | Date range: 2023-01-01 → 2023-12-31
---
🔍 Key Analyses Performed

1. Annual Average Measurement (AAM)
The mean pollutant concentration measured across all 8,760 hourly readings — the standard metric used for WHO guideline compliance assessment.
Pollutant	Annual Average	WHO Guideline	Status
CO	201.77 µg/m³	4,000 µg/m³	✅ Safe
NO₂	19.10 µg/m³	10 µg/m³	⚠️ 191% of limit
SO₂	2.98 µg/m³	40 µg/m³	✅ Safe
O₃	48.87 µg/m³	60 µg/m³	✅ Within limit
PM2.5	8.83 µg/m³	5 µg/m³	⚠️ 177% of limit
PM10	13.16 µg/m³	15 µg/m³	✅ Within limit

3. Hourly Average Measurement
Mean pollutant concentration by hour of day (0:00–23:00), revealing diurnal cycles driven by traffic and atmospheric chemistry.
Peak hours identified:
CO → 21:00 (226.8 µg/m³)
NO₂ → 20:00 (25.3 µg/m³)
SO₂ → 21:00 (3.82 µg/m³)
O₃ → 15:00 (64.1 µg/m³) — photochemical peak
PM2.5 → 22:00 (10.4 µg/m³)
PM10 → 22:00 (14.6 µg/m³)

4. Monthly Trend Analysis
Monthly averages reveal seasonal patterns: Winter (Dec–Feb) shows highest CO, NO₂, SO₂; Summer (Jun–Aug) shows lowest traffic pollutants but highest O₃.

5. Seasonal Comparison
Season	CO	NO₂	O₃	PM2.5	AQI
Winter	244.8	25.1	40.4	10.3	27.1
Spring	165.1	17.5	58.7	9.09	25.9
Summer	172.7	12.2	55.8	7.10	23.6
Autumn	225.7	21.8	40.3	8.87	22.6

6. AQI Distribution
Good (0–50): 8,399 hours (95.9%)
Moderate (51–100): 361 hours (4.1%)
Unhealthy or worse: 0 hours

7. Correlation Analysis (Pearson r)
Pair	r	Interpretation
PM2.5 ↔ PM10	+0.946	Co-sourced particulates
NO₂ ↔ CO	+0.776	Traffic co-emission fingerprint
NO₂ ↔ SO₂	+0.776	Combustion co-product
O₃ ↔ NO₂	−0.677	Photochemical inverse (NOₓ-O₃ cycle)
O₃ ↔ CO	−0.631	Traffic/photochemistry opposition

8. Worst AQI Days
Rank	Date	Daily Avg AQI
1	23 Jan 2023	68.6
2	15 Feb 2023	66.3
3	08 Feb 2023	62.6
4	14 Feb 2023	62.3
5	07 Sep 2023	62.2
---
🛠️ Tools & Methodology

Excel
Data import and inspection
Date/time parsing and column formatting
Pivot tables: monthly averages, hourly averages by pollutant
WHO guideline compliance columns (calculated fields)
Conditional formatting for AQI thresholds
Charts: line trends, bar comparisons

SQL
All queries written in standard SQL (compatible with PostgreSQL / MySQL / SQLite):
`GROUP BY` aggregations for annual, monthly, hourly, and seasonal averages
`CASE WHEN` logic for AQI categorisation
`RANK()` window function for top-N worst days
Subqueries for correlation-ready pivots

Python — used Pandas and NumPy for data preprocessing and analysis, including handling missing values, calculating AQI metrics, and identifying peak pollution trends; built visualizations (Matplotlib/Seaborn) to present seasonal and hourly patterns
---
💡 Key Insights
NO₂ and PM2.5 exceed WHO guidelines on an annual average basis — the two pollutants most associated with long-term respiratory and cardiovascular harm.
Evening hours are more polluted than morning rush hour — CO, NO₂, and PM2.5 all peak between 20:00–22:00 due to combined traffic and atmospheric boundary layer effects.
February was the worst month — highest NO₂, PM2.5, and AQI, driven by cold, stable atmospheric conditions that trap surface-level emissions.
O₃ follows an inverse pattern to traffic pollutants — summer afternoons are the ozone peak, not the traffic peak. This reflects the NOₓ-O₃ photochemical cycle.
PM2.5 and PM10 are effectively co-located (r = 0.946) — both originate from road dust, tyre/brake wear, and construction, confirming non-exhaust emissions as a dominant source.
95.9% of hours were "Good" AQI — but this metric masks annual-average WHO exceedances and 361 "Moderate" hours that represent real risk for sensitive populations.
---
📚 References
WHO Air Quality Guidelines (2021)
UK Government Air Pollution Information System
London Air Quality Network
European Environment Agency — Air Quality
---
👤 Author
MD NAJMUL ISLAM
Data Analyst | Excel · SQL · Power BI · Python
LinkedIn: https://www.linkedin.com/in/mohammad-najmul-islam-rayhan/
Medium: https://medium.com/@md_najmul_islam

---
📄 Licence
This project is open for educational use. Dataset sourced from publicly available London air quality monitoring records. Analysis and visualisations by the author.
---
⭐ If this project helped you, a star goes a long way!
