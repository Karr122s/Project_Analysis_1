--Database testing
SELECT *
FROM Portfolio_Project_1..Loan

SELECT *
FROM Portfolio_Project_1..Status

SELECT *
FROM Portfolio_Project_1..Loan AS L
LEFT JOIN Portfolio_Project_1..Status AS S
ON L.id = S.id


	--DATA EXPLORATION QUERIES

SELECT COUNT(id) AS Total_Applications
FROM Portfolio_Project_1..Loan	-- Total Loan Applications


			--Good Loans
SELECT COUNT(id) AS Total_Good_Loan_Applications
FROM Portfolio_Project_1..Status
WHERE loan_status != 'Charged off' -- Good Loan Applications 

SELECT (100 * COUNT(CASE WHEN loan_status != 'Charged off' THEN id
			END)) / COUNT(id) AS Bad_Loan_Percentage
FROM Portfolio_Project_1..Status -- Good loan percentage

SELECT SUM(loan_amount) AS total_amount_funded
FROM Portfolio_Project_1..Status
WHERE loan_status != 'Charged off'-- Total amount funded to good loans

SELECT SUM(total_payment) AS total_amount_received
FROM Portfolio_Project_1..Status
WHERE loan_status != 'Charged off'-- Total amount received from good loans

SELECT 	SUM(total_payment) - SUM(loan_amount) AS Good_Loan_PNL
FROM Portfolio_Project_1..Status AS L
WHERE loan_status != 'Charged off'--PNL of good loans


SELECT COUNT(CASE WHEN loan_status != 'Charged off' THEN id END) AS Total_Good_Loan_Applications,
		(100 * COUNT(CASE WHEN loan_status != 'Charged off' THEN id END) / COUNT(id)) AS Good_Loan_Percentage,
		SUM(CASE WHEN loan_status != 'Charged off' THEN loan_amount END) AS Total_Good_Loan_Amount_Funded,
		SUM(CASE WHEN loan_status != 'Charged off' THEN total_payment END) AS Total_Good_Loan_Amount_Received,
		SUM(CASE WHEN loan_status != 'Charged off' THEN total_payment END) - 
		SUM(CASE WHEN loan_status != 'Charged off' THEN loan_amount END) AS Good_Loan_PNL
FROM Portfolio_Project_1..Status--GOOD LOANS SUMMARY
SELECT 
    Total_Good_Loan_Applications,
    ROUND(100.0 * Total_Good_Loan_Applications / Total_Loan_Applications, 1) AS Good_Loan_Percentage,
    Total_Good_Loan_Amount_Funded,
    Total_Good_Loan_Amount_Received,
    Total_Good_Loan_Amount_Received - Total_Good_Loan_Amount_Funded AS Good_Loan_PNL
FROM (
    SELECT 
        COUNT(*) AS Total_Loan_Applications,
        SUM(CASE WHEN loan_status != 'Charged off' THEN 1 ELSE 0 END) AS Total_Good_Loan_Applications,
        SUM(CASE WHEN loan_status != 'Charged off' THEN loan_amount ELSE 0 END) AS Total_Good_Loan_Amount_Funded,
        SUM(CASE WHEN loan_status != 'Charged off' THEN total_payment ELSE 0 END) AS Total_Good_Loan_Amount_Received
    FROM Portfolio_Project_1..Status
) AS subquery --GOOD LOANS SUMMARY using subquery


			--Bad Loans
SELECT COUNT(id) AS Total_Bad_Loan_Applications
FROM Portfolio_Project_1..Status
WHERE loan_status = 'Charged off' -- Bad Loan Applications 

SELECT (100 * COUNT(CASE WHEN loan_status = 'Charged off' THEN id
		END)) / COUNT(id) AS Bad_Loan_Percentage
FROM Portfolio_Project_1..Status -- Bad loan percentage

SELECT SUM(loan_amount) AS total_amount_funded
FROM Portfolio_Project_1..Status
WHERE loan_status = 'Charged off'-- Total amount funded to bad loans

SELECT SUM(total_payment) AS total_amount_received
FROM Portfolio_Project_1..Status
WHERE loan_status = 'Charged off' -- Total amount received from bad loans

SELECT SUM(total_payment) - SUM(loan_amount) AS Bad_Loan_PNL
FROM Portfolio_Project_1..Status
WHERE loan_status = 'Charged off'--PNL of bad loans


SELECT COUNT(CASE WHEN loan_status = 'Charged off' THEN id END) AS Total_Bad_Loan_Applications,
		(100 * COUNT(CASE WHEN loan_status = 'Charged off' THEN id END) / COUNT(id)) AS Bad_Loan_Percentage,
		SUM(CASE WHEN loan_status = 'Charged off' THEN loan_amount END) AS Total__Bad_Loan_Amount_Funded,
		SUM(CASE WHEN loan_status = 'Charged off' THEN total_payment END) AS Total_Bad_Loan_Amount_Received,
		SUM(CASE WHEN loan_status = 'Charged off' THEN total_payment END) - 
		SUM(CASE WHEN loan_status = 'Charged off' THEN loan_amount END) AS Bad_Loan_PNL
