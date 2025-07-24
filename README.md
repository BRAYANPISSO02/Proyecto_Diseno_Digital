<p align="center">
  <img src="https://img.shields.io/badge/Verilog-HD-blue.svg" />
  <img src="https://img.shields.io/badge/FPGA-Compatible-green.svg" />
</p>

---

## INTEGRANTES

 ➤   **Federico Villa Gutierrez CC. 1192755321**  
 ➤   **Brayan Ricardo Pisso Ramírez CC. 1004249850** 

---

### Fecha de entrega

Jueves, 24 de Julio de 2025 

---

### Materia

> Diseño Digital – Proyecto Final  
> Universidad Nacional De Colombia - Sede Manizales

---

# Generador de señal PWM parametrizable mediante interfaz de registros en Verilog
> Este proyecto implementa un sistema digital modular en Verilog HDL que genera una señal PWM (Pulse Width Modulation) con ciclo de trabajo configurable a través de una interfaz de registros. El diseño está pensado para su ejecución en plataformas FPGA y permite modificar el duty cycle de forma dinámica mediante un bus de control simulado, facilitando su integración en sistemas embebidos o controladores personalizados.

##  Objetivo General

Diseñar e implementar un sistema generador de señal PWM (Pulse Width Modulation) utilizando Verilog HDL, que integre una interfaz de registros direccionables para permitir la configuración dinámica del ciclo de trabajo de la señal. El sistema debe estar estructurado de manera modular, permitiendo su simulación, verificación funcional y posterior integración en arquitecturas digitales más complejas, como procesadores embebidos o controladores personalizados en FPGA. Además, se busca facilitar la reutilización del diseño en proyectos futuros mediante una arquitectura clara, documentada y escalable.

## Objetivos Específicos

- Implementar en Verilog HDL un módulo generador de señal PWM con ciclo de trabajo ajustable.
- Diseñar una interfaz de registros direccionables que permita escribir y leer configuraciones desde un bus de control simulado o sistemas embebidos.
- Integrar los módulos del sistema en una unidad top-level funcional y coherente.
- Desarrollar bancos de prueba (testbenches) que validen mediante simulación el comportamiento de cada módulo individual y del sistema completo.
- Simular y verificar el funcionamiento del sistema utilizando herramientas como Icarus Verilog y GTKWave.
- Documentar detalladamente la arquitectura, el funcionamiento y los resultados obtenidos del proyecto.

## Requisitos y Plataforma

Esta sección detalla el entorno de desarrollo necesario para ejecutar, simular y extender el diseño del sistema PWM, así como los componentes técnicos requeridos para su implementación y validación.

---

### Requisitos de Software

A continuación, se enumeran las herramientas necesarias para el correcto funcionamiento y verificación del sistema:

- **Icarus Verilog**  
  Herramienta de simulación libre para compilar y ejecutar código Verilog.  
  ➤ Versión utilizada: 10.3.

- **GTKWave**  
  Visualizador de formas de onda compatible con archivos `.vcd`, útil para analizar el comportamiento de las señales digitales.  
  ➤ Versión utilizada: 3.3.

- **Terminal de Linux**  
  Para ejecutar scripts automatizados que facilitan el flujo de simulación (`run.sh` o similares).

- **Editor de Texto con Soporte para Verilog**  
  Utilizado: Visual Studio Code con las extensiones:
  - Verilog-HDL/SystemVerilog
  - Code Runner o equivalente para facilitar pruebas rápidas

- **Github**  
  Para clonar el repositorio desde GitHub y gestionar versiones del código fuente.

---

### Plataforma de Desarrollo

El sistema fue desarrollado y probado en el siguiente entorno:

- **Lenguaje de Descripción de Hardware**: Verilog HDL (IEEE 1364)
- **Sistema Operativo**:  
  - Desarrollo y pruebas realizadas en **Linux Ubuntu**  

- **Simulador Utilizado**:  
  - Icarus Verilog (`iverilog`) para compilación
  - GTKWave para visualización de señales

