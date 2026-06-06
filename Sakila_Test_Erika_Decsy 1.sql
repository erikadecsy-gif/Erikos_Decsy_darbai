-- EEEEEEEEEEEEEEEEEEEEEE		XXXXXXX       XXXXXXX		               AAA               	MMMMMMMM               MMMMMMMM
-- E::::::::::::::::::::E		X:::::X       X:::::X		              A:::A              	M:::::::M             M:::::::M
-- E::::::::::::::::::::E		X:::::X       X:::::X		             A:::::A             	M::::::::M           M::::::::M
-- EE::::::EEEEEEEEE::::E		X::::::X     X::::::X		            A:::::::A            	M:::::::::M         M:::::::::M
--   E:::::E       EEEEEE		XXX:::::X   X:::::XXX		           A:::::::::A           	M::::::::::M       M::::::::::M
--   E:::::E             		   X:::::X X:::::X   		          A:::::A:::::A          	M:::::::::::M     M:::::::::::M
--   E::::::EEEEEEEEEE   		    X:::::X:::::X    		         A:::::A A:::::A         	M:::::::M::::M   M::::M:::::::M
--   E:::::::::::::::E   		     X:::::::::X     		        A:::::A   A:::::A        	M::::::M M::::M M::::M M::::::M
--   E:::::::::::::::E   		     X:::::::::X     		       A:::::A     A:::::A       	M::::::M  M::::M::::M  M::::::M
--   E::::::EEEEEEEEEE   		    X:::::X:::::X    		      A:::::AAAAAAAAA:::::A      	M::::::M   M:::::::M   M::::::M
--   E:::::E             		   X:::::X X:::::X   		     A:::::::::::::::::::::A     	M::::::M    M:::::M    M::::::M
--   E:::::E       EEEEEE		XXX:::::X   X:::::XXX		    A:::::AAAAAAAAAAAAA:::::A    	M::::::M     MMMMM     M::::::M
-- EE::::::EEEEEEEE:::::E		X::::::X     X::::::X		   A:::::A             A:::::A   	M::::::M               M::::::M
-- E::::::::::::::::::::E		X:::::X       X:::::X		  A:::::A               A:::::A  	M::::::M               M::::::M
-- E::::::::::::::::::::E		X:::::X       X:::::X		 A:::::A                 A:::::A 	M::::::M               M::::::M
-- EEEEEEEEEEEEEEEEEEEEEE		XXXXXXX       XXXXXXX		AAAAAAA                   AAAAAAA	MMMMMMMM               MMMMMMMM

/*
	[LT] Žemiau rasite pateiktas užklausas ataskaitoms. Kiekviena ataskaita yra finalinės ataskaitos 
		žingsnis, todėl neskubėkite pereiti prie sekančio uždavinio, kol neužbaigėte prieš tai buvusio,
        nes turint neteisingą duomenų šaltinį gali kisti tolimesni rezultatai. Kiekvieno uždavinio 
        rezultatai turi būti išsaugoti vis naujoje laikinoje lentelėje pagal pavadinimo
        šabloną 'temp_TaskX'
		Vertinimas - Viso 100 taškų
			* Teisingas sprendimas - 15 taškų
            * Kodo kultūra (formatavimas) - 5 taškai       
*/
-- #####################################################################################################
-- #####################################################################################################
DROP TABLE IF EXISTS temp_Task1;																	  ##
DROP TABLE IF EXISTS temp_Task2;	-- [EN] CLEAR ENVIRONMENT, DO NOT CHANGE ANYTHING				  ##
DROP TABLE IF EXISTS temp_Task3;																	  ##
DROP TABLE IF EXISTS temp_Task4;	-- [LT] APLINKOS PARUOŠIMAS DARBUI, NIEKO KEISTI NEREIKIA		  ##
DROP TABLE IF EXISTS temp_Task5;																	  ##
-- #####################################################################################################
-- #####################################################################################################
/*
THINGS YOU WILL NEED
	SELECT: Used to specify the columns you want to retrieve from a database table.
	FROM: Specifies the table or tables from which to retrieve the data.
	JOIN: Combines rows from two or more tables based on a related column between them.
	WHERE: Filters the rows in a table based on specified conditions.
	GROUP BY: Groups the rows in a table based on specified columns, often used with aggregate functions.
	ORDER BY: Sorts the result set in ascending or descending order based on specified columns.
	CASE: Evaluates a set of conditions and returns a result based on the first condition that is met.
	SUBQUERY: A query nested within another query, used to retrieve data for a specific condition.
	CREATE TEMPORARY TABLE: Creates a temporary table that exists only for the duration of a session or transaction.
    DISTINCT: Helps to indentify unique values in the list.

FUNCTIONS:
	SUM(): Calculates the sum of values in a specified column.
    COUNT(): Counts the number of rows or non-null values in a specified column.
	AVG(): Calculates the average of values in a specified column.
	MAX(): Retrieves the maximum value from a specified column.
	MIN(): Retrieves the minimum value from a specified column.
	CONCAT(): Concatenates two or more strings together.
	ROUND(): Rounds a numeric value to a specified number of decimal places.
    DATEDIFF(): Shows difference is days between two dates.
*/
-- #####################################################################################################
-- #####################################################################################################
																							-- TASK 1 
