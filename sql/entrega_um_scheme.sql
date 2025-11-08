CREATE DATABASE IF NOT EXISTS entrega_nomeEquipe;
USE entrega_nomeEquipe;

CREATE TABLE professores(
    id_professor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(256),
    titulacao VARCHAR(128),
    email VARCHAR(256)
);

CREATE TABLE cursos(
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(128),
    coordenador VARCHAR(256),
    carga_horaria_total INT
);

CREATE TABLE alunos(
    id_aluno INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(256),
    cpf VARCHAR(11) UNIQUE NOT NULL,
    email VARCHAR(256),
    data_nascimento DATE,
    fk_id_curso INT,
     CONSTRAINT fk_id_curso_alunos FOREIGN KEY (fk_id_curso) REFERENCES cursos(id_curso)
);

CREATE TABLE curriculos(
    id_curriculo INT AUTO_INCREMENT PRIMARY KEY,
    fk_id_curso INT,
    ano_inicio INT,
    versao INT,
    CONSTRAINT fk_id_cursos_curriculos FOREIGN KEY (fk_id_curso) REFERENCES cursos(id_curso)
);

CREATE TABLE disciplinas(
    id_disciplina INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(128),
    carga_horaria INT
);

CREATE TABLE disciplinas_curriculos(
    fk_id_curriculo INT NOT NULL,
    fk_id_disciplina INT NOT NULL,
    PRIMARY KEY (fk_id_curriculo, fk_id_disciplina),
    periodo_ideal INT,
    CONSTRAINT fk_id_curriculo_DspCrc FOREIGN KEY (fk_id_curriculo) REFERENCES curriculos(id_curriculo),
    CONSTRAINT fk_id_disciplina_DspCrc FOREIGN KEY (fk_id_disciplina) REFERENCES disciplinas(id_disciplina)
);

CREATE TABLE pre_requisitos(
    id_disciplina_principal INT,
    id_disciplina_prerequisito INT,
    PRIMARY KEY (id_disciplina_principal, id_disciplina_prerequisito),
    CONSTRAINT fk_disciplina_principal FOREIGN KEY (id_disciplina_principal) REFERENCES disciplinas(id_disciplina),
    CONSTRAINT fk_disciplina_prerequisito FOREIGN KEY (id_disciplina_prerequisito) REFERENCES disciplinas(id_disciplina)
);

CREATE TABLE semestres(
    id_semestre INT PRIMARY KEY,
    codigo INT,
    aberto_p_matricula BOOLEAN
);

CREATE TABLE turmas(
    id_turma INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_disciplina INT NOT NULL,
    fk_id_professor INT NOT NULL,
    fk_id_semestre INT NOT NULL,
    maximo_vagas INT,
    vagas_ocupadas INT DEFAULT 0, 
    CONSTRAINT fk_id_disciplina_turmas FOREIGN KEY (fk_id_disciplina) REFERENCES disciplinas(id_disciplina),
    CONSTRAINT fk_id_professor_turmas FOREIGN KEY (fk_id_professor) REFERENCES professores(id_professor),
    CONSTRAINT fk_id_semestre_turmas FOREIGN KEY (fk_id_semestre) REFERENCES semestres(id_semestre)
);

CREATE TABLE matriculas(
    id_matricula INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_aluno INT NOT NULL,
    fk_id_turma INT NOT NULL,
    status VARCHAR(20),
    nota_final DECIMAL(4,2),
    CONSTRAINT fk_id_aluno_matriculas FOREIGN KEY (fk_id_aluno) REFERENCES alunos(id_aluno),
    CONSTRAINT fk_id_turma_matricula FOREIGN KEY (fk_id_turma) REFERENCES turmas(id_turma),
    CONSTRAINT chk_status_matricula CHECK (status IN ('Cursando', 'Aprovado', 'Reprovado', 'Trancado'))
);

CREATE TABLE historico(
    id_historico INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_aluno INT NOT NULL,
    fk_id_disciplina INT NOT NULL,
    nota_final DECIMAL(4,2),
    status VARCHAR(20),
    data_Conclusão DATE,
    CONSTRAINT fk_id_aluno_historico FOREIGN KEY (fk_id_aluno) REFERENCES alunos(id_aluno),
    CONSTRAINT fk_id_disciplina_historico FOREIGN KEY (fk_id_disciplina) REFERENCES disciplinas(id_disciplina)
);

