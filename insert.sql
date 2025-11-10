--------------------------------------------------------------------------------
-- 1️⃣ INSERÇÃO DE PAÍSES
--------------------------------------------------------------------------------
INSERT INTO TB_MOTTU_PAIS (id_pais, nm_pais) VALUES (1, 'Brasil');
INSERT INTO TB_MOTTU_PAIS (id_pais, nm_pais) VALUES (2, 'Argentina');
INSERT INTO TB_MOTTU_PAIS (id_pais, nm_pais) VALUES (3, 'Chile');
INSERT INTO TB_MOTTU_PAIS (id_pais, nm_pais) VALUES (4, 'Uruguai');
INSERT INTO TB_MOTTU_PAIS (id_pais, nm_pais) VALUES (5, 'Paraguai');

--------------------------------------------------------------------------------
-- 2️⃣ INSERÇÃO DE ESTADOS
--------------------------------------------------------------------------------
INSERT INTO TB_MOTTU_ESTADO (id_estado, id_pais, nm_estado, sigla_estado)
VALUES (1, 1, 'São Paulo', 'SP');
INSERT INTO TB_MOTTU_ESTADO (id_estado, id_pais, nm_estado, sigla_estado)
VALUES (2, 1, 'Rio de Janeiro', 'RJ');
INSERT INTO TB_MOTTU_ESTADO (id_estado, id_pais, nm_estado, sigla_estado)
VALUES (3, 1, 'Minas Gerais', 'MG');
INSERT INTO TB_MOTTU_ESTADO (id_estado, id_pais, nm_estado, sigla_estado)
VALUES (4, 1, 'Paraná', 'PR');
INSERT INTO TB_MOTTU_ESTADO (id_estado, id_pais, nm_estado, sigla_estado)
VALUES (5, 1, 'Bahia', 'BA');

--------------------------------------------------------------------------------
-- 3️⃣ INSERÇÃO DE CIDADES
--------------------------------------------------------------------------------
INSERT INTO TB_MOTTU_CIDADE (id_cidade, id_estado, nm_cidade)
VALUES (1, 1, 'São Paulo');
INSERT INTO TB_MOTTU_CIDADE (id_cidade, id_estado, nm_cidade)
VALUES (2, 2, 'Rio de Janeiro');
INSERT INTO TB_MOTTU_CIDADE (id_cidade, id_estado, nm_cidade)
VALUES (3, 3, 'Belo Horizonte');
INSERT INTO TB_MOTTU_CIDADE (id_cidade, id_estado, nm_cidade)
VALUES (4, 4, 'Curitiba');
INSERT INTO TB_MOTTU_CIDADE (id_cidade, id_estado, nm_cidade)
VALUES (5, 5, 'Salvador');

--------------------------------------------------------------------------------
-- 4️⃣ INSERÇÃO DE BAIRROS
--------------------------------------------------------------------------------
INSERT INTO TB_MOTTU_BAIRRO (id_bairro, id_cidade, nm_bairro)
VALUES (1, 1, 'Centro');
INSERT INTO TB_MOTTU_BAIRRO (id_bairro, id_cidade, nm_bairro)
VALUES (2, 2, 'Copacabana');
INSERT INTO TB_MOTTU_BAIRRO (id_bairro, id_cidade, nm_bairro)
VALUES (3, 3, 'Savassi');
INSERT INTO TB_MOTTU_BAIRRO (id_bairro, id_cidade, nm_bairro)
VALUES (4, 4, 'Batel');
INSERT INTO TB_MOTTU_BAIRRO (id_bairro, id_cidade, nm_bairro)
VALUES (5, 5, 'Rio Vermelho');

--------------------------------------------------------------------------------
-- 5️⃣ INSERÇÃO DE ENDEREÇOS
--------------------------------------------------------------------------------
INSERT INTO TB_MOTTU_ENDERECO (id_endereco, id_bairro, logradouro, nr_endereco, nr_cep, complemento)
VALUES (1, 1, 'Av. Paulista', 1000, '01311000', 'Torre A');
INSERT INTO TB_MOTTU_ENDERECO (id_endereco, id_bairro, logradouro, nr_endereco, nr_cep, complemento)
VALUES (2, 2, 'Av. Atlântica', 500, '22021000', 'Frente Mar');
INSERT INTO TB_MOTTU_ENDERECO (id_endereco, id_bairro, logradouro, nr_endereco, nr_cep, complemento)
VALUES (3, 3, 'Rua da Bahia', 200, '30160010', 'Loja 2');
INSERT INTO TB_MOTTU_ENDERECO (id_endereco, id_bairro, logradouro, nr_endereco, nr_cep, complemento)
VALUES (4, 4, 'Rua XV de Novembro', 150, '80020010', 'Ed. Itália');
INSERT INTO TB_MOTTU_ENDERECO (id_endereco, id_bairro, logradouro, nr_endereco, nr_cep, complemento)
VALUES (5, 5, 'Av. Oceânica', 300, '41940000', 'Sala 5');

--------------------------------------------------------------------------------
-- 6️⃣ INSERÇÃO DE FILIAIS
--------------------------------------------------------------------------------
INSERT INTO TB_MOTTU_FILIAL (id_filial, id_endereco, nm_filial)
VALUES (1, 1, 'Filial São Paulo');
INSERT INTO TB_MOTTU_FILIAL (id_filial, id_endereco, nm_filial)
VALUES (2, 2, 'Filial Rio de Janeiro');
INSERT INTO TB_MOTTU_FILIAL (id_filial, id_endereco, nm_filial)
VALUES (3, 3, 'Filial Belo Horizonte');
INSERT INTO TB_MOTTU_FILIAL (id_filial, id_endereco, nm_filial)
VALUES (4, 4, 'Filial Curitiba');
INSERT INTO TB_MOTTU_FILIAL (id_filial, id_endereco, nm_filial)
VALUES (5, 5, 'Filial Salvador');

