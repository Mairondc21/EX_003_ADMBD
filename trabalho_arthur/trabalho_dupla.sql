select *
from carros;
select *
from clientes;
select *
from locacao;
select *
from dimensoes;

INSERT INTO DIMENSOES (altura_mm, largura_mm, comprimento_mm, peso_kg, tanque_L, entre_eixos_mm, porta_mala_L, ocupante, fk_idCarro) VALUES
(1.475, 1.656, 3.892, 1020, 55, 2.467, 285, 5, 6), -- Gol
(1.480, 1.760, 4.540, 1230, 60, 2.600, 470, 5, 4), -- Corolla
(1.673, 1.844, 4.945, 1650, 55, 2.982, 0, 5, 1),  -- Toro
(1.487, 1.765, 3.935, 1084, 54, 2.488, 270, 5, 3), -- Fiesta
(1.490, 1.730, 4.425, 1130, 45, 2.550, 473, 5, 2), -- Yaris
(1.470, 1.720, 4.015, 993, 50, 2.530, 300, 5, 5),  -- Hb20
(1.471, 1.731, 4.163, 1034, 44, 2.551, 303, 5, 7); -- Onix

#3 Agora as perguntas a serem respondidas com o schema todo pronto: Crie 1 View para cada uma das perguntas

#Questao 1 -- Qual o modelo do carro que já foi alugado
select carros.modelo, locacao.dataLocacao
from carros as carros
inner join locacao as locacao on carros.idCarro = locacao.fk_idCarro;

#Questao 2 -- Qual o nome do cliente que já alugou um carro
select clientes.nome, locacao.dataLocacao
from clientes as clientes
inner join locacao as locacao on clientes.idCLiente = locacao.fk_idCliente;

#Questao 3 -- Qual o nome do cliente que alugou o carro com a diária mais alta.
select clientes.nome, max(locacao.valorDiaria) as valorDiaria
from clientes as clientes
inner join locacao as locacao on clientes.idCliente = locacao.fk_idCliente
group by (clientes.nome);

#Questao 4-- Qual a categoria do carro que foi alugado por ultimo
select carros.categoria, min(dataLocacao)
from carros as carros
inner join locacao as locacao on carros.idCarro = locacao.fk_idCarro
group by carros.categoria;

#Questao 5 -- Qual o nome do fabricante(s) que produziu o carro(s) mais potente(s)
SELECT fabricante, potenciaMotor
FROM carros AS c
where potenciaMotor = (
	select max(potenciaMotor)
    from carros
);

#Questao 6 -- Qual a cor da SUV locada no dia 2024-10-22
select a.modelo, a.cor, a.categoria, b.dataLocacao
from carros as a
inner join locacao as b on a.idCarro = b.fk_idCarro
where a.categoria = 'SUV'
and b.dataLocacao = '2024-10-22';

#Questao 7 -- Qual o modelo do carro, fabricante, cor que tem a menor diária
SELECT a.modelo, a.fabricante, a.cor, b.valorDiaria
FROM carros AS a
INNER JOIN locacao AS b ON a.idCarro = b.fk_idCarro
WHERE b.valorDiaria = (
    SELECT MIN(valorDiaria)
    FROM locacao
)
LIMIT 1;

#Questao 8 -- Qual o modelo do carro e categoria que não foi alugado ainda
select a.modelo
from carros as a 
left join locacao as b on a.idCarro = b.fk_idCarro	
where b.idLocacao is null;

#Questao 9 -- Qual o nome do cliente que nunca alugou um carro do ano de fabricao 2013
select a.*
from carros as a
where year(anoFabricacao) = 2013;

#Questao 10 -- Qual o nome do cliente que já alugou um carro SUV
select a.nome, c.categoria
from clientes as a
inner join locacao as b on a.idCliente = b.fk_idCliente
inner join carros as c on c.idCarro = b.fk_idCarro
where c.categoria = 'SUV';

