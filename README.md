# Test_PL-SQL-PGSQL
contiene los procesos oracle y postgres para sar solución al problema planteado

#SOLUCIÓN

- Reto 1 y 2: Archivos contenidos carpeta Oracle\DLL_statements
- Reto 3: Archivos contenidos en la carpeta Oracle\DML_statements
- Reto 4. Se da solución con la función practical_test.generate_ratings
		  y todas las funciones auxiliares que parten de su ejecución
- Reto 5: Se da solución con el procedimiento practical_test.bulk_insert_ratings
- Reto 6: Se da solución con los trigger trg_audit_videogames de la tabla videogames
- Reto 7: Se da solución con el procedimiento practical_test.update_ratings
- Reto 8: Se da solución con los archivos contenidos en la carpeta Postgres\DLL_Statements
- Reto 9: Se da solución de dos maneras
		  * Lo primero que se debe tener en cuenta es que se debe ejecutar el archivo
		     Postgres\DML_Statement\1. NSERT Companies.sql para poblar la tabla companies.
		  * Por medio del ETL pentaho
		  * Se construyen el procedimiento practical_test.export_videogames_ratings_to_csv
		     de oracle para exporta la data en un archivo CSV, tener en cuenta que se debe 
			 crear la carpeta donde se exportara el archivo ejecutando el archivo
			 Oracle\DLL_statements\22. CREATE DIRECTORY.sql.
			 Se crea el procedimiento load_data_from_csv, para importar el archivo creado 
			 por el procedimiento de oracle a la base de datos de postgres
- Reto 10: Se da solució con la función get_game_ranking de la carpeta Postgres\Procces

# DLL
las sentencias DLL estan creadas de manera indpendiente pero de igual manera se crea el archivo CONSOLIDATED DLL.sql
el cual contiene todas las sentencias, esto con el fin de facilitar la ejecución

#DML
Al igual que las se DLL estas estan creadas de forma independiente, pero se crea el archivo DML_CONSOLIDATE.sql, co el 
mismo fin

#PROCESOS
en la carpeta procesos encontraran las sentencias para compilar los procesos, en el archivo 4. package_practical_test.sql, 
se encuentra un PACKAGE que contiene todas las funciones y procedimientos necesarios para dar solución a lo requerido
- El archivo 5. CREATE_UPDATE_RATING_JOB.sql contiene el script para programar un job que ejecutara el procedimienot 
de process_ratings_queue, implementado para tener una cola de los videojuegos que se debe actualizar la calificación y dar solución
a un problema mutada, conflicto que se presento por el trigger de auditoria de la tabla y la actualización de las calificaciones



#AUDITORIA
Solo solicitaban la tabla auditoria para dejar traza de los cambios en la tabla videogames, por la normalización de la base de datos
analice que era mejor separar las compañias de la tabla de videojuegos, para complementar un  poco el proceso, se incluye proceso
de auditoria para la tabla comapnies, ademas tambies se inclure para la tabla raiting

# PROCESOS

- Generar calificación: SELECT practical_test.generate_ratings(5, 1) FROM DUAL;

- Inserción masiva: 
					DECLARE
						p_error_code NUMBER;
						p_error_message VARCHAR2(200);
					BEGIN
						practical_test.bulk_insert_ratings (
																200,--Camtiodad de registros
																2,--identificador de juego
																p_error_code,
																p_error_message
															);

					END;


- Actualización de puntuación: 
								DECLARE
									p_error_code NUMBER;
									p_error_message VARCHAR2(200);
								BEGIN
									practical_test.update_ratings (
																	  p_error_code,
																	  p_error_message
																  );

								END;
								

- MIgrar data: 1. exporta data oracle
					
					SET SERVEROUTPUT ON

					DECLARE
					  p_error_code NUMBER;
					  p_error_message VARCHAR2(200);
					BEGIN
						practical_test.export_videogames_ratings_to_csv(
																	p_error_code,
																	p_error_message
																);
																
					  DBMS_OUTPUT.PUT_LINE(p_error_code||' '||p_error_message);
					END;
					
				2. importar data postgres:
				     
					 CALL load_data_from_csv('C:/app/videogames_ratings_export.csv');
					 
- RAnking: Base de datos postgres
				SELECT * FROM get_game_ranking(10);