-- [EN] We are trying to understand how our current stores are doing. We need a report in which
	-- visible number of opened stores, number of sales during the entire period, amount earned, average
     -- one-time payment and how many different customers have shopped in the store. It should also
     -- see how long the store has been open. It is not necessary to see more than 5 at most in the list
     -- the stores that earned the most sales.
-- [LT] Bandome suprasti kaip sekasi mūsų dabartinėms parduotuvėms. Mums reikia ataskaitos kurioje
	-- matytųsi atidarytų parduotuvių numeris, pardavimų skaičius per visą periodą, uždirbta suma, vidutinis 
    -- vienkartinis mokėjimas ir kiek skirtingų klientų buvo apsiprekinę parduotuvėje. Taip pat reiktų 
    -- matyti kiek laiko jau dirba parduotuvė. Sąraše nėra būtina matyti daugiau nei 5 daugiausiai 
    -- uždirbusių ir daugiausiai pardavimų atlikusių parduotuvių.
    
-- Tables/lentelės (not in order/ne iš eilės)
	-- store
    -- payment
    -- staff
    -- address

-- SOLUTION
CREATE TEMPORARY TABLE temp_Task1
SELECT
	st.store_id AS 'Store',
    COUNT(p.payment_id) AS 'Number of Sales',
    ROUND(SUM(p.amount)) AS 'Total Profit',
	ROUND(AVG(p.amount),2) AS 'Average Payment',
	COUNT(DISTINCT customer_id) AS 'Unique Customers',
    DATEDIFF(MAX(p.payment_date),MIN(p.payment_date)) AS 'Number of Days in Business'
FROM 
	payment p
JOIN
	staff s ON p.staff_id = s.staff_id
JOIN
	store st ON s.store_id = st.store_id
JOIN
	address a ON st.address_id = a.address_id
GROUP BY
	`Store`
ORDER BY
	`Total Profit` DESC
LIMIT 5;
    
    
    
    

-- REPORT
SELECT * 			-- [DO NOT CHANGE]
FROM temp_Task1;	-- [NEKEISTI]

-- EXPECTED RESULSTS - 2 rows
-- || Store 	|| Number Of Sales 	|| Total Profit || Average payment 	|| Unique customers || Number Of Days In Business 	|| 
-- || 2 		|| 7990 			|| 33924 		|| 4.25 			|| 599 				|| 266							|| 
-- || 1 		|| 8054 			|| 33483 		|| 4.16  			|| 599				|| 266							||
-- #####################################################################################################
-- #####################################################################################################
																							-- TASK 2 
-- [EN] Okay, but in order to assess the need more accurately, we need to calculate the 
	-- average profit per customer and average profit per day (using the entire working period). 
    -- Oh, and do the math at the same time how many different movies we have in each store. Where money 
    -- is involved, indicate the amount with a dollar sign, and list the results from the highest 
    -- profit per customer.
