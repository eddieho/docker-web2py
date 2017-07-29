
/* create sample table for testing only */

use web2py_db;

CREATE TABLE sample_table ( id smallint unsigned not null auto_increment, 
	name varchar(20) not null, 
	constraint pk_example primary key (id) );
