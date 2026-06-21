## Introduction
This project is part of my journey to learn Data Analytics tools, including SQL, Python, and BI tools. It is based on the Data Analyst Bootcamp by Luke Barousse on YouTube.

## Background
Dive into the data job market! Focusing on Data Analyst roles. This project explores top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics.

The project aims to answer the following questions:
1. What are the top-paying Data Analyst jobs?
2. What skills are required for the top-paying Data Analyst jobs?
3. What are the most in-demand skills for Data Analyst?
4. What are the top skills based on salary?
5. What are the most optimal skill to learn (high demand & high-paying skill)?

SQL queries? Check them out here: [project_sql folder](/all_folders/project_sql/)

## Tools I used
The tools I used are:

- **SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights.

- **PostgreSQL**: The chosen database management system, ideal for handling the job posting data.

- **Visual Studio Code**: My go-to for database management and executing SQL queries.

- **Excel**: Used to create visualizations

- **Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

## The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the top 10 highest-paying remote Data Analyst jobs by filtering for roles with a specified salary.

```sql
SELECT
    jpf.job_title_short AS job_title_short,
    jpf.job_title AS job_title,
    jpf.job_location AS job_location,
    cd.name AS company_name,
    jpf.job_schedule_type AS job_schedule_type,
    jpf.job_posted_date::DATE AS job_post_date,
    jpf.salary_year_avg AS salary_year_avg
FROM job_postings_fact jpf
LEFT JOIN company_dim cd
ON jpf.company_id = cd.company_id
WHERE
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
    AND job_location = 'Anywhere'
ORDER BY salary_year_avg DESC
LIMIT 10;
```
**Key Takeaways**

- **Seniority Premium**: Director/Principal roles pay significantly higher.
- **Unusual Outlier**:	"Data Analyst" at Mantys pays $650K - likely a specialized/senior role misclassified.
- **Top Paying Company**:	Meta ($336,500), AT&T ($255,830).
- **Consistent Player**:	SmartAsset appears twice in top 10
- **Job Type**:	All are full-time remote positions.

**Summary**

The top remote Data Analyst jobs pay $184K-$336K+, with director/principal titles dominating. The $650K role at Mantys is an outlier, likely a specialized position. Meta and AT&T offer the highest salaries among recognizable brands, while SmartAsset is a consistent top employer.

![Top Paying Roles](/all_folders/project_sql/assets/top_paying_roles.png)

### 2. Top Paying Skills for Data Analyst jobs

To provide a detailed look at which high-paying jobs demand certain skills, helping job seekers
understand which skills to develop that align with top salaries.

```sql
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
```
**Key Takeaways**

- **SQL** is the undisputed king: 100% penetration in top-paying roles
- **Visualization skills** matter: Tableau and Power BI are essential
- **Cloud** literacy is crucial: Companies pay premium for cloud skills
- **Programming variety** is valued: Python, R, Go, and Crystal show diversity
- Senior roles require **"soft tech"**:  Version control and collaboration tools

**Analysis Summary**

- Most common skill: **SQL (8/10 jobs)**
- Top 3 skill categories: **programming (33.3%)**, **analyst tools (19.7%)** & **cloud (15.2%)**

![Top Skill Categories](/all_folders\project_sql\assets\skill_categories_distribution.png)

### 3. Most in-demand Skills for Data Analyst jobs

To retreive the top 5 skills with the highest demand in the job marker,
providing insights into the most valuable skills for seekers.

```sql
SELECT 
    sd.skills AS skill_name,
    COUNT(DISTINCT jpf.job_id) AS postings_counts
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Analyst'
GROUP BY 
    sd.skills
ORDER BY 
    postings_counts DESC
LIMIT 5;
```
The data reveals a clear hierarchy: SQL dominates the Data Analyst skill landscape, followed by essential tools like Excel. Programming (Python) and visualization tools (Tableau, Power BI) are also critical but secondary to foundational data manipulation skills. 

To maximize job opportunities, prioritize SQL first, then add Python and one visualization tool.

![Most In-Demand Skills](/all_folders\project_sql\assets\most_in_demand_skills.png)

