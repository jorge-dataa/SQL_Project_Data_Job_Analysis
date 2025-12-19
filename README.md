# Introduction
This project analyzes a job postings dataset to uncover insights about the data job market. Using SQL, I explored salary trends, in-demand skills, and which skills lead to higher-paying roles. The goal is to answer practical business questions that help job seekers and employers understand the current landscape of data-related careers.

SQL queries? Check them out here:[project_sql folder](/project_sql/)
# Background
The dataset used in this project contains thousands of real job postings related to data analytics, including details such as salaries, job titles, locations, required skills, and posting dates. This information provides a foundation for exploring patterns in the data job market.

To make the analysis meaningful, the project focuses on answering five core business questions derived from common needs of job seekers and employers:

What are the top-paying data analyst jobs?

What skills are required for these top-paying jobs?

What skills are most in demand for data analysts?

Which skills are associated with higher salaries?

What are the most optimal skills to learn?

These questions guide the SQL queries and shape the insights produced throughout the project.
# Tools I use
Tools I Used

To explore and analyze the data analyst job market, I relied on several key tools:

- **SQL** – The core language used to query the dataset and extract meaningful insights.

- **PostgreSQL** – The database management system used to store and process the job posting data.

- **Visual Studio Code** – My main environment for writing, organizing, and running SQL scripts.

- **Git & GitHub** – Essential for version control and sharing my SQL queries and project files, ensuring organization and project tracking.
# The Analysis 
The Analysis

Each query for this project aimed at investigating specific aspects of the data analyst job market.

### 1. Top-Paying Data Analyst Jobs

To identify the highest-paying data analyst positions, I filtered the job postings to include only:

Roles with the title “Data Analyst”

Positions listed as remote (“Anywhere”)

Jobs that reported a yearly salary

I then sorted the results by salary_year_avg in descending order and limited the output to the top 10 highest-paying roles.
This approach reveals which companies are offering the most competitive compensation for remote data analyst positions.
```sql
SELECT  job_id,
        job_title_short,
        dm.name AS company_name,
        job_location,
        job_schedule_type,
        salary_year_avg,
        job_posted_date
FROM 
    job_postings_fact AS jp
LEFT JOIN company_dim AS dm
ON jp.company_id = dm.company_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10;
```
Here is a breakdown of the top data analyst jobs:

Data Analyst Job Openings Across Various Companies: The table lists various companies hiring for the role of "Data Analyst," with positions from companies like Meta, AT&T, SmartAsset, and Pinterest. All the listed positions have the same job title and are located "Anywhere," suggesting remote or flexible work opportunities.

Salary Variation: The salaries for Data Analyst positions vary significantly, ranging from around $184,000 to $650,000 annually. This may indicate differences in company size, job requirements, or other factors like location and benefits.

Job Post Dates: The job postings span several months, from as early as June 2023 to February 2023. This may reflect ongoing demand for Data Analysts and the continued recruitment efforts by these companies.

![Top Paying Roles](assets\Picture1.png)


### 2. Top-Paying Data Analyst Skills

To identify the highest-paying remote Data Analyst roles and determine the skills they require:

The code filters job postings to include only remote Data Analyst roles with a valid salary.

It sorts those roles by salary and selects the top ten highest-paying positions.

It then joins those top jobs with the skills tables to retrieve all skills associated with each role.

```sql
WITH top_paying_jobs AS (
    SELECT  job_id,
            job_title_short,
            dm.name AS company_name,
            salary_year_avg
    FROM 
        job_postings_fact AS jp
    LEFT JOIN company_dim AS dm
    ON jp.company_id = dm.company_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY 
        salary_year_avg DESC
    LIMIT 10)

SELECT 
    top_paying_jobs.*,
    skills  
FROM top_paying_jobs 
INNER JOIN skills_job_dim AS skd
ON top_paying_jobs.job_id = skd.job_id
INNER JOIN skills_dim AS sd
ON skd.skill_id = sd.skill_id
ORDER BY salary_year_avg DESC
```
Key Insights from the Skills Data
1. SQL is the most consistently required skill

