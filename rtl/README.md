# Periférico PWM - Documentación RTL

Este repositorio implementa un **módulo PWM configurable** en Verilog, compuesto por tres archivos principales:  
- `reg_iface.v` (interfaz de registros)  
- `pwm_unit.v` (núcleo PWM)  
- `top_pwm_alt.v` (integración top-level)

Toda la documentación usa los **nombres exactos de señales y puertos** del código.

---

## Estructura y explicación de módulos

### 1. `reg_iface.v`  
**Interfaz de registros de control y estado**

#### **Puertos**
- **Entradas**
  - `clk_i`      : Reloj de sistema.
  - `rst_ni`     : Reset global, activo en bajo.
  - `addr_i`     : Dirección del registro a acceder.
  - `wr_data_i`  : Dato a escribir en el registro seleccionado.
  - `wr_en_i`    : Habilita operación de escritura.
  - `rd_en_i`    : Habilita operación de lectura.
  - `status_in_i`: Señales de estado del PWM (por ejemplo, el valor actual del contador o PWM).
- **Salidas**
  - `rd_data_o`  : Dato leído desde el registro seleccionado.
  - `ctrl_o`     : Señales de control para el núcleo PWM (`periodo`, `duty`, `enable`...).
  - `status_o`   : Salida de estado para uso externo (o para monitoreo desde el bus).

#### **Descripción**
Este módulo se encarga de mapear registros de configuración del periférico a través de un bus simple. Permite al usuario configurar el período, el ciclo útil (duty) y habilitar/deshabilitar el PWM a través de registros. También facilita la lectura de información de estado.

---

### 2. `pwm_unit.v`  
**Núcleo generador PWM**

#### **Puertos**
- **Entradas**
  - `clk_i`   : Reloj de sistema.
  - `rst_ni`  : Reset global, activo en bajo.
  - `ctrl_i`  : Señales de control provenientes de la interfaz (normalmente incluye: periodo, duty, enable).
- **Salidas**
  - `status_o`: Señales de estado, por ejemplo valor actual del contador.
  - `pwm_o`   : Salida de señal PWM.

#### **Descripción**
Este módulo implementa la lógica generadora de la señal PWM.  
Recibe parámetros configurables (período, duty, enable) y entrega la señal PWM correspondiente.  
Reporta estado al exterior para depuración, monitoreo o sincronización.

---

### 3. `top_pwm_alt.v`  
**Integración top-level**

#### **Puertos**
- **Entradas**
  - `clk_i`      : Reloj de sistema.
  - `rst_ni`     : Reset global, activo en bajo.
  - `addr_i`     : Dirección de registro.
  - `wr_data_i`  : Dato a escribir.
  - `wr_en_i`    : Habilita escritura.
  - `rd_en_i`    : Habilita lectura.
- **Salidas**
  - `rd_data_o`  : Dato leído.
  - `pwm_o`      : Salida PWM para el mundo exterior.

#### **Descripción**
Este módulo instancia y conecta `reg_iface.v` y `pwm_unit.v`.  
Hace que todo el periférico sea fácilmente integrable en un SoC, microcontrolador soft o sistema digital más grande.

---

## Justificación de la arquitectura

- **Modularidad**: Permite reutilización y pruebas independientes.
- **Separación clara de funciones**: La interfaz de registros se mantiene independiente de la lógica PWM.
- **Escalabilidad**: Puedes agregar más registros o modos avanzados (dead time, interrupciones, etc.) sin afectar el núcleo.
- **Compatibilidad**: Facilita la integración con buses simples personalizados.

---

## Descripción de los registros de control (en `reg_iface.v`)

| Dirección (`addr_i`) | Registro     | Función                              | Bits relevantes     |
|----------------------|--------------|--------------------------------------|---------------------|
| 0x0                  | `period`     | Valor de período del PWM             | Depende de diseño   |
| 0x1                  | `duty`       | Valor de duty cycle                  | Depende de diseño   |
| 0x2                  | `enable`     | Habilitación del PWM (bit 0)         | Solo bit 0          |



---

## Ejemplo de diagrama de tiempo

### WaveDrom (código)

```json
{
  "signal": [
    { "name": "clk_i",     "wave": "p.......|........|........|........" },
    { "name": "rst_ni",    "wave": "10......|........|........|........", "data": ["RESET"] },
    { "name": "wr_en_i",   "wave": "0.10....|0.10....|0......0|........", "data": ["", "PER", "", "DUTY", "", "", "EN"] },
    { "name": "rd_en_i",   "wave": "0.......|.10.....|........|........", "data": ["", "RD"] },
    { "name": "addr_i",    "wave": "x.=.....|x.=.....|x......x|........", "data": ["", "0", "", "1", "", "", "2"] },
    { "name": "wr_data_i", "wave": "x.=.....|x.=.....|x......x|........", "data": ["", "20", "", "10", "", "", "1"] },
    { "name": "ctrl_o",    "wave": "x.......|..=.....|..=.....|..=.....", "data": ["", "PER", "DUTY", "EN"] },
    { "name": "pwm_o",     "wave": "0.......|..01.0..|.1010.1.|.0101.0." }
  ],
  "head": {
    "text": "Diagrama de tiempo PWM (WaveDrom)"
  }
}
