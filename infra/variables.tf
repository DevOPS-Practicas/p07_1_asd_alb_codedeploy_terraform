# ==============================================================================
# Variables de Infraestructura - Proyecto Calculadora
# ==============================================================================

variable "aws_region" {
  description = "Región de AWS donde se desplegarán todos los recursos"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefijo/nombre común para identificar todos los recursos del proyecto"
  type        = string
  default     = "calculadora"
}

variable "environment" {
  description = "Ambiente de despliegue (ej. production, staging, dev)"
  type        = string
  default     = "production"
}

# --- Red (VPC) ---
variable "vpc_cidr" {
  description = "Bloque CIDR para la VPC principal"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Lista de bloques CIDR para las subredes públicas (mínimo 2 en distintas AZs)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# --- Cómputo (EC2 / ASG / Launch Template) ---
variable "instance_type" {
  description = "Tipo de instancia EC2 utilizado en el Launch Template"
  type        = string
  default     = "t3.micro"
}

variable "asg_min_size" {
  description = "Número mínimo de instancias en el Auto Scaling Group"
  type        = number
  default     = 2
}

variable "asg_desired_capacity" {
  description = "Capacidad deseada de instancias en el Auto Scaling Group"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Número máximo de instancias en el Auto Scaling Group"
  type        = number
  default     = 4
}

variable "health_check_grace_period" {
  description = "Tiempo de gracia (segundos) tras el lanzamiento de una instancia antes de verificar su salud en el ASG"
  type        = number
  default     = 300
}

# --- Aplicación y Balanceador de Carga (ALB) ---
variable "app_port" {
  description = "Puerto en el que la aplicación escucha en las instancias EC2 (Nginx/Frontend)"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Ruta de verificación de salud en el Target Group (honesta, evalúa backend/frontend)"
  type        = string
  default     = "/api/health"
}

variable "deregistration_delay" {
  description = "Tiempo en segundos que el Target Group espera para drenar conexiones activas al remover una instancia"
  type        = number
  default     = 30
}

variable "allowed_ssh_cidrs" {
  description = "Lista opcional de CIDRs permitidos para acceso SSH directo (SSM Session Manager es el método recomendado)"
  type        = list(string)
  default     = []
}
