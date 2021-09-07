SET NAMES 'utf8' COLLATE 'utf8_general_ci';

create database zomato;

use zomato;

CREATE TABLE country (
    country_code INT,
    country VARCHAR(100),
    CONSTRAINT code_pk PRIMARY KEY (country_code)
);

CREATE TABLE zomato (
    RestaurantID INT,
    RestaurantName VARCHAR(500),
    CountryCode INT,
    City VARCHAR(150),
    Address VARCHAR(500),
    Locality VARCHAR(300),
    LocalityVerbose VARCHAR(500),
    Longitude INT,
    Latitude INT,
    Cuisines VARCHAR(200),
    AverageCostfortwo INT,
    Currency VARCHAR(200),
    HasTableBooking VARCHAR(3),
    HasOnlineDelivery VARCHAR(3),
    IsDeliveringNow VARCHAR(3),
    SwitchToOrderMenu VARCHAR(3),
    PriceRange INT,
    AggregateRating INT,
    RatingColor VARCHAR(50),
    RatingText VARCHAR(50),
    Votes INT,
    CONSTRAINT code_fk FOREIGN KEY (CountryCode)
        REFERENCES country (country_code)
);


ALTER TABLE `zomato` CHANGE RestaurantName RestaurantName BLOB;
ALTER TABLE zomato CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `zomato` CHANGE RestaurantName RestaurantName VARCHAR(64);

/*PriceRange vs Aggregate Rating*/
SELECT 
    PriceRange,
    AVG(AggregateRating) AS AvgRatingBasedOnPriceRange
FROM
    zomato
GROUP BY pricerange
ORDER BY pricerange ASC;
/*Int: Higher the price range higher the avgRating.*/



/*Customer engagement*/
SELECT DISTINCT
    city,
    country,
    SUM(votes) AS TotalVotes,
    COUNT(RestaurantID) AS cntRes,
    COUNT(RestaurantID) / SUM(votes) AS percentage
FROM
    country,
    zomato
WHERE
    zomato.CountryCode = country.country_code
GROUP BY city
HAVING cntRes > 5
ORDER BY percentage DESC;

/*Which country,city has most number of restaurant?*/
SELECT DISTINCT
    city, country, COUNT(RestaurantID) AS TotalNoOfRestaurant
FROM
    country,
    zomato
WHERE
    zomato.CountryCode = country.country_code
GROUP BY city
ORDER BY TotalNoOfRestaurant;
/*In INDIA New Delhi has the most number of restaurant.*/



/*Compare total number of res with avg rating of city(Bottom to top)*/
SELECT DISTINCT
    city,
    country,
    COUNT(RestaurantID) AS TotalNoOfRestaurant,
    AVG(AggregateRating)
FROM
    country,
    zomato
WHERE
    zomato.CountryCode = country.country_code
        AND country = 'india'
GROUP BY city
ORDER BY AVG(AggregateRating) ASC;


/*Compare total number of res with avg rating of city(top to bottom)*/
SELECT DISTINCT
    city,
    country,
    COUNT(RestaurantID) AS TotalNoOfRestaurant,
    AVG(AggregateRating)
FROM
    country,
    zomato
WHERE
    zomato.CountryCode = country.country_code
        AND country = 'india'
GROUP BY city
ORDER BY AVG(AggregateRating) desc;



/*City | RestaurantName | AggregateRating*/
SELECT 
    city, RestaurantName, AggregateRating
FROM
    zomato,
    country
WHERE
    zomato.CountryCode = country.country_code
        AND country = 'india'
ORDER BY AggregateRating DESC;



/*Does count of cusisens depends on rating?*/
SELECT 
    Cuisines,
    LENGTH(Cuisines) - LENGTH(REPLACE(Cuisines, ',', '')) + 1 AS NoOfCuisines,
    AggregateRating
FROM
    zomato;
/*More no. of cuisines does not mena avg rating.*/


/*city | country | count(Has Delivery?)*/
SELECT 
    country, city, COUNT(HasOnlineDelivery) AS NoOfRestaurant
FROM
    zomato,
    country
WHERE
    zomato.CountryCode = country.country_code
        AND HasOnlineDelivery = 'Yes'
        AND city IS NOT NULL
        AND country IS NOT NULL
GROUP BY city
ORDER BY NoOfRestaurant;
/*Int: Only UAE and India has online delivery service available out of which New Delhi has most no of restaurant having this service.*/


/*Table booking service*/
SELECT 
    country, city, COUNT(HasTableBooking) AS NoOfRestaurant
FROM
    zomato,
    country
WHERE
    zomato.CountryCode = country.country_code
        AND HasTableBooking = 'Yes'
        AND city IS NOT NULL
        AND country IS NOT NULL
GROUP BY city
ORDER BY NoOfRestaurant;
/*Int:Very Few has table booking service available out of which New Delhi has most no of restaurant having this service.*/



/*What is the avg of average cost of two for higher rated restaurant(India only)?*/
SELECT 
    country,
    city,
    RestaurantName,
    avg(AverageCostForTwo),
    AggregateRating
FROM
    zomato,
    country
WHERE
    AggregateRating = (SELECT 
            MAX(AggregateRating)
        FROM
            zomato)
        AND AverageCostForTwo > 0
        AND country = 'india'
        AND zomato.CountryCode = country.country_code
GROUP BY city
ORDER BY AverageCostForTwo;
/*Average Cost for two in india does not reflect rating.Given the rating as 5 avg cost varies between 150 to 5000*/

select * from country;



















