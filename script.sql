DROP TABLE pessoas						CASCADE CONSTRAINTS;
DROP TABLE passageiros					CASCADE CONSTRAINTS;
DROP TABLE pilotos						CASCADE CONSTRAINTS;
DROP TABLE bagagens						CASCADE CONSTRAINTS;
DROP TABLE passagens					CASCADE CONSTRAINTS;
DROP TABLE tipos_passagens				CASCADE CONSTRAINTS;
DROP TABLE voos							CASCADE CONSTRAINTS;
DROP TABLE bagagens_em_transporte		CASCADE CONSTRAINTS;
DROP TABLE aeronaves					CASCADE CONSTRAINTS;
DROP TABLE aeroportos					CASCADE CONSTRAINTS;
DROP TABLE cias_aereas					CASCADE CONSTRAINTS;
DROP TABLE cias_no_aeroporto			CASCADE CONSTRAINTS;
DROP TABLE aeroporto_intermediario		CASCADE CONSTRAINTS;
DROP TABLE rotas						CASCADE CONSTRAINTS;

CREATE TABLE pessoas (
	id_pessoa					NUMBER(5)		NOT NULL,
	nome						VARCHAR2(100)	NOT NULL,
	cpf							CHAR(11)		NOT NULL,
	idade						NUMBER(3)		NOT NULL,
	CONSTRAINT pk_pessoas PRIMARY KEY (id_pessoa),
	CONSTRAINT uk_pessoas_cpf UNIQUE (cpf),
	CONSTRAINT check_pessoas_cpf CHECK (length(cpf) = 11),
	CONSTRAINT check_pessoas_idade CHECK (idade >= 0)
);

CREATE TABLE passageiros (
	id_pessoa_passageiro		NUMBER(5)		NOT NULL,
	numero_passagem				NUMBER(5)		NOT NULL,
	CONSTRAINT pk_passageiros PRIMARY KEY (id_pessoa_passageiro),
	CONSTRAINT uk_passageiros_num_passagem UNIQUE (numero_passagem)
);

CREATE TABLE pilotos (
	id_pessoa_piloto			NUMBER(5)		NOT NULL,
	anos_experiencia			NUMBER(2)		NOT NULL,
	data_admissao				DATE			NOT NULL,
	CONSTRAINT pk_pilotos PRIMARY KEY (id_pessoa_piloto),
	CONSTRAINT check_pilotos_anos_exp CHECK (anos_experiencia >= 0)
);

CREATE TABLE bagagens (
	id_bagagem					NUMBER(5)		NOT NULL,
	peso						NUMBER(5,2)		NOT NULL,
	altura						NUMBER(5,2)		NOT NULL,
	largura						NUMBER(5,2)		NOT NULL,
	comprimento					NUMBER(5,2)		NOT NULL,
	id_pessoa_dono				NUMBER(5)		NOT NULL,
	CONSTRAINT pk_bagagens PRIMARY KEY (id_bagagem),
	CONSTRAINT check_bagagens_peso CHECK (peso > 0),
	CONSTRAINT check_bagagens_altura CHECK (altura > 0),
	CONSTRAINT check_bagagens_largura CHECK (largura > 0),
	CONSTRAINT check_bagagens_comprimento CHECK (comprimento > 0)
);

CREATE TABLE passagens (
	numero_passagem				NUMBER(5) 		NOT NULL,
	id_tipo_passagem			NUMBER(5)		NOT NULL,
	numero_voo					CHAR(10)		NOT NULL,
	preco						NUMBER(7,2)		NOT NULL,
	CONSTRAINT pk_passagens	PRIMARY KEY (numero_passagem),
	CONSTRAINT check_tipos_passagens_preco CHECK (preco > 0)
);

CREATE TABLE tipos_passagens (
	id_tipo_passagem			NUMBER(5)		NOT NULL,
	descricao					VARCHAR2(50)	NOT NULL,
	CONSTRAINT pk_tipos_passagens PRIMARY KEY (id_tipo_passagem)
);

CREATE TABLE voos (
	numero_voo					CHAR(10)		NOT NULL,
	data_hora_partida			DATE			NOT NULL,
	data_hora_chegada			DATE			NOT NULL,
	id_pessoa_piloto			NUMBER(5)		NOT NULL,
	id_aeronave					NUMBER(5)		NOT NULL,
	id_cia_operadora			NUMBER(5)		NOT NULL,
	id_rota						NUMBER(5)		NOT NULL,
	CONSTRAINT pk_voos PRIMARY KEY (numero_voo)
);

