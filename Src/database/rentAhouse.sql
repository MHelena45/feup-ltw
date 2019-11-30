BEGIN TRANSACTION;

-- Table: Agenda
DROP TABLE IF EXISTS Agenda;

CREATE TABLE Agenda (
    data DATE PRIMARY KEY 
);

-- Table: Pais
DROP TABLE IF EXISTS Pais;

CREATE TABLE Pais (
    idPais      INTEGER PRIMARY KEY,
    nome    VARCHAR(15) UNIQUE NOT NULL 
);

-- Table: Cidade
DROP TABLE IF EXISTS Cidade;

CREATE TABLE Cidade (
    idCidade      INTEGER PRIMARY KEY,
    nome    VARCHAR(15) NOT NULL, 
    idPais    INTEGER REFERENCES Pais (idPais) 
);

-- Table: Utilizador
DROP TABLE IF EXISTS Utilizador;

CREATE TABLE Utilizador (
    idUtilizador   INTEGER IDENTITY(1,1) PRIMARY KEY,
    username       VARCHAR(30) NOT NULL, 
    nome            VARCHAR(30) NOT NULL, 
    email           VARCHAR(30) UNIQUE NOT NULL, 
    idPais          INTEGER REFERENCES Pais (idPais) ON DELETE SET NULL ON UPDATE CASCADE,
    pass        VARCHAR(20) NOT NULL
);

-- Table: Cliente
DROP TABLE IF EXISTS Cliente;

CREATE TABLE Cliente (
    idCliente  INTEGER REFERENCES Utilizador(idUtilizador)  ON DELETE CASCADE ON UPDATE CASCADE,
    classificacaoCliente INTEGER CHECK(classificacaoCLiente >= 1 AND classificacaoCliente <= 5),
    PRIMARY KEY(idCliente)
);


-- Table: Anfitriao
DROP TABLE IF EXISTS Anfitriao;

CREATE TABLE Anfitriao (
    idAnfitriao INTEGER REFERENCES Utilizador(idUtilizador)  ON DELETE CASCADE ON UPDATE CASCADE,
    classificacaoAnfitriao INTEGER CHECK(classificacaoAnfitriao >= 1 AND classificacaoAnfitriao <= 5),
    PRIMARY KEY(idAnfitriao)
);

-- Table: MetodoDePagamento
DROP TABLE IF EXISTS MetodoDePagamento;

CREATE TABLE MetodoDePagamento (
    idMetodo      INTEGER PRIMARY KEY,
    nome    VARCHAR(25) UNIQUE NOT NULL
);

-- Table: Aceita
DROP TABLE IF EXISTS Aceita;

CREATE TABLE Aceita ( 
    anfitriao   INTEGER REFERENCES Anfitriao (idAnfitriao) ON DELETE CASCADE ON UPDATE CASCADE, 
    idMetodo      INTEGER  REFERENCES MetodoDePagamento(idMetodo) ON DELETE CASCADE ON UPDATE CASCADE, 
    PRIMARY KEY (anfitriao, idMetodo)
);

-- Table: Reserva
DROP TABLE IF EXISTS Reserva;

CREATE TABLE Reserva (
    idReserva          INTEGER PRIMARY KEY, 
    dataCheckIn DATE    NOT NULL,
    dataCheckOut DATE   NOT NULL,
    numHospedes INTEGER CHECK (numHospedes > 0), 
    precoTotal  REAL    CHECK (precoTotal > 0), 
    idEstado INTEGER REFERENCES Estado(idEstado) ON DELETE CASCADE ON UPDATE CASCADE,
    idHabitacao   INTEGER REFERENCES Habitacao (idHabitacao),
    UNIQUE (dataCheckIn, idHabitacao)
);

DROP TABLE IF EXISTS Estado;

CREATE TABLE Estado (
    idEstado      INTEGER PRIMARY KEY,                 
    estado  CHAR(9) UNIQUE NOT NULL
);

-- Table: Cancelamento
DROP TABLE IF EXISTS Cancelamento;

CREATE TABLE Cancelamento (
    reembolso   INTEGER     NOT NULL, 
    idCliente     INTEGER REFERENCES Cliente (idCliente)  ON DELETE CASCADE ON UPDATE CASCADE, 
    idReserva     INTEGER REFERENCES Reserva (idReserva)  ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY(idReserva)
);

-- Table: ClassificacaoPorAnfitriao
DROP TABLE IF EXISTS ClassificacaoPorAnfitriao;

CREATE TABLE ClassificacaoPorAnfitriao (
    classificacao   INTEGER CHECK(classificacao >= 1 AND classificacao <= 5), 
    descricao       VARCHAR(500) DEFAULT 'Nao preenchido', 
    idReserva       INTEGER REFERENCES Reserva (idReserva) ON DELETE RESTRICT ON UPDATE RESTRICT,
    idAnfitriao     INTEGER REFERENCES Anfitriao (idAnfitriao) ON DELETE RESTRICT ON UPDATE RESTRICT, 
    PRIMARY KEY (idReserva)
);

-- Table: ClassificacaoPorCliente
DROP TABLE IF EXISTS ClassificacaoPorCliente;

CREATE TABLE ClassificacaoPorCliente (
    limpeza     INTEGER CHECK(limpeza >= 1 AND limpeza <= 5), 
    valor       INTEGER CHECK(valor >= 1 AND valor <= 5),
    checkIn     INTEGER CHECK(checkIn >= 1 AND checkIn <= 5),
    localizacao INTEGER CHECK(localizacao >= 1 AND localizacao <= 5),
    outros      VARCHAR(500) DEFAULT 'Nao preenchido', 
    classificacaoAnfitriao  INTEGER CHECK(classificacaoAnfitriao >= 1 AND classificacaoAnfitriao <= 5),
    descricaoAnfitriao      VARCHAR(500) DEFAULT 'Nao preenchido', 
    idCliente INTEGER REFERENCES Cliente (idCliente)  ON DELETE RESTRICT ON UPDATE RESTRICT,
    idReserva INTEGER REFERENCES Reserva (idReserva) ON DELETE RESTRICT ON UPDATE RESTRICT, 
    PRIMARY KEY (idReserva)
);

-- Table: Comodidade
DROP TABLE IF EXISTS Comodidade;

CREATE TABLE Comodidade (
    idComodidade      INTEGER PRIMARY KEY,
    nome    VARCHAR(15) UNIQUE NOT NULL
);

-- Table: Efetua
DROP TABLE IF EXISTS Efetua;

CREATE TABLE Efetua (
    idCliente INTEGER REFERENCES Cliente(idCliente) ON DELETE CASCADE ON UPDATE CASCADE, 
    idReserva INTEGER REFERENCES Reserva(idReserva) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY(idReserva)
);

-- Table: EscolhidoPelocliente
DROP TABLE IF EXISTS EscolhidoPelocliente;

CREATE TABLE EscolhidoPelocliente (
    idMetodo  INTEGER REFERENCES MetodoDePagamento(idMetodo) ON DELETE CASCADE ON UPDATE CASCADE, 
    idReserva INTEGER REFERENCES Reserva(idReserva) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (idReserva)
);

-- Table: TipoDeHabitacao
DROP TABLE IF EXISTS TipoDeHabitacao;

CREATE TABLE TipoDeHabitacao (
    idTipo   INTEGER PRIMARY KEY,
    nome VARCHAR(30) UNIQUE NOT NULL
);


-- Table: Habitacao
DROP TABLE IF EXISTS Habitacao;

