/*
Covid 19 Data Exploration 
Skills used: Creating Views that would be imported into Microsoft Power BI
*/
--USE PortfolioProject

-- 1. 
--To create the table that showes percentage of daath if infected
CREATE VIEW LocationDeaths AS
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From ['covid-Deaths$']
--Where location like '%states%'
where continent is not null 

-- 2. 
--To create the bar chat to show the total death by continent
CREATE VIEW DeathPercentage AS
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From ['covid-Deaths$']
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location

-- 2. 
--To create the infection by population as per the population using a globe chart
CREATE VIEW InfectionByPopulation AS
Select Location, Population, continent, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From ['covid-Deaths$']
--Where location like '%states%'
Group by Location, Population, continent
