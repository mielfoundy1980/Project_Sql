/*
DROP TABLE IF EXISTS january_jobs;
CREATE TABLE january_jobs AS
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

DROP TABLE IF EXISTS february_jobs;
CREATE TABLE february_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

DROP TABLE IF EXISTS march_jobs;
CREATE TABLE march_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Outside'
    END AS location_category,
    COUNT(job_id) AS number_of_jobs
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY
    location_category
ORDER BY 2 DESC;

WITH salary_standards AS (
SELECT
    job_title_short,
    salary_year_avg,
    CASE 
        WHEN salary_year_avg <= 100000 THEN '<= 100000'
        WHEN salary_year_avg BETWEEN 100001 AND 200000 
            THEN '100001 - 200000'
        ELSE '> 200001'
    END AS salary_category,
    CASE
        WHEN salary_year_avg <= 100000 THEN 'Low_salary_range'
        WHEN salary_year_avg BETWEEN 100001 AND 200000
            THEN 'Mid_salary_range'
        ELSE 'High_salary_range'
    END AS salary_standard
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
)
SELECT
    salary_category,
    salary_standard,
    COUNT(*) AS counts
FROM salary_standards
GROUP BY salary_category, salary_standard
ORDER BY
    CASE salary_category
        WHEN '<= 100000' THEN 1
        WHEN '100001 - 200000' THEN 2
        ELSE 3
    END
;

WITH company_jobs_count AS (
SELECT
    company_id,
    COUNT(job_id) AS number_jobs
FROM job_postings_fact
GROUP BY company_id
)

SELECT
    cd.name AS company_name,
    cjc.number_jobs AS total_jobs
FROM company_dim cd
LEFT JOIN company_jobs_count cjc
ON cjc.company_id = cd.company_id
ORDER BY 2 DESC
;


SELECT top_skills.skill_id, sd.skills, sd.type
FROM (
    SELECT
        skill_id,
        COUNT(*) AS skill_counts
    FROM skills_job_dim
    GROUP BY skill_id
    LIMIT 5) AS top_skills
LEFT JOIN skills_dim sd
ON top_skills.skill_id = sd.skill_id
;


WITH company_size_cte AS (
SELECT
    company_id,
    CASE
        WHEN total_job_postings < 10 THEN 'Small'
        WHEN total_job_postings BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS company_size
FROM (
    SELECT
        company_id,
        COUNT(job_id) AS total_job_postings
    FROM job_postings_fact
    GROUP BY company_id
))
SELECT
    company_size,
    COUNT(*) AS total_companies
FROM company_size_cte
GROUP BY company_size
ORDER BY 2 DESC;

WITH company_size_cte AS (
    SELECT
        company_id,
        CASE
            WHEN total_job_postings < 10 THEN 'Small'
            WHEN total_job_postings BETWEEN 10 AND 50 THEN 'Medium'
            ELSE 'Large'
        END AS company_size,
        total_job_postings  -- Garder le nombre exact
    FROM (
        SELECT
            company_id,
            COUNT(job_id) AS total_job_postings
        FROM job_postings_fact
        GROUP BY company_id
    ) AS job_counts
)
SELECT
    company_size,
    COUNT(*) AS total_companies,
    MIN(total_job_postings) AS min_postings,
    MAX(total_job_postings) AS max_postings,
    ROUND(AVG(total_job_postings), 2) AS avg_postings
FROM company_size_cte
GROUP BY company_size
ORDER BY 
    CASE company_size
        WHEN 'Small' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'Large' THEN 3
    END;

WITH remote_jobs AS (
    SELECT
        jpf.job_id AS job_id,
        jpf.job_location AS job_location,
        sd.skill_id AS skill_id,
        sd.skills AS skill_name,
        sd.type AS skill_type
    FROM job_postings_fact jpf
    INNER JOIN skills_job_dim sjd
    ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim sd
    ON sjd.skill_id = sd.skill_id
    WHERE jpf.job_location = 'Anywhere' AND
        jpf.job_title_short = 'Data Analyst'
)
SELECT
    skill_id,
    skill_name,
    COUNT(*) AS total_counts
FROM remote_jobs
GROUP BY
    skill_id,
    skill_name
ORDER BY 3 DESC
LIMIT 5;

WITH jobs_first_quarter AS (
SELECT
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE,
    salary_year_avg
FROM january_jobs

UNION ALL

SELECT
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE,
    salary_year_avg
FROM february_jobs

UNION ALL

SELECT
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE,
    salary_year_avg
FROM march_jobs
)

SELECT
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE,
    salary_year_avg
FROM jobs_first_quarter
WHERE salary_year_avg IS NOT NULL
    AND salary_year_avg > 70000
    AND job_title_short = 'Data Analyst'
ORDER BY 5 DESC;
*/