#Questao 11 -- Qual o nome do cliente que NÃO alugou um carro Sedan
select *
from clientes as a 
inner join locacao as b on a.idCliente = b.fk_idCliente
inner join carros as c on c.idCarro = b.fk_idCarro
where c.categoria != 'Sedan';
#Questao 12 -- Qual a categoria do cliente que já alugou um carro com mais de 3000 quilômetros rodados
select a.nome, c.categoria, c.quilometragem
from clientes as a 
inner join locacao as b on a.idCliente = b.fk_idCliente
inner join carros as c on c.idCarro = b.fk_idCarro
where c.quilometragem > 3000;
#Questao 13 -- Qual o modelo do carro que tem a menor altura.
select a.modelo, b.altura_mm
from carros as a
inner join dimensoes as b on a.idCarro = b.fk_idCarro
where b.altura_mm = (
	select min(altura_mm)
    from dimensoes
);
#Questao 14 -- Qual o tamanho do porta mala do carro que é da categoria Hatch
select b.porta_mala_L
from carros as a
inner join dimensoes as b on a.idCarro = b.fk_idCarro
where a.categoria = 'Hatch';

#Questao 15 – Você deve criar mais 10 sub Consultas nesse sistema.
#1
select *
from carros
where quilometragem = (
	select max(quilometragem)
    from carros
);
#2
select b.modelo, a.peso_kg
from dimensoes as a
inner join carros as b on a.fk_idCarro = b.idCarro
where peso_kg = (
	select max(peso_kg)
    from dimensoes
);
#3
select *
from carros
where anoFabricacao = (
	select min(anoFabricacao)
    from carros
);
#4 
select *
from clientes
where pontuacao = (
	select max(pontuacao)
    from clientes
);
#5 
select *
from dimensoes 
where altura_mm = (
	select max(altura_mm)
    from dimensoes
);
#6
select *
from dimensoes 
where largura_mm = (
	select max(largura_mm)
    from dimensoes
);


/*4. Crie uma trigger para monitorar a tabela locação. Ela deve registrar os dados do usuário, data de
inserção de um registro, e quais foram os dados novos inseridos. Para isso crie uma tabela chamada log.*/

create table log (
	log_id int auto_increment primary key,
    usuario varchar(100),
    data_insercao datetime,
    idLocacao int,
    dataLocacao date,
    valorDiaria decimal(10,2),
    fk_idCliente int,
    fk_idCarro int
);

delimiter $$

create trigger after_insert_locacao 
after insert on locacao
for each row
begin 
	insert into log (usuario,data_insercao,idLocacao,dataLocacao,valorDiaria,valorDiaria,fk_idCliente,fk_idCarro)
    values (user(), now(), new.idLocacao, new.dataLocacao, new.valorDiaria, new.valorDiaria, new.fk_idCliente, new.fk_idCarro);
end $$
delimiter ;

/*
5. Analise o database e suas tabelas para implementar uma trigger que possa fazer a gestão da
quilometragem dos carros que foram alugados. Exemplo: Aluguei um gol com quilometragem de 2344
quilômetros e só posso rodar 1000 quilômetros, se ao entregar o carro ele estiver com quilometragem de
mais que 3344, meu valor do quilometro deve subir pra 30% a mais. Você deve mudar o que for preciso
para atender a demanda passada. Se achar necessário, use uma tabela pra devolução com os valores
extras nela.
*/
CREATE TABLE devolucao (
    idDevolucao INT AUTO_INCREMENT PRIMARY KEY,
    idLocacao INT,
    quilometragemFinal INT,
    valorExtra DECIMAL(10, 2) DEFAULT 0,
    dataDevolucao DATE,
    FOREIGN KEY (idLocacao) REFERENCES locacao(idLocacao)
);

ALTER TABLE locacao 
ADD COLUMN quilometragemLimite INT;

DELIMITER $$

