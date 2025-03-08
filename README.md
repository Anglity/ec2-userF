# 🚀 Infraestructura AWS con Terraform

Este proyecto despliega una infraestructura completa en AWS utilizando Terraform. La solución integra:

## 📌 Componentes

- **Bucket S3**: Para almacenar el código ZIP de la función Lambda 📦
- **SNS**: Un tópico para enviar notificaciones y alertas 📣
- **SQS**: Una cola que recibe mensajes publicados en el tópico SNS 📬
- **Lambda**: Una función en Python que se activa con eventos de SQS, procesa el mensaje y envía un correo electrónico vía SMTP ✉️
- **IAM**: Roles y políticas necesarios para que Lambda acceda a S3, SNS, SQS y CloudWatch Logs 🔐
- **CloudWatch**: Alarmas para monitorear errores en Lambda y la longitud de la cola SQS, enviando notificaciones a través del tópico SNS 📊

---

## 📋 Requisitos Previos

### 1️⃣ Instalar Terraform en Windows

Descarga Terraform desde [Terraform Downloads](https://developer.hashicorp.com/terraform/downloads) y añade el ejecutable al PATH.

### 2️⃣ Instalar AWS CLI para Windows

Descárgalo e instálalo (por ejemplo, usando el instalador MSI). Luego, configura tus credenciales en PowerShell:

```powershell
aws configure
```

Ingresa tu **Access Key**, **Secret Key**, región (por ejemplo, `us-east-1`) y el formato de salida (`json`).

### 3️⃣ Editor de Texto

Se recomienda usar **Visual Studio Code** o **Notepad++** para editar los archivos de Terraform y el código de Lambda.

### 4️⃣ PowerShell o CMD

Para ejecutar comandos desde tu máquina local.

---

## 📂 Estructura del Proyecto

```
terraform-aws-lambda-sns-sqs/
├── lambda-code/
│   ├── index.py         # Código Python de la función Lambda
│   ├── mi_lambda.zip    # Archivo ZIP (se genera a partir de index.py)
├── main.tf              # Archivo de Terraform con la configuración completa
└── credentials.tfvars   # (Opcional) Archivo para variables sensibles, como SMTP
```

---

## 🔧 Despliegue y Configuración con Terraform

### 1️⃣ Subir el Código de Lambda a S3

Antes de aplicar Terraform, empaqueta tu código Lambda y súbelo a S3:

```powershell
# Navega a la carpeta donde está el código
cd C:\Projects\terraform-aws-lambda-sns-sqs\lambda-code

# Empaqueta el archivo index.py en un ZIP
Compress-Archive -Path index.py -DestinationPath mi_lambda.zip

# Sube el ZIP al bucket (la ruta en S3 debe coincidir con la definida en main.tf)
aws s3 cp .\mi_lambda.zip s3://<tu-bucket-unico>/lambda-code/mi_lambda.zip
```

**Nota**: El nombre del bucket S3 debe ser único a nivel global.

### 2️⃣ Inicializar y Aplicar Terraform

Desde PowerShell, en el directorio raíz del proyecto:

```powershell
cd C:\Projects\terraform-aws-lambda-sns-sqs
terraform init       # Inicializa el backend y descarga plugins
terraform plan       # Revisa el plan de ejecución
terraform apply      # Aplica la configuración (escribe "yes" cuando se solicite)
```

Si usas un archivo de variables (por ejemplo, para SMTP), puedes ejecutar:

```powershell
terraform apply -var-file="credentials.tfvars"
```

---

## 📧 Configuración Segura de Credenciales de Correo

### 🔹 Opción 1: Archivo de Variables (.tfvars)

Crea un archivo `credentials.tfvars` en la raíz del proyecto con contenido similar a:

```hcl
smtp_host = "smtp.gmail.com"
smtp_port = "587"
smtp_user = "tuemail@gmail.com"
smtp_pass = "tu_contraseña"
```

Incluye este archivo en el `.gitignore` para no subirlo a GitHub.

Ejecuta Terraform con el archivo de variables:

```powershell
terraform apply -var-file="credentials.tfvars"
```

### 🔹 Opción 2: AWS Secrets Manager (Recomendado para Producción)

1. Almacena tus credenciales SMTP en **AWS Secrets Manager**.
2. Configura la función Lambda para que las recupere en tiempo de ejecución usando `boto3`.
3. Otorga permisos al rol de Lambda para acceder al secreto.

---

## 🔍 Verificación y Monitoreo

### ✅ Verificar Recursos en AWS

- **S3**: Revisa en la consola de S3 que el bucket y el archivo ZIP estén creados.
- **SNS**: Confirma que el tópico `cloudwatch_alarm_topic` está activo y tiene suscripciones.
- **SQS**: Verifica la cola `mi_sqs_queue` en la consola de SQS.
- **Lambda**: Confirma que la función `ProcessSQSMessages` está creada y en estado "Active".
- **CloudWatch**: Revisa que las alarmas (`LambdaErrorsAlarm` y `SQSQueueLengthAlarm`) estén configuradas y notifiquen mediante SNS.

### 🔹 Probar el Flujo Completo

#### 1️⃣ Publicar un Mensaje de Prueba en SNS

Desde la consola de SNS, publica un mensaje con el siguiente JSON:

```json
{
  "to": "destinatario@ejemplo.com",
  "cc": "copia@ejemplo.com",
  "bcc": "copiaoculta@ejemplo.com",
  "origen": "remitente@ejemplo.com"
}
```

#### 2️⃣ Flujo de Ejecución

✅ **SNS** envía el mensaje a **SQS**.  
✅ **Lambda** se activa, procesa el mensaje y envía el correo vía SMTP.  
✅ **CloudWatch Logs** registra la ejecución.  
✅ **El destinatario recibe el correo**.  

---

## 🚀 Resumen Final

Con este proyecto desplegado con Terraform, obtendrás:

- 🟢 Un **bucket S3** para almacenar el código de Lambda.
- 🟢 Un **tópico SNS** para notificaciones y alarmas.
- 🟢 Una **cola SQS** suscrita al tópico SNS.
- 🟢 Una **función Lambda** que se activa con SQS y envía correos vía SMTP.
- 🟢 **Roles IAM** que permiten la integración entre estos servicios.
- 🟢 **Alarmas de CloudWatch** que monitorean errores y notifican mediante SNS.

🎉 ¡Disfruta del despliegue y la gestión de tu infraestructura en AWS! 🚀