CREATE TABLE usuarios(
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(256) NOT NULL,
    email VARCHAR(256) NOT NULL,
    tipo_usuario VARCHAR(20),
    senha_hash VARCHAR(28) NOT NULL
);

CREATE TABLE log_sistema(
    id_log INT PRIMARY KEY AUTO_INCREMENT,
    fk_usuario INT NOT NULL,
    acao VARCHAR (100),
    tabela_afetada VARCHAR(100),
    data_hora DATETIME,
    descricao TEXT,
    CONSTRAINT fk_usuario_log_sistema FOREIGN KEY (fk_usuario) REFERENCES usuarios(id_usuario)
);

-- Views -- 

CREATE VIEW vw_BoletimAluno AS
SELECT
    a.id_aluno,
    a.nome AS Aluno,
    s.codigo AS Semestre,
    d.nome AS Disciplina,
    p.nome AS Professor,
    m.nota_final AS NotaFinal,
    m.status AS Status
FROM 
    matriculas m
JOIN 
    alunos a ON m.fk_id_aluno = a.id_aluno
JOIN 
    turmas t ON m.fk_id_turma = t.id_turma
JOIN 
    disciplinas d ON t.fk_id_disciplina = d.id_disciplina
JOIN 
    professores p ON t.fk_id_professor = p.id_professor
JOIN 
    semestres s ON t.fk_id_semestre = s.id_semestre;

SELECT * FROM vw_BoletimAluno WHERE id_aluno = 1;

CREATE VIEW vw_TurmasDisponiveis AS
SELECT 
    t.id_turma,
    d.nome AS Disciplina,
    p.nome AS Professor,
    s.codigo AS Semestre,
    (t.maximo_vagas - t.vagas_ocupadas) AS VagasRestantes
FROM 
    turmas t
JOIN 
    disciplinas d ON t.fk_id_disciplina = d.id_disciplina
JOIN 
    professores p ON t.fk_id_professor = p.id_professor
JOIN 
    semestres s ON t.fk_id_semestre = s.id_semestre
WHERE 
    s.aberto_p_matricula = TRUE
    AND t.vagas_ocupadas < t.maximo_vagas;



CREATE VIEW vw_DesempenhoTurma AS
SELECT 
    d.nome AS Disciplina,
    p.nome AS Professor,
    s.codigo AS Semestre,
    t.id_turma,
    AVG(m.nota_final) AS MediaNotas,
    SUM(CASE WHEN m.status = 'Aprovado' THEN 1 ELSE 0 END) AS TotalAprovados,
    SUM(CASE WHEN m.status = 'Reprovado' THEN 1 ELSE 0 END) AS TotalReprovados
FROM 
    matriculas m
JOIN 
    turmas t ON m.fk_id_turma = t.id_turma
JOIN 
    disciplinas d ON t.fk_id_disciplina = d.id_disciplina
JOIN 
    professores p ON t.fk_id_professor = p.id_professor
JOIN 
    semestres s ON t.fk_id_semestre = s.id_semestre
WHERE
    m.status IN ('Aprovado', 'Reprovado') -- Só calcula média de quem já concluiu
GROUP BY 
    t.id_turma, d.nome, p.nome, s.codigo;



CREATE VIEW vw_LogAuditoria AS
SELECT 
    id_log,
    fk_usuario,
    acao,
    tabela_afetada,
    data_hora,
    descricao
FROM 
    log_sistema
ORDER BY 
    data_hora DESC
LIMIT 20;


-- Stored Procedures --

DELIMITER $$