CREATE TRIGGER after_car_return
AFTER INSERT ON devolucao
FOR EACH ROW
BEGIN
    DECLARE limite INT;
    DECLARE valorDiariaOriginal DECIMAL(10, 2);
    DECLARE quilometragemExcedida INT;
    DECLARE valorExtra DECIMAL(10, 2);

    SELECT quilometragemLimite, valorDiaria 
    INTO limite, valorDiariaOriginal
    FROM locacao
    WHERE idLocacao = NEW.idLocacao;

    IF NEW.quilometragemFinal > limite THEN
        SET quilometragemExcedida = NEW.quilometragemFinal - limite;
        SET valorExtra = valorDiariaOriginal * 1.30;
    ELSE
        SET valorExtra = 0;
    END IF;

    UPDATE devolucao
    SET valorExtra = valorExtra
    WHERE idDevolucao = NEW.idDevolucao;

    UPDATE carros
    SET quilometragem = NEW.quilometragemFinal
    WHERE idCarro = (SELECT fk_idCarro FROM locacao WHERE idLocacao = NEW.idLocacao);
END $$

DELIMITER ;

/*Crie 10 usuários com senha para acessar (Roles) conforme as restrições abaixo (Você decide quem
acessa o que) cada acesso é uma Role
• Acesso1 - Apenas para dar select em todas as tabelas.
• Acesso2 - Apenas Select e insert na tabela de carros
• Acesso3 - Total no Sistema e database.
• Acesso4 - Create, alter e drop em tabelas e schema.
• Acesso5 - Total ao schema.*/

CREATE ROLE Acesso1; 
GRANT SELECT ON *.* TO Acesso1;

CREATE ROLE Acesso2;
GRANT SELECT, INSERT ON newtonloc.carros TO Acesso2;

CREATE ROLE Acesso3; 
GRANT ALL PRIVILEGES ON *.* TO Acesso3 WITH GRANT OPTION;

CREATE ROLE Acesso4; 
GRANT CREATE, ALTER, DROP ON newton_loc.* TO Acesso4;

CREATE ROLE Acesso5;  
GRANT ALL PRIVILEGES ON newtonloc.* TO Acesso5;


CREATE USER 'user1'@'localhost' IDENTIFIED BY 'password1';
GRANT Acesso1 TO 'user1'@'localhost'; 

CREATE USER 'user2'@'localhost' IDENTIFIED BY 'password2';
GRANT Acesso2 TO 'user2'@'localhost';

CREATE USER 'user3'@'localhost' IDENTIFIED BY 'password3';
GRANT Acesso3 TO 'user3'@'localhost';

CREATE USER 'user4'@'localhost' IDENTIFIED BY 'password4';
GRANT Acesso4 TO 'user4'@'localhost';

CREATE USER 'user5'@'localhost' IDENTIFIED BY 'password5';
GRANT Acesso5 TO 'user5'@'localhost';

CREATE USER 'user6'@'localhost' IDENTIFIED BY 'password6';
GRANT Acesso1 TO 'user6'@'localhost';

CREATE USER 'user7'@'localhost' IDENTIFIED BY 'password7';
GRANT Acesso2 TO 'user7'@'localhost';

CREATE USER 'user8'@'localhost' IDENTIFIED BY 'password8';
GRANT Acesso3 TO 'user8'@'localhost';

CREATE USER 'user9'@'localhost' IDENTIFIED BY 'password9';
GRANT Acesso4 TO 'user9'@'localhost';

CREATE USER 'user10'@'localhost' IDENTIFIED BY 'password10';
GRANT Acesso5 TO 'user10'@'localhost';

#7. Entre os usuários criados acima, altere as permissões de 5. A sua escolha.
REVOKE Acesso1 FROM 'user6'@'localhost';
GRANT Acesso2 TO 'user6'@'localhost';

REVOKE Acesso2 FROM 'user2'@'localhost';
GRANT Acesso4 TO 'user2'@'localhost';

REVOKE Acesso3 FROM 'user8'@'localhost';
GRANT Acesso5 TO 'user8'@'localhost';

REVOKE Acesso4 FROM 'user9'@'localhost';
GRANT Acesso3 TO 'user9'@'localhost';

REVOKE Acesso5 FROM 'user10'@'localhost';
GRANT Acesso1 TO 'user10'@'localhost';

