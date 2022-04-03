CREATE DATABASE p1LabBDRefatoracao
GO
USE p1LabBDRefatoracao

CREATE TABLE times(
	codigoTime		INT				NOT NULL	IDENTITY(1,1),
	nomeTime		VARCHAR(100)	NOT NULL,
	cidade			VARCHAR(100)	NOT NULL,
	estadio			VARCHAR(100)	NOT NULL,
	fl_unico_time	BIT				NOT NULL
	PRIMARY KEY(codigoTime)
)

CREATE TABLE grupos(
	codigoGrupo		INT				NOT NULL	IDENTITY(1,1),
	nome			VARCHAR(1)		NOT NULL	CHECK(UPPER(nome) = 'A' OR 
													  UPPER(nome) = 'B' OR 
													  UPPER(nome) = 'C' OR 
													  UPPER(nome) = 'D')
	PRIMARY KEY(codigoGrupo)
)

CREATE TABLE grupos_times(
	codigoTime		INT,
	codigoGrupo		INT				
	PRIMARY KEY(codigoTime, codigoGrupo)
	FOREIGN KEY(codigoGrupo) REFERENCES grupos(codigoGrupo),
	FOREIGN KEY(codigoTime) REFERENCES times(codigoTime)
)

CREATE TABLE jogos(
	CodigoTimeA		INT				NOT NULL,
	CodigoTimeB		INT				NOT NULL,
	GolsTimeA		INT				,
	GolsTimeB		INT				,
	Data			DATE				
	PRIMARY KEY(CodigoTimeA, CodigoTimeB),
	FOREIGN KEY(CodigoTimeA) REFERENCES times(CodigoTime),
	FOREIGN KEY(CodigoTimeB) REFERENCES times(CodigoTime)
)

CREATE TABLE datas_jogos(
	dia				DATE			NOT NULL,
	fl_passou		BIT				NOT NULL
	PRIMARY KEY(dia)
)

/*Declaração de constantes*/
INSERT INTO times VALUES('Corinthians', 'São Paulo', 'Neo Química Arena', 1, 0),
						('Palmeiras', 'São Paulo', 'Allianz Parque', 1, 0),
						('São Paulo', 'São Paulo', 'Morumbi', 1, 0),
						('Santos', 'Santos', 'Vila Belmiro', 1, 0),
						('Botafogo-SP', 'Ribeirão Preto', 'Santa Cruz', 0, 0),
						('Ferroviária', 'Araraquara', 'Fonte Luminosa', 0, 0),
						('Guarani', 'Campinas', 'Brinco de Ouro', 0, 0),
						('Inter de Limeira', 'Limeira', 'Limeirão', 0, 0),
						('Ituano', 'Itu', 'Novelli Júnior', 0, 0),
						('Mirassol', 'Mirassol', 'José Maria de Campos Maia', 0, 0),
						('Novorizontino', 'Novo Horizonte', 'Jorge Ismael de Biasi', 0, 0),
						('Ponte Preta', 'Campinas', 'Moisés Lucarelli', 0, 0),
						('Red Bull Bragantino', 'Bragança Paulista', 'Nabi Abi Chedid', 0, 0),
						('Santo André', 'Santo André', 'Bruno José Daniel', 0, 0),
						('São Bento', 'Sorocaba', 'Walter Ribeiro', 0, 0),
						('São Caetano', 'São Caetano do Sul', 'Anacletto Campanella', 0, 0)

INSERT INTO grupos VALUES ('A'), ('B'), ('C'), ('D')

INSERT INTO datas_jogos VALUES ('2022-02-27', 0), ('2022-03-02', 0), ('2022-03-06', 0), 
('2022-03-09', 0), ('2022-03-13', 0), ('2022-03-16', 0), 
('2022-03-20', 0), ('2022-03-23', 0), ('2022-03-27', 0),
('2022-03-30', 0), ('2022-04-03', 0), ('2022-04-06', 0)