CREATE PROCEDURE sp_RegistrarMatricula(
    IN p_id_aluno INT,
    IN p_id_turma INT
)
BEGIN
    DECLARE v_id_disciplina INT;
    DECLARE v_id_semestre INT;
    DECLARE v_vagas_ocupadas INT;
    DECLARE v_maximo_vagas INT;
    DECLARE v_semestre_aberto BOOLEAN;
    DECLARE v_disciplinas_cursando INT DEFAULT 0;
    DECLARE v_prerequisitos_nao_cumpridos INT DEFAULT 0;
    DECLARE v_disciplina_ja_matriculada INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
    SELECT 
        t.fk_id_disciplina,
        t.fk_id_semestre,
        t.vagas_ocupadas,
        t.maximo_vagas,
        s.aberto_p_matricula
    INTO 
        v_id_disciplina,
        v_id_semestre,
        v_vagas_ocupadas,
        v_maximo_vagas,
        v_semestre_aberto
    FROM 
        turmas t
    JOIN 
        semestres s ON t.fk_id_semestre = s.id_semestre
    WHERE 
        t.id_turma = p_id_turma
    FOR UPDATE;

    IF v_semestre_aberto = FALSE THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: O período de matrícula para este semestre está fechado.';
    END IF;

    IF v_vagas_ocupadas >= v_maximo_vagas THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Não há vagas disponíveis para esta turma.';
    END IF;

    SELECT COUNT(*)
    INTO v_disciplinas_cursando
    FROM matriculas m
    JOIN turmas t ON m.fk_id_turma = t.id_turma
    WHERE 
        m.fk_id_aluno = p_id_aluno
        AND t.fk_id_semestre = v_id_semestre
        AND m.status = 'Cursando';

    IF v_disciplinas_cursando >= 6 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Limite de 6 disciplinas em "Cursando" por semestre atingido.';
    END IF;

    SELECT COUNT(*)
    INTO v_disciplina_ja_matriculada
    FROM matriculas m
    JOIN turmas t ON m.fk_id_turma = t.id_turma
    WHERE 
        m.fk_id_aluno = p_id_aluno
        AND t.fk_id_disciplina = v_id_disciplina
        AND t.fk_id_semestre = v_id_semestre;

    IF v_disciplina_ja_matriculada > 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Aluno já matriculado nesta disciplina no semestre atual.';
    END IF;

    SELECT COUNT(pr.id_disciplina_prerequisito)
    INTO v_prerequisitos_nao_cumpridos
    FROM pre_requisitos pr
    LEFT JOIN historico h ON h.fk_id_aluno = p_id_aluno 
                         AND h.fk_id_disciplina = pr.id_disciplina_prerequisito
                         AND h.status = 'Aprovado'
    WHERE 
        pr.id_disciplina_principal = v_id_disciplina
        AND h.id_historico IS NULL;
    IF v_prerequisitos_nao_cumpridos > 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: O aluno não cumpre os pré-requisitos para esta disciplina.';
    END IF;

    INSERT INTO matriculas (fk_id_aluno, fk_id_turma, status, nota_final)
    VALUES (p_id_aluno, p_id_turma, 'Cursando', NULL);

    COMMIT;
    
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_LancarNotas(
    IN p_id_matricula INT,
    IN p_nota_final DECIMAL(4,2)
)
BEGIN
    DECLARE v_status VARCHAR(20);

    IF p_nota_final >= 7.0 THEN
        SET v_status = 'Aprovado';
    ELSE
        SET v_status = 'Reprovado';
    END IF;

    UPDATE matriculas
    SET 
        nota_final = p_nota_final,
        status = v_status
    WHERE 
        id_matricula = p_id_matricula;

END$$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE sp_TrancarMatricula(
    IN p_id_matricula INT,
    IN p_id_usuario INT
)
BEGIN
    DECLARE v_id_turma INT;
    DECLARE v_id_aluno INT;
    DECLARE v_status_atual VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT fk_id_turma, fk_id_aluno, status
    INTO v_id_turma, v_id_aluno, v_status_atual
    FROM matriculas
    WHERE id_matricula = p_id_matricula
    FOR UPDATE;

    IF v_status_atual = 'Cursando' THEN
    
        UPDATE matriculas
        SET status = 'Trancado'
        WHERE id_matricula = p_id_matricula;

        UPDATE turmas
        SET vagas_ocupadas = vagas_ocupadas - 1
        WHERE id_turma = v_id_turma;

        INSERT INTO log_sistema (fk_usuario, acao, tabela_afetada, data_hora, descricao)
        VALUES (
            p_id_usuario, 
            'Trancamento', 
            'matriculas', 
            NOW(), 
            CONCAT('Matrícula ID ', p_id_matricula, ' (Aluno ID ', v_id_aluno, ') trancada.')
        );

        COMMIT;
        
    ELSE
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: A matrícula não está com status "Cursando" e não pode ser trancada.';
    END IF;