CREATE TABLE Habitacao (
    idHabitacao INTEGER PRIMARY KEY,
    numQuartos  INTEGER CHECK (numQuartos > 0), 
    maxHospedes INTEGER CHECK (maxHospedes > 0), 
    morada      VARCHAR(250) UNIQUE NOT NULL, 
    precoNoite  REAL    CHECK (precoNoite > 0), 
    classificacaoHabitacao INTEGER  CHECK(classificacaoHabitacao >= 1 AND classificacaoHabitacao <= 5), 
    idCidade      INTEGER REFERENCES Cidade (idCidade) ON DELETE CASCADE ON UPDATE CASCADE, 
    idTipo        INTEGER REFERENCES TipoDeHabitacao (idTipo) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table: Disponivel
DROP TABLE IF EXISTS Disponivel;

CREATE TABLE Disponivel (
    idHabitacao   INTEGER REFERENCES Habitacao (idHabitacao)  ON DELETE CASCADE ON UPDATE CASCADE, 
    data        DATE REFERENCES Agenda (data)  ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (idHabitacao, data)
);

-- Table: Dispoe
DROP TABLE IF EXISTS Dispoe;

CREATE TABLE Dispoe (
    idComodidade  INTEGER REFERENCES Comodidade (idComodidade) ON DELETE CASCADE ON UPDATE CASCADE, 
    idHabitacao   INTEGER REFERENCES Habitacao (idHabitacao) ON DELETE CASCADE ON UPDATE CASCADE, 
    PRIMARY KEY (idComodidade, idHabitacao)
);

-- Table: Favorito
DROP TABLE IF EXISTS Favorito;

CREATE TABLE Favorito (
    idCliente     INTEGER REFERENCES Cliente (idCliente) ON DELETE CASCADE ON UPDATE CASCADE, 
    idHabitacao   INTEGER REFERENCES Habitacao (idHabitacao) ON DELETE CASCADE ON UPDATE CASCADE, 
    PRIMARY KEY (idCliente, idHabitacao)
);

-- Table: Fotografia
DROP TABLE IF EXISTS Fotografia;

CREATE TABLE Fotografia (
    urlImagem   VARCHAR(20) PRIMARY KEY, 
    legenda     VARCHAR(250), 
    idHabitacao   INTEGER REFERENCES Habitacao(idHabitacao) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Table: Possui
DROP TABLE IF EXISTS Possui;

CREATE TABLE Possui (
    idAnfitriao   INTEGER REFERENCES Anfitriao (idAnfitriao) ON DELETE CASCADE ON UPDATE CASCADE, 
    idHabitacao   INTEGER REFERENCES Habitacao (idHabitacao) ON DELETE CASCADE ON UPDATE CASCADE, 
    PRIMARY KEY (idHabitacao)
);



CREATE TRIGGER Restricao_Estado
BEFORE INSERT ON ClassificacaoPorCliente
FOR EACH ROW
WHEN exists (SELECT * FROM Reserva WHERE Reserva.idReserva = New.idReserva AND Reserva.idEstado != 0)
BEGIN
    SELECT RAISE(IGNORE);
END;

CREATE TRIGGER Classificacao
AFTER INSERT ON ClassificacaoPorCliente
FOR EACH ROW
BEGIN
    UPDATE Anfitriao
    SET classificacaoAnfitriao = (
        SELECT AVG(classificacaoAnfitriao)
        FROM (ClassificacaoPorCliente NATURAL JOIN (Reserva NATURAL JOIN (Habitacao NATURAL JOIN Possui))) AS E
        WHERE E.idAnfitriao = Anfitriao.idAnfitriao
    )
    WHERE Anfitriao.idAnfitriao = (SELECT idAnfitriao FROM Possui WHERE Possui.idHabitacao = (SELECT idHabitacao FROM Reserva WHERE Reserva.idReserva = New.idReserva));

    UPDATE Habitacao
    SET classificacaoHabitacao = (
        (
        (SELECT AVG(limpeza)
        FROM (ClassificacaoPorCliente NATURAL JOIN Reserva) AS E
        WHERE E.idHabitacao = Habitacao.idHabitacao)
        +
        (SELECT AVG(valor)
        FROM (ClassificacaoPorCliente NATURAL JOIN Reserva) AS E
        WHERE E.idHabitacao = Habitacao.idHabitacao)
        +
        (SELECT AVG(checkIn)
        FROM (ClassificacaoPorCliente NATURAL JOIN Reserva) AS E
        WHERE E.idHabitacao = Habitacao.idHabitacao)
        +
        (SELECT AVG(localizacao)
        FROM (ClassificacaoPorCliente NATURAL JOIN Reserva) AS E
        WHERE E.idHabitacao = Habitacao.idHabitacao)
        ) / 4
    )
    WHERE Habitacao.idHabitacao = (SELECT idHabitacao FROM Reserva WHERE Reserva.idReserva = New.idReserva);
END;


CREATE TRIGGER Disponibilidade
AFTER INSERT ON Reserva
FOR EACH ROW
BEGIN
    DELETE FROM Disponivel
    WHERE Disponivel.idHabitacao = New.idHabitacao AND Disponivel.data >= New.dataCheckIn AND Disponivel.data <= New.dataCheckOut;
END;


COMMIT TRANSACTION;


PRAGMA foreign_keys = ON;

insert into Agenda(data) values('2018-01-01');
insert into Agenda(data) values('2018-01-02');
insert into Agenda(data) values('2018-01-03');
insert into Agenda(data) values('2018-01-04');
insert into Agenda(data) values('2018-01-05');
insert into Agenda(data) values('2018-01-06');
insert into Agenda(data) values('2018-01-07');
insert into Agenda(data) values('2018-01-08');
insert into Agenda(data) values('2018-01-09');
insert into Agenda(data) values('2018-01-10');
insert into Agenda(data) values('2018-01-11');
insert into Agenda(data) values('2018-01-12');
insert into Agenda(data) values('2018-01-13');
insert into Agenda(data) values('2018-01-14');
insert into Agenda(data) values('2018-01-15');
insert into Agenda(data) values('2018-01-16');
insert into Agenda(data) values('2018-01-17');
insert into Agenda(data) values('2018-01-18');
insert into Agenda(data) values('2018-01-19');
insert into Agenda(data) values('2018-01-20');
insert into Agenda(data) values('2018-01-21');
insert into Agenda(data) values('2018-01-22');
insert into Agenda(data) values('2018-01-23');
insert into Agenda(data) values('2018-01-24');
insert into Agenda(data) values('2018-01-25');
insert into Agenda(data) values('2018-01-26');
insert into Agenda(data) values('2018-01-27');
insert into Agenda(data) values('2018-01-28');
insert into Agenda(data) values('2018-01-29');
insert into Agenda(data) values('2018-01-30');
insert into Agenda(data) values('2018-01-31');
insert into Agenda(data) values('2018-02-01');
insert into Agenda(data) values('2018-02-02');
insert into Agenda(data) values('2018-02-03');
insert into Agenda(data) values('2018-02-04');
insert into Agenda(data) values('2018-02-05');
insert into Agenda(data) values('2018-02-06');
insert into Agenda(data) values('2018-02-07');
insert into Agenda(data) values('2018-02-08');
insert into Agenda(data) values('2018-02-09');
insert into Agenda(data) values('2018-02-10');
insert into Agenda(data) values('2018-02-11');
insert into Agenda(data) values('2018-02-12');
insert into Agenda(data) values('2018-02-13');
insert into Agenda(data) values('2018-02-14');
insert into Agenda(data) values('2018-02-15');
insert into Agenda(data) values('2018-02-16');
insert into Agenda(data) values('2018-02-17');
insert into Agenda(data) values('2018-02-18');
insert into Agenda(data) values('2018-02-19');
insert into Agenda(data) values('2018-02-20');
insert into Agenda(data) values('2018-02-21');
insert into Agenda(data) values('2018-02-22');
insert into Agenda(data) values('2018-02-23');
insert into Agenda(data) values('2018-02-24');
insert into Agenda(data) values('2018-02-25');
insert into Agenda(data) values('2018-02-26');
insert into Agenda(data) values('2018-02-27');
insert into Agenda(data) values('2018-02-28');
insert into Agenda(data) values('2018-03-01');
insert into Agenda(data) values('2018-03-02');
insert into Agenda(data) values('2018-03-03');
insert into Agenda(data) values('2018-03-04');
insert into Agenda(data) values('2018-03-05');
insert into Agenda(data) values('2018-03-06');
insert into Agenda(data) values('2018-03-07');
insert into Agenda(data) values('2018-03-08');
insert into Agenda(data) values('2018-03-09');
insert into Agenda(data) values('2018-03-10');
insert into Agenda(data) values('2018-03-11');
insert into Agenda(data) values('2018-03-12');
insert into Agenda(data) values('2018-03-13');
insert into Agenda(data) values('2018-03-14');
insert into Agenda(data) values('2018-03-15');
insert into Agenda(data) values('2018-03-16');
insert into Agenda(data) values('2018-03-17');
insert into Agenda(data) values('2018-03-18');
insert into Agenda(data) values('2018-03-19');
insert into Agenda(data) values('2018-03-20');
insert into Agenda(data) values('2018-03-21');
insert into Agenda(data) values('2018-03-22');
insert into Agenda(data) values('2018-03-23');
insert into Agenda(data) values('2018-03-24');
insert into Agenda(data) values('2018-03-25');
insert into Agenda(data) values('2018-03-26');
insert into Agenda(data) values('2018-03-27');
insert into Agenda(data) values('2018-03-28');
insert into Agenda(data) values('2018-03-29');
insert into Agenda(data) values('2018-03-30');
insert into Agenda(data) values('2018-03-31');
insert into Agenda(data) values('2018-04-01');
insert into Agenda(data) values('2018-04-02');
insert into Agenda(data) values('2018-04-03');
insert into Agenda(data) values('2018-04-04');
insert into Agenda(data) values('2018-04-05');
insert into Agenda(data) values('2018-04-06');
insert into Agenda(data) values('2018-04-07');
insert into Agenda(data) values('2018-04-08');
insert into Agenda(data) values('2018-04-09');
insert into Agenda(data) values('2018-04-10');
insert into Agenda(data) values('2018-04-11');
insert into Agenda(data) values('2018-04-12');
insert into Agenda(data) values('2018-04-13');
insert into Agenda(data) values('2018-04-14');
insert into Agenda(data) values('2018-04-15');
insert into Agenda(data) values('2018-04-16');
insert into Agenda(data) values('2018-04-17');
insert into Agenda(data) values('2018-04-18');
insert into Agenda(data) values('2018-04-19');
insert into Agenda(data) values('2018-04-20');
insert into Agenda(data) values('2018-04-21');
insert into Agenda(data) values('2018-04-22');
insert into Agenda(data) values('2018-04-23');
insert into Agenda(data) values('2018-04-24');
insert into Agenda(data) values('2018-04-25');
insert into Agenda(data) values('2018-04-26');
insert into Agenda(data) values('2018-04-27');
insert into Agenda(data) values('2018-04-28');
insert into Agenda(data) values('2018-04-29');
insert into Agenda(data) values('2018-04-30');
insert into Agenda(data) values('2018-05-01');
insert into Agenda(data) values('2018-05-02');
insert into Agenda(data) values('2018-05-03');
insert into Agenda(data) values('2018-05-04');
insert into Agenda(data) values('2018-05-05');
insert into Agenda(data) values('2018-05-06');
insert into Agenda(data) values('2018-05-07');
insert into Agenda(data) values('2018-05-08');
insert into Agenda(data) values('2018-05-09');
insert into Agenda(data) values('2018-05-10');
insert into Agenda(data) values('2018-05-11');
insert into Agenda(data) values('2018-05-12');
insert into Agenda(data) values('2018-05-13');
insert into Agenda(data) values('2018-05-14');
insert into Agenda(data) values('2018-05-15');
insert into Agenda(data) values('2018-05-16');
insert into Agenda(data) values('2018-05-17');
insert into Agenda(data) values('2018-05-18');
insert into Agenda(data) values('2018-05-19');
insert into Agenda(data) values('2018-05-20');
insert into Agenda(data) values('2018-05-21');
insert into Agenda(data) values('2018-05-22');
insert into Agenda(data) values('2018-05-23');
insert into Agenda(data) values('2018-05-24');
insert into Agenda(data) values('2018-05-25');
insert into Agenda(data) values('2018-05-26');
insert into Agenda(data) values('2018-05-27');
insert into Agenda(data) values('2018-05-28');
insert into Agenda(data) values('2018-05-29');
insert into Agenda(data) values('2018-05-30');
insert into Agenda(data) values('2018-05-31');
insert into Agenda(data) values('2018-06-01');
insert into Agenda(data) values('2018-06-02');
insert into Agenda(data) values('2018-06-03');
insert into Agenda(data) values('2018-06-04');
insert into Agenda(data) values('2018-06-05');
insert into Agenda(data) values('2018-06-06');
insert into Agenda(data) values('2018-06-07');
insert into Agenda(data) values('2018-06-08');
insert into Agenda(data) values('2018-06-09');
insert into Agenda(data) values('2018-06-10');
insert into Agenda(data) values('2018-06-11');
insert into Agenda(data) values('2018-06-12');
insert into Agenda(data) values('2018-06-13');
insert into Agenda(data) values('2018-06-14');
insert into Agenda(data) values('2018-06-15');
insert into Agenda(data) values('2018-06-16');
insert into Agenda(data) values('2018-06-17');
insert into Agenda(data) values('2018-06-18');
insert into Agenda(data) values('2018-06-19');
insert into Agenda(data) values('2018-06-20');
insert into Agenda(data) values('2018-06-21');
insert into Agenda(data) values('2018-06-22');
insert into Agenda(data) values('2018-06-23');
insert into Agenda(data) values('2018-06-24');
insert into Agenda(data) values('2018-06-25');
insert into Agenda(data) values('2018-06-26');
insert into Agenda(data) values('2018-06-27');
insert into Agenda(data) values('2018-06-28');
insert into Agenda(data) values('2018-06-29');
insert into Agenda(data) values('2018-06-30');
insert into Agenda(data) values('2018-07-01');
insert into Agenda(data) values('2018-07-02');
insert into Agenda(data) values('2018-07-03');
insert into Agenda(data) values('2018-07-04');
insert into Agenda(data) values('2018-07-05');
insert into Agenda(data) values('2018-07-06');
insert into Agenda(data) values('2018-07-07');
insert into Agenda(data) values('2018-07-08');
insert into Agenda(data) values('2018-07-09');
insert into Agenda(data) values('2018-07-10');
insert into Agenda(data) values('2018-07-11');
insert into Agenda(data) values('2018-07-12');
insert into Agenda(data) values('2018-07-13');
insert into Agenda(data) values('2018-07-14');
insert into Agenda(data) values('2018-07-15');
insert into Agenda(data) values('2018-07-16');
insert into Agenda(data) values('2018-07-17');
insert into Agenda(data) values('2018-07-18');
insert into Agenda(data) values('2018-07-19');
insert into Agenda(data) values('2018-07-20');
insert into Agenda(data) values('2018-07-21');
insert into Agenda(data) values('2018-07-22');
insert into Agenda(data) values('2018-07-23');
insert into Agenda(data) values('2018-07-24');
insert into Agenda(data) values('2018-07-25');
insert into Agenda(data) values('2018-07-26');
insert into Agenda(data) values('2018-07-27');
insert into Agenda(data) values('2018-07-28');
insert into Agenda(data) values('2018-07-29');
insert into Agenda(data) values('2018-07-30');
insert into Agenda(data) values('2018-07-31');
insert into Agenda(data) values('2018-08-01');
insert into Agenda(data) values('2018-08-02');
insert into Agenda(data) values('2018-08-03');
insert into Agenda(data) values('2018-08-04');
insert into Agenda(data) values('2018-08-05');
insert into Agenda(data) values('2018-08-06');
insert into Agenda(data) values('2018-08-07');
insert into Agenda(data) values('2018-08-08');
insert into Agenda(data) values('2018-08-09');
insert into Agenda(data) values('2018-08-10');
insert into Agenda(data) values('2018-08-11');
insert into Agenda(data) values('2018-08-12');
insert into Agenda(data) values('2018-08-13');
insert into Agenda(data) values('2018-08-14');
insert into Agenda(data) values('2018-08-15');
insert into Agenda(data) values('2018-08-16');
insert into Agenda(data) values('2018-08-17');
insert into Agenda(data) values('2018-08-18');
insert into Agenda(data) values('2018-08-19');
insert into Agenda(data) values('2018-08-20');
insert into Agenda(data) values('2018-08-21');
insert into Agenda(data) values('2018-08-22');
insert into Agenda(data) values('2018-08-23');
insert into Agenda(data) values('2018-08-24');
insert into Agenda(data) values('2018-08-25');
insert into Agenda(data) values('2018-08-26');
insert into Agenda(data) values('2018-08-27');
insert into Agenda(data) values('2018-08-28');
insert into Agenda(data) values('2018-08-29');
insert into Agenda(data) values('2018-08-30');
insert into Agenda(data) values('2018-08-31');
insert into Agenda(data) values('2018-09-01');
insert into Agenda(data) values('2018-09-02');
insert into Agenda(data) values('2018-09-03');
insert into Agenda(data) values('2018-09-04');
insert into Agenda(data) values('2018-09-05');
insert into Agenda(data) values('2018-09-06');
insert into Agenda(data) values('2018-09-07');
insert into Agenda(data) values('2018-09-08');
insert into Agenda(data) values('2018-09-09');
insert into Agenda(data) values('2018-09-10');
insert into Agenda(data) values('2018-09-11');
insert into Agenda(data) values('2018-09-12');
insert into Agenda(data) values('2018-09-13');
insert into Agenda(data) values('2018-09-14');
insert into Agenda(data) values('2018-09-15');
insert into Agenda(data) values('2018-09-16');
insert into Agenda(data) values('2018-09-17');
insert into Agenda(data) values('2018-09-18');
insert into Agenda(data) values('2018-09-19');
insert into Agenda(data) values('2018-09-20');
insert into Agenda(data) values('2018-09-21');
insert into Agenda(data) values('2018-09-22');
insert into Agenda(data) values('2018-09-23');
insert into Agenda(data) values('2018-09-24');
insert into Agenda(data) values('2018-09-25');
insert into Agenda(data) values('2018-09-26');
insert into Agenda(data) values('2018-09-27');
insert into Agenda(data) values('2018-09-28');
insert into Agenda(data) values('2018-09-29');
insert into Agenda(data) values('2018-09-30');
insert into Agenda(data) values('2018-10-01');
insert into Agenda(data) values('2018-10-02');
insert into Agenda(data) values('2018-10-03');
insert into Agenda(data) values('2018-10-04');
insert into Agenda(data) values('2018-10-05');
insert into Agenda(data) values('2018-10-06');
insert into Agenda(data) values('2018-10-07');
insert into Agenda(data) values('2018-10-08');
insert into Agenda(data) values('2018-10-09');
insert into Agenda(data) values('2018-10-10');
insert into Agenda(data) values('2018-10-11');
insert into Agenda(data) values('2018-10-12');
insert into Agenda(data) values('2018-10-13');
insert into Agenda(data) values('2018-10-14');
insert into Agenda(data) values('2018-10-15');
insert into Agenda(data) values('2018-10-16');
insert into Agenda(data) values('2018-10-17');
insert into Agenda(data) values('2018-10-18');
insert into Agenda(data) values('2018-10-19');
insert into Agenda(data) values('2018-10-20');
insert into Agenda(data) values('2018-10-21');
insert into Agenda(data) values('2018-10-22');
insert into Agenda(data) values('2018-10-23');
insert into Agenda(data) values('2018-10-24');
insert into Agenda(data) values('2018-10-25');
insert into Agenda(data) values('2018-10-26');
insert into Agenda(data) values('2018-10-27');
insert into Agenda(data) values('2018-10-28');
insert into Agenda(data) values('2018-10-29');
insert into Agenda(data) values('2018-10-30');
insert into Agenda(data) values('2018-10-31');
insert into Agenda(data) values('2018-11-01');
insert into Agenda(data) values('2018-11-02');
insert into Agenda(data) values('2018-11-03');
insert into Agenda(data) values('2018-11-04');
insert into Agenda(data) values('2018-11-05');
insert into Agenda(data) values('2018-11-06');
insert into Agenda(data) values('2018-11-07');
insert into Agenda(data) values('2018-11-08');
insert into Agenda(data) values('2018-11-09');
insert into Agenda(data) values('2018-11-10');
insert into Agenda(data) values('2018-11-11');
insert into Agenda(data) values('2018-11-12');
insert into Agenda(data) values('2018-11-13');
insert into Agenda(data) values('2018-11-14');
insert into Agenda(data) values('2018-11-15');
insert into Agenda(data) values('2018-11-16');
insert into Agenda(data) values('2018-11-17');
insert into Agenda(data) values('2018-11-18');
insert into Agenda(data) values('2018-11-19');
insert into Agenda(data) values('2018-11-20');
insert into Agenda(data) values('2018-11-21');
insert into Agenda(data) values('2018-11-22');
insert into Agenda(data) values('2018-11-23');
insert into Agenda(data) values('2018-11-24');
insert into Agenda(data) values('2018-11-25');
insert into Agenda(data) values('2018-11-26');
insert into Agenda(data) values('2018-11-27');
insert into Agenda(data) values('2018-11-28');
insert into Agenda(data) values('2018-11-29');
insert into Agenda(data) values('2018-11-30');
insert into Agenda(data) values('2018-12-01');
insert into Agenda(data) values('2018-12-02');
insert into Agenda(data) values('2018-12-03');
insert into Agenda(data) values('2018-12-04');
insert into Agenda(data) values('2018-12-05');
insert into Agenda(data) values('2018-12-06');
insert into Agenda(data) values('2018-12-07');
insert into Agenda(data) values('2018-12-08');
insert into Agenda(data) values('2018-12-09');
insert into Agenda(data) values('2018-12-10');
insert into Agenda(data) values('2018-12-11');
insert into Agenda(data) values('2018-12-12');
insert into Agenda(data) values('2018-12-13');
insert into Agenda(data) values('2018-12-14');
insert into Agenda(data) values('2018-12-15');
insert into Agenda(data) values('2018-12-16');
insert into Agenda(data) values('2018-12-17');
insert into Agenda(data) values('2018-12-18');
insert into Agenda(data) values('2018-12-19');
insert into Agenda(data) values('2018-12-20');
insert into Agenda(data) values('2018-12-21');
insert into Agenda(data) values('2018-12-22');
insert into Agenda(data) values('2018-12-23');
insert into Agenda(data) values('2018-12-24');
insert into Agenda(data) values('2018-12-25');
insert into Agenda(data) values('2018-12-26');
insert into Agenda(data) values('2018-12-27');
insert into Agenda(data) values('2018-12-28');
insert into Agenda(data) values('2018-12-29');
insert into Agenda(data) values('2018-12-30');
insert into Agenda(data) values('2018-12-31');
insert into Agenda(data) values ('2019-04-15');
insert into Agenda(data) values ('2019-04-16');
insert into Agenda(data) values ('2019-04-17');
insert into Agenda(data) values ('2019-04-18');
insert into Agenda(data) values ('2019-04-19');
insert into Agenda(data) values ('2019-04-20');
insert into Agenda(data) values ('2019-04-21');
insert into Agenda(data) values ('2019-04-22');
insert into Agenda(data) values ('2019-04-23');
insert into Agenda(data) values ('2019-04-24');
insert into Agenda(data) values ('2019-04-25');
insert into Agenda(data) values ('2019-04-26');
insert into Agenda(data) values ('2019-04-27');
insert into Agenda(data) values ('2019-04-28');
insert into Agenda(data) values ('2019-04-29');
insert into Agenda(data) values ('2019-04-30');
insert into Agenda(data) values ('2019-05-01');
insert into Agenda(data) values ('2019-05-02');
insert into Agenda(data) values ('2019-05-03');
insert into Agenda(data) values ('2019-05-04');
insert into Agenda(data) values ('2019-05-05');
insert into Agenda(data) values ('2019-05-06');
insert into Agenda(data) values ('2019-05-07');
insert into Agenda(data) values ('2019-05-08');
insert into Agenda(data) values ('2019-05-09');
insert into Agenda(data) values ('2019-05-10');
insert into Agenda(data) values ('2019-05-11');
insert into Agenda(data) values ('2019-05-12');
insert into Agenda(data) values ('2019-05-13');
insert into Agenda(data) values ('2019-05-14');
insert into Agenda(data) values ('2019-05-15');
insert into Agenda(data) values ('2019-05-16');
insert into Agenda(data) values ('2019-05-17');
insert into Agenda(data) values ('2019-05-18');
insert into Agenda(data) values ('2019-05-19');
insert into Agenda(data) values ('2019-05-20');
insert into Agenda(data) values ('2019-05-21');
insert into Agenda(data) values ('2019-05-22');
insert into Agenda(data) values ('2019-05-23');
insert into Agenda(data) values ('2019-05-24');
insert into Agenda(data) values ('2019-05-25');
insert into Agenda(data) values ('2019-05-26');
insert into Agenda(data) values ('2019-05-27');
insert into Agenda(data) values ('2019-05-28');
insert into Agenda(data) values ('2019-05-29');
insert into Agenda(data) values ('2019-05-30');
insert into Agenda(data) values ('2019-05-31');
insert into Agenda(data) values ('2019-06-01');
insert into Agenda(data) values ('2019-06-02');
insert into Agenda(data) values ('2019-06-03');
insert into Agenda(data) values ('2019-06-04');
insert into Agenda(data) values ('2019-06-05');
insert into Agenda(data) values ('2019-06-06');
insert into Agenda(data) values ('2019-06-07');
insert into Agenda(data) values ('2019-06-08');
insert into Agenda(data) values ('2019-06-09');
insert into Agenda(data) values ('2019-06-10');
insert into Agenda(data) values ('2019-06-11');
insert into Agenda(data) values ('2019-06-12');
insert into Agenda(data) values ('2019-06-13');
insert into Agenda(data) values ('2019-06-14');
insert into Agenda(data) values ('2019-06-15');
insert into Agenda(data) values ('2019-06-16');
insert into Agenda(data) values ('2019-06-17');
insert into Agenda(data) values ('2019-06-18');
insert into Agenda(data) values ('2019-06-19');
insert into Agenda(data) values ('2019-06-20');
insert into Agenda(data) values ('2019-06-21');
insert into Agenda(data) values ('2019-06-22');
insert into Agenda(data) values ('2019-06-23');
insert into Agenda(data) values ('2019-06-24');
insert into Agenda(data) values ('2019-06-25');
insert into Agenda(data) values ('2019-06-26');
insert into Agenda(data) values ('2019-06-27');
insert into Agenda(data) values ('2019-06-28');
insert into Agenda(data) values ('2019-06-29');
insert into Agenda(data) values ('2019-06-30');
insert into Agenda(data) values ('2019-07-01');
insert into Agenda(data) values ('2019-07-02');
insert into Agenda(data) values ('2019-07-03');
insert into Agenda(data) values ('2019-07-04');
insert into Agenda(data) values ('2019-07-05');
insert into Agenda(data) values ('2019-07-06');
insert into Agenda(data) values ('2019-07-07');
insert into Agenda(data) values ('2019-07-08');
insert into Agenda(data) values ('2019-07-09');
insert into Agenda(data) values ('2019-07-10');
insert into Agenda(data) values ('2019-07-11');
insert into Agenda(data) values ('2019-07-12');
insert into Agenda(data) values ('2019-07-13');
insert into Agenda(data) values ('2019-07-14');
insert into Agenda(data) values ('2019-07-15');
insert into Agenda(data) values ('2019-07-16');
insert into Agenda(data) values ('2019-07-17');
insert into Agenda(data) values ('2019-07-18');
insert into Agenda(data) values ('2019-07-19');
insert into Agenda(data) values ('2019-07-20');
insert into Agenda(data) values ('2019-07-21');
insert into Agenda(data) values ('2019-07-22');
insert into Agenda(data) values ('2019-07-23');
insert into Agenda(data) values ('2019-07-24');
insert into Agenda(data) values ('2019-07-25');
insert into Agenda(data) values ('2019-07-26');
insert into Agenda(data) values ('2019-07-27');
insert into Agenda(data) values ('2019-07-28');
insert into Agenda(data) values ('2019-07-29');
insert into Agenda(data) values ('2019-07-30');
insert into Agenda(data) values ('2019-07-31');
insert into Agenda(data) values ('2019-08-01');
insert into Agenda(data) values ('2019-08-02');
insert into Agenda(data) values ('2019-08-03');
insert into Agenda(data) values ('2019-08-04');
insert into Agenda(data) values ('2019-08-05');
insert into Agenda(data) values ('2019-08-06');
insert into Agenda(data) values ('2019-08-07');
insert into Agenda(data) values ('2019-08-08');
insert into Agenda(data) values ('2019-08-09');
insert into Agenda(data) values ('2019-08-10');
insert into Agenda(data) values ('2019-08-11');
insert into Agenda(data) values ('2019-08-12');
insert into Agenda(data) values ('2019-08-13');
insert into Agenda(data) values ('2019-08-14');
insert into Agenda(data) values ('2019-08-15');
insert into Agenda(data) values ('2019-08-16');
insert into Agenda(data) values ('2019-08-17');
insert into Agenda(data) values ('2019-08-18');
insert into Agenda(data) values ('2019-08-19');
insert into Agenda(data) values ('2019-08-20');
insert into Agenda(data) values ('2019-08-21');
insert into Agenda(data) values ('2019-08-22');
insert into Agenda(data) values ('2019-08-23');
insert into Agenda(data) values ('2019-08-24');
insert into Agenda(data) values ('2019-08-25');
insert into Agenda(data) values ('2019-08-26');
insert into Agenda(data) values ('2019-08-27');
insert into Agenda(data) values ('2019-08-28');
insert into Agenda(data) values ('2019-08-29');
insert into Agenda(data) values ('2019-08-30');
insert into Agenda(data) values ('2019-08-31');
insert into Agenda(data) values ('2019-09-01');
insert into Agenda(data) values ('2019-09-02');
insert into Agenda(data) values ('2019-09-03');
insert into Agenda(data) values ('2019-09-04');
insert into Agenda(data) values ('2019-09-05');
insert into Agenda(data) values ('2019-09-06');
insert into Agenda(data) values ('2019-09-07');
insert into Agenda(data) values ('2019-09-08');
insert into Agenda(data) values ('2019-09-09');
insert into Agenda(data) values ('2019-09-10');
insert into Agenda(data) values ('2019-09-11');
insert into Agenda(data) values ('2019-09-12');
insert into Agenda(data) values ('2019-09-13');
insert into Agenda(data) values ('2019-09-14');
insert into Agenda(data) values ('2019-09-15');
insert into Agenda(data) values ('2019-09-16');
insert into Agenda(data) values ('2019-09-17');
insert into Agenda(data) values ('2019-09-18');
insert into Agenda(data) values ('2019-09-19');
insert into Agenda(data) values ('2019-09-20');
insert into Agenda(data) values ('2019-09-21');
insert into Agenda(data) values ('2019-09-22');
insert into Agenda(data) values ('2019-09-23');
insert into Agenda(data) values ('2019-09-24');
insert into Agenda(data) values ('2019-09-25');
insert into Agenda(data) values ('2019-09-26');
insert into Agenda(data) values ('2019-09-27');
insert into Agenda(data) values ('2019-09-28');
insert into Agenda(data) values ('2019-09-29');
insert into Agenda(data) values ('2019-09-30');

insert into Pais(idPais, nome) values (1,"Portugal");
insert into Pais(idPais, nome) values (2,"United States of America");
insert into Pais(idPais, nome) values (3,"Spain");
insert into Pais(idPais, nome) values (4,"France");
insert into Pais(idPais, nome) values (5,"United Kingdom");
insert into Pais(idPais, nome) values (6,"Italy");
insert into Pais(idPais, nome) values (7,"Japan");
insert into Pais(idPais, nome) values (8,"Angola");
insert into Pais(idPais, nome) values (9,"Australia");
insert into Pais(idPais, nome) values (10,"Finland");
insert into Pais(idPais, nome) values (11,"Mali");
insert into Pais(idPais, nome) values (12,"Peru");
insert into Pais(idPais, nome) values (13,"Chile");
insert into Pais(idPais, nome) values (14,"China");
insert into Pais(idPais, nome) values (15,"New Zealand");
insert into Pais(idPais, nome) values (16,"Turkey");
insert into Pais(idPais, nome) values (17,"Brazil");
insert into Pais(idPais, nome) values (18,"Argentina");

insert into Cidade(idCidade, nome, idPais) values(1,"Porto", 1);
insert into Cidade(idCidade, nome, idPais) values(2,"Lisboa", 1);
insert into Cidade(idCidade, nome, idPais) values(3,"Braga", 1);
insert into Cidade(idCidade, nome, idPais) values(4,"Felgueiras", 1);
insert into Cidade(idCidade, nome, idPais) values(5,"Fafe", 1);
insert into Cidade(idCidade, nome, idPais) values(6,"Aveiro", 1);
insert into Cidade(idCidade, nome, idPais) values(7,"Portimao", 1);
insert into Cidade(idCidade, nome, idPais) values(8,"Alentejo", 1);
insert into Cidade(idCidade, nome, idPais) values(9,"Coimbra", 1);
insert into Cidade(idCidade, nome, idPais) values(10,"Nova Iorque", 2);
insert into Cidade(idCidade, nome, idPais) values(11,"Madrid", 3);
insert into Cidade(idCidade, nome, idPais) values(12,"Paris", 4);
insert into Cidade(idCidade, nome, idPais) values(13,"Londres", 5);
insert into Cidade(idCidade, nome, idPais) values(14,"Roma", 6);
insert into Cidade(idCidade, nome, idPais) values(15,"Toquio", 7);
insert into Cidade(idCidade, nome, idPais) values(16,"Luanda", 8);
insert into Cidade(idCidade, nome, idPais) values(17,"Sydney", 9);
insert into Cidade(idCidade, nome, idPais) values(18,"Santarem", 1);
insert into Cidade(idCidade, nome, idPais) values(19,"Setubal", 1);
insert into Cidade(idCidade, nome, idPais) values(20,"Vizela", 1);
insert into Cidade(idCidade, nome, idPais) values(21,"Felgueiras", 1);
insert into Cidade(idCidade, nome, idPais) values(22,"Pevidem", 1);
insert into Cidade(idCidade, nome, idPais) values(23,"Guimaraes", 1);
insert into Cidade(idCidade, nome, idPais) values(24,"Viana do Castelo", 1);
insert into Cidade(idCidade, nome, idPais) values(25,"Caminha", 1);
insert into Cidade(idCidade, nome, idPais) values(26,"Evora", 1);
insert into Cidade(idCidade, nome, idPais) values(27,"Los Angeles", 2);
insert into Cidade(idCidade, nome, idPais) values(28,"Helsinquia", 10);
insert into Cidade(idCidade, nome, idPais) values(29,"Bamako", 11);
insert into Cidade(idCidade, nome, idPais) values(30,"Lima", 12);
insert into Cidade(idCidade, nome, idPais) values(31,"Santiago", 13);
insert into Cidade(idCidade, nome, idPais) values(32,"Pequim", 14);
insert into Cidade(idCidade, nome, idPais) values(33,"Auckland", 15);
insert into Cidade(idCidade, nome, idPais) values(34,"Istambul", 16);
insert into Cidade(idCidade, nome, idPais) values(35,"Rio de Janeiro", 17);
insert into Cidade(idCidade, nome, idPais) values(36,"Buenos Aires", 18);

insert into Utilizador ( username, nome,  email, idPais, pass) values ( "Jose", "José Ribeiro", "jribeiro@gmail.com", 1, "crocodilo1");
insert into Utilizador ( username, nome, email, idPais, pass) values ( "Stuart","Stuart Little", "slittle@gmail.com", 2, "tartaruga2");
insert into Utilizador ( username, nome, email, idPais, pass) values ("Marta", "Marta Silva", "msilva15@gmail.com", 1, "leao3");
insert into Utilizador ( username, nome, email, idPais, pass) values ("Ricardo", "Ricardo Sousa", "rsousa@gmail.com", 1, "tigre4");
insert into Utilizador ( username, nome, email, idPais, pass) values ("Penélope","Penélope Cruz", "pcruz@gmail.com", 3, "hipopotamo5");
insert into Utilizador ( username, nome, email, idPais, pass) values ("Kit", "Kit Harington", "kharington@gmail.com", 5, "formiga6");
insert into Utilizador ( username, nome, email, idPais, pass) values ("Monica", "Monica Bellucci", "mbelluci@gmail.com", 6, "pato7");
insert into Utilizador ( username, nome, email, idPais, pass) values ("Chris","Chris Hemsworth", "chemsworth@gmail.com", 9, "rinoceronte8");

insert into Anfitriao (idAnfitriao, classificacaoAnfitriao) values (1, NULL); 
insert into Anfitriao (idAnfitriao, classificacaoAnfitriao) values (2, NULL);
insert into Anfitriao (idAnfitriao, classificacaoAnfitriao) values (3, NULL);
insert into Anfitriao (idAnfitriao, classificacaoAnfitriao) values (9, NULL); 
insert into Anfitriao (idAnfitriao, classificacaoAnfitriao) values (13, NULL);
insert into Anfitriao (idAnfitriao, classificacaoAnfitriao) values (14, NULL);

insert into Cliente (idCliente, ClassificacaoCliente) values (1, NULL);
insert into Cliente (idCliente, ClassificacaoCliente) values (3, NULL);
insert into Cliente (idCliente, ClassificacaoCliente) values (4, NULL); 
insert into Cliente (idCliente, ClassificacaoCliente) values (5, NULL);
insert into Cliente (idCliente, ClassificacaoCliente) values (6, NULL);
insert into Cliente (idCliente, ClassificacaoCliente) values (7, NULL);
insert into Cliente (idCliente, ClassificacaoCliente) values (8, NULL);
insert into Cliente (idCliente, ClassificacaoCliente) values (9, NULL);
insert into Cliente (idCliente, ClassificacaoCliente) values (10, NULL);
insert into Cliente (idCliente, ClassificacaoCliente) values (11, NULL);
insert into Cliente (idCliente, ClassificacaoCliente) values (12, NULL); 
insert into Cliente (idCliente, ClassificacaoCliente) values (13, NULL); 
insert into Cliente (idCliente, ClassificacaoCliente) values (14, NULL);
insert into Cliente (idCliente, ClassificacaoCliente) values (15, NULL);
insert into Cliente (idCliente, ClassificacaoCliente) values (16, NULL);

insert into MetodoDePagamento(idMetodo,nome) values(1,"Multibanco");
insert into MetodoDePagamento(idMetodo,nome) values(2,"MB Way");
insert into MetodoDePagamento(idMetodo,nome) values(3,"Transferencia Bancaria");
insert into MetodoDePagamento(idMetodo,nome) values(4,"PayPal");
insert into MetodoDePagamento(idMetodo,nome) values(5,"Cartao de Credito");

insert into Aceita(anfitriao, idMetodo) values (1, 2);
insert into Aceita(anfitriao, idMetodo) values (1, 4);
insert into Aceita(anfitriao, idMetodo) values (1, 5);
insert into Aceita(anfitriao, idMetodo) values (2, 4);
insert into Aceita(anfitriao, idMetodo) values (2, 5);
insert into Aceita(anfitriao, idMetodo) values (2, 3);

insert into Comodidade(idComodidade,nome) values(1,"Cozinha equipada");
insert into Comodidade(idComodidade,nome) values(2,"Internet gratuita");
insert into Comodidade(idComodidade,nome) values(3,"TV por cabo");
insert into Comodidade(idComodidade,nome) values(4,"Roupa de cama");
insert into Comodidade(idComodidade,nome) values(5,"Barbecue");
insert into Comodidade(idComodidade,nome) values(6,"Maquina de Lavar Roupa");
insert into Comodidade(idComodidade,nome) values(7,"Maquina de Lavar Louca");
insert into Comodidade(idComodidade,nome) values(8,"Ferro de Engomar");
insert into Comodidade(idComodidade,nome) values(9,"Casa de Banho Privada");
insert into Comodidade(idComodidade,nome) values(10,"Piscina Exterior");
insert into Comodidade(idComodidade,nome) values(11,"Piscina Interior");
insert into Comodidade(idComodidade,nome) values(12,"Jacuzzi");

insert into TipoDeHabitacao(idTipo,nome) values (1,"Apartamento");
insert into TipoDeHabitacao(idTipo,nome) values (2,"Casa");
insert into TipoDeHabitacao(idTipo,nome) values (3,"Bungalow");
insert into TipoDeHabitacao(idTipo,nome) values (4,"Tenda");
insert into TipoDeHabitacao(idTipo,nome) values (5,"Quarto de Hotel");
insert into TipoDeHabitacao(idTipo,nome) values (6,"Quarto Privado");
insert into TipoDeHabitacao(idTipo,nome) values (7,"Quarto Partilhado");
insert into TipoDeHabitacao(idTipo,nome) values (8,"Hostel");

insert into Habitacao(idHabitacao,numQuartos, maxHospedes,morada, precoNoite, classificacaoHabitacao, idCidade, idTipo) values (1,3,7,"Av. Afonso Henriques 9035", 35, NULL, 7, 2);
insert into Habitacao(idHabitacao,numQuartos, maxHospedes,morada, precoNoite, classificacaoHabitacao, idCidade, idTipo) values (2,5,10,"Rua S. Caetano, s/n",40, NULL, 8, 2);
insert into Habitacao(idHabitacao,numQuartos, maxHospedes,morada, precoNoite, classificacaoHabitacao, idCidade, idTipo) values (3,1,2,"Rua da Boavista",35, NULL, 1, 6);
insert into Habitacao(idHabitacao,numQuartos, maxHospedes,morada, precoNoite, classificacaoHabitacao, idCidade, idTipo) values (4,1,1,"Praceta Joao XXI",80, NULL, 3, 5);
insert into Habitacao(idHabitacao,numQuartos, maxHospedes,morada, precoNoite, classificacaoHabitacao, idCidade, idTipo) values (5,4,9,"Av. Esteves Alberto 645", 33, NULL, 8, 6);
insert into Habitacao(idHabitacao,numQuartos, maxHospedes,morada, precoNoite, classificacaoHabitacao, idCidade, idTipo) values (6,3,3,"Rua D.Pedro III, s/n", 40, NULL, 7, 2);
insert into Habitacao(idHabitacao,numQuartos, maxHospedes,morada, precoNoite, classificacaoHabitacao, idCidade, idTipo) values (7,2,4,"Rua da Trindade",43, NULL, 3, 2);
insert into Habitacao(idHabitacao,numQuartos, maxHospedes,morada, precoNoite, classificacaoHabitacao, idCidade, idTipo) values (8,1,2,"Praca Joao I", 23, NULL, 3, 5);
insert into Habitacao(idHabitacao,numQuartos, maxHospedes,morada, precoNoite, classificacaoHabitacao, idCidade, idTipo) values (9,3,7,"Rua do Algarve, 23", 23, NULL, 7, 2);

insert into Habitacao(idHabitacao,numQuartos, maxHospedes,morada, precoNoite, classificacaoHabitacao, idCidade, idTipo) values (10,3,5,"Rua do Olhar, 23", 50, NULL, 7, 2);
insert into Habitacao(idHabitacao,numQuartos, maxHospedes,morada, precoNoite, classificacaoHabitacao, idCidade, idTipo) values (11,3,3,"Rua da Gaivota, 30", 70,  NULL, 7, 2);
insert into Habitacao(idHabitacao,numQuartos, maxHospedes,morada, precoNoite, classificacaoHabitacao, idCidade, idTipo) values (12,3,10,"Praca D. Pedro, 10", 300, NULL, 7, 2);
insert into Habitacao(idHabitacao,numQuartos, maxHospedes,morada, precoNoite, classificacaoHabitacao, idCidade, idTipo) values (13,3,5,"Rua do Mar, 1", 23, NULL, 7, 2);
insert into Habitacao(idHabitacao,numQuartos, maxHospedes,morada, precoNoite, classificacaoHabitacao, idCidade, idTipo) values (14,3,6,"Rua da Alegria, 1000", 20,  NULL, 7, 2);
insert into Habitacao(idHabitacao,numQuartos, maxHospedes,morada, precoNoite, classificacaoHabitacao, idCidade, idTipo) values (15,3,8,"Rua do Sal, 14", 60,  NULL, 7, 2);
insert into Habitacao(idHabitacao,numQuartos, maxHospedes,morada, precoNoite, classificacaoHabitacao, idCidade, idTipo) values (16,3,4,"Rua da Areia, 70", 85, NULL, 7, 2);
insert into Habitacao(idHabitacao,numQuartos, maxHospedes,morada, precoNoite, classificacaoHabitacao, idCidade, idTipo) values (17,3,7,"Rua do Algarve, 500", 890, NULL, 7, 2);

insert into Disponivel (idHabitacao, data) values (1, '2019-06-01');   
insert into Disponivel (idHabitacao, data) values (1, '2019-06-02');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-03');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-04');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-05');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-06');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-07');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-08');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-09');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-10');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-11');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-12');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-13');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-14');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-15');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-16');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-17');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-18');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-19');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-20');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-21');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-22');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-23');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-24');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-25');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-26');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-27');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-28');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-29');
insert into Disponivel (idHabitacao, data) values (1, '2019-06-30');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-01');   
insert into Disponivel (idHabitacao, data) values (1, '2019-07-02');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-03');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-04');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-05');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-06');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-07');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-08');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-09');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-10');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-11');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-12');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-13');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-14');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-15');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-16');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-17');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-18');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-19');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-20');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-21');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-22');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-23');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-24');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-25');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-26');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-27');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-28');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-29');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-30');
insert into Disponivel (idHabitacao, data) values (1, '2019-07-31');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-01');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-02');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-03');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-04');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-05');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-06');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-07');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-08');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-09');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-10');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-11');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-12');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-13');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-14');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-15');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-16');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-17');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-18');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-19');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-20');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-21');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-22');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-23');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-24');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-25');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-26');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-27');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-28');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-29');
insert into Disponivel (idHabitacao, data) values (2, '2019-06-30');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-01');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-02');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-03');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-04');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-05');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-06');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-07');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-08');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-09');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-10');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-11');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-12');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-13');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-14');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-15');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-16');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-17');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-18');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-19');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-20');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-21');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-22');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-23');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-24');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-25');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-26');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-27');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-28');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-29');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-30');
insert into Disponivel (idHabitacao, data) values (2, '2019-07-31');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-01');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-02');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-03');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-04');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-05');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-06');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-07');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-08');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-09');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-10');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-11');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-12');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-13');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-14');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-15');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-16');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-17');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-18');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-19');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-20');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-21');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-22');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-23');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-24');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-25');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-26');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-27');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-28');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-29');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-30');
insert into Disponivel (idHabitacao, data) values (2, '2019-08-31');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-01');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-02');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-03');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-04');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-05');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-06');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-07');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-08');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-09');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-10');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-11');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-12');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-13');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-14');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-15');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-16');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-17');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-18');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-19');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-20');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-21');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-22');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-23');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-24');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-25');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-26');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-27');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-28');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-29');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-30');
insert into Disponivel (idHabitacao, data) values (3, '2019-05-31');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-01');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-02');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-03');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-04');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-05');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-06');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-07');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-08');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-09');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-10');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-11');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-12');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-13');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-14');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-15');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-16');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-17');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-18');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-19');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-20');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-21');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-22');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-23');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-24');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-25');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-26');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-27');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-28');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-29');
insert into Disponivel (idHabitacao, data) values (3, '2019-06-30');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-01');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-02');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-03');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-04');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-05');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-06');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-07');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-08');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-09');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-10');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-11');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-12');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-13');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-14');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-15');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-16');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-17');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-18');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-19');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-20');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-21');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-22');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-23');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-24');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-25');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-26');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-27');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-28');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-29');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-30');
insert into Disponivel (idHabitacao, data) values (3, '2019-07-31');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-01');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-02');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-03');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-04');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-05');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-06');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-07');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-08');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-09');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-10');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-11');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-12');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-13');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-14');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-15');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-16');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-17');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-18');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-19');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-20');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-21');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-22');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-23');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-24');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-25');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-26');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-27');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-28');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-29');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-30');
insert into Disponivel (idHabitacao, data) values (3, '2019-08-31');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-01');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-02');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-03');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-04');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-05');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-06');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-07');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-08');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-09');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-10');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-11');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-12');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-13');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-14');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-15');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-16');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-17');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-18');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-19');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-20');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-21');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-22');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-23');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-24');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-25');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-26');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-27');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-28');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-29');
insert into Disponivel (idHabitacao, data) values (3, '2019-09-30');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-01');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-02');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-03');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-04');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-05');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-06');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-07');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-08');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-09');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-10');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-11');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-12');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-13');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-14');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-15');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-16');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-17');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-18');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-19');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-20');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-21');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-22');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-23');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-24');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-25');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-26');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-27');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-28');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-29');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-30');
insert into Disponivel (idHabitacao, data) values (4, '2019-07-31');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-01');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-02');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-03');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-04');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-05');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-06');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-07');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-08');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-09');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-10');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-11');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-12');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-13');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-14');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-15');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-16');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-17');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-18');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-19');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-20');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-21');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-22');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-23');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-24');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-25');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-26');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-27');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-28');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-29');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-30');
insert into Disponivel (idHabitacao, data) values (6, '2019-07-31');