#8. Crie um índice para cada uma das tabelas acima
CREATE INDEX idx_clientes_nome ON clientes(nome);
CREATE INDEX idx_locacao_data ON locacao(dataLocacao);
CREATE INDEX idx_carros_fabricante ON carros(fabricante);
CREATE INDEX idx_devolucao_data ON devolucao(dataDevolucao);

#Crie 20 perguntas e 20 respostas onde as respostas devem ser todas com Join
-- 1. Qual o nome do cliente que alugou o carro mais recentemente?
SELECT c.nome, l.dataLocacao
FROM clientes c
JOIN locacao l ON c.idCliente = l.fk_idCliente
ORDER BY l.dataLocacao DESC
LIMIT 1;

-- 2. Qual o carro mais alugado?
SELECT car.modelo, COUNT(*) AS total_alugueis
FROM carros car
JOIN locacao l ON car.idCarro = l.fk_idCarro
GROUP BY car.modelo
ORDER BY total_alugueis DESC
LIMIT 1;

-- 3. Quantas vezes cada cliente alugou um carro?
SELECT c.nome, COUNT(l.idLocacao) AS total_alugueis
FROM clientes c
JOIN locacao l ON c.idCliente = l.fk_idCliente
GROUP BY c.nome;

-- 4. Qual o total arrecadado por cliente?
SELECT c.nome, SUM(l.valorDiaria) AS total_gasto
FROM clientes c
JOIN locacao l ON c.idCliente = l.fk_idCliente
GROUP BY c.nome;

-- 5. Quais carros estão disponíveis para locação?
SELECT car.modelo
FROM carros car
LEFT JOIN locacao l ON car.idCarro = l.fk_idCarro
WHERE l.idLocacao IS NULL;

-- 6. Qual cliente devolveu o carro com quilometragem excedida?
SELECT cl.nome, car.modelo, d.quilometragemFinal
FROM devolucao d
JOIN locacao l ON d.idLocacao = l.idLocacao
JOIN clientes cl ON l.fk_idCliente = cl.idCliente
JOIN carros car ON l.fk_idCarro = car.idCarro
WHERE d.quilometragemFinal > l.quilometragemLimite;

-- 7. Qual foi o maior valor de locação já pago?
SELECT c.nome, l.valorDiaria
FROM clientes c
JOIN locacao l ON c.idCliente = l.fk_idCliente
ORDER BY l.valorDiaria DESC
LIMIT 1;

-- 8. Qual a quilometragem média dos carros devolvidos?
SELECT AVG(d.quilometragemFinal) AS quilometragem_media
FROM devolucao d;

-- 9. Qual carro tem a maior quilometragem atual?
SELECT a.modelo, a.quilometragem
FROM carros as a where a.quilometragem  = (
	select max(quilometragem)
    from carros
);

-- 10. Quais carros foram alugados mais de 5 vezes?
SELECT car.modelo, COUNT(*) AS total_alugueis
FROM carros car
JOIN locacao l ON car.idCarro = l.fk_idCarro
GROUP BY car.modelo
HAVING total_alugueis > 5;

-- 10. Quilometragem  e porta mala dos carros SUV
select categoria, modelo, quilometragem, b.porta_mala_L
from carros as a
inner join dimensoes as b on  a.idCarro = b.fk_idCarro
where categoria = 'SUV';

-- 11. QUANTIDADE DE OCUPANTES DOS TOYOTA
SELECT a.fabricante, b.ocupantes
from carros as a
inner join dimensoes as b on  a.idCarro = b.fk_idCarro
WHERE fabricante = 'Toyota';

-- 12. Valor diaria menor que 100
select *
from clientes as a
inner join locacao as b on a.idCliente = b.fk_idCliente
where b.valorDiaria < 100;

-- 13. Valor diaria maior que 100
select *
from clientes as a
inner join locacao as b on a.idCliente = b.fk_idCliente
where b.valorDiaria > 100;

# 10. Crie 10 procedures com tema livre.