CREATE TABLE bagagens_em_transporte (
	id_bagagem					NUMBER(5)		NOT NULL,
	numero_voo					CHAR(10)		NOT NULL,
	CONSTRAINT pk_bagagens_em_transporte PRIMARY KEY (numero_voo, id_bagagem)
);

CREATE TABLE aeronaves (
	id_aeronave					NUMBER(5)		NOT NULL,
	limite_passageiros			NUMBER(3)		NOT NULL,
	modelo						VARCHAR2(50)	NOT NULL,
	fabricante					VARCHAR2(50)	NOT NULL,
	cod_IATA_aeroporto_atual	CHAR(3)			NOT NULL,
	id_cia_proprietaria			NUMBER(5)		NOT NULL,
	CONSTRAINT pk_aeronaves PRIMARY KEY (id_aeronave),
	CONSTRAINT check_aeronaves_lim_passag CHECK (limite_passageiros > 0)
);

CREATE TABLE aeroportos (
	cod_IATA_aeroporto			CHAR(3)			NOT NULL,
	latitude					NUMBER(10,8)	NOT NULL,
	longitude					NUMBER(11,8)	NOT NULL,
	nome						VARCHAR2(100)	NOT NULL,
	CONSTRAINT pk_aeroportos PRIMARY KEY (cod_IATA_aeroporto),
	CONSTRAINT check_aeroportos_cod CHECK (length(cod_IATA_AEROPORTO) = 3)
);

CREATE TABLE cias_aereas (
	id_cia						NUMBER(5)		NOT NULL,
	nome						VARCHAR2(100)	NOT NULL,
	limite_peso_bagagem			NUMBER(5,2)		NOT NULL,
	limite_altura_bagagem		NUMBER(5,2)		NOT NULL,
	limite_largura_bagagem		NUMBER(5,2)		NOT NULL,
	limite_comprimento_bagagem	NUMBER(5,2)		NOT NULL,
	codigo						CHAR(2)			NOT NULL,
	CONSTRAINT pk_cias_aereas PRIMARY KEY (id_cia),
	CONSTRAINT check_cias_lim_peso CHECK (limite_peso_bagagem > 0),
	CONSTRAINT check_cias_lim_altura CHECK (limite_altura_bagagem > 0),
	CONSTRAINT check_cias_lim_largura CHECK (limite_largura_bagagem > 0),
	CONSTRAINT check_cias_lim_compr CHECK (limite_comprimento_bagagem > 0),
	CONSTRAINT check_cias_codigo CHECK (length(codigo) = 2),
	CONSTRAINT uk_cias_codigo UNIQUE (codigo)
);

CREATE TABLE cias_no_aeroporto (
	cod_IATA_aeroporto			CHAR(3)			NOT NULL,
	id_cia						NUMBER(5)		NOT NULL,
	CONSTRAINT pk_cias_no_aeroporto PRIMARY KEY (cod_IATA_aeroporto, id_cia)
);

CREATE TABLE aeroporto_intermediario (
	id_rota						NUMBER(5)		NOT NULL,
	cod_IATA_aeroporto			CHAR(3)			NOT NULL,
	CONSTRAINT pk_aeroporto_intermediario PRIMARY KEY (cod_IATA_aeroporto, id_rota)
);

CREATE TABLE rotas (
	id_rota						NUMBER(5)		NOT NULL,
	CONSTRAINT pk_rotas PRIMARY KEY (id_rota)
);

--=============================================================================================================================================================
-- FOREIGN KEYS
ALTER TABLE passageiros ADD CONSTRAINT fk_passageiros_pessoas FOREIGN KEY (id_pessoa_passageiro) REFERENCES pessoas (id_pessoa);
ALTER TABLE passageiros ADD CONSTRAINT fk_passageiros_passagens FOREIGN KEY (numero_passagem) REFERENCES passagens (numero_passagem);

ALTER TABLE pilotos ADD CONSTRAINT fk_pilotos_pessoas FOREIGN KEY (id_pessoa_piloto) REFERENCES pessoas (id_pessoa);

ALTER TABLE bagagens ADD CONSTRAINT fk_bagagens_pessoas FOREIGN KEY (id_pessoa_dono) REFERENCES pessoas (id_pessoa);
CREATE INDEX idx_bagagens_id_pessoa_dono ON bagagens (id_pessoa_dono);

ALTER TABLE passagens ADD CONSTRAINT fk_passagens_tipo_passagem FOREIGN KEY (id_tipo_passagem) REFERENCES tipos_passagens (id_tipo_passagem);
ALTER TABLE passagens ADD CONSTRAINT fk_passagens_voos FOREIGN KEY (numero_voo) REFERENCES voos (numero_voo);
CREATE INDEX idx_passagens_numero_voo ON passagens (numero_voo);

