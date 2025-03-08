import boto3
import time

sns_client = boto3.client("sns")

TOPIC_ARN = "arn:aws:sns:us-east-1:216989108933:cloudwatch_alarm_topic"

def lambda_handler(event, context):
    message = "🚨 Alerta de prueba: Notificación de CloudWatch SNS 🚨\n\nEste es un mensaje de prueba para verificar que SNS está enviando correos correctamente."
    
    for _ in range(6):  # Se ejecuta 6 veces (cada 10 segundos, total 1 minuto)
        response = sns_client.publish(
            TopicArn=TOPIC_ARN,
            Message=message
        )
        print(f"Mensaje enviado con ID: {response['MessageId']}")
        time.sleep(10)  # Esperar 10 segundos antes de la siguiente ejecución

    return {"statusCode": 200, "body": "Mensajes enviados cada 10 segundos"}
