#!/bin/bash

# Este script busca y activa una conexión de tethering USB en Manjaro.

# 1. Busca la interfaz del teléfono a través de una búsqueda más específica.
#    NetworkManager asigna un tipo de interfaz 'Modem' a las conexiones de tethering USB.
#    Usamos 'nmcli' para encontrar una interfaz con este tipo y que no esté conectada.
interface=$(nmcli device status | grep -E 'Modem|usb0' | awk '{print $1}')

# 2. Verifica si se encontró una interfaz válida.
if [ -z "$interface" ]; then
    echo "❌ No se encontró un dispositivo de tethering USB o ya está conectado."
    echo "Asegúrate de que el tethering USB esté activado en tu teléfono."
    exit 1
fi

# 3. Muestra la interfaz encontrada y procede a conectar.
echo "✅ Interfaz de tethering USB encontrada: $interface"

# 4. Activa la conexión de la interfaz.
#    El comando 'nmcli device connect' es el más adecuado para esta tarea.
echo "⌛ Conectando..."
nmcli device connect "$interface"

# 5. Verifica el estado de la conexión.
if [ $? -eq 0 ]; then
    echo "✅ ¡Conexión de tethering USB activada con éxito!"
    echo "Detalles de la conexión:"
    nmcli device show "$interface" | grep -E 'IP4.ADDRESS|IP4.GATEWAY'
else
    echo "❌ Error al conectar. Intenta desactivar y volver a activar el tethering en tu teléfono."
fi