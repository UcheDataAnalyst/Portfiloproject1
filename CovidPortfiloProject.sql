select *
from [Protfilo Project].dbo.[CovidDeaths]
where continent is not null
order by 3,4


--select *
--from [dbo].[CovidVaccinationinfo] as CovidVaccinations
--order by 3,4


select location, date,  total_cases, new_cases, total_deaths,population
from [dbo].[CovidDeaths] 
 order by 1,2  



--looking for the total death pecentage 
--shoes lkehood f deing if you contract covid in your country 
select location, date,  total_cases, total_deaths, (total_deaths /total_cases) * 100 as DEathPercentage
from [Protfilo Project].dbo.[CovidDeaths]
where location like '%state%' 
 order by 1,2  


 --looking at total cases  vs population
 --shows us the percentage of population got covid
 select location, date,  total_cases, total_deaths,population, (total_cases /population) * 100 as Percentageofpopulationinfected
from [Protfilo Project].dbo.[CovidDeaths]
--where location like '%state%' 
 order by 1,2  



--looking at countries with highest infection rate compared tro populatio 
 select location,population,Max(total_cases) as HIghestInfectionCount, Max((total_cases /population)) * 100 as Percentageofpopulationinfected
from [Protfilo Project].dbo.[CovidDeaths]
--where location like '%state%' 
group by population,location
 order by Percentageofpopulationinfected desc




 --showing the countries with highest death count vs population 
 select location,Max(cast (Total_Deaths as int)) as TotaldeathsCounts
 from [Protfilo Project].dbo.[CovidDeaths]
 where continent is not null
 group by location
 order by TotaldeathsCounts desc



 --lets break things down by conttinet
 select continent,Max(cast (Total_Deaths as int)) as TotaldeathsCounts
 from [Protfilo Project].dbo.[CovidDeaths]
 where continent is not null
 group by continent
 order by TotaldeathsCounts desc

 --select upper(location),population as countrypopulation
 --from [Protfilo Project].dbo.[CovidDeaths]
 --where continent is not null
 --group by location,population
 --order by population desc 

 
--select sum(new_cases) AS TOTAL_CASES, sum(cast(new_deaths as int)) AS TOTAL_DEATHS
--from [Protfilo Project].dbo.[CovidDeaths]
--where continent is NOT null 
--group by new_cases,new_deaths
-- order by 1,2  


SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as Rollingpeoplevac
FROM [Protfilo Project].dbo.CovidDeaths as dea
join [Protfilo Project].dbo.CovidVaccination as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3 


---CtE
with PopvsVac(contintent,location,date,population,new_vaccination,Rollingpeoplevac)
as
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as Rollingpeoplevac
FROM [Protfilo Project].dbo.CovidDeaths as dea
join [Protfilo Project].dbo.CovidVaccination as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3 

)
select *, (Rollingpeoplevac/population)*100
from Popvsvac


create view TotalDeaths as
 select continent,Max(cast (Total_Deaths as int)) as TotaldeathsCounts
 from [Protfilo Project].dbo.[CovidDeaths]
 where continent is not null
 group by continent
 --order by TotaldeathsCounts desc