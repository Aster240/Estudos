USE entrega_final_grupo05;

INSERT INTO cursos (id_curso, nome, coordenador, carga_horaria_total) VALUES
(1, 'Ciência da Computação', 'Dr. Alan Turing', 3200),
(2, 'Engenharia Elétrica', 'Dr. Nikola Tesla', 4000),
(3, 'Administração', 'Msc. Peter Drucker', 3000),
(4, 'Design Digital', 'Dr. Ada Lovelace', 2800);

INSERT INTO professores (id_professor, nome, titulacao, email) VALUES
(1, 'Dr. Ricardo G.', 'Doutor', 'ricardo.g@uni.com'),
(2, 'Msc. Marcia L.', 'Mestre', 'marcia.l@uni.com'),
(3, 'Dr. Tiago B.', 'Doutor', 'tiago.b@uni.com'),
(4, 'Msc. Sandra F.', 'Mestre', 'sandra.f@uni.com'),
(5, 'Dr. Evandro S.', 'Doutor', 'evandro.s@uni.com'),
(6, 'Dr. Beatriz M.', 'Doutor', 'beatriz.m@uni.com');

INSERT INTO disciplinas (id_disciplina, nome, carga_horaria) VALUES
(1, 'Banco de Dados', 60),
(2, 'Programação Python', 60),
(3, 'Cálculo I', 80),
(4, 'Inteligência Artificial', 60),
(5, 'Estrutura de Dados', 80),
(6, 'Engenharia de Software', 60),
(7, 'Circuitos Elétricos I', 80),
(8, 'Marketing Digital', 40),
(9, 'Teoria dos Grafos', 60),
(10, 'Design de Interação', 60),
(11, 'Contabilidade Geral', 60),
(12, 'Física I', 80);

INSERT INTO semestres (id_semestre, codigo, aberto_p_matricula) VALUES
(20231, 2023.1, FALSE),
(20232, 2023.2, FALSE),
(20241, 2024.1, FALSE),
(20242, 2024.2, FALSE),
(20251, 2025.1, TRUE);

INSERT INTO usuarios (id_usuario, nome, email, tipo_usuario, senha_hash) VALUES
(1, 'Admin Root', 'admin@uni.com', 'Admin', 'hash_admin_root'),
(2, 'Secretaria Acadêmica', 'secretaria@uni.com', 'Admin', 'hash_sec_123'),
(3, 'Dr. Ricardo G.', 'ricardo.g@uni.com', 'Professor', 'hash_prof_1'),
(4, 'Msc. Marcia L.', 'marcia.l@uni.com', 'Professor', 'hash_prof_2'),
(5, 'Dr. Tiago B.', 'tiago.b@uni.com', 'Professor', 'hash_prof_3'),
(6, 'Msc. Sandra F.', 'sandra.f@uni.com', 'Professor', 'hash_prof_4'),
(7, 'Dr. Evandro S.', 'evandro.s@uni.com', 'Professor', 'hash_prof_5'),
(8, 'Dr. Beatriz M.', 'beatriz.m@uni.com', 'Professor', 'hash_prof_6');

INSERT INTO alunos (id_aluno, nome, cpf, email, data_nascimento, fk_id_curso) VALUES
(1, 'Ana Silva', '11122233344', 'ana.silva@aluno.com', '2000-01-15', 1),
(2, 'Bruno Costa', '22233344455', 'bruno.costa@aluno.com', '2001-02-20', 1),
(3, 'Carla Dias', '33344455566', 'carla.dias@aluno.com', '2002-03-10', 2),
(4, 'Daniel Moreira', '44455566677', 'daniel.moreira@aluno.com', '2000-04-05', 3),
(5, 'Elisa Fernandes', '55566677788', 'elisa.fernandes@aluno.com', '2001-05-12', 4),
(6, 'Felipe Guedes', '66677788899', 'felipe.guedes@aluno.com', '2002-06-30', 1),
(7, 'Gabriela Lima', '77788899900', 'gabriela.lima@aluno.com', '2000-07-25', 2);

INSERT INTO usuarios (nome, email, tipo_usuario, senha_hash) VALUES
('Ana Silva', 'ana.silva@aluno.com', 'Aluno', 'hash_aluno_1'),
('Bruno Costa', 'bruno.costa@aluno.com', 'Aluno', 'hash_aluno_2'),
('Carla Dias', 'carla.dias@aluno.com', 'Aluno', 'hash_aluno_3'),
('Daniel Moreira', 'daniel.moreira@aluno.com', 'Aluno', 'hash_aluno_4'),
('Elisa Fernandes', 'elisa.fernandes@aluno.com', 'Aluno', 'hash_aluno_5'),
('Felipe Guedes', 'felipe.guedes@aluno.com', 'Aluno', 'hash_aluno_6'),
('Gabriela Lima', 'gabriela.lima@aluno.com', 'Aluno', 'hash_aluno_7');