insert into Disponivel (idHabitacao, data) values (10, '2019-07-01');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-02');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-03');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-04');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-05');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-06');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-07');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-08');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-09');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-10');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-11');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-12');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-13');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-14');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-15');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-16');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-17');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-18');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-19');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-20');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-21');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-22');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-23');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-24');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-25');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-26');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-27');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-28');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-29');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-30');
insert into Disponivel (idHabitacao, data) values (10, '2019-07-31');

insert into Disponivel (idHabitacao, data) values (11, '2019-07-01');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-02');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-03');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-04');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-05');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-06');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-07');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-08');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-09');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-10');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-11');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-12');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-13');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-14');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-15');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-16');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-17');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-18');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-19');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-20');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-21');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-22');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-23');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-24');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-25');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-26');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-27');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-28');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-29');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-30');
insert into Disponivel (idHabitacao, data) values (11, '2019-07-31');

insert into Disponivel (idHabitacao, data) values (12, '2019-07-01');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-02');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-03');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-04');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-05');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-06');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-07');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-08');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-09');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-10');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-11');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-12');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-13');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-14');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-15');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-16');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-17');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-18');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-19');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-20');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-21');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-22');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-23');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-24');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-25');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-26');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-27');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-28');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-29');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-30');
insert into Disponivel (idHabitacao, data) values (12, '2019-07-31');

