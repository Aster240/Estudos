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
        
        # --- CORREÇÃO 3: Bloco try/except envolve a lógica do cursor ---
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