--------------------------------------------------------------------------------
-- 7️⃣ INSERÇÃO DE STATUS
--------------------------------------------------------------------------------
INSERT INTO TB_MOTTU_STATUS (id_stat, nm_stat) VALUES (1, 'Ativo');
INSERT INTO TB_MOTTU_STATUS (id_stat, nm_stat) VALUES (2, 'Inativo');
INSERT INTO TB_MOTTU_STATUS (id_stat, nm_stat) VALUES (3, 'Manutenção');
INSERT INTO TB_MOTTU_STATUS (id_stat, nm_stat) VALUES (4, 'Reservado');
INSERT INTO TB_MOTTU_STATUS (id_stat, nm_stat) VALUES (5, 'Disponível');

--------------------------------------------------------------------------------
-- 8️⃣ INSERÇÃO DE ÁREAS (cada filial tem uma área operacional)
--------------------------------------------------------------------------------
INSERT INTO TB_MOTTU_AREA (id_area, id_filial, id_stat, pos_x, pos_y)
VALUES (1, 1, 1, 100, 200);
INSERT INTO TB_MOTTU_AREA (id_area, id_filial, id_stat, pos_x, pos_y)
VALUES (2, 2, 2, 150, 250);
INSERT INTO TB_MOTTU_AREA (id_area, id_filial, id_stat, pos_x, pos_y)
VALUES (3, 3, 3, 200, 300);
INSERT INTO TB_MOTTU_AREA (id_area, id_filial, id_stat, pos_x, pos_y)
VALUES (4, 4, 4, 250, 350);
INSERT INTO TB_MOTTU_AREA (id_area, id_filial, id_stat, pos_x, pos_y)
VALUES (5, 5, 5, 300, 400);

--------------------------------------------------------------------------------
-- 9️⃣ INSERÇÃO DE IOTs (sensores nas motos)
--------------------------------------------------------------------------------
INSERT INTO TB_MOTTU_IOT (iot_hash, latitude, longitude)
VALUES (1, -23.5610, -46.6558);
INSERT INTO TB_MOTTU_IOT (iot_hash, latitude, longitude)
VALUES (2, -22.9707, -43.1823);
INSERT INTO TB_MOTTU_IOT (iot_hash, latitude, longitude)
VALUES (3, -19.9215, -43.9352);
INSERT INTO TB_MOTTU_IOT (iot_hash, latitude, longitude)
VALUES (4, -25.4284, -49.2733);
INSERT INTO TB_MOTTU_IOT (iot_hash, latitude, longitude)
VALUES (5, -12.9777, -38.5016);

--------------------------------------------------------------------------------
-- 🔟 INSERÇÃO DE MODELOS DE MOTOS
--------------------------------------------------------------------------------
INSERT INTO TB_MOTTU_MODELO (id_modelo, nm_modelo, desc_modelo)
VALUES (1, 'Honda CG 160', 'Moto urbana econômica');
INSERT INTO TB_MOTTU_MODELO (id_modelo, nm_modelo, desc_modelo)
VALUES (2, 'Yamaha Fazer 250', 'Alta performance e conforto');
INSERT INTO TB_MOTTU_MODELO (id_modelo, nm_modelo, desc_modelo)
VALUES (3, 'Honda Biz 125', 'Automática para uso leve');
INSERT INTO TB_MOTTU_MODELO (id_modelo, nm_modelo, desc_modelo)
VALUES (4, 'Yamaha Factor 150', 'Modelo intermediário de rua');
INSERT INTO TB_MOTTU_MODELO (id_modelo, nm_modelo, desc_modelo)
VALUES (5, 'Honda CB 300', 'Moto esportiva');

--------------------------------------------------------------------------------
-- 1️⃣1️⃣ INSERÇÃO DE MOTOS (TABELA CENTRAL)
--------------------------------------------------------------------------------
INSERT INTO TB_MOTTU_MOTO (id_moto, iot_hash, id_stat, id_filial, id_modelo, placa, nr_motor)
VALUES (1, 1, 1, 1, 1, 'ABC1A23', 'MOT001A');
INSERT INTO TB_MOTTU_MOTO (id_moto, iot_hash, id_stat, id_filial, id_modelo, placa, nr_motor)
VALUES (2, 2, 2, 2, 2, 'DEF4B56', 'MOT002B');
INSERT INTO TB_MOTTU_MOTO (id_moto, iot_hash, id_stat, id_filial, id_modelo, placa, nr_motor)
VALUES (3, 3, 3, 3, 3, 'GHI7C89', 'MOT003C');
INSERT INTO TB_MOTTU_MOTO (id_moto, iot_hash, id_stat, id_filial, id_modelo, placa, nr_motor)
VALUES (4, 4, 4, 4, 4, 'JKL0D12', 'MOT004D');
INSERT INTO TB_MOTTU_MOTO (id_moto, iot_hash, id_stat, id_filial, id_modelo, placa, nr_motor)
VALUES (5, 5, 5, 5, 5, 'MNO3E45', 'MOT005E');

COMMIT;
