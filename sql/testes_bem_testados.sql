USE entrega_final_grupo05;
-- TESTE 1: REGISTRO DE MATRÍCULAS VÁLIDAS
-- Testa o cenário básico de sucesso da procedure sp_RegistrarMatricula.

-- Teste 1.1: Matricular Aluno 6 na Turma 7
CALL sp_RegistrarMatricula(6, 7);

-- Teste 1.2: Matricular Aluno 1 na Turma 7
CALL sp_RegistrarMatricula(1, 7);


-- TESTE 2: MATRÍCULA EM TURMA CHEIA (TESTE DE ROLLBACK)
-- Verifica se o sistema impede a matrícula quando as vagas estão esgotadas.

-- 1. Força a turma 12 a ficar cheia
UPDATE turmas SET vagas_ocupadas = 25 WHERE id_turma = 12;

-- 2. Tenta matricular um aluno (deve falhar e retornar mensagem de erro)
CALL sp_RegistrarMatricula(5, 12);


-- TESTE 3: TRANCAMENTO DE MATRÍCULA
-- 1. Registra a matrícula para o teste
CALL sp_RegistrarMatricula(3, 8);
SELECT vagas_ocupadas FROM turmas WHERE id_turma = 8; -- Esperado: 2

-- 2. Captura o ID da matrícula recém-criada
SELECT MAX(id_matricula) INTO @id_matricula_teste FROM matriculas WHERE fk_id_aluno = 3 AND fk_id_turma = 8;

-- 3. Executa o trancamento
CALL sp_TrancarMatricula(@id_matricula_teste, 3);


-- 4. Verifica se a vaga foi liberada
SELECT vagas_ocupadas FROM turmas WHERE id_turma = 8; -- Esperado: 1

-- 5. Verifica o status da matrícula
SELECT status FROM matriculas WHERE id_matricula = @id_matricula_teste; -- Esperado: 'Trancado'


-- TESTE 4: LANÇAMENTO DE NOTAS (APROVAÇÃO/REPROVAÇÃO)
-- Verifica a sp_LancarNotas e a atualização de status.

-- 1. Matricula Aluno 4 (Daniel) na Turma 11 (Marketing)
CALL sp_RegistrarMatricula(5, 11);
SELECT MAX(id_matricula) INTO @id_mat_daniel FROM matriculas;

-- 4. Lança nota 4.0 para Daniel (Deve REPROVAR)
CALL sp_LancarNotas(@id_mat_daniel, 4.0);
SELECT status FROM matriculas WHERE id_matricula = @id_mat_daniel; -- Esperado: 'Reprovado'

-- TESTE 5 E 11: GERAÇÃO DE HISTÓRICO (TRIGGER E PROCEDURE)

-- 1. Teste do Trigger (trg_AtualizarHistoricoAutomaticamente)
-- (Verifica se a nota da Carla (do Teste 4) foi para o histórico)
SELECT * FROM historico WHERE fk_id_aluno = 3 AND fk_id_disciplina = 3; -- ID 3 = Cálculo (Esperado: 1 linha)

-- 2. Teste da Procedure (sp_GerarHistoricoAluno)
-- (Consolida o histórico da Ana)
CALL sp_GerarHistoricoAluno(1);
SELECT * FROM historico WHERE fk_id_aluno = 1; -- Esperado: 5 linhas (exemplo)


-- TESTE 7: FUNÇÕES DE CÁLCULO ACADÊMICO
-- Testa as funções (fn_) que calculam métricas do aluno.
-- ------------------------------------------------------------------
-- 1. Coeficiente de Rendimento (Média das notas de Ana)
SELECT fn_CalcularCoeficienteRendimento(1) AS Coeficiente;

-- 2. Disciplinas Pendentes (Total do Curso 1 - Aprovadas de Ana)
SELECT fn_ContarDisciplinasPendentes(1, 1) AS Pendentes;

-- 3. Lista de Aprovadas (Nomes das 5 disciplinas)
SELECT fn_ListarDisciplinasAprovadas(1) AS Aprovadas;