/*Procedure para separar os times nos grupos*/
CREATE PROCEDURE sp_gerador_grupos 
AS
	
	/*Limpa a separação de gupos passada*/
	DELETE FROM grupos_times

	DECLARE @loop INT
	SET @loop = 1

	WHILE(@loop < 5)BEGIN
		DECLARE @time INT
		SELECT TOP 1 @time = t.codigoTime FROM times AS t 
		LEFT JOIN grupos_times AS gt ON gt.codigoTime = t.codigoTime
		WHERE fl_unico_time = 1 AND gt.codigoTime IS NULL ORDER BY NEWID()
		INSERT INTO grupos_times VALUES(@time, @loop)
		SET @loop = @loop + 1
	END

	SET @loop = 1
	WHILE (@loop < 13)BEGIN
		DECLARE @grupo INT

		SELECT TOP 1 @time = t.codigoTime FROM times AS t 
		LEFT JOIN grupos_times AS gt ON gt.codigoTime = t.codigoTime
		WHERE fl_unico_time = 0 AND gt.codigoTime IS NULL ORDER BY NEWID()

		SELECT TOP 1 @grupo = g.codigoGrupo FROM grupos AS g
		INNER JOIN grupos_times AS gt ON gt.codigoGrupo = g.codigoGrupo
		GROUP BY g.codigoGrupo
		HAVING COUNT(g.codigoGrupo) < 4
		ORDER BY NEWID()

		INSERT INTO grupos_times VALUES(@time, @grupo) 

		SET @loop = @loop + 1
	END

/*Procedure para separar os times*/
CREATE PROCEDURE sp_grupos_rodadas(@rodada INT, @jogos INT, @codigoA INT OUTPUT, @codigoB INT OUTPUT) 
AS
	IF(@rodada <= 4)BEGIN
		IF(@jogos <= 4)BEGIN
			SET @codigoA = 1
			SET @codigoB = 2
		END
		ELSE
		BEGIN
			SET @codigoA = 3
			SET @codigoB = 4
		END
	END

	IF(@rodada > 4 AND @rodada <= 8)BEGIN
		IF(@jogos <= 4)BEGIN
			SET @codigoA = 1
			SET @codigoB = 4
		END
		ELSE
		BEGIN
			SET @codigoA = 2
			SET @codigoB = 3
		END
	END

	IF(@rodada > 8)BEGIN
		IF(@jogos <= 4)BEGIN
			SET @codigoA = 1
			SET @codigoB = 3
		END
		ELSE
		BEGIN
			SET @codigoA = 2
			SET @codigoB = 4
		END
	END

/*Procedure para gerar os jogos*/
CREATE PROCEDURE sp_gerador_jogos
AS

/*Limpa as ultimas partidas*/
DELETE FROM jogos
UPDATE datas_jogos SET fl_passou = 0

/*Separa os grupos caso não estejam separados*/
IF(ISNULL((SELECT COUNT(codigoTime) FROM grupos_times), 0) = 0)BEGIN
	exec sp_gerador_grupos
END

DECLARE @loopRodada INT, @data DATE
SET @loopRodada = 1
SELECT TOP 1 @data = dia FROM datas_jogos WHERE fl_passou != 1 ORDER BY NEWID()

