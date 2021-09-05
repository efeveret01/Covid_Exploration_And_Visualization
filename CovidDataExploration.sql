/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

use PortfolioProject

----View whole Data
Select *
From PortfolioProject..['covid-Deaths$']
Where continent is not null 
order by 3,4

-- Select Data that we are going to be starting with
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..['covid-Deaths$']
Where continent is not null 
order by 1,2

-- Total Cases vs Total Deaths in United Kingdom
-- Shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..['covid-Deaths$']
Where location like '%kingdom%'
and continent is not null 
order by 1,2

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..['covid-Deaths$']
Where location like '%kingdom%'
order by 1,2

-- Countries and their Highest Infection Rate compared to Population
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population)*100) as PercentPopulationInfected
From PortfolioProject..['covid-Deaths$']
--Where location like '%kingdom%'
Group by Location, Population
order by PercentPopulationInfected desc

-- Countries and their Highest Death Count per Population

Select Location, MAX(Total_deaths) as TotalDeathCount
From PortfolioProject..['covid-Deaths$']
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..['covid-Deaths$'] dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3