-- AdventureWorks2019 Test 
-- 1. Klientų lojalumo analizė.  
-- Scenarijus: Įmonės rinkodaros komanda 2014 m. birželio 30 d.siekia įvertinti klientų 
-- lojalumą. 
	-- Jūsų užduotis skirta įvertinti klientų elgseną laike. Reikia nustatyti, kurie klientai 
-- pirmą kartą užsakė 2013 metais ir kiek vidutiniškai išleido tais metais, ir ar jie užsakė dar 
-- kartą ir kiekvieno užsakymo sumą 2014 metais.  
-- Naudojamos lentelės: sales_salesorderheader, sales_customer, person_person.  
-- Naudojamos window function: DENSE_RANK().


-- Pas mane klientas, kurio id yra 11012, yra Chloe Thompson, o testo užduoties atsakyme 11012 yra Lauren Walker
WITH Customers_first_order AS (
SELECT
	CustomerID AS 'Customer id',
	DATE(MIN(OrderDate)) AS 'First order date'
FROM 
	sales_salesorderheader
GROUP BY
	`Customer id`
HAVING
	YEAR(DATE(MIN(OrderDate))) = 2013 ),
    
Customers_average_payment_in_2013 AS (
SELECT
	f.`Customer id`,
    f.`First order date`,
    ROUND(AVG(h.TotalDue),2) AS 'Average order amount in 2013'
FROM 
	Customers_first_order f
JOIN 
	sales_salesorderheader h ON f.`Customer id` = h.CustomerID
WHERE
	YEAR(h.OrderDate) = 2013
GROUP BY
	f.`Customer id`),

Customers_orders_in_2014 AS(
SELECT
	h.CustomerID AS 'Customer id',
    h.SalesOrderID AS 'Sales order id',
	DATE(OrderDate) AS 'Order date',
    ROUND(SUM(h.TotalDue),2) AS 'Amount',
	DENSE_RANK() OVER (PARTITION BY h.CustomerID ORDER BY DATE(OrderDate)) AS 'Rank'
FROM 
	Customers_first_order f
JOIN 
	sales_salesorderheader h ON f.`Customer id` = h.CustomerID
WHERE
	YEAR(DATE(OrderDate)) = 2014 
GROUP BY
	`Customer id`,
    `Sales order id`,
    `Order date`)
    


SELECT
	c.CustomerID AS 'Customer id',
    p.FirstName AS 'First name',
    p.LastName AS 'Last name',
    s.`Average order amount in 2013`,
    o.`Sales order id`,
    o.`Order date`,
    o.`Amount`,
    o.`Rank`
FROM 
	Customers_first_order f
JOIN 
	sales_customer c ON f.`Customer id` = c.CustomerID
JOIN
	person_person p ON p.BusinessEntityID = c.CustomerID
LEFT JOIN
	Customers_average_payment_in_2013 s ON f.`Customer id` = s.`Customer id`
LEFT JOIN 
	Customers_orders_in_2014 o ON o.`Customer id` = s.`Customer id`;

-- Aš nesuprantu, kodėl mano pirmas atsakymas nesutampa su Testo užduoties atsakymo užuomina. Man pirmas gavosi 'Bikes', 'Southwest', '7595644.40',o užduoties atsakymo užuominoje, Bikes', 'Australia', '3951062.89'  

-- 2. Produktų pardavimų analizė pagal prekių kategorijas ir regionus  
-- Užduotis: Parašykite užklausą, kuri apskaičiuoja bendrą produktų pardavimų sumą pagal prekių  
-- kategorijas ir rodo rezultatus pagal regionus. Užklausoje turi būti šie stulpeliai:  
-- • Prekės kategorija (iš ProductCategory)  
-- • Regionas (iš SalesTerritory)  
-- • Bendros pardavimų sumos  
-- Užuomina: Susijunkite SalesOrderDetail su Product ir ProductCategory, tada susijunkite  
-- SalesOrderHeader su SalesTerritory naudojant atitinkamus Foreign Keys. Filtruokite  
-- rezultatus pagal 2013 metų pardavimus.  
-- Tikėtinas rezultatas:  
-- • Prekės kategorija  
-- • Regionas  
-- • Bendros pardavimų sumos  
-- Tikėtini rezultatai: 
-- # kategorija, regionas, suma 
-- 'Bikes', 'Australia', '3951062.89' 
-- 40 rows 
-- Testo atsakymo užuominoje sako, kad pirmas atsakymas turi būti'Bikes', 'Australia', '3951062.89', bet aš gaunu Bikes, Northwest, 4918481.23, o Australija su duotais duomenimis yra antroje vietoje
SELECT
	c.Name AS 'Category name',
    t.Name AS 'Territory name',
    ROUND(SUM(d.LineTotal),2) AS 'Total sales'
