/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Aggregate Functions, Creating Views

*/

SELECT *
FROM covid-404217.covid_data_set.covid_deaths
ORDER BY 3,4;

SELECT *
FROM covid-404217.covid_data_set.covid_vaccinations
ORDER BY 3,4;

-- Select Data that we are going to be starting with

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid-404217.covid_data_set.covid_deaths
ORDER BY 1,2;

-- Looking Total cases vs Total deaths
-- Shows likelihood of dying if you contract covid in Finland

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM covid-404217.covid_data_set.covid_deaths
WHERE location = 'Finland'
ORDER BY 1,2;

-- Looking at Total Cases vs Population
-- Shows what percentage of population got covid in Finland

SELECT location, date, population, total_cases, (total_cases/population)*100 AS PercentagePopulationInfected
FROM covid-404217.covid_data_set.covid_deaths
WHERE location = 'Finland'
ORDER BY 1,2;

-- Countries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentagePopulationInfected
FROM covid-404217.covid_data_set.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentagePopulationInfected DESC;

-- Countries with highest death rate per population

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM covid-404217.covid_data_set.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location 
ORDER BY TotalDeathCount DESC;

-- Let's break things down by continent
-- Showing continents with highest deaths count per population

SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM covid-404217.covid_data_set.covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Global numbers

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM covid-404217.covid_data_set.covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Looking at total population vs vaccination
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM covid-404217.covid_data_set.covid_deaths dea
JOIN covid-404217.covid_data_set.covid_vaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;

-- Using CTE to perform Calculation on Partition By in previous query

WITH PopvsVac AS 
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM covid-404217.covid_data_set.covid_deaths dea
JOIN covid-404217.covid_data_set.covid_vaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated/population)*100 AS RollingPercent
FROM PopvsVac;

-- Creating View to store data for later visualizations

CREATE VIEW covid_data_set.PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM covid-404217.covid_data_set.covid_deaths dea
JOIN covid-404217.covid_data_set.covid_vaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

SELECT *
FROM covid-404217.covid_data_set.PercentPopulationVaccinated;

-- Shows what percentage of population got covid in Finland
CREATE VIEW covid_data_set.PersentInfected AS
SELECT location, date, population, total_cases, (total_cases/population)*100 AS PercentagePopulationInfected
FROM covid-404217.covid_data_set.covid_deaths
WHERE location = 'Finland'
ORDER BY 1,2;

--  Countries with highest death rate per population
CREATE VIEW covid_data_set.DeathRate AS
SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM covid-404217.covid_data_set.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location 
ORDER BY TotalDeathCount DESC;

--  Countries with highest infection rate compared to population
CREATE VIEW covid_data_set.PopulationInfected AS
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentagePopulationInfected
FROM covid-404217.covid_data_set.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentagePopulationInfected DESC;