INSERT INTO curriculos (id_curriculo, fk_id_curso, ano_inicio, versao) VALUES
(1, 1, 2020, 1),
(2, 2, 2020, 1),
(3, 3, 2019, 2),
(4, 4, 2022, 1);

INSERT INTO disciplinas_curriculos (fk_id_curriculo, fk_id_disciplina, periodo_ideal) VALUES
(1, 1, 3), (1, 2, 1), (1, 5, 2), (1, 6, 4), (1, 4, 5), (1, 9, 3), (1, 3, 1),
(2, 3, 1), (2, 7, 2), (2, 12, 1),
(3, 8, 1), (3, 11, 1),
(4, 10, 1), (4, 2, 2);

INSERT INTO pre_requisitos (id_disciplina_principal, id_disciplina_prerequisito) VALUES
(1, 2), (1, 5),
(5, 2),
(4, 5), (4, 9),
(6, 5),
(9, 5),
(7, 3), (7, 12);

INSERT INTO turmas (id_turma, fk_id_disciplina, fk_id_professor, fk_id_semestre, maximo_vagas, vagas_ocupadas) VALUES
(1, 2, 2, 20241, 40, 2),
(2, 3, 6, 20241, 50, 2),
(3, 12, 6, 20241, 50, 2),
(4, 5, 5, 20242, 40, 3),
(5, 9, 3, 20242, 30, 1),
(6, 7, 6, 20242, 50, 2),
(7, 1, 1, 20251, 40, 0),
(8, 2, 2, 20251, 40, 0),
(9, 4, 5, 20251, 30, 0),
(10, 6, 3, 20251, 35, 0),
(11, 8, 4, 20251, 50, 0),
(12, 10, 4, 20251, 25, 0),
(13, 11, 4, 20251, 50, 0),
(14, 3, 6, 20251, 50, 0);

INSERT INTO historico (id_historico, fk_id_aluno, fk_id_disciplina, nota_final, status, data_Conclusao) VALUES
(1, 1, 2, 9.0, 'Aprovado', '2024-03-01'),
(2, 1, 3, 7.0, 'Aprovado', '2024-03-01'),
(3, 1, 5, 8.5, 'Aprovado', '2024-07-01'),
(4, 1, 9, 7.5, 'Aprovado', '2024-07-01'),
(5, 2, 2, 4.0, 'Reprovado', '2024-03-01'),
(6, 2, 3, 6.5, 'Reprovado', '2024-03-01'),
(7, 2, 5, 6.0, 'Reprovado', '2024-07-01'),
(8, 3, 3, 7.5, 'Aprovado', '2024-03-01'),
(9, 3, 12, 8.0, 'Aprovado', '2024-03-01'),
(10, 3, 7, 8.0, 'Aprovado', '2024-07-01'),
(11, 6, 2, 7.0, 'Aprovado', '2024-03-01'),
(12, 6, 3, 5.0, 'Reprovado', '2024-03-01'),
(13, 7, 3, 9.0, 'Aprovado', '2024-03-01'),
(14, 7, 12, 9.5, 'Aprovado', '2024-03-01'),
(15, 7, 7, 6.0, 'Reprovado', '2024-07-01');

INSERT INTO matriculas (id_matricula, fk_id_aluno, fk_id_turma, status, nota_final) VALUES
(1, 1, 1, 'Aprovado', 9.0),
(2, 1, 2, 'Aprovado', 7.0),
(3, 2, 1, 'Reprovado', 4.0),
(4, 2, 2, 'Reprovado', 6.5),
(5, 3, 2, 'Aprovado', 7.5),
(6, 3, 3, 'Aprovado', 8.0),
(7, 6, 1, 'Aprovado', 7.0),
(8, 6, 2, 'Reprovado', 5.0),
(9, 7, 2, 'Aprovado', 9.0),
(10, 7, 3, 'Aprovado', 9.5),
(11, 1, 4, 'Aprovado', 8.5),
(12, 1, 5, 'Aprovado', 7.5),
(13, 2, 4, 'Reprovado', 6.0),
(14, 3, 6, 'Aprovado', 8.0),
(15, 7, 6, 'Reprovado', 6.0);

CALL sp_RegistrarMatricula(1, 7);
CALL sp_RegistrarMatricula(1, 9);
CALL sp_RegistrarMatricula(1, 10);
CALL sp_RegistrarMatricula(2, 8);
CALL sp_RegistrarMatricula(4, 11);
CALL sp_RegistrarMatricula(4, 13);
CALL sp_RegistrarMatricula(5, 12);
-- CALL sp_RegistrarMatricula(6, 7); -- Deu erro e é para dar erro mesmo zéééééé
CALL sp_RegistrarMatricula(6, 14);
CALL sp_RegistrarMatricula(7, 14);

CALL sp_LancarNotas(16, 8.5);
CALL sp_LancarNotas(17, 9.0);
CALL sp_LancarNotas(19, 7.5);

CALL sp_TrancarMatricula(18, 2);

CALL sp_GerarHistoricoAluno(1);