### 4. Top Skills based on Salary

To reveal how different skills impact salary levels for Data Analyst and helps
identify the most financially rewarding skills to acquire or improve.

```sql
SELECT
    sd.skills AS skill_name,
    ROUND(AVG(jpf.salary_year_avg), 2) AS avg_salary
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Analyst'
    AND jpf.salary_year_avg IS NOT NULL
    AND jpf.job_location = 'Anywhere'
GROUP BY 
    sd.skills
ORDER BY avg_salary DESC
LIMIT 25;
```

**Summary**

- **Salary range**: $121,619.25 - $208,172.25
- **Average salary**: $143,380.00
- **Top paying skill**: pyspark ($208,172.25)
- **Category with highest avg salary**: Big Data ($158,727.28)

**Big Data tools** (PySpark) and **DevOps platforms** (Bitbucket, GitLab) dominate the top-paying skills for Data Analysts. 

This signals a market shift where data professionals are expected to handle large-scale data processing and work within modern DevOps pipelines. To maximize earning potential, focus on Big Data technologies, Python's data ecosystem, and AI/ML automation tools.

![Top Skills based on Salary](/all_folders\project_sql\assets\top_skills_salary.png)

### 5. Optimal Skills (High Demand & High Paying Jobs)
To target skills that offer job security (high demand) and financial benefits (high salaries), offering startegic insights for career development in data analysis.

```sql
SELECT
    sd.skill_id AS skill_id,
    sd.skills AS skill_name,
    ROUND(AVG(jpf.salary_year_avg), 2) AS avg_salary,
    COUNT(jpf.job_id) AS demand_count
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Analyst'
    AND jpf.salary_year_avg IS NOT NULL
    AND jpf.job_location = 'Anywhere'
GROUP BY
    sd.skill_id
HAVING COUNT(jpf.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```
![Optimal Skills](/all_folders\project_sql\assets\optimal_skills_figures.png)
![Optimal Skills scatter plot](/all_folders\project_sql\assets\optimal_skills_scatterplot.png)

**Summary**

Programming Languages are the undisputed champion across all metrics, making them the most important skill category for Data Analysts. BI Tools, while highly demanded, offer lower returns, suggesting they are best as complementary skills rather than a primary focus. For maximum career impact, prioritize Programming (Python, R) and Cloud (Snowflake, AWS) skills to combine high demand with premium salaries.

### 6. Strategic Recommendations for Career Growth

| Priority  | Category               | Rationale                                         |
|-----------|------------------------|---------------------------------------------------|
| 1         | Programming Languages  | Highest demand + salary + weight foundational     |
| 2         | Cloud Platforms        | High salary, low competition – differentiator     |
| 3         | Databases              | Stable demand, consistent value – core skill      |
| 4         | Big Data & ETL         | Premium niche – specialist path                   |
| 5         | BI Tools               | High demand for entry-level – good starting point |

## Conclusion
This project was an excellent opportunity to apply my SQL skills and expand my technical toolkit. Key learnings include:

- **Database Integration**: Connecting VS Code to PostgreSQL to create a database, design tables, and load data.
- **Version Control**: Using Git Bash to connect VS Code with my GitHub account, and pushing files and query scripts.
- **Advanced Querying**: Testing and improving my SQL proficiency by writing queries that leverage subqueries and Common Table Expressions (CTEs).
- **AI-Assisted Problem Solving**: Leveraging AI tools to debug complex queries, optimize performance, and extract meaningful insights from the data, which enhanced both my efficiency and understanding.


![Top Paying Roles](all_folders/project_sql/assets/Top_paying_roles.png)
![Top Skill Categories](all_folders/project_sql/assets/Top_skill_categories.png)
![Most In-Demand Skills](all_folders/project_sql/assets/Most_in-demand_skills.png)
![Top Skills based on Salary](all_folders/project_sql/assets/Top_skills_based_on_salary.png)
![Optimal Skills](all_folders\project_sql\assets\optimal_skills_figures.png)
![Optimal Skills Scatter Plot](all_folders/project_sql/assets/Optimal_skills_scatter_plot.png)