-- 4. Total de Horas Concluídas (Soma da carga horária das 5 disciplinas)
SELECT fn_TotalHorasConcluidas(1) AS HorasConcluidas;


-- TESTE 8: VIEW DE AUDITORIA (LOGS)
-- Verifica se a vw_LogAuditoria está capturando as ações.
-- ------------------------------------------------------------------
-- 1. Verifica log de trancamento (gerado no Teste 3)
SELECT * FROM vw_LogAuditoria WHERE acao = 'Trancamento';

-- 2. Executa um UPDATE para gerar um novo log
UPDATE alunos SET email = 'bruno.novo@aluno.com' WHERE id_aluno = 2;

-- 3. Verifica o log do UPDATE
SELECT * FROM vw_LogAuditoria WHERE tabela_afetada = 'Alunos' AND acao LIKE 'UPDATE%';

-- TESTE 9 (
-- 1. PREPARAÇÃO: Limpa TODAS as matrículas da Ana em 20251
DELETE m FROM matriculas m
JOIN turmas t ON m.fk_id_turma = t.id_turma
WHERE m.fk_id_aluno = 1
  AND t.fk_id_semestre = 20251;

-- Atualiza a contagem de vagas (importante)
UPDATE turmas SET vagas_ocupadas = 0
WHERE id_turma IN (7, 9, 10)
  AND vagas_ocupadas > 0;

-- 2. EXECUÇÃO: Tenta matricular Ana 7 vezes

-- Matrícula 1: Banco de Dados (Turma 7)
CALL sp_RegistrarMatricula(1, 7);

-- Matrícula 2: Inteligência Artificial (Turma 9)
CALL sp_RegistrarMatricula(1, 9);

-- Matrícula 3: Engenharia de Software (Turma 10)
CALL sp_RegistrarMatricula(1, 10);

-- Matrícula 4: Python (Turma 8)
CALL sp_RegistrarMatricula(1, 8);

-- Matrícula 5: Marketing (Turma 11)
CALL sp_RegistrarMatricula(1, 11);

-- Matrícula 6: Cálculo I (Turma 14)
CALL sp_RegistrarMatricula(1, 14);


-- 3. VERIFICAÇÃO (PARCIAL)
SELECT
    COUNT(*) AS total_matriculas_cursando_ana
FROM matriculas m
JOIN turmas t ON m.fk_id_turma = t.id_turma
WHERE m.fk_id_aluno = 1
  AND t.fk_id_semestre = 20251
  AND m.status = 'Cursando';
-- O RESULTADO AQUI DEVE SER 6

-- 4. O TESTE FINAL: A 7ª MATRÍCULA
CALL sp_RegistrarMatricula(1, 13); -- Turma 13 (Contabilidade)

-- TESTE 10: VIEW DE TURMAS E REABERTURA DE SEMESTRE
-- ------------------------------------------------------------------
-- 1. Fecha o semestre para matrículas (ID 20251)
UPDATE semestres SET aberto_p_matricula = FALSE WHERE id_semestre = 20251;

-- 2. Verifica a View (não deve retornar nada)
SELECT * FROM vw_TurmasDisponiveis; -- Esperado: 0 linhas

-- 3. Reabre o semestre
CALL sp_ReabrirPeriodoMatricula(20251);

-- 4. Verifica a View novamente (deve mostrar as turmas disponíveis)
SELECT * FROM vw_TurmasDisponiveis; -- Esperado: Várias linhas


-- TESTE 13: SIMULAÇÃO DE ERRO (ROLLBACK E FK)
-- 1. Tenta matricular em uma turma inexistente (deve falhar)
CALL sp_RegistrarMatricula(1, 9999);

-- 2. Tenta deletar um curso com dependências (deve falhar - FK)
-- (Aluno 1 está no Curso 1)
DELETE FROM cursos WHERE id_curso = 1;
SELECT * FROM vw_DesempenhoTurma;