-- [LT] Gerai, bet kad tiksliau įsivertintumėme poreikį reikia iškart išskaičiuoti vidutinį pelną per
	-- klientą ir vidutinį pelną per dieną (vartinant visą darbo periodą). Ai ir tuo pačiu paskaičiuokite 
    -- kiek skirtingų filmų turime kiekvienoje parduotuvėje. Ten kur kalbama apie pinigus, nurodykite sumą
    -- su dolerio ženklu, o rezultatus pateikite nuo didžiausio pelno per klientą.
    
-- Tables/lentelės (not in order/ne iš eilės)
    -- temp_Task1
    -- inventory
    -- SOLUTION
CREATE TEMPORARY TABLE temp_Task2
SELECT
	t.`Store`,
    CONCAT('$ ',t.`Total Profit`) 'AS Total Profit',
    t.`Unique Customers`,
    CONCAT('$ ', ROUND(t.`Total Profit`/ t.`Unique Customers`,2)) AS 'Average Profit Per Customer',
    t.`Number of Days in Business`,
    CONCAT('$ ', ROUND(t.`Total Profit`/ `Number of Days in Business`,2)) AS 'Average Profit Per Day',
    COUNT(DISTINCT i.film_id)  AS 'Number Of Unique Movies'
FROM 
	temp_Task1 t
JOIN 
	inventory i ON t.`Store` = i.store_id
GROUP BY
	t.`Store`,
    t.`Total Profit`,
    t.`Unique Customers`,
    t.`Number of Days in Business`
ORDER BY
	`Average Profit Per Customer` DESC;






-- REPORT
SELECT *			-- [DO NOT CHANGE]
FROM temp_Task2;	-- [NEKEISTI]

-- EXPECTED RESULSTS - 2 rows
-- || Store || Total Profit || Unique Customers ||	Average Profit Per Customer ||	Number Of Days In Business	||	Average Profit Per Day	|| 	Number Of Unique Movies ||
-- || 2		|| $ 33924		|| 599 				||	$ 56.63						||	266							||	$ 127.53				||	762						||
-- || 1 	|| $ 33483 		|| 599 				||	$ 55.90						||	266							||	$ 125.88				||	759						||
-- #####################################################################################################
-- #####################################################################################################
																							-- TASK 3 
-- [EN] Very good reports - keep it up! We decided to open a new store, now we plan to order inventory.
	-- We want to avoid films that are already not making a profit in others stores. Please show the 150
    -- movies that earned the least. Rate only those movies that are not in the "Horror" or "Sports" 
    -- category and are released in 2006 or older, 135 min or longer. We need movie id, title + genre, 
    -- gross. However, some movies naturally earns less, so we should investigate whether we know why 
    -- the film could have been niche.
		-- If the genre of the film is horror, enter [Horror movies always has lower rent.]
		-- If the movie genre is sport and the rating is R - enter [Sport with an R rating is a bad decision.]
		-- If the film is longer than 170 min - enter [Longer movies tend to be rented less.]
		-- If the reason is unknown - enter [Unknown]
	-- Sort the answers in the same order as given in the description according to the presumed cause and
	-- maximum profit.
-- [LT] Labai geros ataskaitos - taip ir toliau! Nusprendėme atidaryti naują parduotuvę, dabar 
	-- planuojame užsakyti inventorių. Norime išvengti filmų kurie jau dabar neatneša pelno kitose 
    -- parduotuvėse. Prašau parodykite 150 filmų kurie uždirbo mažiausiai. Vertinkite tik tuos filmus 
    -- kurie nėra "Horror" arba "Sports" kategorijoje ir yra išleisti 2006 metais arba jie ilgesni už
    -- 135 min. Mums reikia filmo ID, pavadinimo + žanras, bendro pelno. Visgi, kaikurie filmai natūraliai
    -- uždirba mažiau, tad reiktų patyrinėti ar žinome kodėl filmas galėjo būti nišinis.
		-- Jeigu filmo žanras siaubo - įrašykite [Horror movies always has lower rent.]
		-- Jeigu filmo žanras sportas ir reitingas R - įrašykite [Sport with an R rating is a bad decision.]
        -- Jeigu filmas ilgesnis nei 170 min - įrašykite [Longer movies tend to be rented less.]
        -- Jeigu priežastis nežinoma - įrašykite [Unknown]
	-- Atsakymus surūšiuokite ta pačia eilės tvarka kaip pateikta apraše pagal numanomą priežastį ir 
    -- didžiausią pelną.
    
