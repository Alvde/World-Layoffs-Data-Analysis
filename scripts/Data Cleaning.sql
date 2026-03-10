-- data cleaning

select *
from layoffs;

-- 1.  remove duplicates
-- 2. Standardize the data
-- 3. Null values or blank
-- 4. remove unnecessary columns

-- create column headers from the raw data, but rows are empty
create table layoffs_staging
like layoffs;

select *
from layoffs_staging;

-- populate stagging table with raw data
Insert layoffs_staging
select *
from layoffs;

select *
from layoffs_staging;

-- trying to get duplicate values, once the row_num column is 2, then it is a duplicate
select *,
row_number() over(partition by company , industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_staging;


-- using cte to filter for only the duplicates
with duplicate_cte as
(
select *,
row_number() over(partition by company , location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num > 1;


-- creating another staging table 
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
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- loading the new staging table with data from the previous staging table
insert into layoffs_staging2
select *, row_number() over(
partition by company , location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;


delete
from layoffs_staging2
where row_num > 1;

Select *
from layoffs_staging2
where row_num > 1;


-- standardizing data

select company, (trim(company))
FROM layoffs_staging2;

-- taking white spaces and updating the column
update layoffs_staging2
set company = trim(company);


select distinct industry
FROM layoffs_staging2
Order by 1;

select industry
FROM layoffs_staging2
group by industry
Order by 1;

select *
FROM layoffs_staging2
where industry like 'crypto%';

-- setting all type of Crypto inputs to 'Crypto'
update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

select industry
FROM layoffs_staging2
group by industry
Order by 1;

select distinct country
FROM layoffs_staging2
Order by 1;


select distinct country, trim(trailing '.' from country)
FROM layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';


select distinct country
FROM layoffs_staging2
Order by 1;

-- checking datatypes 
DESCRIBE layoffs_staging2;

Select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;


update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

select *
FROM layoffs_staging2;

-- set the data type of date to date
Alter table layoffs_staging2
modify column `date` Date;

select *
FROM layoffs_staging2;

-- Null values or blank

select *
FROM layoffs_staging2
Where total_laid_off is null
and percentage_laid_off is null;

update layoffs_staging2
set industry = null
where industry = '';

select *
FROM layoffs_staging2
Where industry is null
or industry = '';

select *
from layoffs_staging2
where company = 'Airbnb';

select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null
;

-- update empty industry with the industry of the same company that was populated

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null or t1.industry = '')
and t2.industry is not null
;

-- 4. remove unnecessary columns

select *
FROM layoffs_staging2
Where total_laid_off is null
and percentage_laid_off is null;


delete
FROM layoffs_staging2
Where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_staging2;

alter table layoffs_staging2
drop column row_num;


select *
from layoffs_staging2;