- **Estructura Modular del Código**:  
  - `rtl/`: código fuente en Verilog  
  - `sim/`: testbenches y scripts de simulación  
  - `doc/`: documentación técnica  
  - `script/`: herramientas automatizadas para verificación

---

### Requisitos Opcionales (para futuras extensiones)

Si se desea escalar el proyecto a síntesis en hardware (por ejemplo, implementación en FPGA que no se pudo dar debido al tiempo), se pueden considerar las siguientes plataformas:

- **Placa de desarrollo** (si se implementa físicamente):  
  - FPGA como Lattice iCE40, Xilinx Spartan-6 o Artix-7

- **Simuladores Alternativos**:
  - Verilator (más veloz para simulaciones de alto rendimiento)
  - ModelSim o GHDL (si se desea compatibilidad con VHDL)

---

## Descripción Completa del Diseño

Este proyecto implementa un sistema digital en Verilog HDL que genera señales PWM (Pulse Width Modulation) con control dinámico del ciclo de trabajo a través de una interfaz de registros direccionables. El diseño es modular y se estructura en tres componentes principales: `pwm_unit`, `reg_iface` y `top_pwm_alt`.

---

### 1. `pwm_unit.v` — Núcleo Generador de PWM

Este módulo es el encargado de generar la señal PWM propiamente dicha. Sus características clave incluyen:

- **Parámetros configurables**:
  - `WIDTH_PERIOD`: define el ancho del periodo (por defecto, 16 bits).
  - `WIDTH_DUTY`: define el ancho del ciclo de trabajo (por defecto, 16 bits).
- **Entradas**:
  - `clk`: señal de reloj.
  - `reset_n`: reset activo en bajo.
  - `period`: valor del periodo de la señal PWM.
  - `duty`: valor del duty cycle (ancho del pulso en alto).
- **Salida**:
  - `pwm_out`: señal PWM generada.

El módulo cuenta con un contador interno que se incrementa con el reloj y se reinicia al alcanzar el valor de `period`. La salida `pwm_out` se mantiene en alto mientras el contador es menor a `duty`, generando así el pulso.

---

### 2. `reg_iface.v` — Interfaz de Registro

Este módulo proporciona una interfaz básica para el control y configuración del sistema mediante lectura y escritura de registros. Sus características incluyen:

- Soporte para acceso externo a través de señales de control (`wr_en_i`, `rd_en_i`) y dirección (`addr`).
- Gestión de registros de control (`ctrl`) y de estado (`status`, `status_in`).
- Facilita la comunicación entre una unidad de control (por ejemplo, microprocesador o testbench) y el generador PWM.

Actúa como puente entre el entorno de control y el núcleo funcional del sistema.

---

### 3. `top_pwm_alt.v` — Módulo Top-Level

Este módulo integra los componentes anteriores (`reg_iface` y `pwm_unit`) para conformar el diseño completo. Funciona como la entidad superior del sistema y coordina:

- La recepción de datos desde el exterior mediante la interfaz de registro.
- El paso de parámetros (`duty`, `period`) hacia el generador PWM.
- La salida de la señal PWM final.

Gracias a esta arquitectura, el sistema es fácilmente integrable y reutilizable en distintas plataformas FPGA y entornos de simulación.

---

### 4. Señales de Entrada y Salida

#### Entradas

| Señal       | Descripción                                                   |
|-------------|---------------------------------------------------------------|
| `clk`       | Señal de reloj del sistema.                                   |
| `reset_n`   | Reset activo en bajo.                                         |
| `wr_en_i`       | Señal de habilitación de escritura en los registros.          |
| `rd_en_i`       | Señal de habilitación de lectura de registros.                |
| `addr`      | Dirección del registro a acceder.                             |
| `wr_data_i`     | Dato que se desea escribir en el registro.                    |
| `status_in` | Entrada opcional para transmitir estados al registro de estado. |

#### Salidas

