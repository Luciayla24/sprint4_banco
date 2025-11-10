--------------------------------------------------------------------------------
-- 🔹 TRIGGER: TRG_AUDIT_ENDERECO
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_audit_endereco
AFTER INSERT OR UPDATE OR DELETE ON TB_MOTTU_ENDERECO
FOR EACH ROW
DECLARE
    v_user       VARCHAR2(50);
    v_operacao   VARCHAR2(10);
    v_old_values VARCHAR2(4000);
    v_new_values VARCHAR2(4000);
BEGIN
    -- Captura o nome do usuário que executou a operação
    SELECT USER INTO v_user FROM DUAL;

    -- Define o tipo de operação
    IF INSERTING THEN
        v_operacao := 'INSERT';
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
    ELSIF DELETING THEN
        v_operacao := 'DELETE';
    END IF;

    -- Monta os valores antigos, se houver
    IF DELETING OR UPDATING THEN
        v_old_values :=
            'ID:' || :OLD.id_endereco ||
            ', LOGRADOURO:' || :OLD.logradouro ||
            ', CEP:' || :OLD.nr_cep ||
            ', COMPLEMENTO:' || NVL(:OLD.complemento, '-');
    END IF;

    -- Monta os valores novos, se houver
    IF INSERTING OR UPDATING THEN
        v_new_values :=
            'ID:' || :NEW.id_endereco ||
            ', LOGRADOURO:' || :NEW.logradouro ||
            ', CEP:' || :NEW.nr_cep ||
            ', COMPLEMENTO:' || NVL(:NEW.complemento, '-');
    END IF;

    -- Insere o registro de auditoria
    INSERT INTO TB_MOTTU_AUDIT (
        username,
        operation_type,
        operation_date,
        old_values,
        new_values
    ) VALUES (
        v_user,
        v_operacao,
        SYSDATE,
        v_old_values,
        v_new_values
    );

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro na trigger TRG_AUDIT_ENDERECO: ' || SQLERRM);
END;
/

-- Limpar registros anteriores de auditoria
DELETE FROM TB_MOTTU_AUDIT;
COMMIT;

-- 1️⃣ Teste de INSERT
INSERT INTO TB_MOTTU_ENDERECO (id_endereco, id_bairro, logradouro, nr_endereco, nr_cep, complemento)
VALUES (10, 1, 'Rua das Flores', 120, '11111111', 'Casa A');

-- 2️⃣ Teste de UPDATE
UPDATE TB_MOTTU_ENDERECO
SET logradouro = 'Avenida Central', complemento = 'Bloco B'
WHERE id_endereco = 10;

-- 3️⃣ Teste de DELETE
DELETE FROM TB_MOTTU_ENDERECO
WHERE id_endereco = 10;

COMMIT;

SELECT * FROM TB_MOTTU_AUDIT ORDER BY audit_id;

SET SERVEROUTPUT ON;

BEGIN
  prc_listar_auditoria_endereco;
END;
/
