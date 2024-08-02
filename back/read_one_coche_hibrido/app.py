import json
import os
import mysql.connector
from mysql.connector import Error

def lambda_handler(event, __):
    # Obtener variables de entorno
    db_host = os.environ['RDS_HOST']
    db_user = os.environ['RDS_USER']
    db_password = os.environ['RDS_PASSWORD']
    db_name = os.environ['RDS_DB']

    try:
        # Conexión a la base de datos
        connection = mysql.connector.connect(
            host=db_host,
            user=db_user,
            password=db_password,
            database=db_name
        )
        print(connection)

        cursor = connection.cursor()

        # Obtener el ID del vehículo desde los parámetros de la ruta
        vehicle_id = event['pathParameters']['vehicle_id']

        # Consultar la base de datos
        sql = "SELECT * FROM hybrid_vehicles WHERE id = %s"
        cursor.execute(sql, (vehicle_id,))
        vehicle = cursor.fetchone()

        if vehicle:
            # Convertir la respuesta a un formato adecuado para JSON
            data = {
                'id': vehicle[0],
                'brand': vehicle[1],
                'model': vehicle[2],
                'electric_range': vehicle[3],  # Asegurarse de que sea un float
                'fuel_consumption': vehicle[4]  # Asegurarse de que sea un float
            }
            return {
                'statusCode': 200,
                'headers': {
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Methods': 'GET',
                    'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'
                },
                'body': json.dumps(data)
            }
        else:
            return {
                'statusCode': 404,
                'headers': {
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Methods': 'GET',
                    'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'
                },
                'body': json.dumps({'error': 'Vehículo no encontrado'})
            }
    except Error as e:
        error_message = f"Error de conexión a la base de datos: {str(e)}"
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET',
                'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'
            },
            'body': json.dumps({'error': error_message})
        }
    except KeyError as e:
        error_message = f"Falta la clave esperada en el evento: {str(e)}"
        return {
            'statusCode': 400,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET',
                'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'
            },
            'body': json.dumps({'error': error_message})
        }
    except Exception as error:
        error_message = f"Error inesperado: {str(error)}"
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET',
                'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'
            },
            'body': json.dumps({'error': error_message})
        }
    finally:
        if 'connection' in locals():
            cursor.close()
            connection.close()
