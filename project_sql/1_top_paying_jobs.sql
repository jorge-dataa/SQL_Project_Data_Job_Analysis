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
LIMIT 10