--------------------------------------------------------------------------------
-- PACKAGES & TRIGGER
--------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE pkg_mottu_core AS
  FUNCTION fn_validar_motor (p_motor IN VARCHAR2) RETURN VARCHAR2;

  FUNCTION fn_para_json (p_id_moto IN NUMBER) RETURN VARCHAR2;

  FUNCTION fn_qtd_motos_filial_status (
    p_id_filial IN NUMBER,
    p_id_stat   IN NUMBER
  ) RETURN NUMBER;
END pkg_mottu_core;
/
SHOW ERRORS PACKAGE pkg_mottu_core;

CREATE OR REPLACE PACKAGE BODY pkg_mottu_core AS
  FUNCTION fn_validar_motor (p_motor IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF p_motor IS NULL OR LENGTH(p_motor) < 5 THEN
      RETURN 'Número de motor inválido';
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

  FUNCTION fn_para_json (p_id_moto IN NUMBER) RETURN VARCHAR2 IS
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
      JOIN TB_MOTTU_STATUS S ON M.id_stat = S.id_stat
      JOIN TB_MOTTU_FILIAL F ON M.id_filial = F.id_filial
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

  FUNCTION fn_qtd_motos_filial_status (
    p_id_filial IN NUMBER,
    p_id_stat   IN NUMBER
  ) RETURN NUMBER IS
    v_qtd NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_qtd
      FROM TB_MOTTU_MOTO
     WHERE id_filial = p_id_filial
       AND id_stat   = p_id_stat;
    RETURN v_qtd;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END fn_qtd_motos_filial_status;
END pkg_mottu_core;
/
SHOW ERRORS PACKAGE BODY pkg_mottu_core;

--------------------------------------------------------------------------------
-- PACKAGE: PKG_MOTTU_REPORTS
--------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE pkg_mottu_reports AS
  PROCEDURE prc_exibir_motos_json;
  PROCEDURE prc_resumo_motos;
END pkg_mottu_reports;
/
SHOW ERRORS PACKAGE pkg_mottu_reports;

CREATE OR REPLACE PACKAGE BODY pkg_mottu_reports AS
  PROCEDURE prc_exibir_motos_json IS
    CURSOR c_motos IS SELECT id_moto FROM TB_MOTTU_MOTO ORDER BY id_moto;
    v_json VARCHAR2(4000);
  BEGIN
    DBMS_OUTPUT.PUT_LINE('==== LISTAGEM DE MOTOS (JSON) ====');
    FOR r IN c_motos LOOP
      v_json := pkg_mottu_core.fn_para_json(r.id_moto);
      DBMS_OUTPUT.PUT_LINE(v_json);
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro em prc_exibir_motos_json: ' || SQLERRM);
  END prc_exibir_motos_json;

  PROCEDURE prc_resumo_motos IS
    CURSOR c_resumo IS
      SELECT f.id_filial, f.nm_filial,
             s.id_stat,  s.nm_stat,
             NVL(cnt.qtd, 0) AS qtd
        FROM TB_MOTTU_FILIAL f
   CROSS JOIN TB_MOTTU_STATUS s
   LEFT JOIN (SELECT id_filial, id_stat, COUNT(*) qtd
                FROM TB_MOTTU_MOTO
               GROUP BY id_filial, id_stat) cnt
          ON cnt.id_filial = f.id_filial
         AND cnt.id_stat   = s.id_stat
       ORDER BY f.nm_filial, s.id_stat;

    v_filial_atual TB_MOTTU_FILIAL.nm_filial%TYPE := NULL;
    v_subtotal     NUMBER := 0;
    v_total_geral  NUMBER := 0;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('==== RESUMO DE MOTOS POR FILIAL E STATUS ====');
    DBMS_OUTPUT.PUT_LINE(RPAD('FILIAL',25)||RPAD('STATUS',18)||RPAD('TOTAL',8));
    DBMS_OUTPUT.PUT_LINE(RPAD('-',25,'-')||RPAD('-',18,'-')||RPAD('-',8,'-'));

    FOR r IN c_resumo LOOP
      IF v_filial_atual IS NOT NULL AND v_filial_atual <> r.nm_filial THEN
        DBMS_OUTPUT.PUT_LINE(RPAD(' ',25)||RPAD('Subtotal',18)||TO_CHAR(v_subtotal,'9999'));
        DBMS_OUTPUT.PUT_LINE(RPAD('-',25,'-')||RPAD('-',18,'-')||RPAD('-',8,'-'));
        v_subtotal := 0;
      END IF;

      DBMS_OUTPUT.PUT_LINE(
        RPAD(r.nm_filial,25)||RPAD(r.nm_stat,18)||TO_CHAR(r.qtd,'9999')
      );

      v_subtotal     := v_subtotal + r.qtd;
      v_total_geral  := v_total_geral + r.qtd;
      v_filial_atual := r.nm_filial;
    END LOOP;

    IF v_filial_atual IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE(RPAD(' ',25)||RPAD('Subtotal',18)||TO_CHAR(v_subtotal,'9999'));
    END IF;

    DBMS_OUTPUT.PUT_LINE(RPAD(' ',25)||RPAD('TOTAL GERAL',18)||TO_CHAR(v_total_geral,'9999'));
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro em prc_resumo_motos: ' || SQLERRM);
  END prc_resumo_motos;
END pkg_mottu_reports;
/
SHOW ERRORS PACKAGE BODY pkg_mottu_reports;

--------------------------------------------------------------------------------
-- PACKAGE: PKG_MOTTU_AUDIT
--------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE pkg_mottu_audit AS
  PROCEDURE write_audit(
    p_username    IN VARCHAR2,
    p_operation   IN VARCHAR2,
    p_old_values  IN VARCHAR2,
    p_new_values  IN VARCHAR2
  );

  PROCEDURE prc_listar_auditoria_endereco;
END pkg_mottu_audit;
/
SHOW ERRORS PACKAGE pkg_mottu_audit;

CREATE OR REPLACE PACKAGE BODY pkg_mottu_audit AS
  PROCEDURE write_audit(
    p_username    IN VARCHAR2,
    p_operation   IN VARCHAR2,
    p_old_values  IN VARCHAR2,
    p_new_values  IN VARCHAR2
  ) IS
  BEGIN
    INSERT INTO TB_MOTTU_AUDIT(username, operation_type, operation_date, old_values, new_values)
    VALUES (p_username, p_operation, SYSDATE, p_old_values, p_new_values);
  END write_audit;

  PROCEDURE prc_listar_auditoria_endereco IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('ID',6) || RPAD('USUARIO',15) || RPAD('OPERACAO',12) ||
                         RPAD('DATA',20) || RPAD('OLD',45) || RPAD('NEW',45));
    DBMS_OUTPUT.PUT_LINE(RPAD('-',6,'-') || RPAD('-',15,'-') || RPAD('-',12,'-') ||
                         RPAD('-',20,'-') || RPAD('-',45,'-') || RPAD('-',45,'-'));

    FOR r IN (
      SELECT audit_id,
             username,
             operation_type,
             TO_CHAR(operation_date,'DD/MM/YYYY HH24:MI:SS') AS data_operacao,
             NVL(old_values,'-') AS old_values,
             NVL(new_values,'-') AS new_values
        FROM TB_MOTTU_AUDIT
       ORDER BY audit_id
    ) LOOP
      DBMS_OUTPUT.PUT_LINE(
        RPAD(r.audit_id,6) ||
        RPAD(r.username,15) ||
        RPAD(r.operation_type,12) ||
        RPAD(r.data_operacao,20) ||
        RPAD(SUBSTR(r.old_values,1,44),45) ||
        RPAD(SUBSTR(r.new_values,1,44),45)
      );
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro em prc_listar_auditoria_endereco: ' || SQLERRM);
  END prc_listar_auditoria_endereco;
END pkg_mottu_audit;
/
SHOW ERRORS PACKAGE BODY pkg_mottu_audit;