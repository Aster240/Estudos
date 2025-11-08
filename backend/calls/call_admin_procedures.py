from connect import get_db_connection
import mysql.connector
from datetime import date

def cadastrar_aluno(nome, cpf, email, data_nascimento, id_curso):
    print(f'\n--- TENTANDO CADASTRAR NOVO ALUNO: {nome}')
    
    with get_db_connection() as conn:
        if not conn:
            print('Falha na conexão com o banco de dados.')
            return

        with conn.cursor() as cursor:
            try:
                # Converte string de data 'YYYY-MM-DD' para objeto date
                data_obj = date.fromisoformat(data_nascimento)
                
                args = (nome, cpf, email, data_obj, id_curso)
                cursor.callproc('sp_Admin_CadastrarAluno', args)
                conn.commit()
                print(f"Aluno {nome} (CPF: {cpf}) cadastrado com sucesso.")
            except mysql.connector.Error as e:
                print(f"Erro ao cadastrar aluno: {e.msg}")
            except ValueError:
                print("Erro: Formato de data inválido. Use YYYY-MM-DD.")
            except Exception as e:
                print(f"Um erro inesperado ocorreu: {e}")

def cadastrar_professor(nome, titulacao, email):
    print(f'\n--- TENTANDO CADASTRAR NOVO PROFESSOR: {nome}')
    
    with get_db_connection() as conn:
        if not conn:
            print('Falha na conexão com o banco de dados.')
            return

        with conn.cursor() as cursor:
            try:
                args = (nome, titulacao, email)
                cursor.callproc('sp_Admin_CadastrarProfessor', args)
                conn.commit()
                print(f"Professor {nome} ({titulacao}) cadastrado com sucesso.")
            except mysql.connector.Error as e:
                print(f"Erro ao cadastrar professor: {e.msg}")
            except Exception as e:
                print(f"Um erro inesperado ocorreu: {e}")

def criar_turma(id_disciplina, id_professor, id_semestre, max_vagas):
    print(f'\n--- TENTANDO CRIAR NOVA TURMA')
    
    with get_db_connection() as conn:
        if not conn:
            print('Falha na conexão com o banco de dados.')
            return

        with conn.cursor() as cursor:
            try:
                args = (id_disciplina, id_professor, id_semestre, max_vagas)
                cursor.callproc('sp_Admin_CriarTurma', args)
                conn.commit()
                print(f"Nova turma para disciplina {id_disciplina} criada com sucesso.")
            except mysql.connector.Error as e:
                print(f"Erro ao criar turma: {e.msg}")
            except Exception as e:
                print(f"Um erro inesperado ocorreu: {e}")