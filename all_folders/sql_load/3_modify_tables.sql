-- SELECT * FROM job_postings_fact LIMIT 10;
-- SELECT * FROM company_dim LIMIT 10;
-- SELECT * FROM skills_dim LIMIT 10;
-- SELECT * FROM skills_job_dim LIMIT 10;

SELECT
    job_schedule_type,
    AVG(salary_year_avg) AS avg_salary_year_avg,
    AVG(salary_hour_avg) AS avg_salary_hour_avg
FROM 
    job_postings_fact
WHERE 
    job_posted_date::DATE >= '2023-06-01'
GROUP BY 
    job_schedule_type;




SELECT 
    EXTRACT(
        MONTH 
        FROM job_posted_date 
        AT TIME ZONE 'UTC' 
        AT TIME ZONE 'America/New_York'
        ) AS job_posted_month, 
    COUNT(job_id) AS job_postings_count
FROM job_postings_fact
GROUP BY job_posted_month
ORDER BY job_posted_month;

WITH job_postings_quarterly AS (
SELECT
    jpf.company_id AS company_id,
    cd.name AS company_name,
    jpf.job_health_insurance AS health_insurance,
    jpf.job_posted_date::DATE AS job_posted_date,
    EXTRACT(YEAR FROM jpf.job_posted_date) AS job_posted_year,
    EXTRACT(QUARTER FROM jpf.job_posted_date) AS job_posted_quarter,
    TO_CHAR(jpf.job_posted_date, 'Month') AS job_posted_month
FROM job_postings_fact jpf
LEFT JOIN company_dim cd
ON jpf.company_id = cd.company_id
)
SELECT
    company_name,
    health_insurance,
    job_posted_date,
    job_posted_month
FROM job_postings_quarterly
WHERE 
    health_insurance = TRUE AND
    job_posted_year = 2023 AND
    job_posted_quarter = 2
ORDER BY job_posted_date;



