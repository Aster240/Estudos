from connect import get_db_connection
import mysql.connector

from calls.call_viewers import (
    Buscar_boletim_por_aluno,
    Buscar_todos_boletins,
    buscar_turmas_disponiveis,
    buscar_desempenho_turmas,
    buscar_logs_recentes
)

from calls.call_procedures import (
    registrar_matricula,
    lancar_nota,
    trancar_matricula,
    gerar_historico_aluno,
    reabrir_periodo_matricula
)

from calls.call_admin_procedures import (
    cadastrar_aluno,
    cadastrar_professor,
    criar_turma
)

from calls.call_functions import (
    calcular_coeficiente_rendimento,
    contar_disciplinas_pendentes,
    listar_disciplinas_aprovadas,
    total_horas_concluidas
)

def get_user_info(user_id):
    with get_db_connection() as conn:
        if not conn:
            return None, None
        with conn.cursor() as cursor:
            try:
                query = "SELECT nome, tipo_usuario FROM usuarios WHERE id_usuario = %s"
                cursor.execute(query, (user_id,))
                user = cursor.fetchone()
                if user:
                    return user[0], user[1] # (nome, tipo_usuario)
            except mysql.connector.Error as e:
                print(f"Erro ao buscar usuário: {e.msg}")
                return None, None
    return None, None

def safe_input_int(prompt):
    while True:
        try:
            return int(input(prompt))
        except ValueError:
            print("Entrada inválida. Por favor, digite um número.")

def menu_admin(user_id, nome_usuario):
    print(f"\n--- PAINEL ADMIN (Secretaria) ---")
    print(f"Usuário: {nome_usuario} (ID: {user_id})")
    
    while True:
        print("\nEscolha uma operação:")
        print("--- Gerenciamento ---")
        print(" 1. Cadastrar Novo Aluno")
        print(" 2. Cadastrar Novo Professor")
        print(" 3. Criar Nova Turma")
        print(" 4. Reabrir Período de Matrícula")
        print("--- Operações Acadêmicas ---")
        print(" 5. Matricular Aluno em Turma")
        print(" 6. Trancar Matrícula de Aluno")
        print(" 7. Gerar/Atualizar Histórico de Aluno")
        print("--- Consultas ---")
        print(" 8. Ver Logs do Sistema")
        print(" 9. Ver Turmas Disponíveis")
        print(" 10. Ver Boletim de Aluno Específico")
        print(" 0. Sair (Deslogar)")
        
        op = input("Opção: ")
        
        try:
            if op == '1':
                nome = input("Nome do aluno: ")
                cpf = input("CPF (apenas números): ")
                email = input("Email: ")
                data_nasc = input("Data Nascimento (YYYY-MM-DD): ")
                id_curso = safe_input_int("ID do Curso: ")
                cadastrar_aluno(nome, cpf, email, data_nasc, id_curso)
                
            elif op == '2':
                nome = input("Nome do professor: ")
                titulacao = input("Titulação (Mestre, Doutor, etc.): ")
                email = input("Email: ")
                cadastrar_professor(nome, titulacao, email)

            elif op == '3':
                id_disc = safe_input_int("ID da Disciplina: ")
                id_prof = safe_input_int("ID do Professor: ")
                id_sem = safe_input_int("ID do Semestre: ")
                vagas = safe_input_int("Máximo de Vagas: ")
                criar_turma(id_disc, id_prof, id_sem, vagas)

            elif op == '4':
                id_sem = safe_input_int("ID do Semestre para reabrir: ")
                reabrir_periodo_matricula(id_sem)

            elif op == '5':
                id_aluno = safe_input_int("ID do Aluno: ")
                id_turma = safe_input_int("ID da Turma: ")
                registrar_matricula(id_aluno, id_turma)

            elif op == '6':
                id_mat = safe_input_int("ID da Matrícula a trancar: ")
                trancar_matricula(id_mat, user_id) # Usa o ID do admin logado

            elif op == '7':
                id_aluno = safe_input_int("ID do Aluno para gerar histórico: ")
                gerar_historico_aluno(id_aluno)

            elif op == '8':
                buscar_logs_recentes()
            
            elif op == '9':
                buscar_turmas_disponiveis()

            elif op == '10':
                id_aluno = safe_input_int("ID do Aluno para ver boletim: ")
                Buscar_boletim_por_aluno(id_aluno)
                
            elif op == '0':
                print("Deslogando do painel de Admin...")
                break
            else:
                print("Opção inválida.")
        except Exception as e:
            print(f"Ocorreu um erro na operação: {e}")


