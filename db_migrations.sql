-- DROP SCHEMA public;

CREATE SCHEMA public AUTHORIZATION pg_database_owner;

-- DROP SEQUENCE public.bd_building_location_building_id_seq;

CREATE SEQUENCE public.bd_building_location_building_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.bd_parameter_building_specific_building_parameter_id_seq;

CREATE SEQUENCE public.bd_parameter_building_specific_building_parameter_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.bd_parameter_values_value_id_seq;

CREATE SEQUENCE public.bd_parameter_values_value_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.bd_parameters_parameter_id_seq;

CREATE SEQUENCE public.bd_parameters_parameter_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.name_name_id_seq;

CREATE SEQUENCE public.name_name_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.parameter_operations_operation_id_seq;

CREATE SEQUENCE public.parameter_operations_operation_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.technologies_technology_id_seq;

CREATE SEQUENCE public.technologies_technology_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.technology_parameters_parameter_id_seq;

CREATE SEQUENCE public.technology_parameters_parameter_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;-- public.bd_building_location definition

-- Drop table

-- DROP TABLE public.bd_building_location;

CREATE TABLE public.bd_building_location (
	building_id serial4 NOT NULL,
	latitude float8 NOT NULL,
	longitude float8 NOT NULL,
	CONSTRAINT bd_building_location_pkey PRIMARY KEY (building_id)
);


-- public.bd_parameters definition

-- Drop table

-- DROP TABLE public.bd_parameters;

CREATE TABLE public.bd_parameters (
	parameter_id serial4 NOT NULL,
	parameter_name varchar(100) NOT NULL,
	unit varchar(50) NULL,
	description text NULL,
	CONSTRAINT bd_parameters_pkey PRIMARY KEY (parameter_id)
);


-- public.tec_name definition

-- Drop table

-- DROP TABLE public.tec_name;

CREATE TABLE public.tec_name (
	name_id int4 DEFAULT nextval('name_name_id_seq'::regclass) NOT NULL,
	technology varchar(100) NOT NULL,
	specification varchar(100) NULL,
	distribution varchar(100) NULL,
	description text NULL,
	CONSTRAINT name_pkey PRIMARY KEY (name_id)
);


-- public.tec_parameter_operations definition

-- Drop table

-- DROP TABLE public.tec_parameter_operations;

CREATE TABLE public.tec_parameter_operations (
	operation_id int4 DEFAULT nextval('parameter_operations_operation_id_seq'::regclass) NOT NULL,
	operation_name varchar(100) NOT NULL,
	operation_formula text NOT NULL,
	reference text NULL,
	description text NULL,
	CONSTRAINT parameter_operations_pkey PRIMARY KEY (operation_id)
);


-- public.bd_parameter_values definition

-- Drop table

-- DROP TABLE public.bd_parameter_values;

CREATE TABLE public.bd_parameter_values (
	value_id serial4 NOT NULL,
	parameter_id int4 NOT NULL,
	value varchar(50) NOT NULL,
	description text NULL,
	CONSTRAINT bd_parameter_values_pkey PRIMARY KEY (value_id),
	CONSTRAINT bd_parameter_values_parameter_id_fkey FOREIGN KEY (parameter_id) REFERENCES public.bd_parameters(parameter_id) ON DELETE CASCADE
);


-- public.tec_technologies definition

-- Drop table

-- DROP TABLE public.tec_technologies;

CREATE TABLE public.tec_technologies (
	technology_id int4 DEFAULT nextval('technologies_technology_id_seq'::regclass) NOT NULL,
	"type" varchar(50) NOT NULL,
	name_id int4 NOT NULL,
	description text NULL,
	CONSTRAINT technologies_pkey PRIMARY KEY (technology_id),
	CONSTRAINT technologies_name_id_fkey FOREIGN KEY (name_id) REFERENCES public.tec_name(name_id) ON DELETE CASCADE
);


-- public.tec_technology_parameters definition

-- Drop table

-- DROP TABLE public.tec_technology_parameters;

CREATE TABLE public.tec_technology_parameters (
	parameter_id int4 DEFAULT nextval('technology_parameters_parameter_id_seq'::regclass) NOT NULL,
	technology_id int4 NOT NULL,
	"version" varchar(50) NOT NULL,
	value float8 NOT NULL,
	unit varchar(50) NOT NULL,
	reference text NULL,
	acquisition_date date NULL,
	quality varchar(50) NULL,
	description text NULL,
	is_derived bool DEFAULT false NULL,
	operation_id int4 NULL,
	CONSTRAINT technology_parameters_pkey PRIMARY KEY (parameter_id),
	CONSTRAINT technology_parameters_technology_id_fkey FOREIGN KEY (technology_id) REFERENCES public.tec_technologies(technology_id) ON DELETE CASCADE
);


-- public.bd_parameter_building_specific definition

-- Drop table

-- DROP TABLE public.bd_parameter_building_specific;

CREATE TABLE public.bd_parameter_building_specific (
	building_parameter_id serial4 NOT NULL,
	building_id int4 NOT NULL,
	parameter_id int4 NOT NULL,
	value_id int4 NOT NULL,
	CONSTRAINT bd_parameter_building_specific_pkey PRIMARY KEY (building_parameter_id),
	CONSTRAINT bd_parameter_building_specific_building_id_fkey FOREIGN KEY (building_id) REFERENCES public.bd_building_location(building_id) ON DELETE CASCADE,
	CONSTRAINT bd_parameter_building_specific_parameter_id_fkey FOREIGN KEY (parameter_id) REFERENCES public.bd_parameters(parameter_id) ON DELETE CASCADE,
	CONSTRAINT bd_parameter_building_specific_value_id_fkey FOREIGN KEY (value_id) REFERENCES public.bd_parameter_values(value_id) ON DELETE CASCADE
);
