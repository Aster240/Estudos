from connect import get_db_connection
import mysql.connector

def calcular_coeficiente_rendimento(id_aluno):
    print(f'\n--- CALCULANDO COEFICIENTE DO ALUNO {id_aluno}')
    
    with get_db_connection() as conn:
        if not conn:
            print('Falha na conexão com o banco de dados.')
            return None

        with conn.cursor() as cursor:
            try:
                query = "SELECT fn_CalcularCoeficienteRendimento(%s)"
                cursor.execute(query, (id_aluno,))
                resultado = cursor.fetchone()
                
                if resultado:
                    coeficiente = resultado[0]
                    print(f"Coeficiente de Rendimento (CR): {coeficiente:.2f}")
                    return coeficiente
                else:
                    print("Não foi possível calcular o coeficiente.")
                    return None
            except mysql.connector.Error as e:
                print(f"Erro ao calcular coeficiente: {e.msg}")
            except Exception as e:
                print(f"Um erro inesperado ocorreu: {e}")

def contar_disciplinas_pendentes(id_aluno, id_curso):
    print(f'\n--- CONTANDO DISCIPLINAS PENDENTES (ALUNO {id_aluno}, CURSO {id_curso})')
    
    with get_db_connection() as conn:
        if not conn:
            print('Falha na conexão com o banco de dados.')
            return None

        with conn.cursor() as cursor:
            try:
                query = "SELECT fn_ContarDisciplinasPendentes(%s, %s)"
                cursor.execute(query, (id_aluno, id_curso))
                resultado = cursor.fetchone()
                
                if resultado:
                    pendentes = resultado[0]
                    print(f"Total de disciplinas pendentes: {pendentes}")
                    return pendentes
                else:
                    print("Não foi possível contar as disciplinas.")
                    return None
            except mysql.connector.Error as e:
                print(f"Erro ao contar disciplinas: {e.msg}")
            except Exception as e:
                print(f"Um erro inesperado ocorreu: {e}")

def listar_disciplinas_aprovadas(id_aluno):
    print(f'\n--- LISTANDO DISCIPLINAS APROVADAS (ALUNO {id_aluno})')
    
    with get_db_connection() as conn:
        if not conn:
            print('Falha na conexão com o banco de dados.')
            return None

        with conn.cursor() as cursor:
            try:
                query = "SELECT fn_ListarDisciplinasAprovadas(%s)"
                cursor.execute(query, (id_aluno,))
                resultado = cursor.fetchone()
                
                if resultado and resultado[0]:
                    lista_disciplinas = resultado[0]
                    print(f"Disciplinas Aprovadas: {lista_disciplinas}")
                    return lista_disciplinas
                else:
                    print("Nenhuma disciplina aprovada encontrada.")
                    return ""
            except mysql.connector.Error as e:
                print(f"Erro ao listar disciplinas: {e.msg}")
            except Exception as e:
                print(f"Um erro inesperado ocorreu: {e}")

def total_horas_concluidas(id_aluno):
    print(f'\n--- CALCULANDO TOTAL DE HORAS CONCLUÍDAS (ALUNO {id_aluno})')
    
    with get_db_connection() as conn:
        if not conn:
            print('Falha na conexão com o banco de dados.')
            return None

        with conn.cursor() as cursor:
            try:
                query = "SELECT fn_TotalHorasConcluidas(%s)"
                cursor.execute(query, (id_aluno,))
                resultado = cursor.fetchone()
                
                if resultado:
                    total_horas = resultado[0]
                    print(f"Total de horas concluídas: {total_horas}h")
                    return total_horas
                else:
                    print("Não foi possível calcular as horas.")
                    return 0
            except mysql.connector.Error as e:
                print(f"Erro ao calcular horas: {e.msg}")
            except Exception as e:
                print(f"Um erro inesperado ocorreu: {e}")