-- Tables/lentelės (not in order/ne iš eilės)
	-- film
	-- payment
	-- category
    -- rental
    -- inventory
    -- film_category
    
-- SOLUTION
-- DROP TEMPORARY TABLE IF EXISTS temp_Task3;
CREATE TEMPORARY TABLE temp_Task3 
SELECT
	f.film_id AS 'Film ID',
    CONCAT(f.title,' ', '( ' , c.name ,' )') AS 'Movie',
    SUM(p.amount) AS 'Total Profit',
		CASE
			WHEN c.name = 'Horror' THEN 'Horror movies always has lower rent.' 
            WHEN c.name = 'Sports' AND f.rating = 'R' THEN 'Sport with an R rating is a bad decision.' 
            WHEN f.length > 170 THEN 'Longer movies tend to be rented less.' 
            ELSE 'Unknown' 
			END AS 'Possible Reason'
FROM 
	payment p
JOIN
	rental r ON p.rental_id = r.rental_id
JOIN 
	inventory i ON r.inventory_id = i.inventory_id
JOIN 
	film f ON i.film_id = f.film_id
JOIN 
	film_category fc ON f.film_id = fc.film_id
JOIN 
	category c ON fc.category_id = c.category_id
WHERE
    (c.name NOT IN ('Horror', 'Sports')
	AND f.release_year = 2006)
    OR f.length > 135
GROUP BY
	`Film ID`,
    `Movie`,
    `Possible Reason`
ORDER BY 
    CASE `Possible Reason`
        WHEN 'Horror movies always has lower rent.'      THEN 1
        WHEN 'Sport with an R rating is a bad decision.' THEN 2
        WHEN 'Longer movies tend to be rented less.'     THEN 3
        ELSE 4
    END,
    `Total Profit` DESC
LIMIT 150;



    

-- REPORT
SELECT *			-- [DO NOT CHANGE]
FROM temp_Task3;	-- [NEKEISTI]

-- EXPECTED RESULSTS - 150 rows
-- || film_id 	|| Movie 									|| Total Profit 	|| Possible Reason 					||
-- || 35		|| ARACHNOPHOBIA ROLLERCOASTER ( Horror )	|| 114.76	|| Horror movies always has lower rent.		||
-- || 665		|| PATTON INTERVIEW ( Horror )				|| 102.77	|| Horror movies always has lower rent.		||
-- || 749 		|| RULES HUMAN ( Horror )					|| 101.84	|| Horror movies always has lower rent.		||
-- || ...		|| ...										|| ... 		|| ...										||
-- #####################################################################################################
-- #####################################################################################################
																							-- TASK 4  
-- [EN] Great, we know which movies are unprofitable and should be avoided. So now you need to find out
	-- which movies to order for the new store! Get the list of 25 highest grossing movies, their
     -- id + title, category and total profit. Make sure none fall into this list a movie from the past
     -- list with the reason 'Unknown'!!!
-- [LT] Puiku, žinome kurie filmai yra nepelningi ir jų reikia vengti. Todėl dabar reikia sužinoti 
	-- kokius filmus užsakyti naujai parduotuvei! Gaukite 25 pelingiausių filmų sąrašą, jų 
    -- id + pavadinimą, kategoriją ir bendrą pelną. Užtikrinkite, kad į šį sąrašą nepakliūtų nė vienas
    -- filmas iš praeito sąrašo su priežastimi 'Unknown'!!!
        
-- Tables/lentelės (not in order/ne iš eilės)
	-- film
	-- payment
	-- category
    -- rental
    -- temp_Task3
    -- inventory
    -- film_category
                                                                                            
-- SOLUTION
 -- DROP TEMPORARY TABLE IF EXISTS temp_Task4
