--------------------------------------------------------------------------------
-- 🔹 PROJETO: SISTEMA TRACER - GESTÃO DE MOTO
--------------------------------------------------------------------------------
-- 1️⃣ TABELA: TB_MOTTU_IOT
-- Armazena o identificador físico (hash) e coordenadas de localização do sensor IoT
--------------------------------------------------------------------------------
CREATE TABLE TB_MOTTU_IOT(
  iot_hash  NUMBER(5)     NOT NULL,  -- Identificador único do dispositivo IoT
  latitude  NUMBER(7, 5)  NOT NULL,  -- Latitude de localização
  longitude NUMBER(8, 5)  NOT NULL,  -- Longitude de localização
  CONSTRAINT PK_MOTTU_IOT PRIMARY KEY (iot_hash)
);

--------------------------------------------------------------------------------
-- 2️⃣ TABELA: TB_MOTTU_MODELO
-- Registra os diferentes modelos de motocicleta disponíveis
--------------------------------------------------------------------------------
CREATE TABLE TB_MOTTU_MODELO(
  id_modelo   NUMBER(5)     NOT NULL,   -- Identificador único do modelo
  nm_modelo   VARCHAR2(20)  NOT NULL,   -- Nome do modelo
  desc_modelo VARCHAR2(255),            -- Descrição opcional
  CONSTRAINT PK_MOTTU_MODELO PRIMARY KEY (id_modelo)
);

--------------------------------------------------------------------------------
-- 3️⃣ TABELA: TB_MOTTU_STATUS
-- Define os status possíveis de uma moto, área ou equipamento
--------------------------------------------------------------------------------
CREATE TABLE TB_MOTTU_STATUS(
  id_stat NUMBER(2)    NOT NULL,  -- Código do status
  nm_stat VARCHAR2(25) NOT NULL,  -- Nome do status (ex: Ativo, Inativo, Manutenção)
  CONSTRAINT PK_MOTTU_STATUS PRIMARY KEY (id_stat)
);

--------------------------------------------------------------------------------
-- 4️⃣ TABELA: TB_MOTTU_PAIS
-- Define o país onde estão as filiais (nível mais alto da hierarquia geográfica)
--------------------------------------------------------------------------------
CREATE TABLE TB_MOTTU_PAIS(
  id_pais NUMBER(5)    NOT NULL,
  nm_pais VARCHAR2(50) NOT NULL,
  CONSTRAINT PK_MOTTU_PAIS PRIMARY KEY (id_pais)
);

--------------------------------------------------------------------------------
-- 5️⃣ TABELA: TB_MOTTU_ESTADO
-- Armazena os estados vinculados a um país
--------------------------------------------------------------------------------
CREATE TABLE TB_MOTTU_ESTADO(
  id_estado    NUMBER(5)    NOT NULL,
  id_pais      NUMBER(5)    NOT NULL,
  nm_estado    VARCHAR2(50) NOT NULL,
  sigla_estado CHAR(2)      NOT NULL,
  CONSTRAINT PK_MOTTU_ESTADO PRIMARY KEY (id_estado),
  CONSTRAINT FK_MOTTU_ESTADO_PAIS FOREIGN KEY (id_pais)
      REFERENCES TB_MOTTU_PAIS(id_pais)
);

--------------------------------------------------------------------------------
-- 6️⃣ TABELA: TB_MOTTU_CIDADE
-- Lista as cidades vinculadas a um estado
--------------------------------------------------------------------------------
CREATE TABLE TB_MOTTU_CIDADE(
  id_cidade NUMBER(5)    NOT NULL,
  id_estado NUMBER(5)    NOT NULL,
  nm_cidade VARCHAR2(50) NOT NULL,
  CONSTRAINT PK_MOTTU_CIDADE PRIMARY KEY (id_cidade),
  CONSTRAINT FK_MOTTU_CIDADE_ESTADO FOREIGN KEY (id_estado)
      REFERENCES TB_MOTTU_ESTADO(id_estado)
);

--------------------------------------------------------------------------------
-- 7️⃣ TABELA: TB_MOTTU_BAIRRO
-- Define os bairros pertencentes a uma cidade
--------------------------------------------------------------------------------
CREATE TABLE TB_MOTTU_BAIRRO(
  id_bairro NUMBER(5)    NOT NULL,
  id_cidade NUMBER(5)    NOT NULL,
  nm_bairro VARCHAR2(50) NOT NULL,
  CONSTRAINT PK_MOTTU_BAIRRO PRIMARY KEY (id_bairro),
  CONSTRAINT FK_MOTTU_BAIRRO_CIDADE FOREIGN KEY (id_cidade)
      REFERENCES TB_MOTTU_CIDADE(id_cidade)
);

--------------------------------------------------------------------------------
-- 8️⃣ TABELA: TB_MOTTU_ENDERECO
-- Armazena endereços detalhados (logradouro, número, CEP, etc.)
--------------------------------------------------------------------------------
CREATE TABLE TB_MOTTU_ENDERECO(
  id_endereco NUMBER(5)     NOT NULL,
  id_bairro   NUMBER(5)     NOT NULL,
  logradouro  VARCHAR2(150) NOT NULL,
  nr_endereco NUMBER(5)     NOT NULL,
  nr_cep      CHAR(8)       NOT NULL,
  complemento VARCHAR2(50),
  CONSTRAINT PK_MOTTU_ENDERECO PRIMARY KEY (id_endereco),
  CONSTRAINT FK_MOTTU_ENDERECO_BAIRRO FOREIGN KEY (id_bairro)
      REFERENCES TB_MOTTU_BAIRRO(id_bairro)
);