ALTER TABLE voos ADD CONSTRAINT fk_voos_pilotos FOREIGN KEY (id_pessoa_piloto) REFERENCES pilotos (id_pessoa_piloto);
ALTER TABLE voos ADD CONSTRAINT fk_voos_aeronaves FOREIGN KEY (id_aeronave) REFERENCES aeronaves (id_aeronave);
ALTER TABLE voos ADD CONSTRAINT fk_voos_cias_aereas FOREIGN KEY (id_cia_operadora) REFERENCES cias_aereas (id_cia);
ALTER TABLE voos ADD CONSTRAINT fk_voos_rotas FOREIGN KEY (id_rota) REFERENCES rotas (id_rota);
CREATE INDEX idx_voos_id_pessoa_piloto ON voos (id_pessoa_piloto);
CREATE INDEX idx_voos_id_rota ON voos (id_rota);

ALTER TABLE bagagens_em_transporte ADD CONSTRAINT fk_bagagens_em_transp_bagagens FOREIGN KEY (id_bagagem) REFERENCES bagagens (id_bagagem);
ALTER TABLE bagagens_em_transporte ADD CONSTRAINT fk_bagagens_em_transp_voos FOREIGN KEY (numero_voo) REFERENCES voos (numero_voo);

ALTER TABLE aeronaves ADD CONSTRAINT fk_aeronaves_aeroportos FOREIGN KEY (cod_IATA_aeroporto_atual) REFERENCES aeroportos (cod_IATA_aeroporto);
ALTER TABLE aeronaves ADD CONSTRAINT fk_aeronaves_cias_aereas FOREIGN KEY (id_cia_proprietaria) REFERENCES cias_aereas (id_cia);
CREATE INDEX idx_aeronaves_id_cia_propr ON aeronaves (id_cia_proprietaria);

ALTER TABLE cias_no_aeroporto ADD CONSTRAINT fk_cias_no_aerop_aeroportos FOREIGN KEY (cod_IATA_aeroporto) REFERENCES aeroportos (cod_IATA_aeroporto);
ALTER TABLE cias_no_aeroporto ADD CONSTRAINT fk_cias_no_aerop_cias_aereas FOREIGN KEY (id_cia) REFERENCES cias_aereas (id_cia);

ALTER TABLE aeroporto_intermediario ADD CONSTRAINT fk_aeroporto_interm_rotas FOREIGN KEY (id_rota) REFERENCES rotas (id_rota);
ALTER TABLE aeroporto_intermediario ADD CONSTRAINT fk_aeroporto_interm_aeroportos FOREIGN KEY (cod_IATA_aeroporto) REFERENCES aeroportos (cod_IATA_aeroporto);



--=============================================================================================================================================================
-- INSERCAO DE DADOS
INSERT INTO pessoas (id_pessoa, nome, cpf, idade) VALUES (1, 'Ricardo Süffert', '01122030300', 19);
INSERT INTO pessoas (id_pessoa, nome, cpf, idade) VALUES (2, 'Fernando Chagas', '02122580309', 20);
INSERT INTO pessoas (id_pessoa, nome, cpf, idade) VALUES (3, 'Arthur Huelsen', '16192000960', 19);
INSERT INTO pessoas (id_pessoa, nome, cpf, idade) VALUES (4, 'Guilherme Stein', '87391299901', 18);
INSERT INTO pessoas (id_pessoa, nome, cpf, idade) VALUES (5, 'João Wendt', '88122312987', 19);
COMMIT;

INSERT INTO tipos_passagens (id_tipo_passagem, preco, descricao) VALUES (1, 'Classe econômica');
INSERT INTO tipos_passagens (id_tipo_passagem, preco, descricao) VALUES (2, 'Classe executiva');
INSERT INTO tipos_passagens (id_tipo_passagem, preco, descricao) VALUES (3, 'Primeira classe');
COMMIT;

INSERT INTO cias_aereas (id_cia, nome, limite_peso_bagagem, limite_altura_bagagem, limite_largura_bagagem, limite_comprimento_bagagem, codigo) 
			VALUES (1, 'Gol Linhas Aéreas', 10, 55, 25, 35, 'GL');
INSERT INTO cias_aereas (id_cia, nome, limite_peso_bagagem, limite_altura_bagagem, limite_largura_bagagem, limite_comprimento_bagagem, codigo) 
			VALUES (2, 'LATAM Airlines Brasil', 23, 55, 25, 35, 'LA');
