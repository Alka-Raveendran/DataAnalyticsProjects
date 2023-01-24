


/*

Cleaning Data in SQL Queries

1.  Standardize Date Format by converting them to "Date" type
2.  Fill in the Missing Property Address data
3.  Splitting Address into Individual Columns (Address, City, State)
4.  Change Y and N to Yes and No in "Sold AS Vacant" field
5.  Find duplicate rows
6.  Deleting unwanted columns

*/


SELECT * FROM nashvillehousing;


--------------------------------------------------------------------------------------------------------------------------


-- Standardize Date Format


ALTER TABLE nashvillehousing
ADD SaleDateConverted DATE;


UPDATE nashvillehousing
SET SaleDateConverted = CONVERT(SaleDate,DATE);



--------------------------------------------------------------------------------------------------------------------------


-- Breaking out Property Address into Individual Columns (Address & City)


SELECT PropertyAddress
FROM nashvillehousing;


-- ####Address
SELECT PropertyAddress, SUBSTRING_INDEX(PropertyAddress, ',', 1) AS PropertySplitAddress
FROM nashvillehousing;

ALTER TABLE nashvillehousing
ADD PropertySplitAddress VARCHAR(50);

UPDATE nashvillehousing
SET PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1);

SELECT PropertyAddress, PropertySplitAddress
FROM nashvillehousing;



-- ####City
SELECT PropertyAddress, SUBSTRING_INDEX(PropertyAddress, ',', -1) AS PropertySplitCity
FROM nashvillehousing;

ALTER TABLE nashvillehousing
ADD PropertySplitCity VARCHAR(50);

UPDATE nashvillehousing
SET PropertySplitCity = SUBSTRING_INDEX(PropertyAddress, ',', -1);

SELECT PropertyAddress, PropertySplitAddress, PropertySplitCity
FROM nashvillehousing;



--------------------------------------------------------------------------------------------------------------------------



-- Breaking out Owner Address into Individual Columns (Address, City & State)


SELECT OwnerAddress
FROM nashvillehousing;



SELECT OwnerAddress, SUBSTRING_INDEX(OwnerAddress, ',', 1) AS OwnerSplitAddress,
SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)  AS OwnerSplitCity,
SUBSTRING_INDEX(OwnerAddress, ',', -1) AS OwnerSplitState
FROM nashvillehousing;


ALTER TABLE nashvillehousing
ADD OwnerSplitAddress VARCHAR(50);

UPDATE nashvillehousing
SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1);


ALTER TABLE nashvillehousing
ADD OwnerSplitCity VARCHAR(50);

UPDATE nashvillehousing
SET OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1);


ALTER TABLE nashvillehousing
ADD OwnerSplitState VARCHAR(50);

UPDATE nashvillehousing
SET OwnerSplitState = SUBSTRING_INDEX(OwnerAddress, ',', -1);



SELECT OwnerAddress, OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
FROM nashvillehousing;



--------------------------------------------------------------------------------------------------------------------------



-- Change Y and N to Yes and No in "Sold as Vacant" field


SELECT SoldAsVacant
FROM nashvillehousing;


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM nashvillehousing
GROUP BY SoldAsVacant
ORDER BY 2;


Select SoldAsVacant, 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM nashvillehousing;

UPDATE nashvillehousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END;



SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM nashvillehousing
GROUP BY SoldAsVacant
ORDER BY 2;




--------------------------------------------------------------------------------------------------------------------------



-- Remove Duplicates



WITH RowNumCTE AS(
SELECT *, ROW_NUMBER()
OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
ORDER BY UniqueID) row_num
FROM nashvillehousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress;



--------------------------------------------------------------------------------------------------------------------------



-- Delete Unused Columns


SELECT * FROM nashvillehousing;



ALTER TABLE nashvillehousing
DROP COLUMN OwnerAddress,
DROP COLUMN PropertyAddress,
DROP COLUMN TaxDistrict,
DROP COLUMN SaleDate;



--------------------------------------------------------------------------------------------------------------------------



