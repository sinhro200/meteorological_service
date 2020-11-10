use meteoservice;

INSERT INTO Wind_direction(title)
VALUES 
('North'),
('North East'),
('East'),
('South East'),
('South'),
('South West'),
('West'),
('North West');

SET @wd_n := (SELECT wind_direction_id FROM Wind_direction WHERE title = 'North' limit 1);
SET @wd_ne := (SELECT wind_direction_id FROM Wind_direction WHERE title = 'North East' limit 1);
SET @wd_e := (SELECT wind_direction_id FROM Wind_direction WHERE title = 'East' limit 1);
SET @wd_se := (SELECT wind_direction_id FROM Wind_direction WHERE title = 'South East' limit 1);
SET @wd_s := (SELECT wind_direction_id FROM Wind_direction WHERE title = 'South' limit 1);
SET @wd_sw := (SELECT wind_direction_id FROM Wind_direction WHERE title = 'South West' limit 1);
SET @wd_w := (SELECT wind_direction_id FROM Wind_direction WHERE title = 'West' limit 1);
SET @wd_nw := (SELECT wind_direction_id FROM Wind_direction WHERE title = 'North West' limit 1);

INSERT INTO Source(title)
VALUES 
('satellite'),
('meteostation');

SET @src_sat := (SELECT source_id FROM Source WHERE title = 'satellite' limit 1);
SET @src_mts := (SELECT source_id FROM Source WHERE title = 'meteostation' limit 1);

INSERT INTO Administrative_area_type(title)
VALUES
('country'),
('region'), -- область
('locality'), -- населённый пункт
('street'),
('house');

SET @country_id := (SELECT administrative_area_type_id FROM Administrative_area_type WHERE title = 'country' limit 1);
SET @region_id := (SELECT administrative_area_type_id FROM Administrative_area_type WHERE title = 'region' limit 1);
SET @locality_id := (SELECT administrative_area_type_id FROM Administrative_area_type WHERE title = 'locality' limit 1);
SET @street_id := (SELECT administrative_area_type_id FROM Administrative_area_type WHERE title = 'street' limit 1);
SET @house_id := (SELECT administrative_area_type_id FROM Administrative_area_type WHERE title = 'house' limit 1);

	-- Страны
INSERT INTO Administrative_area(title,type_id,included_in_id)
VALUES
('Россия', @country_id , NULL),
('Украина', @country_id , NULL),
('Республика Беларусь', @country_id , NULL);

SET @russia_id := (SELECT administrative_area_id FROM Administrative_area WHERE title = 'Россия');

		-- Области
INSERT INTO Administrative_area(title,type_id,included_in_id)
VALUES
('Воронежская область', @region_id , @russia_id),
('Ростовская область', @region_id , @russia_id),
('Липецкая область', @region_id , @russia_id),
('Томбовская область', @region_id , @russia_id);

SET @voronezh_locality_id := (SELECT administrative_area_id FROM Administrative_area WHERE title = 'Воронежская область');
SET @rostov_locality_id := (SELECT administrative_area_id FROM Administrative_area WHERE title = 'Ростовская область');

		-- Населённые пункты
INSERT INTO Administrative_area(title,type_id,included_in_id)
VALUES
('Воронеж', @locality_id , @voronezh_locality_id),
('Новая Усмань', @locality_id , @voronezh_locality_id),
('Лиски', @locality_id , @voronezh_locality_id),
('Ростов', @locality_id , @rostov_locality_id);

SET @voronezh_id := (SELECT administrative_area_id FROM Administrative_area WHERE title = 'Воронеж');
SET @rostov_id := (SELECT administrative_area_id FROM Administrative_area WHERE title = 'Ростов');

		-- Улицы
INSERT INTO Administrative_area(title,type_id,included_in_id)
VALUES
('Ленинский проспект', @street_id , @voronezh_id),
('Московский проспект', @street_id , @voronezh_id),
('Проспект революции', @street_id , @voronezh_id),
('Проспект Ворошиловский', @street_id , @rostov_id),
('Красноармейская улица', @street_id , @rostov_id);

SET @vrn_lenProsp := (SELECT administrative_area_id FROM Administrative_area WHERE title = 'Ленинский проспект' AND type_id = @street_id AND included_in_id = @voronezh_id);
SET @vrn_revProsp := (SELECT administrative_area_id FROM Administrative_area WHERE title = 'Проспект революции' AND type_id = @street_id AND included_in_id = @voronezh_id);
SET @rst_vrshProsp := (SELECT administrative_area_id FROM Administrative_area WHERE title = 'Проспект Ворошиловский' AND type_id = @street_id AND included_in_id = @rostov_id);
        
        -- Дома
INSERT INTO Administrative_area(title,type_id,included_in_id)
VALUES
('1', @house_id , @vrn_lenProsp ),
('12', @house_id , @vrn_lenProsp),
('44', @house_id , @vrn_lenProsp);

INSERT INTO Administrative_area(title,type_id,included_in_id)
VALUES
('3', @house_id , @vrn_revProsp ),
('4', @house_id , @vrn_revProsp),
('19', @house_id , @vrn_revProsp);

INSERT INTO Administrative_area(title,type_id,included_in_id)
VALUES
('24', @house_id , @rst_vrshProsp ),
('91/1', @house_id , @rst_vrshProsp);

