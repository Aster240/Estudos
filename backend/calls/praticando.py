from connect import get_db_connection

def test():
    print("Tentando consultar a versão")
    with get_db_connection() as conn:
        if conn:
            with conn.cursor() as cursor:
                cursor.execute("SELECT VERSION()")
                version = cursor.fetchone()
                print(f"Versão do servidor: {version[0]}")
