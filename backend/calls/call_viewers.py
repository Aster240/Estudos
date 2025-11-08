from connect import get_db_connection


def Buscar_boletim_por_aluno(id_aluno):
    print(f'--- BUSCANDO O ALUNO COM O ID == {id_aluno}')
    
    with get_db_connection() as conn:
        if not conn:
            print('Falha ao entrar no banco de dados, por favor tente mais tarde!')
            return

        query = """SELECT Aluno, Disciplina, Professor, NotaFinal, Status FROM vw_BoletimAluno WHERE id_aluno = %s"""
        valores = (id_aluno,)

        with conn.cursor() as cursor:
            try:
                cursor.execute(query, valores)
                resultados = cursor.fetchall()

                if not resultados:
                    print(f'Nenhum resultado encontrado para o id {id_aluno}')
                    return

                nome_aluno = resultados[0][0]
                print(f'Boletim para: {nome_aluno}')

                for (aluno, disciplina, prof, nota, status) in resultados:
                    print(f"  - Disciplina: {disciplina} (Prof: {prof})")
                    print(f"    Nota: {nota} | Status: {status}\n")
            except Exception as e:
                print(f"Erro ao consultar a view: {e}")


def Buscar_todos_boletins():
    print('--- Buscando Boletim de Todos os Alunos')

    with get_db_connection() as conn:
        if not conn:
            print('Não foi possível se conectar ao banco de dados, por favor tente mais tarde!')
            return
        
        try:
            query = """SELECT Aluno, Disciplina, Professor, NotaFinal, Status FROM vw_BoletimAluno ORDER BY Aluno, Disciplina"""
            with conn.cursor() as cursor:
                cursor.execute(query)
                resultados = cursor.fetchall()

                if not resultados:
                    print('Nenhum boletim encontrado no sistema')
                    return
                
            aluno_atual = ''
            for (aluno, disciplina, prof, nota, status) in resultados:
                if aluno != aluno_atual:
                    print('\n=================================')
                    print(f'Boletim para o aluno: {aluno}')
                    print('=================================')
                    aluno_atual = aluno

                print(f"  - Disciplina: {disciplina} (Prof: {prof})")
                print(f"    Nota: {nota} | Status: {status}\n")

        except Exception as e:
            print(f"Erro ao consultar a view: {e}")

def buscar_turmas_disponiveis():
    print('\n--- Buscando Turmas disponíveis ---')

    with get_db_connection() as conn:
        if not conn:
            print('falha na conexão do banco de dados')
            return
        
        query = """SELECT id_turma,Disciplina, Professor, Semestre from vw_TurmasDisponiveis"""

        with conn.cursor() as cursor:
            try:
                cursor.execute(query)
                resultados = cursor.fetchall()
                if not resultados:
                    print("nenhuma turma está disponível")
                    return
                
                print("Turmas com vagas no semestre atual:")
                for(id_turma, disc, prof, sem, vagas) in resultados:
                    print(f'[ID TURMA:{id_turma}] {disc} (Prof: {prof}) - Vagas: {vagas} (Sem: {})')
            except mysql.connector.Error as e:
                print(f"Ero ao consultar a view: {e}")

def buscar_desempenho_turmas():
    print('--- Buscando o Desempenho das Turmas ---')        

    with get_db_connection() as conn:
        if not conn:
            print('falha ao conectar ao banco de dados')

        query="""SELECT Disciplina, Professor, Semestre, MediaNotas, TotalAprovados, TotalReprovados FROM vw_DesempenhoTurma"""

        with conn.cursor() as cursor:
            try:
                cursor.execute(query)
                resultados =  cursor.fetchall()
                if not resultados:
                    print('nenhum dado de desempenho enocntrado')
                    return
                print('Desempenho das turmas concluídas')
                for(disc, prof, sem, aprov, reprov) in resultados:
                    print(f"  - {disc} (Prof: {prof}) - Semestre: {sem}")
                    print(f"    Média: {media:.2f} | Aprovados: {aprov} | Reprovados: {reprov}")
            except mysql.connector.Error as e:
                print(f'erro a consultar a view: {e}')                    

def buscar_logs_recentes():
    print('--- Buscando Logs Recentes---')        

    with get_db_connection as conn:
        if not conn:
            print('falha ao conectar ao banco de dados')

        query="""SELECT id_log, fk_usuario, acao, tabela_afetada, data_hora FROM vw_LogAuditoria"""

        with conn.cursor() as cursor:
            try:
                cursor.execute(query)
                resultados =  cursor.fetchall()
                if not resultados:
                    print('nenhum log recente foi enocntrado')
                    return
                print('Ultimas operações do sistema')
                for (id_log, user, acao, tabela, data) in resultados:
                    print(f"  [{data}] ID: {id_log} | User: {user} | Ação: {acao} | Tabela: {tabela}")
            except mysql.connector.Error as e:
                print(f'erro a consultar a view: {e}')   