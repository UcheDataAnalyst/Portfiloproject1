--datacleaning project 
select *
from [Protfilo Project].dbo.Natdata$


--standarize salaDate

select SaleDate
from Natdata$

ALTER TABLE Natdata$
add SaleDateConverted Date;

update Natdata$
set SaleDateConverted = convert(Date, SaleDate)

select SaleDateConverted,Convert(date,SaleDateConverted) as SaleDate2
from Natdata$
--replacing Address/adding address to dulpicated customer info

select *
from Natdata$
--where PropertyAddress is null 
order by ParcelID

--populayed propertyaddress 
select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from Natdata$ a
join Natdata$ b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is not null 



update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from Natdata$ a
join Natdata$ b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <>b.[UniqueID ]
where a.PropertyAddress is null 

--breaking up state,cit from propertyaddress 
select 
substring (PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)  as Address
,substring (PropertyAddress, CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress))  as Address
from [Protfilo Project].dbo.Natdata$



alter table [Protfilo Project].dbo.Natdata$
Add PropertysplitAddress nvarchar(255)


update [Protfilo Project].dbo.Natdata$
set PropertysplitAddress =  substring (PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) 



alter table [Protfilo Project].dbo.Natdata$
Add PropertysplitCity nvarchar(255)


update [Protfilo Project].dbo.Natdata$
set PropertysplitCity = substring (PropertyAddress, CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress))


--breaking up  city,state and personal adrress from the ownersaddress 
select OwnerAddress
from Natdata$

select
PARSENAME (replace(OwnerAddress, ',','.') ,1), 
PARSENAME (replace(OwnerAddress, ',','.') ,2),
PARSENAME (replace(OwnerAddress, ',','.') ,3)
from Natdata$

alter table [Protfilo Project].dbo.Natdata$
Add ownersplitAddress nvarchar(255)


update [Protfilo Project].dbo.Natdata$
set ownersplitAddress =  PARSENAME (replace(OwnerAddress, ',','.') ,3)

alter table [Protfilo Project].dbo.Natdata$
Add ownersplitCity nvarchar(255)


update [Protfilo Project].dbo.Natdata$
set ownersplitCity =  PARSENAME (replace(OwnerAddress, ',','.') ,2)


alter table [Protfilo Project].dbo.Natdata$
Add ownersplitState nvarchar(255)


update [Protfilo Project].dbo.Natdata$
set ownersplitState = PARSENAME (replace(OwnerAddress, ',','.') ,1)

---- converting Y&N to yes and no in the soldasvacant columns

select distinct (SoldAsVacant),count(SoldAsVacant)
from Natdata$
group by SoldAsVacant
order by 2

select SoldAsVacant
, Case when  SoldAsVacant = 'N' then 'No'
	when  SoldAsVacant = 'Y' then 'Yes'
	else  SoldAsVacant
	end
from Natdata$



update Natdata$
set SoldAsVacant = Case when  SoldAsVacant = 'N' then 'No'
	when  SoldAsVacant = 'Y' then 'Yes'
	else  SoldAsVacant
	end

------REMOVING DUPLICATE
select  *
from Natdata$

---remove former colums--- please not that its not advisable to delete data from your database ,hence this was just for the sake of pratice
select *
from Natdata$

alter table Natdata$
drop column SaleDate,propertAddress,ownerAddress
--- this abover query was not executed 