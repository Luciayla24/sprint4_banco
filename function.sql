--------------------------------------------------------------------------------
-- FUNCTION 1: FN_VALIDAR_MOTOR
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_validar_motor (
    p_motor IN VARCHAR2
) RETURN VARCHAR2 IS
BEGIN
    -- Regra 1: nulo ou curto
    IF p_motor IS NULL OR LENGTH(p_motor) < 5 THEN
        RETURN 'Número de motor inválido';

    -- Regra 2: caracteres permitidos
    ELSIF NOT REGEXP_LIKE(p_motor, '^[A-Z0-9]+$') THEN
        RETURN 'Número de motor contém caracteres inválidos';

    ELSE
        RETURN 'Válido';
    END IF;

EXCEPTION
    WHEN VALUE_ERROR THEN
        RETURN 'Erro de valor';
    WHEN OTHERS THEN
        RETURN 'Erro desconhecido';
END fn_validar_motor;
/

--------------------------------------------------------------------------------
-- FUNCTION 2: FN_PARA_JSON
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_para_json (
    p_id_moto IN NUMBER
) RETURN VARCHAR2 IS
    v_json   VARCHAR2(4000);
    v_placa  VARCHAR2(15);
    v_modelo VARCHAR2(20);
    v_status VARCHAR2(25);
    v_filial VARCHAR2(50);
BEGIN
    SELECT M.placa, MO.nm_modelo, S.nm_stat, F.nm_filial
      INTO v_placa, v_modelo, v_status, v_filial
      FROM TB_MOTTU_MOTO M
      JOIN TB_MOTTU_MODELO MO ON M.id_modelo = MO.id_modelo
      JOIN TB_MOTTU_STATUS S  ON M.id_stat   = S.id_stat
      JOIN TB_MOTTU_FILIAL F  ON M.id_filial = F.id_filial
     WHERE M.id_moto = p_id_moto;

    v_json := '{' ||
              '"placa":"'  || v_placa  || '",' ||
              '"modelo":"' || v_modelo || '",' ||
              '"status":"' || v_status || '",' ||
              '"filial":"' || v_filial || '"' ||
              '}';

    RETURN v_json;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '{"erro":"Nenhum dado encontrado"}';
    WHEN TOO_MANY_ROWS THEN
        RETURN '{"erro":"Múltiplos registros encontrados"}';
    WHEN OTHERS THEN
        RETURN '{"erro":"Erro desconhecido"}';
END fn_para_json;
/

--------------------------------------------------------------------------------
-- FUNCTION 3: FN_QTD_MOTOS_FILIAL_STATUS
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_qtd_motos_filial_status (
    p_id_filial IN NUMBER,
    p_id_stat   IN NUMBER
) RETURN NUMBER IS
    v_qtd NUMBER := 0;
BEGIN
    SELECT COUNT(*)
      INTO v_qtd
      FROM TB_MOTTU_MOTO
     WHERE id_filial = p_id_filial
       AND id_stat   = p_id_stat;

    RETURN v_qtd;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
    WHEN OTHERS THEN
        RETURN 0;
END fn_qtd_motos_filial_status;
/

SET SERVEROUTPUT ON;

BEGIN
  -- Teste da validação de motor
  DBMS_OUTPUT.PUT_LINE('Teste 1 (válido): ' || fn_validar_motor('ABC123'));
  DBMS_OUTPUT.PUT_LINE('Teste 2 (inválido - curto): ' || fn_validar_motor('AB1'));
  DBMS_OUTPUT.PUT_LINE('Teste 3 (inválido - caractere especial): ' || fn_validar_motor('A!B23'));
  DBMS_OUTPUT.PUT_LINE('Teste 4 (nulo): ' || fn_validar_motor(NULL));

  -- Teste da função JSON
  DBMS_OUTPUT.PUT_LINE(CHR(10) || 'JSON da moto ID 1:');
  DBMS_OUTPUT.PUT_LINE(fn_para_json(1));

  -- Teste da contagem de motos
  DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Total de motos na Filial 1 com Status 1: ' ||
                       fn_qtd_motos_filial_status(1,1));
END;
/