insert into Disponivel (idHabitacao, data) values (13, '2019-07-01');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-02');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-03');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-04');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-05');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-06');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-07');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-08');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-09');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-10');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-11');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-12');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-13');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-14');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-15');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-16');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-17');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-18');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-19');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-20');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-21');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-22');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-23');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-24');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-25');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-26');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-27');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-28');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-29');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-30');
insert into Disponivel (idHabitacao, data) values (13, '2019-07-31');

insert into Disponivel (idHabitacao, data) values (14, '2019-07-01');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-02');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-03');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-04');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-05');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-06');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-07');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-08');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-09');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-10');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-11');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-12');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-13');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-14');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-15');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-16');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-17');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-18');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-19');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-20');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-21');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-22');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-23');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-24');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-25');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-26');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-27');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-28');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-29');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-30');
insert into Disponivel (idHabitacao, data) values (14, '2019-07-31');

insert into Disponivel (idHabitacao, data) values (15, '2019-07-01');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-02');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-03');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-04');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-05');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-06');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-07');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-08');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-09');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-10');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-11');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-12');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-13');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-14');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-15');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-16');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-17');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-18');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-19');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-20');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-21');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-22');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-23');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-24');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-25');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-26');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-27');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-28');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-29');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-30');
insert into Disponivel (idHabitacao, data) values (15, '2019-07-31');

