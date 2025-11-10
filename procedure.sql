--------------------------------------------------------------------------------
-- PROCEDURE 1: PRC_EXIBIR_MOTOS_JSON
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE prc_exibir_motos_json IS
  -- Cursor com todos os dados necessários para o JSON
  CURSOR c_motos IS
    SELECT
      m.id_moto,
      m.placa,
      mo.nm_modelo,
      s.nm_stat,
      f.nm_filial
    FROM TB_MOTTU_MOTO   m
    JOIN TB_MOTTU_MODELO mo ON mo.id_modelo = m.id_modelo
    JOIN TB_MOTTU_STATUS s  ON s.id_stat   = m.id_stat
    JOIN TB_MOTTU_FILIAL f  ON f.id_filial = m.id_filial
    ORDER BY m.id_moto;

  v_json VARCHAR2(4000);
BEGIN
  DBMS_OUTPUT.PUT_LINE('==== LISTAGEM DE MOTOS (JSON) ====');

  FOR r IN c_motos LOOP
    -- Montagem manual do JSON
    v_json := '{' ||
              '"id_moto":'  || r.id_moto || ',' ||
              '"placa":"'   || r.placa   || '",' ||
              '"modelo":"'  || r.nm_modelo || '",' ||
              '"status":"'  || r.nm_stat   || '",' ||
              '"filial":"'  || r.nm_filial || '"' ||
              '}';

    DBMS_OUTPUT.PUT_LINE(v_json);
  END LOOP;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    -- Em cursores implícitos dificilmente cai aqui, mas deixamos a msg padrão
    DBMS_OUTPUT.PUT_LINE('Nenhuma moto encontrada.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro inesperado em prc_exibir_motos_json: ' || SQLERRM);
END prc_exibir_motos_json;
/

--------------------------------------------------------------------------------
-- PROCEDURE 2: PRC_RESUMO_MOTOS
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE prc_resumo_motos IS

  -- Cursor que já traz filial, status e a contagem
  CURSOR c_resumo IS
    SELECT
      f.id_filial,
      f.nm_filial,
      s.id_stat,
      s.nm_stat,
      NVL(cnt.qtd, 0) AS qtd
    FROM TB_MOTTU_FILIAL f
    CROSS JOIN TB_MOTTU_STATUS s
    LEFT JOIN (
      SELECT id_filial, id_stat, COUNT(*) AS qtd
      FROM TB_MOTTU_MOTO
      GROUP BY id_filial, id_stat
    ) cnt
      ON cnt.id_filial = f.id_filial
     AND cnt.id_stat   = s.id_stat
    ORDER BY f.nm_filial, s.id_stat;

  v_filial_atual   TB_MOTTU_FILIAL.nm_filial%TYPE := NULL;
  v_subtotal       NUMBER := 0;
  v_total_geral    NUMBER := 0;
BEGIN
  DBMS_OUTPUT.PUT_LINE('==== RESUMO DE MOTOS POR FILIAL E STATUS ====');
  DBMS_OUTPUT.PUT_LINE(RPAD('FILIAL', 25) || RPAD('STATUS', 18) || RPAD('TOTAL', 8));
  DBMS_OUTPUT.PUT_LINE(RPAD('-', 25, '-') || RPAD('-', 18, '-') || RPAD('-', 8, '-'));

  FOR r IN c_resumo LOOP
    -- Mudança de filial: imprime subtotal da anterior (se houver) e zera acumulador
    IF v_filial_atual IS NOT NULL AND v_filial_atual <> r.nm_filial THEN
      DBMS_OUTPUT.PUT_LINE(RPAD(' ', 25) || RPAD('Subtotal', 18) || TO_CHAR(v_subtotal, '9999'));
      DBMS_OUTPUT.PUT_LINE(RPAD('-', 25, '-') || RPAD('-', 18, '-') || RPAD('-', 8, '-'));
      v_subtotal := 0;
    END IF;

    -- Imprime linha normal
    DBMS_OUTPUT.PUT_LINE(
      RPAD(r.nm_filial, 25) ||
      RPAD(r.nm_stat,   18) ||
      TO_CHAR(r.qtd, '9999')
    );

    -- Acumula
    v_subtotal    := v_subtotal    + r.qtd;
    v_total_geral := v_total_geral + r.qtd;
    v_filial_atual := r.nm_filial;
  END LOOP;

  -- Subtotal da última filial (se houve linhas)
  IF v_filial_atual IS NOT NULL THEN
    DBMS_OUTPUT.PUT_LINE(RPAD(' ', 25) || RPAD('Subtotal', 18) || TO_CHAR(v_subtotal, '9999'));
  END IF;

  -- Total geral
  DBMS_OUTPUT.PUT_LINE(RPAD(' ', 25) || RPAD('TOTAL GERAL', 18) || TO_CHAR(v_total_geral, '9999'));

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erro inesperado em prc_resumo_motos: ' || SQLERRM);
END prc_resumo_motos;
/

SET SERVEROUTPUT ON;
BEGIN
  prc_exibir_motos_json;          -- JSON de todas as motos
  DBMS_OUTPUT.PUT_LINE(CHR(10));
  prc_resumo_motos;               -- grade Filial x Status com subtotais e total
  DBMS_OUTPUT.PUT_LINE(CHR(10));
END;
/

