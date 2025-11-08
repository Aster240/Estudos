from connect import get_db_connection
import mysql.connector

def registrar_matricula(id_aluno, id_turma):
    print(f'\n--- TENTANDO MATRICULAR ALUNO {id_aluno} NA TURMA {id_turma}')
    
    with get_db_connection() as conn:
        if not conn:
            print('Falha na conexão com o banco de dados.')
            return

        with conn.cursor() as cursor:
            try:
                args = (id_aluno, id_turma)
                cursor.callproc('sp_RegistrarMatricula', args)
                conn.commit()
                print("Matrícula registrada com sucesso.")
            except mysql.connector.Error as e:
                print(f"Erro ao registrar matrícula: {e.msg}")
            except Exception as e:
                print(f"Um erro inesperado ocorreu: {e}")

def lancar_nota(id_matricula, nota_final):
    print(f'\n--- LANÇANDO NOTA {nota_final} PARA MATRÍCULA {id_matricula}')

    with get_db_connection() as conn:
        if not conn:
            print('Falha na conexão com o banco de dados.')
            return
        
        with conn.cursor() as cursor:
            try:
                args = (id_matricula, nota_final)
                cursor.callproc('sp_LancarNotas', args)
                conn.commit()
                print(f"Nota {nota_final} lançada com sucesso para a matrícula {id_matricula}.")
            except mysql.connector.Error as e:
                print(f"Erro ao lançar nota: {e.msg}")
            except Exception as e:
                print(f"Um erro inesperado ocorreu: {e}")

def trancar_matricula(id_matricula, id_usuario_admin):
    print(f'\n--- TRANCANDO MATRÍCULA {id_matricula} (SOLICITADO POR USER {id_usuario_admin})')

    with get_db_connection() as conn:
        if not conn:
            print('Falha na conexão com o banco de dados.')
            return
        
        with conn.cursor() as cursor:
            try:
                args = (id_matricula, id_usuario_admin)
                cursor.callproc('sp_TrancarMatricula', args)
                conn.commit()
                print(f"Matrícula {id_matricula} trancada com sucesso.")
            except mysql.connector.Error as e:
                print(f"Erro ao trancar matrícula: {e.msg}")
            except Exception as e:
                print(f"Um erro inesperado ocorreu: {e}")

def gerar_historico_aluno(id_aluno):
    print(f'\n--- GERANDO/ATUALIZANDO HISTÓRICO PARA ALUNO {id_aluno}')

    with get_db_connection() as conn:
        if not conn:
            print('Falha na conexão com o banco de dados.')
            return
        
        with conn.cursor() as cursor:
            try:
                args = (id_aluno,)
                cursor.callproc('sp_GerarHistoricoAluno', args)
                conn.commit()
                print(f"Histórico do aluno {id_aluno} foi gerado/atualizado.")
            except mysql.connector.Error as e:
                print(f"Erro ao gerar histórico: {e.msg}")
            except Exception as e:
                print(f"Um erro inesperado ocorreu: {e}")

def reabrir_periodo_matricula(id_semestre):
    print(f'\n--- REABRINDO PERÍODO DE MATRÍCULA PARA SEMESTRE {id_semestre}')

    with get_db_connection() as conn:
        if not conn:
            print('Falha na conexão com o banco de dados.')
            return

        with conn.cursor() as cursor:
            try:
                args = (id_semestre,)
                cursor.callproc('sp_ReabrirPeriodoMatricula', args)
                conn.commit()
                print(f"Período de matrícula para o semestre {id_semestre} foi reaberto.")
            except mysql.connector.Error as e:
                print(f"Erro ao reabrir período: {e.msg}")
            except Exception as e:
                print(f"Um erro inesperado ocorreu: {e}")