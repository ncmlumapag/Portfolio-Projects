-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

-- Finding the companies that completely went out of business.
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC; -- Ranking of companies with the highest number of employees laid off. 

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC; -- Ranking of ompanies that went under with the largest funds raised.

SELECT company, total_laid_off
FROM world_layoffs.layoffs_staging
ORDER BY 2 DESC
LIMIT 5; -- Top 5 Companies with the Biggest Layoff in a Single Day.

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10; -- Top 10 Companies with the Most Total Layoffs. 

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2; -- Date range of the data. 
						-- It can be seen that the data probably started right around the beginning of the pandemic and ended almost 3 years later.
				
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC
LIMIT 10; -- Top 10 Industries with the Biggest Total Layoffs. 

SELECT location, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10; -- Top 10 Areas with the Biggest Total Layoffs.

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
LIMIT 5; -- Top 5 Countries with the Biggest Total Layoffs.

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC; -- Which year has the largest layoff?

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC; -- It can be seen that most layoffs come from companies with Post-IPO stage.

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC; -- It can be seen that most layoffs come from Post-IPO stage companies.

SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC; -- Total of Layoffs Per Month

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS monthly_lay_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, monthly_lay_off,
SUM(monthly_lay_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total; -- Rolling Total of Monthly Layoffs


SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5; -- Top 5 Companies with Biggest Layoffs per Year from 2020 to 2023