INSERT INTO cias_aereas (id_cia, nome, limite_peso_bagagem, limite_altura_bagagem, limite_largura_bagagem, limite_comprimento_bagagem, codigo) 
			VALUES (3, 'Azul Linhas Aéreas Brasileiras', 10, 55, 25, 35, 'GL');
COMMIT;

INSERT INTO aeroportos (cod_IATA_aeroporto, latitude, longitude, nome) VALUES ('POA', -29.9942, -51.1714, 'Aeroporto Internacional Salgado Filho');
INSERT INTO aeroportos (cod_IATA_aeroporto, latitude, longitude, nome) VALUES ('GRU', -23.4322, -46.4692, 'Aeroporto Internacional de São Paulo-Guarulhos');
INSERT INTO aeroportos (cod_IATA_aeroporto, latitude, longitude, nome) VALUES ('VCP', -23.0081, -47.1344, 'Aeroporto Internacional de Viracopos-Campinas');
INSERT INTO aeroportos (cod_IATA_aeroporto, latitude, longitude, nome) VALUES ('REC', -8.126389, -34.922778, 'Aeroporto Internacional dos Guararapes');
COMMIT;

INSERT INTO pilotos (id_pessoa_piloto, anos_experiencia, data_admissao) VALUES (5, 0, TO_DATE('05/11/2022', 'DD/MM/YYYY'));
INSERT INTO pilotos (id_pessoa_piloto, anos_experiencia, data_admissao) VALUES (2, 2, TO_DATE('05/11/2020', 'DD/MM/YYYY'));
COMMIT;

INSERT INTO bagagens (id_bagagem, peso, altura, largura, comprimento, id_pessoa_dono) VALUES (1, 12, 43, 19, 30, 1);
INSERT INTO bagagens (id_bagagem, peso, altura, largura, comprimento, id_pessoa_dono) VALUES (2, 19, 54, 32, 35, 3);
INSERT INTO bagagens (id_bagagem, peso, altura, largura, comprimento, id_pessoa_dono) VALUES (3, 8, 31, 14, 23, 4);
INSERT INTO bagagens (id_bagagem, peso, altura, largura, comprimento, id_pessoa_dono) VALUES (4, 17, 46, 16, 32, 2);
COMMIT;

INSERT INTO aeronaves (id_aeronave, limite_passageiros, modelo, fabricante, cod_IATA_aeroporto_atual, id_cia_proprietaria)
			VALUES (1, 186, '737-800', 'Boeing', 'GRU', 1);
INSERT INTO aeronaves (id_aeronave, limite_passageiros, modelo, fabricante, cod_IATA_aeroporto_atual, id_cia_proprietaria)
			VALUES (2, 174, 'A320-200', 'Airbus', 'GRU', 2);
INSERT INTO aeronaves (id_aeronave, limite_passageiros, modelo, fabricante, cod_IATA_aeroporto_atual, id_cia_proprietaria)
			VALUES (3, 186, 'A321-200', 'Airbus', 'POA', 2);
INSERT INTO aeronaves (id_aeronave, limite_passageiros, modelo, fabricante, cod_IATA_aeroporto_atual, id_cia_proprietaria)
			VALUES (4, 165, 'A320neo', 'Airbus', 'VCP', 3);
COMMIT;

INSERT INTO cias_no_aeroporto (cod_IATA_aeroporto, id_cia) VALUES ('POA', 1);
INSERT INTO cias_no_aeroporto (cod_IATA_aeroporto, id_cia) VALUES ('POA', 2);
INSERT INTO cias_no_aeroporto (cod_IATA_aeroporto, id_cia) VALUES ('GRU', 1);
INSERT INTO cias_no_aeroporto (cod_IATA_aeroporto, id_cia) VALUES ('GRU', 2);
INSERT INTO cias_no_aeroporto (cod_IATA_aeroporto, id_cia) VALUES ('GRU', 3);
INSERT INTO cias_no_aeroporto (cod_IATA_aeroporto, id_cia) VALUES ('VCP', 1);
INSERT INTO cias_no_aeroporto (cod_IATA_aeroporto, id_cia) VALUES ('VCP', 2);
INSERT INTO cias_no_aeroporto (cod_IATA_aeroporto, id_cia) VALUES ('VCP', 3);
INSERT INTO cias_no_aeroporto (cod_IATA_aeroporto, id_cia) VALUES ('REC', 2);
INSERT INTO cias_no_aeroporto (cod_IATA_aeroporto, id_cia) VALUES ('REC', 3);
COMMIT;