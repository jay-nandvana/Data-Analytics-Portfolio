-- Data Cleaning

SELECT *
FROM layoffs
;

-- 1. Remove Duplicates
-- 2. Standardrize the Data
-- 3. Null values or blank vlaues 
-- 4. Remove Any Column and rows that are not necessary

CREATE TABLE layoffs_staging
LIKE layoffs ;

SELECT *
FROM layoffs_staging;

INSERT INTO layoffs_staging
SELECT * 
FROM layoffs;

SELECT *
FROM layoffs_staging; 

-- Remove Duplicates

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, date, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;


SELECT * 
FROM (SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, date, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging)
duplicates WHERE row_num >1;


SELECT * 
FROM layoffs_staging 
WHERE company = 'Yahoo';

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int	
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2;


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, date, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2
WHERE row_num > 1;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

SELECT * 
FROM layoffs_staging2;


-- Standardrize the Data

SELECT COUNT(*)
FROM layoffs_staging2;

SELECT COUNT(*)
FROM information_schema.columns
WHERE table_name = 'layoffs_staging2'; 

DESCRIBE layoffs_staging2;

DESC layoffs_staging2;

SELECT distinct(company) 
FROM layoffs_staging2 
ORDER BY company;

SELECT distinct(trim(company)) 
FROM layoffs_staging2 ;

UPDATE layoffs_staging2
SET company = trim(company);

SELECT distinct(industry)
FROM layoffs_staging2 
ORDER BY 1;


SELECT distinct(industry)
FROM layoffs_staging2 
WHERE industry LIKE 'Crypto%' 
ORDER BY 1;

UPDATE layoffs_staging2
SET industry = 'Crypto' 
WHERE industry LIKE 'Crypto%';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;


SELECT *
FROM layoffs_staging2
WHERE company LIKE "Bally's%"; 

SELECT *
FROM layoffs_staging2
WHERE company LIKE "Airbnb"; 

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';


SELECT t1.company,
    t1.industry AS old_industry,
    t2.industry AS new_industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL
AND T2.industry IS NOT NULL;
    
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;


SELECT country
FROM layoffs_staging2 
WHERE country LIKE 'Austr%'
ORDER BY 1;

SELECT *
FROM world_layoffs.layoffs_staging2;

UPDATE layoffs_staging2	
SET `date` = str_to_date(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

DESC layoffs_staging2;

SELECT *
FROM world_layoffs.layoffs_staging2;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE FROM 
layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM world_layoffs.layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP column row_num;




