-- Table: nashvilleHousing.housingdata

DROP TABLE IF EXISTS "nashvilleHousing".housingdata;

CREATE TABLE IF NOT EXISTS "nashvilleHousing".housingdata
(
    "UniqueID" character varying COLLATE pg_catalog."default",
    "ParcelID" character varying COLLATE pg_catalog."default",
    "LandUse" character varying COLLATE pg_catalog."default",
    "PropertyAddress" character varying COLLATE pg_catalog."default",
    "SaleDate" date,
    "SalePrice" character varying,
    "LegalReference" character varying COLLATE pg_catalog."default",
    "SoldAsVacant" character varying COLLATE pg_catalog."default",
    "OwnerName" character varying COLLATE pg_catalog."default",
    "OwnerAddress" character varying COLLATE pg_catalog."default",
    "Acreage" numeric,
    "TaxDistrict" character varying COLLATE pg_catalog."default",
    "LandValue" numeric,
    "BuildingValue" numeric,
    "TotalValue" numeric,
    "YearBuilt" numeric,
    "Bedrooms" numeric,
    "FullBath" numeric,
    "HalfBath" numeric
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS "nashvilleHousing".housingdata
    OWNER to postgres;