--------------------------------------------------------------------------------
-- 9️⃣ TABELA: TB_MOTTU_FILIAL
-- Representa uma filial da empresa Mottu (sede operacional)
--------------------------------------------------------------------------------
CREATE TABLE TB_MOTTU_FILIAL(
  id_filial   NUMBER(5)    NOT NULL,
  id_endereco NUMBER(5)    NOT NULL,
  nm_filial   VARCHAR2(50) NOT NULL,
  CONSTRAINT PK_MOTTU_FILIAL PRIMARY KEY (id_filial),
  CONSTRAINT FK_MOTTU_FILIAL_ENDERECO FOREIGN KEY (id_endereco)
      REFERENCES TB_MOTTU_ENDERECO(id_endereco)
);

--------------------------------------------------------------------------------
-- 🔟 TABELA: TB_MOTTU_AREA
-- Define áreas dentro de uma filial (ex: pátio de estacionamento)
--------------------------------------------------------------------------------
CREATE TABLE TB_MOTTU_AREA(
  id_area   NUMBER(5) NOT NULL,
  id_filial NUMBER(5) NOT NULL,
  id_stat   NUMBER(2) NOT NULL,
  pos_x     NUMBER(4) NOT NULL,  -- Posição X no mapa
  pos_y     NUMBER(4) NOT NULL,  -- Posição Y no mapa
  CONSTRAINT PK_MOTTU_AREA PRIMARY KEY (id_area),
  CONSTRAINT FK_MOTTU_AREA_FILIAL FOREIGN KEY (id_filial)
      REFERENCES TB_MOTTU_FILIAL(id_filial),
  CONSTRAINT FK_MOTTU_AREA_STATUS FOREIGN KEY (id_stat)
      REFERENCES TB_MOTTU_STATUS(id_stat)
);

--------------------------------------------------------------------------------
-- 1️⃣1️⃣ TABELA: TB_MOTTU_MOTO
-- Tabela central: cadastra cada motocicleta, modelo, status e localização IoT
--------------------------------------------------------------------------------
CREATE TABLE TB_MOTTU_MOTO(
  id_moto   NUMBER(5)     NOT NULL,
  iot_hash  NUMBER(5)     NOT NULL,
  id_stat   NUMBER(2)     NOT NULL,
  id_filial NUMBER(5)     NOT NULL,
  id_modelo NUMBER(5)     NOT NULL,
  placa     VARCHAR2(15)  NOT NULL,
  nr_motor  VARCHAR2(100) NOT NULL,
  CONSTRAINT PK_MOTTU_MOTO PRIMARY KEY (id_moto),
  CONSTRAINT FK_MOTTU_MOTO_IOT FOREIGN KEY (iot_hash)
      REFERENCES TB_MOTTU_IOT(iot_hash),
  CONSTRAINT FK_MOTTU_MOTO_STATUS FOREIGN KEY (id_stat)
      REFERENCES TB_MOTTU_STATUS(id_stat),
  CONSTRAINT FK_MOTTU_MOTO_FILIAL FOREIGN KEY (id_filial)
      REFERENCES TB_MOTTU_FILIAL(id_filial),
  CONSTRAINT FK_MOTTU_MOTO_MODELO FOREIGN KEY (id_modelo)
      REFERENCES TB_MOTTU_MODELO(id_modelo),
  CONSTRAINT UN_MOTO_PLACA UNIQUE (placa),
  CONSTRAINT UN_MOTO_NR_MOTOR UNIQUE (nr_motor)
);

--------------------------------------------------------------------------------
-- 1️⃣2️⃣ TABELA: TB_MOTTU_AUDIT
-- Guarda o histórico de auditorias (inserções, atualizações e exclusões)
--------------------------------------------------------------------------------
CREATE TABLE TB_MOTTU_AUDIT(
  audit_id       NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  username       VARCHAR2(50),    -- Usuário que executou a ação
  operation_type VARCHAR2(10),    -- Tipo de operação (INSERT, UPDATE, DELETE)
  operation_date DATE,            -- Data e hora da operação
  old_values     VARCHAR2(4000),  -- Valores antigos (antes da alteração)
  new_values     VARCHAR2(4000)   -- Valores novos (após alteração)
);

--------------------------------------------------------------------------------
-- ⚙️ ÍNDICES PARA OTIMIZAÇÃO DE CONSULTAS
--------------------------------------------------------------------------------
CREATE INDEX IDX_MOTTU_MOTO_IOT        ON TB_MOTTU_MOTO(iot_hash);
CREATE INDEX IDX_MOTTU_FILIAL_ENDERECO ON TB_MOTTU_FILIAL(id_endereco);

--------------------------------------------------------------------------------
-- ✅ FINALIZA CRIAÇÃO
--------------------------------------------------------------------------------
COMMIT;
