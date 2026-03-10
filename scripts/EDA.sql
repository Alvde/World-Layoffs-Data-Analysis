-- EDA

Select *
From layoffs_staging2;

Select max(total_laid_off), max(percentage_laid_off)
From layoffs_staging2;

Select *
From layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

Select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

Select min(`date`), max(`date`)
from layoffs_staging2;

Select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

Select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 2 desc;

Select substring(`date`,6,2) as `Month`, sum(total_laid_off)
from layoffs_staging2
group by `Month`
order by 1 asc;

Select substring(`date`,1,7) as `Month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc
;

with rolling_total as(
Select substring(`date`,1,7) as `Month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc)
select `Month`, total_off,
sum(total_off) over(order by `month`) as rolling_total
from rolling_total;



Select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 Desc;


with company_year (COmpany, years, total_laid_off) as 
(
Select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), Company_year_rank as 
(
Select *, dense_rank() over (partition by years order by total_laid_off Desc) as laid_off_ranking
from company_year
where years is not null
)
Select *
from company_year_rank
where laid_off_ranking <= 5
;
