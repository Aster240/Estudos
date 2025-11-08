import mysql.connector
from mysql.connector import errorcode
import os #
from dotenv import load_dotenv 


load_dotenv()
HOST = os.getenv("DB_HOST")
USER = os.getenv("DB_USER")
PASS = os.getenv("DB_PASS")
DB_NAME = os.getenv("DB_NAME")


def get_db_connection():
    
    # Variável para a conexão
    conn = None 
    
    try:
        conn = mysql.connector.connect(
            host=HOST,
            user=USER,
            password=PASS,
            database=DB_NAME
        )
        
        print("Conexão aberta...")
        yield conn 
    
    except mysql.connector.Error as error:
        #informa o erro
        if error.errno == errorcode.ER_BAD_DB_ERROR:
            print(f"Erro: O banco de dados '{DB_NAME}' não existe.")
        elif error.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Erro: Nome de usuário ou senha estão errados.")
        else:
            print(f"Erro inesperado: {error}")    

    finally:
        if conn and conn.is_connected():
            conn.close()
            print("Conexão fechada.")