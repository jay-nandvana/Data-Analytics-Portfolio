-- EDA


SELECT * 
FROM world_layoffs.layoffs_staging2;

-- Basic Insight

SELECT MAX(total_laid_off)
FROM world_layoffs.layoffs_staging2;  -- how many people fired from company in past all year 

SELECT MAX(percentage_laid_off), MIN(percentage_laid_off)
FROM layoffs_staging2
WHERE percentage_laid_off IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- GROUP BY Insight

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

SELECT location, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;


SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 2 DESC;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;



-- Advanced Queries
-- TOP THREE COPANY WITH HIGH LAID_OFF PER YEAR BASED ON RANKING
-- 

WITH company_year AS
(SELECT company, YEAR(date) AS years, SUM(total_laid_off) as total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(date)
)
,company_year_rank AS(
SELECT company, years, total_laid_off, dense_rank() OVER(partition by years ORDER BY total_laid_off DESC) as ranking 
FROM company_year
)
SELECT company, years, total_laid_off, ranking
FROM company_year_rank
WHERE ranking <= 3
ORDER BY total_laid_off DESC, years ASC;


SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC;


WITH DATE_CTE AS
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, total_laid_off, SUM(total_laid_off) OVER(ORDER BY dates ASC) as rolling_total_layoff
FROM DATE_CTE
ORDER BY dates ASC;