SQL appears across nearly all high-paying roles in your dataset.
This signals that SQL remains the core technical requirement for top Data Analyst positions, regardless of company or industry.

2. Python stands out as the dominant programming language

Python is one of the most frequently listed skills, showing that employers increasingly expect analysts to work with:

automation,

data pipelines,

advanced analytics,

and possibly machine learning workflows.

Python is now a strong differentiator in higher-salary roles.

![Top Paying Skills](assets\Picture2.png)


### 3. In-Demand Skills for Data Analysts


This query identifies the five most in-demand skills for remote Data Analyst roles by counting how often each skill appears across all relevant job postings. It highlights which skills employers prioritize most frequently.

```sql
SELECT 
    skills,
    COUNT(skd.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim AS skd
ON job_postings_fact.job_id = skd.job_id
INNER JOIN skills_dim AS sd
ON skd.skill_id = sd.skill_id
WHERE job_title_short = 'Data Analyst' AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5
```

| Skill     | Demand Count |
|----------|--------------|
| SQL      | 7,291        |
| Excel    | 4,611        |
| Python   | 4,330        |
| Tableau  | 3,745        |
| Power BI | 2,609        |

SQL is by far the most in-demand skill, appearing in significantly more job postings than any other skill, which reinforces its role as the foundational requirement for data analyst positions.

While programming and visualization tools like Python, Tableau, and Power BI are highly sought after, Excel remains one of the top-required skills, showing that traditional data analysis tools are still essential alongside more advanced technologies.


### 4. Skills Based on Salary
 