CREATE TEMPORARY TABLE temp_Task4
SELECT 
    concat('( ', f.film_id,' ) ', f.title) AS 'Movie',
	c.name AS 'Category name',
    SUM(p.amount) AS 'Total profit'
FROM 
	payment p
JOIN 
	rental r ON p.rental_id = r.rental_id
JOIN 
	inventory i ON r.inventory_id = i.inventory_id
JOIN 
	film f ON i.film_id = f.film_id
JOIN 
	film_category fc ON f.film_id = fc.film_id
JOIN 
	category c ON fc.category_id = c.category_id
LEFT JOIN 
	temp_Task3 t ON t.`Film ID` = f.film_id AND t.`Possible Reason` = 'Unknown'
WHERE
	t.`Film ID` IS NULL
GROUP BY
	f.film_id,
	`Movie`,
    `Category name`
ORDER BY
	`Total profit` DESC,
    `Category name` asc
LIMIT 25;

    
    
SELECT *			-- [DO NOT CHANGE]
FROM temp_Task4;	-- [NEKEISTI]

-- EXPECTED RESULSTS - 25 rows
-- ||	Movie					|| 	Category Name	||	Total Profit 	||
-- || 	(973) WIFE TURN			|| 	Documentary 	||	223.69 			||
-- || 	(897) TORQUE BOUND		||	Drama 			||	198.72 			||
-- || 	(460) INNOCENT USUAL	|| 	Foreign 		||	191.74 			||
-- || ...						|| ... 				||	... 			||
-- #####################################################################################################
-- #####################################################################################################
																							-- TASK 5
-- [LT] Great! We know what movies we want to buy. Now what remains is to create an advertisement. 
	-- For each category we will create a stand-alone ad promoting the most popular movie. Select each
    -- category the highest grossing film ever!
-- [LT] Puiku! Žinome kokių filmų norime užsipirkti. Dabar liko sukurti reklamą. Kiekvienai kategorijai
	-- sukursime atskirą reklamą reklamuojančią populiariausią filmą. Išrinkite kiekvienos kategorijos
    -- daugiausiai uždirbusį filmą!
    
