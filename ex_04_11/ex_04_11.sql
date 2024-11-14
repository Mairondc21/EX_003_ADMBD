-- apague todos usuarios menos:
	SELECT CONCAT('DROP USER IF EXISTS ', user, '@', host, ';') 
	FROM mysql.user 
	WHERE user NOT IN ('mysql.infoschema', 'mysql.session', 'mysql.sys', 'root');

-- Role 1: apenas SELECT no schema
	CREATE ROLE 'Role_1';
	GRANT SELECT ON schema_name.* TO 'Role_1';

-- Role 2: apenas INSERT em clientes e CREATE e DROP no schema
	CREATE ROLE 'Role_2';
	GRANT INSERT ON schema_name.clientes TO 'Role_2';
	GRANT CREATE, DROP ON schema_name.* TO 'Role_2';

-- Role 3: apenas SELECT na tabela vendas
	CREATE ROLE 'Role_3';
	GRANT SELECT ON schema_name.vendas TO 'Role_3';

-- Role 4: SELECT, INSERT, UPDATE e DELETE no schema
	CREATE ROLE 'Role_4';
	GRANT SELECT, INSERT, UPDATE, DELETE ON schema_name.* TO 'Role_4';

-- Role 5: apenas UPDATE na tabela vendas
	CREATE ROLE 'Role_5';
	GRANT UPDATE ON schema_name.vendas TO 'Role_5';

-- Criar 10 usuários
	CREATE USER 'User1'@'localhost' IDENTIFIED BY 'password1';
	CREATE USER 'User2'@'localhost' IDENTIFIED BY 'password2';
	CREATE USER 'User3'@'localhost' IDENTIFIED BY 'password3';
	CREATE USER 'User4'@'localhost' IDENTIFIED BY 'password4';
	CREATE USER 'User5'@'localhost' IDENTIFIED BY 'password5';
	CREATE USER 'User6'@'localhost' IDENTIFIED BY 'password6';
	CREATE USER 'User7'@'localhost' IDENTIFIED BY 'password7';
	CREATE USER 'User8'@'localhost' IDENTIFIED BY 'password8';
	CREATE USER 'User9'@'localhost' IDENTIFIED BY 'password9';
	CREATE USER 'User10'@'localhost' IDENTIFIED BY 'password10';
    
-- Aplicar as roles aos usuários
	GRANT 'Role_1' TO 'User1'@'localhost';
	GRANT 'Role_1' TO 'User2'@'localhost';

	GRANT 'Role_2' TO 'User3'@'localhost';
	GRANT 'Role_2' TO 'User4'@'localhost';

	GRANT 'Role_3' TO 'User5'@'localhost';
	GRANT 'Role_3' TO 'User6'@'localhost';

	GRANT 'Role_4' TO 'User7'@'localhost';
	GRANT 'Role_4' TO 'User8'@'localhost';

	GRANT 'Role_5' TO 'User9'@'localhost';
	GRANT 'Role_5' TO 'User10'@'localhost';

-- Revogar o privilégio de SELECT do Role_1 e adicionar CREATE e DROP
	REVOKE SELECT ON schema_name.* FROM 'Role_1';
	GRANT CREATE, DROP ON schema_name.* TO 'Role_1';