END$$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE sp_GerarHistoricoAluno(
    IN p_id_aluno INT
)
BEGIN
    DELETE FROM historico WHERE fk_id_aluno = p_id_aluno;

    INSERT INTO historico (
        fk_id_aluno, 
        fk_id_disciplina, 
        nota_final, 
        status, 
        data_Conclusao
    )
    SELECT 
        m.fk_id_aluno,
        t.fk_id_disciplina,
        m.nota_final,
        m.status,
        CURDATE() 
    FROM 
        matriculas m
    JOIN 
        turmas t ON m.fk_id_turma = t.id_turma
    WHERE 
        m.fk_id_aluno = p_id_aluno
        AND m.status = 'Aprovado';

END$$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE sp_ReabrirPeriodoMatricula(
    IN p_id_semestre INT
)
BEGIN
    UPDATE semestres
    SET aberto_p_matricula = TRUE
    WHERE id_semestre = p_id_semestre;
END$$

DELIMITER ;


-- Functions --

DELIMITER $$

CREATE FUNCTION fn_CalcularCoeficienteRendimento(
    p_id_aluno INT
)
RETURNS DECIMAL(4,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_coeficiente DECIMAL(4,2);

    SELECT AVG(m.nota_final)
    INTO v_coeficiente
    FROM matriculas m
    WHERE 
        m.fk_id_aluno = p_id_aluno
        AND m.status IN ('Aprovado', 'Reprovado');

    RETURN IFNULL(v_coeficiente, 0.0);

END$$

DELIMITER ;


DELIMITER $$

CREATE FUNCTION fn_ContarDisciplinasPendentes(
    p_id_aluno INT,
    p_id_curso INT 
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total_disciplinas_curriculo INT;
    DECLARE v_total_aprovadas INT;
    DECLARE v_id_curriculo INT;

    SELECT id_curriculo 
    INTO v_id_curriculo
    FROM curriculos
    WHERE fk_id_curso = p_id_curso
    ORDER BY AnoInicio DESC, Versao DESC
    LIMIT 1;

    SELECT COUNT(*)
    INTO v_total_disciplinas_curriculo
    FROM disciplinas_curriculos
    WHERE fk_id_curriculo = v_id_curriculo;

    SELECT COUNT(*)
    INTO v_total_aprovadas
    FROM historico
    WHERE 
        fk_id_aluno = p_id_aluno
        AND status = 'Aprovado';

    RETURN (v_total_disciplinas_curriculo - v_total_aprovadas);

END$$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION fn_ListarDisciplinasAprovadas(
    p_id_aluno INT
)
RETURNS TEXT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_lista_disciplinas TEXT;

    SELECT GROUP_CONCAT(d.nome SEPARATOR ', ')
    INTO v_lista_disciplinas
    FROM historico h
    JOIN disciplinas d ON h.fk_id_disciplina = d.id_disciplina
    WHERE 
        h.fk_id_aluno = p_id_aluno
        AND h.status = 'Aprovado';

    RETURN IFNULL(v_lista_disciplinas, '');

END$$

DELIMITER ;


DELIMITER $$

CREATE FUNCTION fn_TotalHorasConcluidas(
    p_id_aluno INT
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total_horas INT;

    SELECT SUM(d.carga_horaria)
    INTO v_total_horas
    FROM historico h
    JOIN disciplinas d ON h.fk_id_disciplina = d.id_disciplina
    WHERE 
        h.fk_id_aluno = p_id_aluno
        AND h.status = 'Aprovado';

    RETURN IFNULL(v_total_horas, 0);

END$$

DELIMITER ;


-- Triggers -- 


DELIMITER $$

CREATE TRIGGER trg_AtualizarContagemVagas
AFTER INSERT ON matriculas -- 
FOR EACH ROW
BEGIN
    UPDATE turmas
    SET vagas_ocupadas = vagas_ocupadas + 1
    WHERE id_turma = NEW.fk_id_turma;
END$$

DELIMITER ;



DELIMITER $$

DROP TRIGGER IF EXISTS trg_AuditoriaAluno;

CREATE TRIGGER trg_AuditoriaAluno_Completo
AFTER UPDATE ON Alunos
FOR EACH ROW
BEGIN
    DECLARE v_descricao TEXT;
    SET v_descricao = CONCAT('Aluno ID ', OLD.id_aluno, ' atualizado. ');

    IF OLD.nome <> NEW.nome THEN
        SET v_descricao = CONCAT(v_descricao, 'Nome: "', OLD.nome, '"->"', NEW.nome, '". ');
    END IF;
    
    IF OLD.cpf <> NEW.cpf THEN
        SET v_descricao = CONCAT(v_descricao, 'CPF: "', OLD.cpf, '"->"', NEW.cpf, '". ');
    END IF;

    IF OLD.email <> NEW.email THEN
        SET v_descricao = CONCAT(v_descricao, 'Email: "', OLD.email, '"->"', NEW.email, '". ');
    END IF;
    
    IF OLD.data_nascimento <> NEW.data_nascimento THEN
        SET v_descricao = CONCAT(v_descricao, 'DataNascimento: "', OLD.data_nascimento, '"->"', NEW.data_nascimento, '". ');
    END IF;
    
    IF OLD.fk_id_curso <> NEW.fk_id_curso THEN
        SET v_descricao = CONCAT(v_descricao, 'Curso: "', OLD.fk_id_curso, '"->"', NEW.fk_id_curso, '". ');
    END IF;

    IF OLD.nome <> NEW.nome OR OLD.cpf <> NEW.cpf OR OLD.email <> NEW.email OR OLD.data_nascimento <> NEW.data_nascimento OR OLD.fk_id_curso <> NEW.fk_id_curso THEN
        INSERT INTO log_sistema (
            fk_usuario, 
            acao, 
            tabela_afetada, 
            data_hora, 
            descricao
        )
        VALUES (
            NULL, 
            'UPDATE - Auditoria', 
            'Alunos', 
            NOW(), 
            v_descricao
        );
    END IF;
END$$

DELIMITER ;

-- INSERTS, UPDATES E DELETES --

DELIMITER $$
CREATE TRIGGER trg_Log_Alunos_INSERT
AFTER INSERT ON alunos
FOR EACH ROW
BEGIN
    INSERT INTO log_sistema (fk_usuario, acao, tabela_afetada, data_hora, descricao)
    VALUES (NULL, 'INSERT', 'alunos', NOW(), 
            CONCAT('Novo aluno inserido. ID: ', NEW.id_aluno, ', Nome: ', NEW.nome));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_Log_Alunos_DELETE
AFTER DELETE ON alunos
FOR EACH ROW
BEGIN
    INSERT INTO log_sistema (fk_usuario, acao, tabela_afetada, data_hora, descricao)
    VALUES (NULL, 'DELETE', 'alunos', NOW(), 
            CONCAT('Aluno ID ', OLD.id_aluno, ' (Nome: ', OLD.nome, ') deletado.'));
END$$
DELIMITER ;


-- professor --

DELIMITER $$
CREATE TRIGGER trg_Log_Professores_INSERT
AFTER INSERT ON professores
FOR EACH ROW
BEGIN
    INSERT INTO log_sistema (fk_usuario, acao, tabela_afetada, data_hora, descricao)
    VALUES (NULL, 'INSERT', 'professores', NOW(), 
            CONCAT('Novo professor inserido. ID: ', NEW.id_professor, ', Nome: ', NEW.nome));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_Log_Professores_UPDATE
AFTER UPDATE ON professores
FOR EACH ROW
BEGIN
    INSERT INTO log_sistema (fk_usuario, acao, tabela_afetada, data_hora, descricao)
    VALUES (NULL, 'UPDATE', 'professores', NOW(), 
            CONCAT('Professor ID ', OLD.id_professor, ' atualizado. Detalhes: ', 
                   'Nome: ', OLD.nome, '->', NEW.nome, ', ',
                   'Titulacao: ', OLD.titulacao, '->', NEW.titulacao));
END$$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER trg_Log_Professores_DELETE
AFTER DELETE ON professores
FOR EACH ROW
BEGIN
    INSERT INTO log_sistema (fk_usuario, acao, tabela_afetada, data_hora, descricao)
    VALUES (NULL, 'DELETE', 'professores', NOW(), 
            CONCAT('Professor ID ', OLD.id_professor, ' (Nome: ', OLD.nome, ') deletado.'));
END$$
DELIMITER ;

-- cursos -- 

DELIMITER $$
CREATE TRIGGER trg_Log_Cursos_INSERT
AFTER INSERT ON cursos
FOR EACH ROW
BEGIN
    INSERT INTO log_sistema (fk_usuario, acao, tabela_afetada, data_hora, descricao)
    VALUES (NULL, 'INSERT', 'cursos', NOW(), 
            CONCAT('Novo curso inserido. ID: ', NEW.id_curso, ', Nome: ', NEW.nome));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_Log_Cursos_UPDATE
AFTER UPDATE ON cursos
FOR EACH ROW
BEGIN
    INSERT INTO log_sistema (fk_usuario, acao, tabela_afetada, data_hora, descricao)
    VALUES (NULL, 'UPDATE', 'cursos', NOW(), 
            CONCAT('Curso ID ', OLD.id_curso, ' atualizado. Nome: ', OLD.nome, '->', NEW.nome));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_Log_Cursos_DELETE
AFTER DELETE ON cursos
FOR EACH ROW
BEGIN
    INSERT INTO log_sistema (fk_usuario, acao, tabela_afetada, data_hora, descricao)
    VALUES (NULL, 'DELETE', 'cursos', NOW(), 
            CONCAT('Curso ID ', OLD.id_curso, ' (Nome: ', OLD.nome, ') deletado.'));
END$$
DELIMITER ;

-- Disciplina --

DELIMITER $$
CREATE TRIGGER trg_Log_Disciplinas_INSERT
AFTER INSERT ON disciplinas
FOR EACH ROW
BEGIN
    INSERT INTO log_sistema (fk_usuario, acao, tabela_afetada, data_hora, descricao)
    VALUES (NULL, 'INSERT', 'disciplinas', NOW(), 
            CONCAT('Nova disciplina inserida. ID: ', NEW.id_disciplina, ', Nome: ', NEW.nome));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_Log_Disciplinas_UPDATE
AFTER UPDATE ON disciplinas
FOR EACH ROW
BEGIN
    INSERT INTO log_sistema (fk_usuario, acao, tabela_afetada, data_hora, descricao)
    VALUES (NULL, 'UPDATE', 'disciplinas', NOW(), 
            CONCAT('Disciplina ID ', OLD.id_disciplina, ' atualizada. Nome: ', OLD.nome, '->', NEW.nome));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_Log_Disciplinas_DELETE
AFTER DELETE ON disciplinas
FOR EACH ROW
BEGIN
    INSERT INTO log_sistema (fk_usuario, acao, tabela_afetada, data_hora, descricao)
    VALUES (NULL, 'DELETE', 'disciplinas', NOW(), 
            CONCAT('Disciplina ID ', OLD.id_disciplina, ' (Nome: ', OLD.nome, ') deletada.'));
END$$
DELIMITER ;

-- curriculo --

DELIMITER $$
CREATE TRIGGER trg_Log_Curriculos_INSERT
AFTER INSERT ON curriculos
FOR EACH ROW
BEGIN
    INSERT INTO log_sistema (fk_usuario, acao, tabela_afetada, data_hora, descricao)
    VALUES (NULL, 'INSERT', 'curriculos', NOW(), 
            CONCAT('Novo currículo inserido. ID: ', NEW.id_curriculo, ', Curso ID: ', NEW.fk_id_curso, ', Ano: ', NEW.ano_inicio));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_Log_Curriculos_UPDATE
AFTER UPDATE ON curriculos
FOR EACH ROW
BEGIN
    INSERT INTO log_sistema (fk_usuario, acao, tabela_afetada, data_hora, descricao)
    VALUES (NULL, 'UPDATE', 'curriculos', NOW(), 
            CONCAT('Currículo ID ', OLD.id_curriculo, ' atualizado. Ano: ', OLD.ano_inicio, '->', NEW.ano_inicio));
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_Log_Curriculos_DELETE
AFTER DELETE ON curriculos
FOR EACH ROW
BEGIN
    INSERT INTO log_sistema (fk_usuario, acao, tabela_afetada, data_hora, descricao)
    VALUES (NULL, 'DELETE', 'curriculos', NOW(), 
            CONCAT('Currículo ID ', OLD.id_curriculo, ' (Curso ID: ', OLD.fk_id_curso, ') deletado.'));
END$$
DELIMITER ;