insert into Disponivel (idHabitacao, data) values (16, '2019-07-01');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-02');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-03');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-04');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-05');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-06');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-07');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-08');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-09');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-10');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-11');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-12');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-13');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-14');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-15');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-16');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-17');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-18');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-19');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-20');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-21');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-22');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-23');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-24');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-25');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-26');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-27');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-28');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-29');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-30');
insert into Disponivel (idHabitacao, data) values (16, '2019-07-31');

insert into Disponivel (idHabitacao, data) values (17, '2019-07-01');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-02');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-03');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-04');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-05');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-06');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-07');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-08');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-09');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-10');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-11');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-12');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-13');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-14');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-15');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-16');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-17');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-18');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-19');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-20');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-21');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-22');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-23');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-24');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-25');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-26');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-27');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-28');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-29');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-30');
insert into Disponivel (idHabitacao, data) values (17, '2019-07-31');
insert into Dispoe (idComodidade, idHabitacao) values (1,1);
insert into Dispoe (idComodidade, idHabitacao) values (2,1);
insert into Dispoe (idComodidade, idHabitacao) values (9,1);
insert into Dispoe (idComodidade, idHabitacao) values (12,1);
insert into Dispoe (idComodidade, idHabitacao) values (11,1);
insert into Dispoe (idComodidade, idHabitacao) values (7,1);
insert into Dispoe (idComodidade, idHabitacao) values (1,3);
insert into Dispoe (idComodidade, idHabitacao) values (2,3);
insert into Dispoe (idComodidade, idHabitacao) values (3,3);
insert into Dispoe (idComodidade, idHabitacao) values (4,3);
insert into Dispoe (idComodidade, idHabitacao) values (5,3);
insert into Dispoe (idComodidade, idHabitacao) values (6,3);
insert into Dispoe (idComodidade, idHabitacao) values (8,3);
insert into Dispoe (idComodidade, idHabitacao) values (9,3);
insert into Dispoe (idComodidade, idHabitacao) values (9,4);
insert into Dispoe (idComodidade, idHabitacao) values (11,4);