def menu_professor(user_id, nome_usuario):
    print(f"\n--- PAINEL DO PROFESSOR ---")
    print(f"Usuário: {nome_usuario} (ID: {user_id})")

    while True:
        print("\nEscolha uma operação:")
        print(" 1. Lançar Nota/Finalizar Matrícula")
        print(" 2. Ver Desempenho de Turmas (Geral)")
        print(" 0. Sair (Deslogar)")
        
        op = input("Opção: ")
        
        try:
            if op == '1':
                id_mat = safe_input_int("ID da Matrícula: ")
                nota = float(input("Nota Final (ex: 8.5): "))
                lancar_nota(id_mat, nota)
            
            elif op == '2':
                buscar_desempenho_turmas()
                
            elif op == '0':
                print("Deslogando do painel do Professor...")
                break
            else:
                print("Opção inválida.")
        except ValueError:
            print("Erro: A nota deve ser um número (use . para decimais).")
        except Exception as e:
            print(f"Ocorreu um erro na operação: {e}")

def menu_aluno(user_id, nome_usuario):
    print(f"\n--- PORTAL DO ALUNO ---")
    print(f"Usuário: {nome_usuario} (ID: {user_id})")

    id_aluno = user_id 

    while True:
        print("\nEscolha uma operação:")
        print(" 1. Ver meu Boletim/Matrículas")
        print(" 2. Ver Turmas Disponíveis (Matrícula)")
        print(" 3. Calcular meu Coeficiente (CR)")
        print(" 4. Listar minhas Disciplinas Aprovadas")
        print(" 5. Ver Total de Horas Concluídas")
        print(" 6. Ver Disciplinas Pendentes (Requer ID do Curso)")
        print(" 0. Sair (Deslogar)")
        
        op = input("Opção: ")
        
        try:
            if op == '1':
                Buscar_boletim_por_aluno(id_aluno)
            
            elif op == '2':
                buscar_turmas_disponiveis()
                
            elif op == '3':
                calcular_coeficiente_rendimento(id_aluno)
            
            elif op == '4':
                listar_disciplinas_aprovadas(id_aluno)
            
            elif op == '5':
                total_horas_concluidas(id_aluno)

            elif op == '6':
                id_curso = safe_input_int("Digite o ID do seu Curso: ")
                contar_disciplinas_pendentes(id_aluno, id_curso)

            elif op == '0':
                print("Deslogando do portal do Aluno...")
                break
            else:
                print("Opção inválida.")
        except Exception as e:
            print(f"Ocorreu um erro na operação: {e}")


def main():
    print("Bem-vindo ao Sistema de Gerenciamento Acadêmico")
    
    while True:
        print("\n--- LOGIN ---")
        try:
            user_id = int(input("Digite seu ID de Usuário (ou 0 para sair): "))
        except ValueError:
            print("ID inválido. Deve ser um número.")
            continue
            
        if user_id == 0:
            print("Saindo do sistema.")
            break
            
        nome, tipo_usuario = get_user_info(user_id)
        
        if not nome:
            print(f"Usuário com ID {user_id} não encontrado.")
            continue
            
        print(f"Login bem-sucedido! Bem-vindo, {nome} ({tipo_usuario}).")
        
        # Direciona para o menu correto
        if tipo_usuario == 'Admin':
            menu_admin(user_id, nome)
        elif tipo_usuario == 'Professor':
            menu_professor(user_id, nome)
        elif tipo_usuario == 'Aluno':
            menu_aluno(user_id, nome)
        else:
            print(f"Tipo de usuário '{tipo_usuario}' não reconhecido.")

if __name__ == "__main__":
    main()