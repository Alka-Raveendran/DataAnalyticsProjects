


-- Use the Database portfolio --
USE portfolio;



-- Select everythiong from the first table - Coviddeaths --
SELECT * FROM coviddeaths;



-- Select everythiong from the Second Table - covidvaccinations --
SELECT * FROM covidvaccinations;



-- Select data that we are using for the data analysis from Coviddeaths’s table --
SELECT location, date, population, total_cases, new_cases, total_deaths, new_deaths
FROM coviddeaths
ORDER BY 1,2;



-- Shows how Covid19 evolved by time --
SELECT date, location, new_cases, new_deaths, (new_deaths/new_cases)*100 AS PercentageCasesOverTime
FROM coviddeaths
ORDER BY 1;



-- Total cases by total deaths --
SELECT location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 AS PercentageDeathRate
FROM coviddeaths
ORDER BY 1,2;



-- Total cases Vs population --
-- Shows what percent of population got Covid --
SELECT location, date, population,(total_cases/population)*100 AS PercentagePopulationInfected
FROM coviddeaths
ORDER BY 1,2;



-- Total death Vs population --
-- Shows what percent of population died due to Covid --
SELECT location, date, population,(total_deaths/population)*100 AS PercentagePopulationDied
FROM coviddeaths
ORDER BY 1,2;



-- Top 10 countries with highest infection rate compared to the population --
SELECT location, population, MAX(total_cases) AS MaxInfectionCount,
MAX((total_cases/population)*100) AS MaxPercentagePopulationInfected
FROM coviddeaths
GROUP BY location
ORDER BY MaxPercentagePopulationInfected DESC
LIMIT 10;



-- Top 10 countries with highest death Rate compared to the population --
SELECT location, population, MAX(total_deaths) AS MaxDeathCount,
MAX((total_deaths/population)*100) AS MaxPercentageDeathPerPopulation
FROM coviddeaths
GROUP BY location
ORDER BY MaxPercentageDeathPerPopulation DESC
LIMIT 10;



-- Global Count --
-- Continents with the highest death count based on the population --
SELECT continent, population, MAX(total_deaths) AS MaxDeathInContinent,
MAX((total_deaths/population)*100) AS MaxDeathPercentagePerPopulationByContinent
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY MaxDeathPercentagePerPopulationByContinent DESC;



-- Global count of total cases and total deaths across the world --
SELECT SUM(new_cases) AS GlobalCovid19Cases, SUM(new_deaths) AS GlobalCovid19Deaths, (SUM(new_deaths)/SUM(new_cases)) AS GlobalDeathPercentage
FROM coviddeaths
WHERE continent IS NOT NULL;



-- Select data that we are using for the data analysis from Covidvaccinations’s table --
SELECT location, date, new_tests, total_vaccinations, people_vaccinated, new_vaccinations
FROM covidvaccinations
ORDER BY 1,2;



-- Showing all the details about Covid cases, deaths and vaccinations --
SELECT * FROM coviddeaths dea
JOIN covidvaccinations vac 
WHERE dea.date = vac.date AND dea.location = vac.location;



-- Looking at the accumulation of vaccination based on the date and location --
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM coviddeaths dea 
JOIN covidvaccinations vac 
ON dea.date = vac.date AND dea.location = vac.location
WHERE dea.continent IS NOT NULL;