-- 1. Procedure para registrar uma nova locação
delimiter $$
CREATE PROCEDURE registrar_locacao(IN data DATE, IN valor DECIMAL(10,2), IN idCliente INT, IN idCarro INT)
BEGIN
    INSERT INTO locacao(dataLocacao, valorDiaria, fk_idCliente, fk_idCarro)
    VALUES (data, valor, idCliente, idCarro);
END $$
delimiter ;

-- 2. Procedure para devolver um carro
delimiter $$
CREATE PROCEDURE devolver_carro(IN idLocacao INT, IN quilometragemFinal INT)
BEGIN
    INSERT INTO devolucao(idLocacao, quilometragemFinal, dataDevolucao)
    VALUES (idLocacao, quilometragemFinal, CURDATE());
END $$
delimiter ;

-- 3. Procedure para calcular o valor total gasto por um cliente
delimiter $$
CREATE PROCEDURE total_gasto_cliente(IN idCliente INT, OUT total DECIMAL(10,2))
BEGIN
    SELECT SUM(valorDiaria) INTO total
    FROM locacao
    WHERE fk_idCliente = idCliente;
END $$
delimiter ;

-- 4. Procedure para buscar carros disponíveis para locação
delimiter $$
CREATE PROCEDURE carros_disponiveis()
BEGIN
    SELECT * FROM carros c
    WHERE NOT EXISTS (SELECT 1 FROM locacao l WHERE l.fk_idCarro = c.idCarro);
END $$
delimiter ;
-- 5. Procedure para listar clientes com devoluções em atraso
delimiter $$
CREATE PROCEDURE clientes_atraso()
BEGIN
    SELECT c.nome
    FROM clientes c
    JOIN locacao l ON c.idCliente = l.fk_idCliente
    JOIN devolucao d ON l.idLocacao = d.idLocacao
    WHERE d.dataDevolucao > DATE_ADD(l.dataLocacao, INTERVAL 7 DAY);
END$$
delimiter ;

-- 6. Procedure para calcular salário 
DELIMITER $$
CREATE PROCEDURE calcular_salario_liquido(IN salario_bruto DECIMAL(10,2), OUT salario_liquido DECIMAL(10,2))
BEGIN
    DECLARE inss DECIMAL(10,2);
    DECLARE irpf DECIMAL(10,2);

    -- Cálculos simplificados para demonstração
    SET inss = salario_bruto * 0.11;
    SET irpf = salario_bruto * 0.2;
    SET salario_liquido = salario_bruto - inss - irpf;
END $$
DELIMITER ;

-- 7. Procedure para inserir cliente em tabela 
DELIMITER $$
CREATE PROCEDURE inserir_cliente(IN nome VARCHAR(100), IN email VARCHAR(100), IN telefone VARCHAR(20))
BEGIN
    INSERT INTO clientes (nome, email, telefone)
    VALUES (nome, email, telefone);
END $$
DELIMITER ;

-- 8. Procedure para atualizar status de um pedido 

DELIMITER $$
CREATE PROCEDURE atualizar_status_pedido(IN id_pedido INT, IN novo_status VARCHAR(50))
BEGIN
    UPDATE pedidos
    SET status = novo_status
    WHERE id = id_pedido;
END $$
DELIMITER ;

-- 9. Procedure para consultar 20 produtos mais vendidos
DELIMITER $$
CREATE PROCEDURE produtos_mais_vendidos()
BEGIN
    SELECT produto_nome, SUM(quantidade) AS total_vendido
    FROM itens_pedidos
    INNER JOIN produtos ON itens_pedidos.produto_id = produtos.id
    GROUP BY produto_nome
    ORDER BY total_vendido DESC
    LIMIT 10;
END $$
DELIMITER ;

-- 10. Procedure para gerar relatório
DELIMITER $$
CREATE PROCEDURE relatorio_vendas_por_mes(IN ano INT)
BEGIN
    SELECT MONTH(data_venda) AS mes, SUM(valor_total) AS total_vendas
    FROM pedidos
    WHERE YEAR(data_venda) = ano
    GROUP BY MONTH(data_venda);
END $$
DELIMITER ;




