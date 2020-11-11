use db_design;

SELECT * 
FROM Wind_direction;

SELECT * 
FROM Source;

DROP VIEW IF EXISTS leafs;

CREATE VIEW leafs AS
SELECT *
FROM Administrative_area aa
WHERE aa.administrative_area_id NOT IN (
	SELECT included_in_id
    FROM Administrative_area
    WHERE included_in_id IS NOT NULL
);

SELECT *
FROM leafs;


DROP FUNCTION IF EXISTS full_title_area_rec_func;
delimiter //
CREATE FUNCTION full_title_area_rec_func (root_elem int) returns text
READS SQL DATA
BEGIN
SET @res = '';
  with recursive weather_location_recursive 
	(administrative_area_id, title, type_id, included_in_id) 
    as (
			select     administrative_area_id, title, type_id, included_in_id
			from       Administrative_area
			where      administrative_area_id = root_elem
		union all
        
			select     aa.administrative_area_id, aa.title, aa.type_id, aa.included_in_id
			from       Administrative_area aa
				inner join weather_location_recursive
				on aa.administrative_area_id = weather_location_recursive.included_in_id
	)
SELECT GROUP_CONCAT(`title` SEPARATOR ', ')
into @res
FROM weather_location_recursive;
return @res;
END//
delimiter ;

SELECT full_title_area_rec_func(leafs.administrative_area_id)
FROM leafs;

SELECT height,wd.title as 'wind direction',wind_power_from,wind_power_to,rainfall,cloudiness,atm_pressure,humidity,src.title as 'source',time,ST_AsText(coordinates) as 'coordinates',full_title_area_rec_func(administrative_area_id)
FROM (Weather w JOIN Location l ON w.location_id = l.location_id) 
JOIN Wind_direction wd ON wd.wind_direction_id = w.wind_direction_id
JOIN Source src ON src.source_id = w.source_id
;

 -- -- -- -- -- -- -- -- -- 


-- Процедура для поиска всех потомков для administrative area
DELIMITER //  
DROP PROCEDURE IF EXISTS allChildren;
CREATE PROCEDURE allChildren (IN parent_id INT)  
LANGUAGE SQL  
DETERMINISTIC  
SQL SECURITY DEFINER  
BEGIN  
    with recursive all_children_recursive 
	(administrative_area_id, title, type_id, included_in_id) 
    as (
			select     administrative_area_id, title, type_id, included_in_id
			from       Administrative_area
			where      administrative_area_id = parent_id
		union all
        
			select     aa.administrative_area_id, aa.title, aa.type_id, aa.included_in_id
			from       Administrative_area aa
				inner join all_children_recursive
				on aa.included_in_id = all_children_recursive.administrative_area_id 
	)
SELECT *
FROM all_children_recursive;
END//  
delimiter ;

-- Выбираем id для administrative_area 'Воронеж'
SELECT aa.administrative_area_id
INTO @vrn_administrative_area_id
FROM Administrative_area aa JOIN administrative_area_type aat ON aa.type_id = aat.administrative_area_type_id
WHERE aat.title = 'locality' AND aa.title = 'Воронеж'
LIMIT 1;

-- Выбираем всех потомков для вышеописанного id
CALL allChildren(@vrn_administrative_area_id) ;

-- Выбираем погоду для administrative_area 'Воронеж' и всех его потомков
with recursive all_children_recursive (administrative_area_id)
as (
		select     administrative_area_id
		from       Administrative_area
		where      administrative_area_id = (SELECT aa.administrative_area_id
					FROM Administrative_area aa JOIN administrative_area_type aat ON aa.type_id = aat.administrative_area_type_id
					WHERE aat.title = 'locality' AND aa.title = 'Воронеж'
					LIMIT 1)
	union all
	
		select     aa.administrative_area_id
		from       Administrative_area aa
			inner join all_children_recursive
			on aa.included_in_id = all_children_recursive.administrative_area_id 
)
SELECT height,wd.title as 'wind direction',wind_power_from,wind_power_to,rainfall,cloudiness,atm_pressure,
		humidity,src.title as 'source',time,ST_AsText(coordinates) as 'coordinates',full_title_area_rec_func(l.administrative_area_id) as 'area'
FROM (Weather w JOIN Location l ON w.location_id = l.location_id) 
JOIN Wind_direction wd ON wd.wind_direction_id = w.wind_direction_id
JOIN Source src ON src.source_id = w.source_id
WHERE l.administrative_area_id IN (
        SELECT *
        FROM all_children_recursive
    )
ORDER BY time;

