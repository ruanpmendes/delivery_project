-- TRIGGER preco
CREATE OR REPLACE FUNCTION
registra_alteracao_preco()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.preco <> OLD.preco THEN
    INSERT INTO log_preco_produto(id_produto, preco_antigo, preco_novo)
    VALUES(OLD.id_produto, OLD.preco, NEW.preco);
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_alteracao_preco
AFTER UPDATE OF preco ON produto
FOR eACH ROW
EXECUTE FUNCTION registra_alteracao_preco()


-- TRIGGER custo
CREATE OR REPLACE FUNCTION
registra_alteracao_custo()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.custo <> OLD.custo THEN
    INSERT INTO log_custo_produto(id_produto, custo_antigo, custo_novo)
    VALUES(OLD.id_produto, OLD.custo, NEW.custo);
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_alteracao_custo
AFTER UPDATE OF custo ON produto
FOR EACH ROW
EXECUTE FUNCTION registra_alteracao_custo()


-- TRIGGER registra status
CREATE OR REPLACE FUNCTION
registra_alteracao_status()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.id_status <> old.status then
	INSERT INTO historico_status_pedido(id_pedido, id_status, data_status)
	VALUES(new.id_pedido, new.id_status, CURRENT_TIMESTAMP);
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tgr_historico_status
AFTER UPDATE OF id_status on historico_status_pedido
FOR EACH ROW
EXECUTE FUNCTION registra_alteracao_status()