insert into Favorito(idCliente, idHabitacao) values (4, 3);
insert into Favorito(idCliente, idHabitacao) values (4, 4);
insert into Favorito(idCliente, idHabitacao) values (1, 1);
insert into Favorito(idCliente, idHabitacao) values (1, 2);
insert into Favorito(idCliente, idHabitacao) values (3, 2);
insert into Favorito(idCliente, idHabitacao) values (12, 3);
insert into Favorito(idCliente, idHabitacao) values (13, 3);
insert into Favorito(idCliente, idHabitacao) values (16, 6);
insert into Favorito(idCliente, idHabitacao) values (8, 8);
insert into Favorito(idCliente, idHabitacao) values (8, 5);
insert into Favorito(idCliente, idHabitacao) values (9, 5);
insert into Favorito(idCliente, idHabitacao) values (5, 3);

insert into Fotografia(urlImagem,legenda, idHabitacao) values ("bit.ly/jHDSA", "Cozinha", 1);
insert into Fotografia(urlImagem,legenda, idHabitacao) values ("bit.ly/Ohds", "Jacuzzi", 1);
insert into Fotografia(urlImagem,legenda, idHabitacao) values ("bit.ly/OhMt", "Piscina Interior", 1);
insert into Fotografia(urlImagem,legenda, idHabitacao) values ("bit.ly/GtdsaeIy", "Quarto 1", 1);
insert into Fotografia(urlImagem,legenda, idHabitacao) values ("bit.ly/GtdsaTUR", "Quarto 2", 1);
insert into Fotografia(urlImagem,legenda, idHabitacao) values ("bit.ly/BmsTreW", "Quarto 3", 1);
insert into Fotografia(urlImagem,legenda, idHabitacao) values ("bit.ly/MerCBrt", "Quarto 1", 2);
insert into Fotografia(urlImagem,legenda, idHabitacao) values ("bit.ly/TypiwQ", "Quarto 2", 2);
insert into Fotografia(urlImagem,legenda, idHabitacao) values ("bit.ly/TydsbeT", "Quarto 3", 2);
insert into Fotografia(urlImagem,legenda, idHabitacao) values ("bit.ly/GkdsaPY", "Quarto 4", 2);
insert into Fotografia(urlImagem,legenda, idHabitacao) values ("bit.ly/GkdsaY", "Quarto 5", 2);
insert into Fotografia(urlImagem,legenda, idHabitacao) values ("bit.ly/GkYxZ", "Cozinha", 3);
insert into Fotografia(urlImagem,legenda, idHabitacao) values ("bit.ly/ZwTub", "Barbecue", 3);
insert into Fotografia(urlImagem,legenda, idHabitacao) values ("bit.ly/Hjuy", "Quarto", 3);
insert into Fotografia(urlImagem,legenda, idHabitacao) values ("bit.ly/Hjdsj", "Casa de Banho", 4);
insert into Fotografia(urlImagem,legenda, idHabitacao) values ("bit.ly/HDAfhd", "Casa de Banho", 4);
insert into Fotografia(urlImagem,legenda, idHabitacao) values ("bit.ly/HjhFEH", "Piscina Interior", 4);