FROM Portfolio_Project_1..Status--BAD LOANS SUMMARY
SELECT 
    Total_Bad_Loan_Applications,
    ROUND(100.0 * Total_Bad_Loan_Applications / Total_Loan_Applications, 1) AS Bad_Loan_Percentage,
    Total_Bad_Loan_Amount_Funded,
    Total_Bad_Loan_Amount_Received,
    Total_Bad_Loan_Amount_Received - Total_Bad_Loan_Amount_Funded AS Bad_Loan_PNL
FROM (
    SELECT 
        COUNT(*) AS Total_Loan_Applications,
        SUM(CASE WHEN loan_status = 'Charged off' THEN 1 ELSE 0 END) AS Total_Bad_Loan_Applications,
        SUM(CASE WHEN loan_status = 'Charged off' THEN loan_amount ELSE 0 END) AS Total_Bad_Loan_Amount_Funded,
        SUM(CASE WHEN loan_status = 'Charged off' THEN total_payment ELSE 0 END) AS Total_Bad_Loan_Amount_Received
    FROM Portfolio_Project_1..Status) AS subquery --BAD LOANS SUMMARY using subquery


	--DATA EXPLORATION FOR VISUALIZATIONS(Charts)

SELECT 	DATENAME(MONTH, issue_date) AS Month_name,
		COUNT(L.id) AS Total_Loan_Application,
		SUM(S.loan_amount) AS Total_Loan_Amount,
		SUM(S.total_payment) AS Total_Received_Amount
FROM Portfolio_Project_1..Loan AS L
LEFT JOIN Portfolio_Project_1..Status AS S
ON L.id=S.id
GROUP BY DATENAME(MONTH, issue_date), MONTH(L.issue_date)
ORDER BY MONTH(L.issue_date)--Monthly Trend by Issue date(Line chart)

SELECT	L.address_state AS State_name,
		COUNT(L.id) AS Total_Loan_Applications,
		SUM(S.loan_amount) AS Distributed_Funds,
		SUM(S.total_payment) AS Received_Funds
FROM Portfolio_Project_1..Loan AS L
LEFT JOIN Portfolio_Project_1..Status AS S
ON L.id=S.id
GROUP BY L.address_state
ORDER BY COUNT(L.id) DESC --Regional Analysis by State(map)

SELECT L.term AS Loan_Term, 
		COUNT(L.id) AS Total_Applications,
		SUM(S.total_payment) AS Amount_Received,
		SUM(S.loan_amount) AS Amount_Funded
FROM Portfolio_Project_1..Loan AS L
LEFT JOIN Portfolio_Project_1..Status AS S
ON L.id=S.id
GROUP BY L.term --Loan term analysis(bar chart)

SELECT L.emp_length AS Length_of_Employment,
		COUNT(L.id) AS Number_of_borrowers,
		SUM(S.loan_amount) AS Amount_Funded,
		SUM(S.total_payment) AS Amount_Received
FROM Portfolio_Project_1..Loan AS L
LEFT JOIN Portfolio_Project_1..Status AS S
ON L.id=S.id
GROUP BY L.emp_length
ORDER BY L.emp_length --Employee length analysis(bar chart)

SELECT L.purpose, 
		COUNT(L.id) AS Number_of_borrowers,
		SUM(S.loan_amount) AS Amount_Funded,
		SUM(S.total_payment) AS Amount_Received
FROM Portfolio_Project_1..Loan AS L
LEFT JOIN Portfolio_Project_1..Status AS S
ON L.id=S.id
GROUP BY L.purpose
ORDER BY Number_of_borrowers DESC --Loan purpose(bar chart)

SELECT L.home_ownership AS Home_Ownership,
		COUNT(L.id) AS Number_of_borrowers,
		SUM(S.loan_amount) AS Amount_Funded,
		SUM(S.total_payment) AS Amount_Received
FROM Portfolio_Project_1..Loan AS L
LEFT JOIN Portfolio_Project_1..Status AS S
ON L.id=S.id
GROUP BY L.home_ownership
ORDER BY COUNT(L.id) DESC--Home ownership analysis(bar chart)

SELECT L.grade AS Borrower_Grade,
		S.sub_grade AS Sub_Grade,
		COUNT(L.id) AS Total_Applicants,
		SUM(S.loan_amount) AS Amount_Funded,
		SUM(S.total_payment) AS Amount_Received
FROM Portfolio_Project_1..Loan AS L
LEFT JOIN Portfolio_Project_1..Status AS S
ON L.id=S.id
GROUP BY L.grade, S.sub_grade
ORDER BY L.grade, S.sub_grade--Borrower grade analysis(column chart)

SELECT S.loan_status AS Applicant_Grade,
		COUNT(L.id) AS Total_Applicants,
		SUM(S.loan_amount) AS Amount_Funded,
		SUM(S.total_payment) AS Amount_Received,
		AVG(S.int_rate) * 100 AS Avg_Interest_rate,
		AVG(S.dti) * 100 AS Avg_Debt_to_Income
FROM Portfolio_Project_1..Loan AS L
LEFT JOIN Portfolio_Project_1..Status AS S
ON L.id=S.id
GROUP BY S.loan_status
ORDER BY COUNT(L.id) DESC--Loan Status analysis(column chart)