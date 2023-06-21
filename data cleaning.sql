-- select all rows of nashville housing data from db
SELECT "UniqueID", "ParcelID", "LandUse", "PropertyAddress", "SaleDate", "SalePrice", "LegalReference", "SoldAsVacant", "OwnerName", "OwnerAddress", "Acreage", "TaxDistrict", "LandValue", "BuildingValue", "TotalValue", "YearBuilt", "Bedrooms", "FullBath", "HalfBath"
FROM "nashvilleHousing".housingdata
; 

-------------------------------------------------------------------------------------------------
-- populating property address data	
SELECT *
FROM "nashvilleHousing".housingdata
where "PropertyAddress" IS NULL
order by "ParcelID"
;
 
select
a."ParcelID",
a."UniqueID",
a."PropertyAddress", 
b."ParcelID", 
b."UniqueID",
b."PropertyAddress",
CASE WHEN a."PropertyAddress" IS NULL THEN b."PropertyAddress" ELSE a."PropertyAddress" END
 from "nashvilleHousing".housingdata a
 join "nashvilleHousing".housingdata b
 on a."ParcelID" = b."ParcelID"
 and a."UniqueID" <> b."UniqueID"
WHERE a."PropertyAddress" IS NULL 
;

 --updating housingdata table with values for null PropertyAddress rows
UPDATE "nashvilleHousing".housingdata
SET "PropertyAddress" = (CASE WHEN a."PropertyAddress" IS NULL and a."ParcelID" = b."ParcelID"
 and a."UniqueID" <> b."UniqueID" THEN b."PropertyAddress" ELSE a."PropertyAddress" END)
FROM "nashvilleHousing".housingdata a 
 LEFT JOIN "nashvilleHousing".housingdata b
 ON a."ParcelID" = b."ParcelID"
WHERE a."PropertyAddress" IS NULL
;

-------------------------------------------------------------------------------------------------
-- breaking property address column into individual columns (address, city, state)
 SELECT  "PropertyAddress"
 FROM "nashvilleHousing".housingdata
 ; 
 
 -- breaking property address column into address and city using substring function
SELECT
 SUBSTRING("PropertyAddress", 1, POSITION(',' IN "PropertyAddress")-1) PropertySplitAddress,
 SUBSTRING("PropertyAddress", POSITION(',' IN "PropertyAddress")+1, LENGTH("PropertyAddress")) PropertySplitCity
FROM "nashvilleHousing".housingdata
; 
 
--adding split address column to housingdata table
ALTER TABLE "nashvilleHousing".housingdata
ADD "PropertySplitAddress" character varying
;

--adding split city column to housingdata table
ALTER TABLE "nashvilleHousing".housingdata
ADD "PropertySplitCity" character varying
;

--updating housingdata table with values for split address column 
UPDATE "nashvilleHousing".housingdata
SET "PropertySplitAddress" = SUBSTRING("PropertyAddress", 1, POSITION(',' IN "PropertyAddress")-1)
;

--updating housingdata table with values for split city column
UPDATE "nashvilleHousing".housingdata
SET "PropertySplitCity" =  SUBSTRING("PropertyAddress", POSITION(',' IN "PropertyAddress")+1, LENGTH("PropertyAddress"))
;

 --breaking owner address column into address, city and state using split_part function
select 
 SPLIT_PART("OwnerAddress", ',', 1) OwnerSplitAddress,
 SPLIT_PART("OwnerAddress", ',', 2) OwnerSplitCity,
 SPLIT_PART("OwnerAddress", ',', 3) OwnerSplitState
from "nashvilleHousing".housingdata
;

--adding owner split address column to housingdata table
ALTER TABLE "nashvilleHousing".housingdata
ADD "OwnerSplitAddress" character varying
;

--adding owner split city column to housingdata table
ALTER TABLE "nashvilleHousing".housingdata
ADD "OwnerSplitCity" character varying
;

--adding split State column to housingdata table
ALTER TABLE "nashvilleHousing".housingdata
ADD "OwnerSplitState" character varying
;
 
--updating housingdata table with values for owner split address column 
UPDATE "nashvilleHousing".housingdata
SET "OwnerSplitAddress" = SPLIT_PART("OwnerAddress", ',', 1)
; 

--updating housingdata table with values for owner split city column 
UPDATE "nashvilleHousing".housingdata
SET "OwnerSplitCity" = SPLIT_PART("OwnerAddress", ',', 2) 
;

--updating housingdata table with values for owner split state column 
UPDATE "nashvilleHousing".housingdata
SET "OwnerSplitState" = SPLIT_PART("OwnerAddress", ',', 3) 
;

-------------------------------------------------------------------------------------------------
--changing Y and N to Yes and No respectively in "SoldAsVacant" column
select distinct ("SoldAsVacant")
from "nashvilleHousing".housingdata
;

UPDATE "nashvilleHousing".housingdata
SET "SoldAsVacant" = 'Yes' Where "SoldAsVacant" = 'Y'
;

UPDATE "nashvilleHousing".housingdata
SET "SoldAsVacant" = 'No' Where "SoldAsVacant" = 'N'
;

-------------------------------------------------------------------------------------------------
--remove duplicate data from dataset
--selecting duplicate rows
WITH RowNumCTE AS (
	select *,
          ROW_NUMBER() OVER (
			  PARTITION BY "ParcelID", "LandUse", "PropertyAddress", "SaleDate", "SalePrice", "LegalReference"
			  ORDER BY "UniqueID")row_num
    from "nashvilleHousing".housingdata)
SELECT *
FROM RowNumCTE
WHERE row_num >1
;

--deleting duplicate rows
DELETE
FROM "nashvilleHousing".housingdata
WHERE "UniqueID" IN (
WITH RowNumCTE AS (
	select *,
          ROW_NUMBER() OVER (
			  PARTITION BY "ParcelID", "LandUse", "PropertyAddress", "SaleDate", "SalePrice", "LegalReference"
			  ORDER BY "UniqueID")row_num
    from "nashvilleHousing".housingdata)
SELECT "UniqueID"
FROM RowNumCTE
WHERE row_num >1
)
;

-------------------------------------------------------------------------------------------------
--delete redundant columns

ALTER TABLE "nashvilleHousing".housingdata
DROP COLUMN "PropertyAddress"

ALTER TABLE "nashvilleHousing".housingdata
DROP COLUMN "OwnerAddress"

ALTER TABLE "nashvilleHousing".housingdata
DROP COLUMN "TaxDistrict"