SET @vrn_len_prosp_1 := (SELECT administrative_area_id FROM Administrative_area WHERE title = '1' AND type_id = @house_id AND included_in_id = @vrn_lenProsp limit 1);
SET @vrn_rev_prosp_4 := (SELECT administrative_area_id FROM Administrative_area WHERE title = '4' AND type_id = @house_id AND included_in_id = @vrn_revProsp limit 1);
SET @rst_vrsh_prosp_91d1 := (SELECT administrative_area_id FROM Administrative_area WHERE title = '91/1' AND type_id = @house_id AND included_in_id = @rst_vrshProsp limit 1);
SET @vrn_rev_prosp_3 := (SELECT administrative_area_id FROM Administrative_area WHERE title = '3' AND type_id = @house_id AND included_in_id = @vrn_revProsp limit 1);
SET @vrn_rev_prosp_19 := (SELECT administrative_area_id FROM Administrative_area WHERE title = '19' AND type_id = @house_id AND included_in_id = @vrn_revProsp limit 1);

INSERT INTO Location(coordinates, administrative_area_id)
VALUES 
(POINT(51.633704, 39.231656),@vrn_len_prosp_1),
(POINT(51.680403, 39.214993),@vrn_rev_prosp_4),
(POINT(47.231759, 39.714088),@rst_vrsh_prosp_91d1),
(POINT(51.679895, 39.215397),@vrn_rev_prosp_3),
(POINT(51.675287, 39.213681),@vrn_rev_prosp_19)
;

SET @loc_vrn_len_prosp_1 := (SELECT location_id FROM Location WHERE administrative_area_id = @vrn_len_prosp_1 limit 1);
SET @loc_vrn_rev_prosp_4 := (SELECT location_id FROM Location WHERE administrative_area_id = @vrn_rev_prosp_4 limit 1);
SET @loc_rst_vrsh_prosp_91d1 := (SELECT location_id FROM Location WHERE administrative_area_id = @rst_vrsh_prosp_91d1 limit 1);
SET @loc_vrn_rev_prosp_3 := (SELECT location_id FROM Location WHERE administrative_area_id = @vrn_rev_prosp_3 limit 1);
SET @loc_vrn_rev_prosp_19 := (SELECT location_id FROM Location WHERE administrative_area_id = @vrn_rev_prosp_19 limit 1);

INSERT INTO Location(coordinates, administrative_area_id)
VALUES (POINT(51.588962, 39.034721),@voronezh_id);
SET @loc_vrn_random := (SELECT LAST_INSERT_ID());

		-- vrn len prosp 1
SELECT TIMESTAMP (CURRENT_TIMESTAMP,'- 60:10') INTO @timest;
INSERT INTO Weather (time, source_id, height, wind_direction_id, wind_power_from,wind_power_to, rainfall, cloudiness, atm_pressure, humidity, location_id) 
VALUES (@timest, @src_sat, null, @wd_s, 7,8, 3, 6, 762, 56,@loc_vrn_len_prosp_1);

		-- vrn rev prosp 4
SELECT TIMESTAMP (CURRENT_TIMESTAMP,'- 60:20') INTO @timest;
INSERT INTO Weather (time, source_id, height, wind_direction_id,  wind_power_from,wind_power_to, rainfall, cloudiness, atm_pressure, humidity, location_id) 
VALUES (@timest, @src_mts, 500, @wd_w, 4,5, 3, 6, 755, 54,@loc_vrn_rev_prosp_4);

		-- rst vrsh prosp 91d1
SELECT TIMESTAMP (CURRENT_TIMESTAMP,'- 60:30') INTO @timest;
INSERT INTO Weather (time, source_id, height, wind_direction_id, wind_power_from,wind_power_to, rainfall, cloudiness, atm_pressure, humidity, location_id) 
VALUES (@timest, @src_mts, 600, @wd_sw, 3,4, 5, 3, 770, 48, @loc_rst_vrsh_prosp_91d1);

		-- -- --
SELECT TIMESTAMP (CURRENT_TIMESTAMP,'- 61') INTO @timest;
INSERT INTO Weather (time, source_id, height, wind_direction_id, wind_power_from,wind_power_to, rainfall, cloudiness, atm_pressure, humidity, location_id) 
VALUES (@timest, @src_sat, 230, @wd_s, 1,2, 3, 6, 770, 50, @loc_vrn_rev_prosp_3);

SELECT TIMESTAMP (CURRENT_TIMESTAMP,'- 63:30') INTO @timest;
INSERT INTO Weather (time, source_id, height, wind_direction_id, wind_power_from,wind_power_to, rainfall, cloudiness, atm_pressure, humidity, location_id) 
VALUES (@timest, @src_mts, 240, @wd_s, 4,5, 2, 6, 771, 48, @loc_vrn_rev_prosp_19);

SELECT TIMESTAMP (CURRENT_TIMESTAMP,'- 40:0:10') INTO @timest;
INSERT INTO Weather (time, source_id, height, wind_direction_id, wind_power_from,wind_power_to, rainfall, cloudiness, atm_pressure, humidity, location_id) 
VALUES (@timest, @src_sat, 340, @wd_sw, 2,3, 3, 5, 769, 49, @loc_vrn_random);


-- SELECT TIMESTAMP('2020-02-01 12:10:06','- 10:10:10')
-- SELECT TIMESTAMP (CURRENT_TIMESTAMP,'- 60');







