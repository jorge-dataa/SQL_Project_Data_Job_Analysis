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
 LIMIT 10
