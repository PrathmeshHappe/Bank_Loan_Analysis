create database bank_loan;
use bank_loan;

show tables;

-- Q1. Write a SQL query to display all loans where LoanAmount is greater than 47000 ?
SELECT LoanId,LoanAmount FROM loans WHERE LoanAmount > 4700;

-- Q2. Display all loans where the APR is greater than 100.
SELECT LoanId , APR FROM loans
WHERE APR > 650;

-- Q3.Display all loans where PayFrequency is Monthly.
SELECT PayFrequency FROM loans
WHERE PayFrequency = 'M';

-- Q4 Display all loans where LoanAmount is greater than 5000 and APR is greater than 100.
SELECT LoanId, LoanAmount , APR FROM loans
WHERE LoanAmount > 4000
AND APR > 100;

-- Q5 Write a SQL query to find the average LoanAmount for each LoanStatus.
SELECT LoanStatus, AVG(LoanAmount) FROM loans GROUP BY LoanStatus;

-- Q6Classify loans as High or Low based on LoanAmount.
SELECT LoanAmount,
       CASE
           WHEN LoanAmount > 400 THEN 'High Loan'
           ELSE 'Low Loan'
       END AS Loan_Category
FROM loans;

-- Q7. Classify loans based on APR.
SELECT APR,
       CASE
           WHEN APR < 50 THEN 'Low APR'
           WHEN APR BETWEEN 100 AND 500 THEN 'Medium APR'
           ELSE 'High APR'
       END AS APR_Category
FROM loans;

-- Q8. Classify borrowers based on nPaidOff.
SELECT nPaidOff,
       CASE
           WHEN nPaidOff = 0 THEN 'New Borrower'
           WHEN nPaidOff BETWEEN 1 AND 2 THEN 'Regular Borrower'
           ELSE 'Experienced Borrower'
       END AS Borrower_Category
FROM loans;

-- Q9 Classify loans based on funding status.
SELECT isFunded,
       CASE
           WHEN isFunded = 1 THEN 'Funded'
           ELSE 'Not Funded'
       END AS Funding_Status
FROM loans;

-- Q10 Classify loans based on approval status.
SELECT Approved,
       CASE
           WHEN Approved = 1 THEN 'Approved'
           ELSE 'Not Approved'
       END AS Approval_Status
FROM loans;

-- Q11 Find the number of loans for each PayFrequency where the count is greater than 1,000.
SELECT PayFrequency, COUNT(*) AS Total_Loans
FROM loans
GROUP BY PayFrequency
HAVING COUNT(*) > 1000;

-- Q12 Find the average LoanAmount for each PayFrequency where the average is greater than 5000.
SELECT PayFrequency, AVG(LoanAmount) AS Average_Loan
FROM loans
GROUP BY PayFrequency
HAVING AVG(LoanAmount) > 500;

-- Q13 Find the average APR for each LoanStatus where the average APR is greater than 50.
SELECT LoanStatus, AVG(APR) AS Average_APR
FROM loans
GROUP BY LoanStatus
HAVING AVG(APR) > 50;

-- Q 14 Find the number of funded and non-funded loans where the count is greater than 1,000.
SELECT isFunded, COUNT(*) AS Total_Loans
FROM loans
GROUP BY isFunded
HAVING COUNT(*) > 1000;

-- Q15 Find each PayFrequency where the average nPaidOff is greater than 2.
SELECT PayFrequency, AVG(nPaidOff) AS Average_PaidOff
FROM loans
GROUP BY PayFrequency
HAVING AVG(nPaidOff) > 0;

-- Q16 Loans with an amount greater than the average loan amount
SELECT LoanId,LoanAmount
FROM loans
WHERE LoanAmount > (
    SELECT AVG(LoanAmount)
    FROM loans
);

-- Q17 Loans with an APR greater than the average APR
SELECT APR
FROM loans
WHERE APR > (
    SELECT AVG(APR)
    FROM loans
);

-- Q18 Loans with the highest loan amount
SELECT LoanAmount
FROM loans
WHERE LoanAmount = (
    SELECT MAX(LoanAmount)
    FROM loans
);

-- Q19 Loans with the same payment frequency as loans having an APR above average
SELECT LoanAmount, APR, PayFrequency
FROM loans
WHERE PayFrequency IN (
    SELECT PayFrequency
    FROM loans
    WHERE APR > (
        SELECT AVG(APR)
        FROM loans
    )
);

-- Q20 Find loans with an amount greater than the average loan amount.
WITH AvgLoan AS (
    SELECT AVG(LoanAmount) AS AverageAmount
    FROM loans
)
SELECT LoanAmount, PayFrequency
FROM loans
WHERE LoanAmount > (SELECT AverageAmount FROM AvgLoan);

-- Q21 Find the total number of loans for each loan status.
WITH LoanStatusCount AS (
    SELECT LoanStatus, COUNT(*) AS TotalLoans
    FROM loans
    GROUP BY LoanStatus
)
SELECT LoanStatus
FROM LoanStatusCount;

-- Q22 Find the average originally scheduled payment amount for funded loans.
WITH FundedLoans AS (
    SELECT OriginallyScheduledPaymentAmount
    FROM loans
    WHERE isFunded = 1
)
SELECT AVG(OriginallyScheduledPaymentAmount) AS AverageScheduledPayment
FROM FundedLoans;

-- Q23 Find loans with a lead cost greater than the average lead cost.
WITH AverageLeadCost AS (
    SELECT AVG(LeadCost) AS AvgCost
    FROM loans
)
SELECT LeadCost
FROM loans
WHERE LeadCost > (SELECT AvgCost FROM AverageLeadCost);

-- Q24 Find the average number of paid-off loans for each funding status.
WITH PaidOffSummary AS (
    SELECT isFunded, AVG(nPaidOff) AS AveragePaidOff
    FROM loans
    GROUP BY isFunded
)
SELECT  AveragePaidOff
FROM PaidOffSummary;

-- Q25 Rank loans by LeadCost from highest to lowest.
SELECT
    LoanStatus,
    LeadCost,
    RANK() OVER (ORDER BY LeadCost DESC) AS LeadCostRank
FROM loans;

-- Q26 Rank loans by nPaidOff within each LoanStatus.
SELECT
    LoanStatus,
    nPaidOff,
    DENSE_RANK() OVER (
        PARTITION BY LoanStatus
        ORDER BY nPaidOff DESC
    ) AS PaidOffRank
FROM loans;

-- Q27 Count Approved and Rejected Loans
SELECT
    COUNT(CASE WHEN Approved = 1 THEN 1 END) AS Approved_Loans,
    COUNT(CASE WHEN Approved = 0 THEN 1 END) AS Rejected_Loans
FROM loans;

-- Q28 Count Funded and Non-Funded Loans
SELECT
    COUNT(CASE WHEN isFunded = 1 THEN 1 END) AS Funded_Loans,
    COUNT(CASE WHEN isFunded = 0 THEN 1 END) AS Non_Funded_Loans
FROM loans;

-- Q29 Average Loan Amount by Approval Status
SELECT
    AVG(CASE WHEN Approved = 1 THEN LoanAmount END) AS Avg_Approved_Loan,
    AVG(CASE WHEN Approved = 0 THEN LoanAmount END) AS Avg_Rejected_Loan
FROM loans;

-- Q30 Count Originated Loans by Funding Status
SELECT
    COUNT(CASE WHEN Originated = 1 AND isFunded = 1 THEN 1 END)
        AS Originated_And_Funded,
    COUNT(CASE WHEN Originated = 1 AND isFunded = 0 THEN 1 END)
        AS Originated_Not_Funded
FROM loans;
    