To identify the highest-paying skills for remote data analyst roles, I filtered job postings to include only positions with the title “Data Analyst,” roles that were remote, and jobs that reported a yearly salary. I then joined the job postings with their associated skills, grouped the data by skill, and calculated the average salary for each one. Finally, I sorted the results by average salary in descending order and limited the output to the top 25 highest-paying skills.

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim AS skd
ON job_postings_fact.job_id = skd.job_id
INNER JOIN skills_dim AS sd
ON skd.skill_id = sd.skill_id
WHERE job_title_short = 'Data Analyst' 
AND salary_year_avg IS NOT NULL
AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25
```

| Skill            | Avg Salary ($) |
|------------------|----------------|
| PySpark          | 208,172        |
| Bitbucket        | 189,155        |
| Couchbase        | 160,515        |
| Watson           | 160,515        |
| DataRobot        | 155,486        |
| GitLab           | 154,500        |
| Swift            | 153,750        |
| Jupyter          | 152,777        |
| Pandas           | 151,821        |
| Elasticsearch    | 145,000        |
| Golang           | 145,000        |
| NumPy            | 143,513        |
| Databricks       | 141,907        |
| Linux            | 136,508        |
| Kubernetes       | 132,500        |
| Atlassian        | 131,162        |
| Twilio           | 127,000        |
| Airflow          | 126,103        |
| Scikit-learn     | 125,781        |
| Jenkins          | 125,436        |
| Notion           | 125,000        |
| Scala            | 124,903        |
| PostgreSQL       | 123,879        |
| GCP              | 122,500        |
| MicroStrategy    | 121,619        |

Skills tied to big data and distributed processing, such as PySpark and Databricks, are associated with the highest average salaries, suggesting that roles closer to data engineering command stronger compensation.

Many of the top-paying skills are infrastructure, cloud, and tooling technologies (Kubernetes, GCP, Airflow, Jenkins, Linux), indicating that data analysts with platform and pipeline expertise tend to earn more than those focused solely on analysis or visualization.

### 5. Most Optimal Skills To Learn

To find the most valuable skills for remote data analyst roles, I filtered job postings to include only positions with the title “Data Analyst,” jobs that were remote, and roles that reported a yearly salary. I first calculated how frequently each skill appears across these postings to measure demand, and then computed the average salary associated with each skill. After combining skill demand with average salary, I filtered out low-demand skills, sorted the results by highest average salary and demand, and limited the output to the top 25 skills.

| Skill ID | Skill        | Demand Count | Avg Salary ($) |
|----------|-------------|--------------|----------------|
| 8        | Go          | 27           | 115,320        |
| 234      | Confluence  | 11           | 114,210        |
| 97       | Hadoop      | 22           | 113,193        |
| 80       | Snowflake   | 37           | 112,948        |
| 74       | Azure       | 34           | 111,225        |
| 77       | BigQuery    | 13           | 109,654        |
| 76       | AWS         | 32           | 108,317        |
| 4        | Java        | 17           | 106,906        |
| 194      | SSIS        | 12           | 106,683        |
| 233      | Jira        | 20           | 104,918        |
| 79       | Oracle      | 37           | 104,534        |
| 185      | Looker      | 49           | 103,795        |
| 2        | NoSQL       | 13           | 101,414        |
| 1        | Python      | 236          | 101,397        |
| 5        | R           | 148          | 100,499        |
| 78       | Redshift    | 16           | 99,936         |
| 187      | Qlik        | 13           | 99,631         |
| 182      | Tableau     | 230          | 99,288         |
| 197      | SSRS        | 14           | 99,171         |
| 92       | Spark       | 13           | 99,077         |
| 13       | C++         | 11           | 98,958         |
| 186      | SAS         | 63           | 98,902         |
| 7        | SAS         | 63           | 98,902         |
| 61       | SQL Server  | 35           | 97,786         |
| 9        | JavaScript  | 20           | 97,587         |

Skills related to cloud platforms and big data technologies such as Go, Snowflake, Azure, AWS, and Hadoop are associated with the highest average salaries, even though their demand is relatively lower than more common tools.

Widely demanded skills like Python and Tableau appear in many more job postings, but their average salaries are lower than several niche or specialized skills, suggesting that scarcity and technical complexity drive higher compensation.

# What I Learned
Throughout this project, I significantly strengthened my SQL skill set and expanded my ability to work with real-world data:

- Complex Query Building: Developed strong proficiency in advanced SQL by combining multiple tables and using CTEs to structure and manage complex queries.

- Data Aggregation and Analysis: Gained hands-on experience with GROUP BY and aggregate functions such as COUNT() and AVG() to summarize and analyze large datasets effectively.

- Analytical Problem Solving: Improved my ability to translate business questions into clear, well-structured SQL queries that produce meaningful and actionable insights.

- Data-Driven Decision Making: Learned how to interpret query results to identify trends, patterns, and high-impact skills, supporting more informed analytical conclusions.

# Conclusions

### Key Insights
1. **Top-Paying Data Analyst Jobs:** Salary Variation: The salaries for Data Analyst positions vary significantly, ranging from around $184,000 to $650,000 annually. This may indicate differences in company size, job requirements, or other factors like location and benefits.
2. **Top-Paying Data Analyst Skills:** SQL is the most consistently required skill. It appears across nearly all high-paying roles in your dataset.
This signals that SQL remains the core technical requirement for top Data Analyst positions, regardless of company or industry.
3. **In-Demand Skills for Data Analysts:** While programming and visualization tools like Python, Tableau, and Power BI are highly sought after, Excel remains one of the top-required skills, showing that traditional data analysis tools are still essential alongside more advanced technologies.
4. **Skills Based on Salary:** Skills tied to big data and distributed processing, such as PySpark and Databricks, are associated with the highest average salaries, suggesting that roles closer to data engineering command stronger compensation.
5. **Most Optimal Skills To Learn:** Widely demanded skills like Python and Tableau appear in many more job postings, but their average salaries are lower than several niche or specialized skills, suggesting that scarcity and technical complexity drive higher compensation.