insert into Possui(idAnfitriao, idHabitacao) values(1, 4);
insert into Possui(idAnfitriao, idHabitacao) values(2, 2);
insert into Possui(idAnfitriao, idHabitacao) values(2, 1);
insert into Possui(idAnfitriao, idHabitacao) values(3, 3);
insert into Possui(idAnfitriao, idHabitacao) values(9, 5);
insert into Possui(idAnfitriao, idHabitacao) values(13, 6);
insert into Possui(idAnfitriao, idHabitacao) values(9, 7);
insert into Possui(idAnfitriao, idHabitacao) values(14, 8);
insert into Possui(idAnfitriao, idHabitacao) values(1, 10);
insert into Possui(idAnfitriao, idHabitacao) values(1, 11);
insert into Possui(idAnfitriao, idHabitacao) values(1, 12);
insert into Possui(idAnfitriao, idHabitacao) values(1, 13);
insert into Possui(idAnfitriao, idHabitacao) values(1, 14);
insert into Possui(idAnfitriao, idHabitacao) values(1, 15);
insert into Possui(idAnfitriao, idHabitacao) values(1, 16);
insert into Possui(idAnfitriao, idHabitacao) values(1, 17);


insert into Estado(idEstado,estado) values(0,"Concluida");
insert into Estado(idEstado,estado) values(1,"Em espera");
insert into Estado(idEstado,estado) values(2,"A decorrer");
insert into Estado(idEstado,estado) values(3,"Cancelado");

insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (1, '2019-06-20', '2019-06-27', 6, 260, 1, 0);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (2, '2019-07-02', '2019-07-15', 1, 80, 4, 3);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (3, '2019-05-03', '2019-08-03', 1, 3235, 3, 2);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (4, '2019-06-28', '2019-06-29', 6, 260, 1, 0);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (5, '2019-06-30', '2019-07-01', 6, 260, 2, 0);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (6, '2019-04-30', '2019-05-01', 6, 100, 1, 0);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (7, '2019-08-30', '2019-09-01', 6, 100, 1, 1);																																							   
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (8, '2018-07-02', '2018-07-15', 2, 80, 6, 0);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (9, '2018-05-03', '2018-06-03', 2, 335, 7, 0);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (10, '2018-06-28', '2018-06-29', 3, 360, 8, 0);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (11, '2018-06-30', '2018-07-01', 3, 560, 5, 0);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (12, '2018-04-30', '2018-05-01', 12, 120, 6, 0);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (13, '2018-06-20', '2018-06-27', 11, 240, 6, 0);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (14, '2018-07-02', '2018-07-15', 1, 40, 7, 0);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (15, '2018-06-10', '2018-06-23', 1, 2435, 7, 0);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (16, '2018-07-03', '2018-07-08', 3, 232, 8, 0);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (17, '2018-07-30', '2018-08-01', 4, 220, 5, 0);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (18, '2018-08-30', '2018-09-01', 8, 500, 6, 0);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (19, '2018-07-03', '2018-07-10', 3, 371, 10, 0);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (20, '2018-08-04', '2018-08-15', 4, 785, 11, 0);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (21, '2018-06-10', '2018-06-23', 1, 3920, 12, 0);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (22, '2018-05-03', '2018-06-08', 2, 215, 13, 0);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (23, '2019-07-30', '2019-08-01', 4, 76, 14, 1);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (24, '2019-09-30', '2019-10-01', 5, 130, 15, 1);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (25, '2019-06-30', '2019-07-01', 4, 76, 14, 3);
insert into Reserva(idReserva, dataCheckIn, dataCheckOut, numHospedes, precoTotal, idHabitacao, idEstado) values (26, '2019-08-30', '2019-09-01', 5, 130, 15, 3);

insert into EscolhidoPeloCliente(idMetodo, idReserva) values(2, 2);
insert into EscolhidoPeloCliente(idMetodo, idReserva) values(4, 3);
insert into EscolhidoPeloCliente(idMetodo, idReserva) values(3, 1);

insert into Efetua(idCliente, idReserva) values (3, 1);
insert into Efetua(idCliente, idReserva) values (4, 2);
insert into Efetua(idCliente, idReserva) values (1, 3);
insert into Efetua(idCliente, idReserva) values (5, 4);
insert into Efetua(idCliente, idReserva) values (6, 5);
insert into Efetua(idCliente, idReserva) values (1, 6);
insert into Efetua(idCliente, idReserva) values (1, 7);													   
insert into Efetua(idCliente, idReserva) values (10, 18);
insert into Efetua(idCliente, idReserva) values (11, 12);
insert into Efetua(idCliente, idReserva) values (12, 11);
insert into Efetua(idCliente, idReserva) values (14, 10);
insert into Efetua(idCliente, idReserva) values (14, 9);
insert into Efetua(idCliente, idReserva) values (15, 8);
insert into Efetua(idCliente, idReserva) values (14, 17);
insert into Efetua(idCliente, idReserva) values (15, 16);
insert into Efetua(idCliente, idReserva) values (16, 13);
insert into Efetua(idCliente, idReserva) values (16, 14);
insert into Efetua(idCliente, idReserva) values (16, 15);
insert into Efetua(idCliente, idReserva) values (1, 19);
insert into Efetua(idCliente, idReserva) values (1, 20);
insert into Efetua(idCliente, idReserva) values (1, 21);
insert into Efetua(idCliente, idReserva) values (1, 22);
insert into Efetua(idCliente, idReserva) values (1, 23);
insert into Efetua(idCliente, idReserva) values (1, 24);
insert into Efetua(idCliente, idReserva) values (7, 25);
insert into Efetua(idCliente, idReserva) values (9, 26);




insert into Cancelamento(reembolso, idCliente, idReserva) values (260, 4, 2);
insert into Cancelamento(reembolso, idCliente, idReserva) values (38, 7, 25);
insert into Cancelamento(reembolso, idCliente, idReserva) values (65, 9, 26);

update Reserva set idEstado = 3 WHERE idReserva = 2;

insert into ClassificacaoPorAnfitriao(classificacao, descricao, idReserva, idAnfitriao) values (4, "Cliente muito simpatico e compreensivo. Otimo hospede!", 1, 2);
insert into ClassificacaoPorAnfitriao(classificacao, descricao, idReserva, idAnfitriao) values (5, "Cliente responsável e limpo. Recomendo", 2, 1);

insert into ClassificacaoPorCliente(limpeza, valor, checkIn, localizacao, outros, classificacaoAnfitriao, descricaoAnfitriao, idReserva, idCliente) values (3,5,5,3,NULL,2,"Anfitriao bastante conflituoso, não regressarei a nenhuma das suas habitações.", 1, 3);
insert into ClassificacaoPorCliente(limpeza, valor, checkIn, localizacao, outros, classificacaoAnfitriao, descricaoAnfitriao, idReserva, idCliente) values (5,4,4,3,NULL,4,"Anfitriao atencioso e preocupado", 4, 5);
insert into ClassificacaoPorCliente(limpeza, valor, checkIn, localizacao, outros, classificacaoAnfitriao, descricaoAnfitriao, idReserva, idCliente) values (5,2,4,5,NULL,5,"Casa muito bem localizada e limpa.0", 6, 1);
insert into ClassificacaoPorCliente(limpeza, valor, checkIn, localizacao, outros, classificacaoAnfitriao, descricaoAnfitriao, idReserva, idCliente) values (3,3,3,3,NULL,5,"Casa pouco cuidada para o valor pedido.", 12, 11);
insert into ClassificacaoPorCliente(limpeza, valor, checkIn, localizacao, outros, classificacaoAnfitriao, descricaoAnfitriao, idReserva, idCliente) values (4,4,3,5,NULL,5,"Casa muito bem localizada", 13, 16);
insert into ClassificacaoPorCliente(limpeza, valor, checkIn, localizacao, outros, classificacaoAnfitriao, descricaoAnfitriao, idReserva, idCliente) values (5,5,3,3,NULL,5,"Anfitriao atencioso e preocupado. Boa experiencia.", 18, 10);
insert into ClassificacaoPorCliente(limpeza, valor, checkIn, localizacao, outros, classificacaoAnfitriao, descricaoAnfitriao, idReserva, idCliente) values (5,5,3,3,NULL,5,"Anfitriao atencioso. Cesto de boas vindas a chegada e um pormenor muito bom.", 8, 15);