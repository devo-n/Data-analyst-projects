-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP by company
ORDER BY 2 DESC;

-- Looking at the date range
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- also what industry, country, year, stage has the most lay offs
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP by industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP by country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP by YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP by stage
ORDER BY 2 DESC;

-- trying to get the rolling total of the amount of lay offs per month
SELECT substring(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE Substring(`date`, 1, 7) is not null
GROUP BY `MONTH`
ORDER BY 1 asc;

WITH Rolling_Total AS 
(
SELECT substring(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE Substring(`date`, 1, 7) is not null
GROUP BY `MONTH`
ORDER BY 1 asc
)
select `MONTH`, total_off, 
SUM(total_off) OVER (ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- now what we're trying to get the amount of layoff's per year per company

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP by Company, YEAR(`date`)
ORDER BY 3 DESC;

-- Trying to get their ranking's
WITH Company_year (company, years, total_laid_off) AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP by Company, YEAR(`date`)
), 	Company_year_rank AS
(SELECT *, dense_rank() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_year_rank
WHERE Ranking <= 5;
