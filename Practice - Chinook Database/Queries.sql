-- Find all the customer emails that start with "J" and are from gmail.com

select Email from Customers where Email like 'J%@gmail.com';

-- Find the total number of invoices for each customer along with the customer's full name, city and email.

select c.FirstName, c.LastName, c.City, c.Email, count(i.InvoiceID)
from Customers as c join Invoices as i on c.CustomerID = i.CustomerID
group by c.CustomerID;

-- Retrieve a list with the managers last name, and the last name of the employees who report to him or her

select e.LastName as emp, m.LastName as manager 
from Employees as e inner join Employees as m on e.ReportsTo = m.EmployeeID;

-- See if there are any customers who have a different city listed in their billing city versus their customer city.

select count(c.CustomerID) 
from Customers as c inner join Invoices as i on c.CustomerID = i.CustomerID 
where c.City != i.BillingCity;

-- Pull a list of customer ids with the customer’s full name, and address, along with combining their city and country together. 
-- Be sure to make a space in between these two and make it UPPER CASE. (e.g. LOS ANGELES USA)

select CustomerID, FirstName || " " || LastName as FullName,
       Address, upper(City || " " || Country) as CityCountry
from Customers;

-- Create a new employee user id by combining the first 4 letters of the employee’s first name with the first 2 letters of the employee’s last name. 
-- Make the new field lower case and pull each individual step to show your work.

select lower(substr(FirstName, 1, 4)||substr(LastName, 1, 2)) as newID
from Employees;

-- Show a list of employees who have worked for the company for 15 or more years using the current date function. 
-- Sort by lastname ascending.

select LastName, (STRFTIME('%Y', 'now') - STRFTIME('%Y', HireDate)) as WorkYears
from Employees
where WorkYears >= 15
order by LastName asc;