-- Tables/lentelės (not in order/ne iš eilės)
	-- temp_Task4
    -- Maybe another temp table/gal papildoma temp lentelė [Error Code: 1137. Can't reopen table: 't4']
		-- [EN] You could not use a single temp table twice in the same query.
		-- [LT] Vienoje užklausoje 2 kartus negalima naudoti tos pačios temp lentelės.
    
-- SOLUTION
DROP TEMPORARY TABLE IF EXISTS MAX_profit_per_film_category;
CREATE TEMPORARY TABLE MAX_profit_per_film_category
SELECT
	`Category name`,
    MAX(`Total profit`) AS 'Total profit'
FROM
	temp_Task4 
GROUP BY
	`Category name`;

CREATE TEMPORARY TABLE temp_Task5
SELECT
	m.`Category name`,
    t.`Movie`,
    CONCAT('$' ,m.`Total profit`) AS'Total profit'
FROM 
	temp_Task4 t
JOIN 
	MAX_profit_per_film_category m ON t.`Category name` = m.`Category name` AND t.`Total profit` = m.`Total profit`
ORDER BY
	`Total profit` DESC;
    
    
-- REPORT
SELECT *			-- [DO NOT CHANGE]
FROM temp_Task5;	-- [NEKEISTI]
-- EXPECTED RESULSTS - 13 rows
-- || Category Name	|| Movie					||	Total Profit 	|| 
-- || Documentary	|| (973) WIFE TURN 			||	$ 223.69		|| 
-- || Drama			|| (897) TORQUE BOUND		||	$ 198.72		|| 
-- || Foreign		|| (460) INNOCENT USUAL 	||	$ 191.74		|| 
-- || ...			|| ... 						||	...				||
-- #########################################################################################################################################################################################################
-- #########################################################################################################################################################################################################
-- #########################################################################################################################################################################################################
-- #########################################################################################################################################################################################################
																																										
--         GGGGGGGGGGGGG	     OOOOOOOOO     		     OOOOOOOOO     		DDDDDDDDDDDDD             	LLLLLLLLLLL            		UUUUUUUU     UUUUUUUU	       CCCCCCCCCCCCC	KKKKKKKKK    KKKKKKK
--      GGG::::::::::::G	   OO:::::::::OO   		   OO:::::::::OO   		D::::::::::::DDD          	L:::::::::L            		U::::::U     U::::::U	    CCC::::::::::::C	K:::::::K    K:::::K
--    GG:::::::::::::::G	 OO:::::::::::::OO 		 OO:::::::::::::OO 		D:::::::::::::::DD        	L:::::::::L            		U::::::U     U::::::U	  CC:::::::::::::::C	K:::::::K    K:::::K
--   G:::::GGGGGGGG::::G	O:::::::OOO:::::::O		O:::::::OOO:::::::O		DDD:::::DDDDD:::::D       	LL:::::::LL            		UU:::::U     U:::::UU	 C:::::CCCCCCCC::::C	K:::::::K   K::::::K
--  G:::::G       GGGGGG	O::::::O   O::::::O		O::::::O   O::::::O		  D:::::D    D:::::D      	  L:::::L              		 U:::::U     U:::::U 	C:::::C       CCCCCC	KK::::::K  K:::::KKK
-- G:::::G              	O:::::O     O:::::O		O:::::O     O:::::O		  D:::::D     D:::::D     	  L:::::L              		 U:::::D     D:::::UC	:::::C              	  K:::::K K:::::K   
-- G:::::G              	O:::::O     O:::::O		O:::::O     O:::::O		  D:::::D     D:::::D     	  L:::::L              		 U:::::D     D:::::UC	:::::C              	  K::::::K:::::K    
-- G:::::G    GGGGGGGGGG	O:::::O     O:::::O		O:::::O     O:::::O		  D:::::D     D:::::D     	  L:::::L              		 U:::::D     D:::::UC	:::::C              	  K:::::::::::K     
-- G:::::G    G::::::::G	O:::::O     O:::::O		O:::::O     O:::::O		  D:::::D     D:::::D     	  L:::::L              		 U:::::D     D:::::UC	:::::C              	  K:::::::::::K     
-- G:::::G    GGGGG::::G	O:::::O     O:::::O		O:::::O     O:::::O		  D:::::D     D:::::D     	  L:::::L              		 U:::::D     D:::::UC	:::::C              	  K::::::K:::::K    
-- G:::::G        G::::G	O:::::O     O:::::O		O:::::O     O:::::O		  D:::::D     D:::::D     	  L:::::L              		 U:::::D     D:::::UC	:::::C              	  K:::::K K:::::K   
--  G:::::G       G::::G	O::::::O   O::::::O		O::::::O   O::::::O		  D:::::D    D:::::D      	  L:::::L         LLLLLL	 U::::::U   U::::::U 	C:::::C       CCCCCC	KK::::::K  K:::::KKK
--   G:::::GGGGGGGG::::G	O:::::::OOO:::::::O		O:::::::OOO:::::::O		DDD:::::DDDDD:::::D       	LL:::::::LLLLLLLLL:::::L	 U:::::::UUU:::::::U 	 C:::::CCCCCCCC::::C	K:::::::K   K::::::K
--    GG:::::::::::::::G	 OO:::::::::::::OO 		 OO:::::::::::::OO 		D:::::::::::::::DD        	L::::::::::::::::::::::L 	 UU:::::::::::::UU  	  CC:::::::::::::::C	K:::::::K    K:::::K
--      GGG::::::GGG:::G	   OO:::::::::OO   		   OO:::::::::OO   		D::::::::::::DDD          	L::::::::::::::::::::::L   	 	UU:::::::::UU    	    CCC::::::::::::C	K:::::::K    K:::::K
--         GGGGGG   GGGG	     OOOOOOOOO     		     OOOOOOOOO     		DDDDDDDDDDDDD             	LLLLLLLLLLLLLLLLLLLLLLLL     	   UUUUUUUUU      	       CCCCCCCCCCCCC	KKKKKKKKK    KKKKKKK