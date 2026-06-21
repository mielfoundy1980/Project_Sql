
/*
Question 2 : What skills are required for the top-paying Data Analyst jobs?
- Use the Top 10 highest-paying Data Analyst jobs from first query.
- Add the specific skills required for these roles.
- Why? It provides a detailed look at which high-paying jobs demand certain skills, helping job seekers
understand which skills to develop that align with top salaries.
*/

WITH top_paying_jobs AS (
    SELECT
        jpf.job_id AS job_id,
        jpf.job_title_short AS job_title_short,
        jpf.job_title AS job_title,
        cd.name AS company_name,
        jpf.salary_year_avg AS salary_year_avg
    FROM job_postings_fact jpf
    LEFT JOIN company_dim cd
    ON jpf.company_id = cd.company_id
    WHERE
        job_title_short = 'Data Analyst' 
        AND salary_year_avg IS NOT NULL
        AND job_location = 'Anywhere'
    ORDER BY salary_year_avg DESC
    LIMIT 10
)

SELECT
    tpj.*,
    sd.skills AS skill_name,
    sd.type AS skill_type
FROM top_paying_jobs tpj
INNER JOIN skills_job_dim sjd
ON tpj.job_id = sjd.job_id
INNER JOIN skills_dim sd
ON sjd.skill_id = sd.skill_id
ORDER BY tpj.salary_year_avg DESC;

/*

==================================================
📊 DATA ANALYST SKILLS ANALYSIS - SUMMARY
==================================================

- Total unique skills: 28
- Most common skill: SQL (8/10 jobs)
- Highest paying company: AT&T ($255,830)
- Company with most diverse skills: Inclusively (14 unique skills)
- Top 3 skill categories: programming (33.3%), analyst tools (19.7%) & cloud (15.2%)

==================================================
💡 FINAL TAKEAWAYS
==================================================

- SQL is the undisputed king - 100% penetration in top-paying roles
- Visualization skills matter - Tableau and Power BI are essential
- Cloud literacy is crucial - Companies pay premium for cloud skills
- Programming variety is valued - Python, R, Go, and Crystal show diversity
- Senior roles require "soft tech" - Version control and collaboration tools

*/