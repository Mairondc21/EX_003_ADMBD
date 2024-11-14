-- Comando 1 - Liste o usuário que está logado no sistema.
    SELECT USER();
    -- Comando 2 - Liste os usuarios e seu host.
    SELECT user, host FROM mysql.user;
    -- Comando 3 - Liste os usuários e todos seus privilégios
    SHOW GRANTS FOR 'root'@'localhost';

-- 2 Crie os seguintes usuarios:
#Local-- JoanaASCII - 123321
#local-- KarenMouse - sem senha
#remoto-- TioTeclas - 131312
#remoto-- Teclaudio - 369099
#local-- RonanAsus - sem senha
#local-- MarcusTeras - 451212
    -- Usuários locais com senhas
    CREATE USER 'JoanaASCII'@'localhost' IDENTIFIED BY '123321';
    CREATE USER 'KarenMouse'@'localhost' IDENTIFIED BY '';
    CREATE USER 'RonanAsus'@'localhost' IDENTIFIED BY '';
    CREATE USER 'MarcusTeras'@'localhost' IDENTIFIED BY '451212';

    -- Usuários remotos com senhas
    CREATE USER 'TioTeclas'@'%' IDENTIFIED BY '131312';
    CREATE USER 'Teclaudio'@'%' IDENTIFIED BY '369099';

-- 3 Depois de criados surgiram de ultima hora algumas alterações que devem ser feitas:
# A usuaria KarenMouse deve receber a senha padrão 123456
# O usuario TioTeclas deve ter a senha alterada para 202020
# O usuario RonanAsus deve receber a senha padrão 12345

    -- Alterar a senha da usuária KarenMouse para 123456
    ALTER USER 'KarenMouse'@'localhost' IDENTIFIED BY '123456';

    -- Alterar a senha do usuário TioTeclas para 202020
    ALTER USER 'TioTeclas'@'%' IDENTIFIED BY '202020';

    -- Alterar a senha do usuário RonanAsus para 12345
    ALTER USER 'RonanAsus'@'localhost' IDENTIFIED BY '12345';

-- 4 Algumas alterações no password de alguns usuarios devem ser realizadas:
-- 1. A usuária KarenMouse deve receber a senha 121212 que nunca expira
    ALTER USER 'KarenMouse'@'localhost' IDENTIFIED BY '121212' PASSWORD EXPIRE NEVER;

    -- 2. O usuário TioTeclas deve receber a senha 1234 que expira em 90 dias
    ALTER USER 'TioTeclas'@'%' IDENTIFIED BY '1234' PASSWORD EXPIRE INTERVAL 90 DAY;

    -- 3. Para o usuário RonanAsus, exigindo a senha atual antes de atualizar:
    -- Primeiro, o usuário deve autenticar e alterar a senha com o comando abaixo:
    ALTER USER 'RonanAsus'@'localhost' IDENTIFIED BY 'R232323';

    -- 4. Para o usuário Teclaudio, configurar uma política que exija senhas fortes 
    -- (não existe nativamente o histórico de senha, mas você pode garantir que uma senha forte seja usada).
    -- Configurar validações com o plugin de senhas:
    SET GLOBAL validate_password_policy = 'STRONG';
    SET GLOBAL validate_password_length = 8; 