| Señal       | Descripción                                                   |
|-------------|---------------------------------------------------------------|
| `rd_data_i`     | Dato leído desde el registro.                                 |
| `pwm_out`   | Salida PWM generada por el núcleo.                            |
| `status`    | Estado leído desde la lógica del sistema.                     |

---

### 5. Módulos del Sistema

El sistema está compuesto por los siguientes módulos:

#### - `pwm_unit.v` — Módulo Generador de PWM

Este módulo genera la señal PWM con parámetros configurables para el periodo y el ciclo de trabajo (duty cycle). Es el núcleo funcional del sistema.

- **Entradas**:
  - `clk`: señal de reloj del sistema.
  - `reset_n`: reset activo en bajo.
  - `period`: define la duración total del ciclo PWM.
  - `duty`: define cuántos ciclos permanece en alto la señal.

- **Salida**:
  - `pwm_out`: señal PWM resultante.

La señal `pwm_out` se mantiene en alto durante el número de ciclos definido por `duty`, y luego en bajo hasta completar el `period`.

---

#### - `reg_iface.v` — Módulo de Interfaz de Registros

Este módulo permite la comunicación con el sistema a través de lectura y escritura de registros. Actúa como puente entre una unidad de control externa y el núcleo PWM.

- **Entradas**:
  - `clk`, `reset_n`: señales de control básicas.
  - `wr_en_i`, `rd_en_i`: señales de habilitación para escritura y lectura.
  - `addr`: dirección del registro a acceder.
  - `wr_data_i`: datos a escribir.
  - `status_in`: entradas de estado externas.

- **Salidas**:
  - `rd_data_i`: datos leídos desde los registros.
  - `status`: contenido del registro de estado.
  - `ctrl`: datos de configuración para el PWM.

---

#### - `top_pwm_alt.v` — Módulo de Integración

Este módulo top-level conecta `reg_iface` y `pwm_unit`, gestionando el flujo de señales entre ambos bloques y el entorno externo.

- **Funciones**:
  - Recibe comandos de lectura y escritura a través de la interfaz de registros.
  - Pasa los parámetros `period` y `duty` al generador PWM.
  - Expone la salida `pwm_out` generada por el sistema.

---

### 6. Diagrama de bloques del funcionamiento

<img width="515" height="615" alt="image" src="https://github.com/user-attachments/assets/da47fd3d-3a4b-4309-a78d-fbcd319b1e2f" />

### 7. Máquina de estados

> El sistema PWM fue modelado como una máquina de estados finita (FSM) de tipo Mealy, ya que sus transiciones dependen tanto del estado actual como de señales de entrada (wr_en_i, rd_en_i, duty, period). El diseño permite detectar y manejar errores de configuración, mantener el estado de ejecución (RUN_PWM) y reiniciar el sistema mediante eventos como reset o clear error. La arquitectura favorece la  reconfiguración dinámica sin bloqueo del sistema.

<img width="467" height="490" alt="image" src="https://github.com/user-attachments/assets/f99aebfb-4b7a-4895-8568-20181a54d63d" />


## Explicación del código 

### Módulo pwm_unit

```module pwm_unit #(
2 parameter CNT_WIDTH = 16,
3 parameter DUTY_WIDTH = 16
4 )(
5 input clk_i,
6 input rst_ni,
7 input [CNT_WIDTH-1:0] cfg_period,
8 input [DUTY_WIDTH-1:0] cfg_duty,
9 output pwm_o
10 );
11
12 reg [CNT_WIDTH-1:0] cnt;
13
14 // Contador principal
15 always @(posedge clk_i or negedge rst_ni) begin
16 if (!rst_ni)
17 cnt <= 0;
18 else if (cnt >= cfg_period - 1)
19 cnt <= 0;
20 else
21 cnt <= cnt + 1;
22 end
23
24 // Lógica PWM
25 assign pwm_o = (cnt < cfg_duty);
26
27 endmodule 
```


### Módulo reg_iface