WHILE(@loopRodada < 13)BEGIN
	DECLARE @loopJogos INT
	SET @loopJogos = 1
	WHILE(@loopJogos < 9)BEGIN
		DECLARE @loopValido BIT, @grupoA INT, @grupoB INT
		SET @loopValido = 0

		EXEC sp_grupos_rodadas @loopRodada, @loopJogos, @grupoA OUTPUT, @grupoB OUTPUT

		/*Prevenção de Deadlock*/
		DECLARE @temp TABLE (CodigoTime INT, CodigoGrupo INT)
		DELETE FROM @temp

		IF(@loopRodada % 2 = 0)BEGIN
			IF(@loopJogos % 2 = 0)BEGIN
				INSERT INTO @temp
				SELECT TOP 2 * FROM grupos_times WHERE codigoGrupo = @grupoA ORDER BY codigoTime ASC
				INSERT INTO @temp
				SELECT TOP 2 * FROM grupos_times WHERE codigoGrupo = @grupoB ORDER BY codigoTime ASC
			END
			ELSE
			BEGIN
				INSERT INTO @temp
				SELECT TOP 2 * FROM grupos_times WHERE codigoGrupo = @grupoA ORDER BY codigoTime DESC
				INSERT INTO @temp
				SELECT TOP 2 * FROM grupos_times WHERE codigoGrupo = @grupoB ORDER BY codigoTime DESC
			END
		END
		ELSE
		BEGIN
			IF(@loopJogos % 2 = 0)BEGIN
				INSERT INTO @temp
				SELECT TOP 2 * FROM grupos_times WHERE codigoGrupo = @grupoA ORDER BY codigoTime ASC
				INSERT INTO @temp
				SELECT TOP 2 * FROM grupos_times WHERE codigoGrupo = @grupoB ORDER BY codigoTime DESC
			END
			ELSE
			BEGIN
				INSERT INTO @temp
				SELECT TOP 2 * FROM grupos_times WHERE codigoGrupo = @grupoA ORDER BY codigoTime DESC
				INSERT INTO @temp
				SELECT TOP 2 * FROM grupos_times WHERE codigoGrupo = @grupoB ORDER BY codigoTime ASC
			END
		END

		/*Loop para validação da partida*/
		WHILE(@loopValido = 0)BEGIN
			DECLARE @timeA INT, @timeB INT, @golsA INT, @golsB INT 
			
			SELECT TOP 1 @timeA = codigoTime FROM @temp 
			WHERE codigoGrupo = @grupoA
			AND codigoTime NOT IN(SELECT codigoTimeA FROM jogos WHERE Data = @data)
			ORDER BY NEWID() 

			SELECT TOP 1 @timeB = codigoTime FROM @temp
			WHERE codigoGrupo = @grupoB
			AND codigoTime NOT IN(SELECT codigoTimeB FROM jogos WHERE Data = @data)
			ORDER BY NEWID()
			
			IF((SELECT codigoTimeA FROM jogos WHERE CodigoTimeA = @timeA AND CodigoTimeB = @timeB) IS NULL)BEGIN
				SET @golsA = CAST((RAND() * 5) AS INT)
				SET @golsB = CAST((RAND() * 5) AS INT) 
				INSERT INTO jogos VALUES (@timeA, @timeB, @golsA, @golsB, @data)
				SET @loopValido = 1
				SET @loopJogos = @loopJogos + 1
			END

		END
		
	END

	UPDATE datas_jogos SET fl_passou = 1 WHERE dia = @data
	SELECT TOP 1 @data = dia FROM datas_jogos WHERE fl_passou != 1 ORDER BY NEWID()
	SET @loopRodada = @loopRodada + 1
END

CREATE VIEW v_grupos_times
AS
	SELECT g.nome AS Grupo, t.nomeTime AS Time, t.cidade, t.estadio FROM grupos_times AS gt
	INNER JOIN grupos AS g ON g.codigoGrupo = gt.codigoGrupo
	INNER JOIN times AS t ON t.codigoTime = gt.codigoTime
	
CREATE VIEW v_jogos
AS
	SELECT Data, t1.nomeTime AS 'NomeTime A', GolsTimeA, GolsTimeB, t2.nomeTime AS 'NomeTime B'  FROM jogos AS j
	INNER JOIN times AS t1 ON j.CodigoTimeA = t1.codigoTime
	INNER JOIN times AS t2 ON j.CodigoTimeB = t2.codigoTime
	


SELECT * FROM v_grupos_times
ORDER BY Grupo

SELECT * FROM v_jogos
ORDER BY Data

EXEC sp_gerador_jogos
SELECT * FROM jogos
ORDER BY Data
SELECT * FROM grupos_times
DELETE FROM jogos

EXEC sp_gerador_grupos

DELETE FROM grupos_times



