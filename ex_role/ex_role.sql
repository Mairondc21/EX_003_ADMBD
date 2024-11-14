-- 5 usuarios locais com senha.
	CREATE USER 'User1'@'localhost' IDENTIFIED BY 'password1';
	CREATE USER 'User2'@'localhost' IDENTIFIED BY 'password2';
	CREATE USER 'User3'@'localhost' IDENTIFIED BY 'password3';
	CREATE USER 'User4'@'localhost' IDENTIFIED BY 'password4';
	CREATE USER 'User5'@'localhost' IDENTIFIED BY 'password5';

-- 5 Roles diferentes usando qualquer nome.
	CREATE ROLE 'Role_A';
	CREATE ROLE 'Role_B';
	CREATE ROLE 'Role_C';
	CREATE ROLE 'Role_D';
	CREATE ROLE 'Role_E';

-- Aplique 5 privilegios diferentes em cada role
	-- Privilégios para Role_A
	GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON *.* TO 'Role_A';

	-- Privilégios para Role_B
	GRANT SELECT, INSERT, UPDATE, DELETE, CREATE ON *.* TO 'Role_B';

	-- Privilégios para Role_C
	GRANT SELECT, INSERT, UPDATE, DELETE, DROP ON *.* TO 'Role_C';

	-- Privilégios para Role_D
	GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON *.* TO 'Role_D';

	-- Privilégios para Role_E
	GRANT SELECT, INSERT, UPDATE, DELETE, INDEX ON *.* TO 'Role_E';


-- Atribuir cada role a um usuário
	GRANT 'Role_A' TO 'User1'@'localhost';
	GRANT 'Role_B' TO 'User2'@'localhost';
	GRANT 'Role_C' TO 'User3'@'localhost';
	GRANT 'Role_D' TO 'User4'@'localhost';
	GRANT 'Role_E' TO 'User5'@'localhost';

-- Criar o usuário Admin com acesso a todos os roles
	CREATE USER 'Admin'@'localhost' IDENTIFIED BY 'adminpassword';

	-- Conceder todos os roles ao usuário Admin
	GRANT 'Role_A', 'Role_B', 'Role_C', 'Role_D', 'Role_E' TO 'Admin'@'localhost';