FROM
	sales_salesterritory t 
JOIN
	sales_salesorderheader h ON h.TerritoryID = t.TerritoryID
JOIN
	sales_salesorderdetail d ON h.SalesOrderID = d.SalesOrderID
JOIN 
	production_product p ON d.ProductID = p.ProductID
JOIN
	production_productsubcategory s ON p.ProductSubcategoryID = s.ProductSubcategoryID
JOIN 
	production_productcategory c ON s.ProductCategoryID = c.ProductCategoryID
WHERE
	YEAR(h.OrderDate) = 2013
GROUP BY
	`Category name`,
    `Territory name`
ORDER BY
	`Total sales` DESC;
    
    
-- 3. Pardavimų departamento darbuotojų našumas  
-- Užduotis: Vadovybė nori įvertinti pardavimų darbuotojų efektyvumą pagal jų priskirtus 
-- departamentus. Naudojant duomenis iš lentelių SalesOrderHeader, Person, 
-- EmployeeDepartmentHistory ir Department, reikia apskaičiuoti bendrą kiekvieno darbuotojo 
-- pardavimų sumą, nustatyti, kuriam departamentui jis priklauso, ir palyginti darbuotojo 
-- rezultatus su to departamento vidurkiu. Skaičiavimui naudojama window function AVG(...) 
-- OVER (PARTITION BY DepartmentID), kuri leidžia gauti departamento vidutinę pardavimų sumą. 
-- Palyginimui reikia pridėti stulpelį, rodantį darbuotojo santykinį našumą procentais, ir tekstinį 
-- įvertinimą (ar darbuotojo rezultatas viršija, atitinka ar nesiekia vidurkio), naudojant CASE.  
-- Tikėtini rezultatai: 
-- +-----+---------+----------+-------------+------------------------+-----------------------------+------------------------+--------------------+ 
-- | id  | vardas  | pavarde  | departamentas | darbuotojo_pardavimai | departamento_pard_vidurkis 
-- | santykinis_nasumas_proc |     vertinimas     | 
-- +-----+---------+----------+-------------+------------------------+-----------------------------+------------------------+--------------------+ 
-- | 
-- +-----+---------+----------+-------------+------------------------+-----------------------------+------------------------+--------------------+ 
-- 17 rows 

WITH Total_sales_per_worker AS(      
SELECT
	h.SalesPersonID AS 'Sales person id',
    p.FirstName AS 'First name',
    p.LastName AS 'Last name',
    d.Name AS 'Department name',
    ROUND(SUM(TotalDue),2)  AS 'Sales person total sales'
FROM	
	sales_salesorderheader h 
JOIN
	person_person p ON h.SalesPersonID = p.BusinessEntityID
JOIN
	humanresources_employee e ON p.BusinessEntityID = e.BusinessEntityID
JOIN
	humanresources_employeedepartmenthistory hi ON e.BusinessEntityID = hi.BusinessEntityID
JOIN 
	humanresources_department d ON hi.DepartmentID = d.DepartmentID
GROUP BY
	`Sales person id`,
    `First name`,
    `Last name`,
    `Department name`),
    
    
Sales_person_average_by_department_comparison AS (
SELECT
	`Sales person id`,
    `First name`,
    `Last name`,
    `Department name`,
    `Sales person total sales`,
    ROUND(AVG(`Sales person total sales`) OVER (PARTITION BY `Department name`),2) AS 'Average sales per department'
FROM
	Total_sales_per_worker),

Sales_person_performance_ratio AS (
SELECT
	`Sales person id`,
    `First name`,
    `Last name`,
    `Department name`,
    `Sales person total sales`,
    `Average sales per department`,
    ROUND(`Sales person total sales` /  `Average sales per department` * 100, 1) AS 'Performance ratio',
    CASE 
		WHEN `Sales person total sales` > `Average sales per department` THEN 'Above average'
        WHEN `Sales person total sales` = `Average sales per department` THEN 'Equal'
        ELSE 'Below average'
        END AS 'Rating'
FROM
	Sales_person_average_by_department_comparison)
    
SELECT
	`Sales person id`,
    `First name`,
    `Last name`,
    `Department name`,
    `Sales person total sales`,
    `Average sales per department`,
    CONCAT(`Performance ratio`,'%') AS 'Performance ratio',
    `Rating`
FROM
	Sales_person_performance_ratio
ORDER BY
	`Sales person total sales` DESC;
    
	
