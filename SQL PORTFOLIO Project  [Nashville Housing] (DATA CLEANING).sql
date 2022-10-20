
select *
from [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing


-- STANDARDIZING DATE FORMAT 

select SaleDate
from  [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing

select SaleDateConverted, CONVERT(DATE,SaleDate)
from  [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing

UPDATE[SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing

SET SaleDate = CONVERT(DATE,SaleDate)

-- (STANDARDIZING DATE FORMAT) DOESNT WORK? TRY

ALTER TABLE [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing
Add SaleDateConverted Date;

Update [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


-- POPULATION THE PROPERTY ADDRESS

Select *
From [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing a
JOIN [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing a
JOIN [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



-- BREAKING OUT ADDRESS INTO SDIFFERENT COLUMNS (ADDRESS, CITY, STATE)

 

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing

ALTER TABLE [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);



SELECT *
FROM [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing





-- BREAKING OUT OWNER ADDRESS INTO DIFFERENT COLUMNS (ADDRESS, CITY, STATE) [method 2]

Select OwnerAddress
From [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing

ALTER TABLE [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);


Update [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing



-- Changing Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant),  Count(SoldAsVacant)
From [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing


Update [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END





-- REMOVING DUPLICATES

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing

--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing





-- DELETING UNUSED COLUMNS 

Select *
From [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing



ALTER TABLE [SQLPORTFOLIODATACLEANING].dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