-- 4. Pardavimų analize pagal laikotarpį ir produktų grupes  
-- Užduotis: Parašykite užklausą, kuri apskaičiuoja bendrą pardavimų sumą per metus (2013)  
-- pagal produktų grupes ir pateikia šiuos duomenis:  
-- • Prekės grupė (iš ProductSubcategory)  
-- • Bendros pardavimų sumos  
-- • Pardavimų kiekis  
-- • Vidutinė pardavimo kaina  
-- Užuomina: Susijunkite SalesOrderDetail su Product ir ProductSubcategory. Filtruokite pagal  
-- 2013 metų pardavimus ir apskaičiuokite bendrą pardavimų sumą, kiekį ir vidutinę pardavimo  
-- kainą (rikiuojant desc).. 
-- Tikėtinas rezultatas:  
-- # prekes_grupe, kiekis, pardavimu_suma, vidutine_pardavimo_kaina 
-- 'Mountain Bikes', '11741', '13046301.82', '1111.17' 
-- 35 rows 
    
SELECT
	s.Name AS 'Sub category name',
    SUM(OrderQty) AS 'Sales quantity',
	ROUND(SUM(d.LineTotal),2) AS 'Total revenue',
	ROUND(SUM(d.LineTotal) / SUM(OrderQty),2) AS 'Average sales price'
FROM
	sales_salesorderheader h
JOIN
    sales_salesorderdetail d ON h.SalesOrderID = d.SalesOrderID
JOIN
	production_product p ON d.ProductID = p.ProductID
JOIN
	production_productsubcategory s ON p.ProductSubcategoryID = s.ProductSubcategoryID
WHERE
	YEAR(h.OrderDate) = 2013
GROUP BY
	`Sub category name`
ORDER BY
	`Average sales price` DESC;
    
--  5. Gamybos ir tiekimo grandinės efektyvumo analizė  
-- Užduotis: Parašykite užklausą, kuri apskaičiuoja prekių tiekimo laiką pagal gamintoją.  
-- Pateikite šiuos duomenis:  
-- • Tiekimo grandinės tiekėjo pavadinimas (iš Supplier)  
-- • Prekės pavadinimas (iš Product)  
-- • Laikas nuo užsakymo iki pristatymo (laiko skirtumas tarp OrderDate ir ShipDate)  
-- Užuomina: Susijunkite Product su ProductSupplier, o ProductSupplier su Supplier.  
-- Apskaičiuokite vidutinį tiekimo laiką pagal tiekėją. Išrūšiuokite pagal tiekėją ir produktą. 
-- Tikėtinas rezultatas:  
-- # tiekejas, produktas, vid_pristatymo_laikas 
-- 'Advanced Bicycles', 'Thin-Jam Hex Nut 1', '10' 
-- 'Advanced Bicycles', 'Thin-Jam Hex Nut 10', '10' 
-- 'Advanced Bicycles', 'Thin-Jam Hex Nut 11', '10' 
-- 460 rows. 
    

SELECT
	v.Name AS 'Vendors name',
    p.Name AS 'Product name',
    ROUND(AVG(DATEDIFF(h.ShipDate,h.OrderDate))) AS 'Delivery time'
FROM
	purchasing_purchaseorderheader h
JOIN
	purchasing_purchaseorderdetail d ON h.PurchaseOrderID = d.PurchaseOrderID
JOIN
	production_product p ON d.ProductID = p.ProductID
JOIN
	purchasing_productvendor pv ON p.ProductID = pv.ProductID
JOIN   
	purchasing_vendor v ON pv.BusinessEntityID = v.BusinessEntityID
GROUP BY
	`Vendors name`,
    `Product name`
ORDER BY
	`Vendors name` ASC,
    `Product name` ASC;
    
-- 6. Pardavimų sezoniškumo analizė  
-- Užduotis: Parašykite užklausą, kuri apskaičiuoja mėnesio pardavimus 2013 metais,  
-- naudodamiesi SalesOrderHeader duomenimis. Užklausoje turi būti:  
-- • Mėnuo (iš OrderDate)  
-- • Bendros pardavimų sumos  
-- • Pardavimų kiekis  
-- Užuomina: Filtruokite pagal 2023 metus, naudokite MONTH() funkciją, kad išgautumėte  
-- mėnesio reikšmę ir MONTHNAME() mėnesio pavadinimui, ir apskaičiuokite bendrą pardavimų 
-- sumą bei kiekį kiekvienam mėnesiui.  
-- # menuo, menuo_pavadinimas, pardavimu_kiekis, pardavimu_suma 
-- '1', 'January', '407', '2354903.68' 
-- 12 rows. 

SELECT
	MONTH(OrderDate) AS 'Month',
    MONTHNAME(OrderDate) 'Month name',
    COUNT(SalesOrderID) AS 'Sales quantity',
    CONCAT(ROUND(SUM(TotalDue),2),' $') AS 'Total revenue'
FROM
	sales_salesorderheader 
WHERE
	YEAR(OrderDate) = 2013
GROUP BY
	`Month`,
	`Month name`
    