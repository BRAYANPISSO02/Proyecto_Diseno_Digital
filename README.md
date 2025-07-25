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

### 1. Diagrama de bloques del funcionamiento

<img width="515" height="615" alt="image" src="https://github.com/user-attachments/assets/da47fd3d-3a4b-4309-a78d-fbcd319b1e2f" />

---

### 2. `pwm_unit.v` — Núcleo Generador de PWM

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

### 3. `reg_iface.v` — Interfaz de Registro

Este módulo proporciona una interfaz básica para el control y configuración del sistema mediante lectura y escritura de registros. Sus características incluyen:

- Soporte para acceso externo a través de señales de control (`wr_en_i`, `rd_en_i`) y dirección (`addr`).
- Gestión de registros de control (`ctrl`) y de estado (`status`, `status_in`).
- Facilita la comunicación entre una unidad de control (por ejemplo, microprocesador o testbench) y el generador PWM.

Actúa como puente entre el entorno de control y el núcleo funcional del sistema.

---

### 4. `top_pwm_alt.v` — Módulo Top-Level

Este módulo integra los componentes anteriores (`reg_iface` y `pwm_unit`) para conformar el diseño completo. Funciona como la entidad superior del sistema y coordina:

- La recepción de datos desde el exterior mediante la interfaz de registro.
- El paso de parámetros (`duty`, `period`) hacia el generador PWM.
- La salida de la señal PWM final.

Gracias a esta arquitectura, el sistema es fácilmente integrable y reutilizable en distintas plataformas FPGA y entornos de simulación.

---

### 5. Señales de Entrada y Salida

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

### 6. Módulos del Sistema

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
El módulo pwm_unit genera una señal PWM basada en dos parámetros: el período
(duración total del ciclo) y el ciclo de trabajo (porción del ciclo en que la señal está
en alto).

#### Funciones clave
- Lógica del contador: El módulo pwm_unit genera una señal PWM basada en dos parámetros: el período
(duración total del ciclo) y el ciclo de trabajo (porción del ciclo en que la señal está
en alto).
- Salida PWM: La salida pwm_o está en alto (1) cuando el contador es menor
que cfg_duty, y en bajo (0) en caso contrario. Esto genera un pulso cuya
duración depende de cfg_duty en relación con cfg_period.

#### Cómo funciona

Supongamos un reloj digital configurado para completar un período en 100 ciclos (cfg_period = 100). En este escenario, el parámetro cfg_duty define el ciclo de trabajo de la señal, es decir, cuántos de esos 100 ciclos la señal permanece en estado alto. Por ejemplo, si cfg_duty = 25, la señal estará activa (en alto) durante los primeros 25 ciclos y luego inactiva (en bajo) durante los 75 ciclos restantes. Esto equivale a un ciclo de trabajo del 25%, lo que significa que la señal está encendida únicamente el 25% del tiempo total del período.

Este comportamiento corresponde a una señal PWM (modulación por ancho de pulso), muy utilizada en electrónica digital para controlar la potencia entregada a dispositivos como motores, LEDs o sistemas de calefacción. Aunque la señal es completamente digital (alta o baja), al variar el valor de cfg_duty se puede ajustar de forma precisa la cantidad de energía promedio entregada. Cuanto mayor sea el valor del ciclo de trabajo, más tiempo permanece la señal en alto dentro de cada período, y por tanto, mayor es la potencia transferida al dispositivo.

### Módulo reg_iface: Interfaz de registros

```
module reg_iface (
2 clk_i, rst_ni, addr_i, wr_data_i, rd_data_o, wr_en_i, rd_en_i,
3 ctrl_o, status_in_i, status_o
4 );
5 parameter AW = 8;
6 parameter DW = 32;
7
8 input clk_i;
9 input rst_ni;
10 input [AW-1:0] addr_i;
11 input [DW-1:0] wr_data_i;
12 output [DW-1:0] rd_data_o;
13 input wr_en_i;
14 input rd_en_i;
4
15 output [DW-1:0] ctrl_o;
16 input [DW-1:0] status_in_i;
17 output [DW-1:0] status_o;
18
19 localparam [AW-1:0] CTRL_ADDR = 8’h00;
20 localparam [AW-1:0] STATUS_ADDR = 8’h04;
21
22 reg [DW-1:0] ctrl_reg;
23 reg [DW-1:0] status_reg;
24 reg [DW-1:0] rd_data_reg;
25
26 // Escritura y actualización de estado
27 always @(posedge clk_i or negedge rst_ni) begin
28 if (!rst_ni) begin
29 ctrl_reg <= {DW{1’b0}};
30 status_reg <= {DW{1’b0}};
31 end else begin
32 status_reg <= status_in_i;
33 if (wr_en_i) begin
34 case (addr_i)
35 CTRL_ADDR: ctrl_reg <= wr_data_i;
36 default: /* noop */ ;
37 endcase
38 end
39 end
40 end
41
42 // Lectura
43 always @(*) begin
44 if (rd_en_i) begin
45 case (addr_i)
46 CTRL_ADDR: rd_data_reg = ctrl_reg;
47 STATUS_ADDR: rd_data_reg = status_reg;
48 default: rd_data_reg = {DW{1’b0}};
49 endcase
50 end else begin
51 rd_data_reg = {DW{1’b0}};
52 end
53 end
54
55 assign ctrl_o = ctrl_reg;
56 assign status_o = status_reg;
57 assign rd_data_o = rd_data_reg;
58
59 endmodule
```
El módulo reg_iface proporciona una interfaz basada en registros para leer y
escribir datos de control y estado.

#### Funciones clave
- Escritura: Cuando wr_en_i está en alto, los datos en wr_data_i se escriben en ctrl_reg si addr_i es CTRL_ADDR (0x00).
- Lectura: Cuando rd_en_i está en alto, rd_data_o devuelve ctrl_reg (si
addr_i = 0x00) o status_reg (si addr_i = 0x04).
- Actualización de Estado: status_reg se actualiza continuamente con status_in_i.
- Reinicio: Al activar el reinicio (rst_ni en bajo), ctrl_reg y status_reg
se ponen a 0.

#### Cómo funciona
Imagina que reg_iface funciona como un archivador digital que contiene dos carpetas principales: una carpeta de control ubicada en la dirección 0x00 y una carpeta de estado ubicada en la dirección 0x04. La carpeta de control es donde el sistema permite escribir configuraciones nuevas, como parámetros de operación o comandos de activación. También es posible leer su contenido para verificar qué configuraciones han sido establecidas previamente. Esta carpeta actúa como el punto de entrada para que el usuario o el sistema modifiquen el comportamiento del módulo.

Por otro lado, la carpeta de estado representa información que proviene de una fuente externa al usuario, como sensores o señales del entorno, y se actualiza de forma automática. Esta carpeta no puede ser modificada directamente, pero su contenido puede leerse para conocer el estado actual del sistema. De este modo, reg_iface permite una separación clara entre las acciones de control (escritura y lectura de configuraciones) y la supervisión del sistema (lectura del estado), facilitando la interacción con el hardware de forma estructurada y segura.

### Módulo top_pwm_alt: Integración del sistema

```
module top_pwm_alt (
2 clk_i, rst_ni, addr_i, wr_data_i, rd_data_o, wr_en_i, rd_en_i,
pwm_out_o
3 );
4 parameter AW = 8;
5 parameter DW = 32;
6 parameter WIDTH_PERIOD = 16;
6
7 parameter WIDTH_DUTY = 16;
8
9 input clk_i;
10 input rst_ni;
11 input [AW-1:0] addr_i;
12 input [DW-1:0] wr_data_i;
13 output [DW-1:0] rd_data_o;
14 input wr_en_i;
15 input rd_en_i;
16 output pwm_out_o;
17
18 wire [DW-1:0] ctrl_reg;
19 wire [DW-1:0] status_in;
20 wire [DW-1:0] status_reg;
21
22 wire [WIDTH_PERIOD-1:0] period_ch0;
23 wire [WIDTH_DUTY-1:0] duty_ch0;
24
25 assign period_ch0 = ctrl_reg[DW-1:WIDTH_DUTY];
26 assign duty_ch0 = ctrl_reg[WIDTH_DUTY-1:0];
27
28 wire error_flag = (duty_ch0 > period_ch0);
29 assign status_in = {{DW-1{1’b0}}, error_flag};
30
31 reg_iface reg_unit (
32 .clk_i(clk_i),
33 .rst_ni(rst_ni),
34 .addr_i(addr_i),
35 .wr_data_i(wr_data_i),
36 .rd_data_o(rd_data_o),
37 .wr_en_i(wr_en_i),
38 .rd_en_i(rd_en_i),
39 .ctrl_o(ctrl_reg),
40 .status_in_i(status_in),
41 .status_o(status_reg)
42 );
43
44 pwm_unit pwm_core_inst (
45 .clk_i(clk_i),
46 .rst_ni(rst_ni),
47 .cfg_period(period_ch0),
48 .cfg_duty(duty_ch0),
49 .pwm_o(pwm_out_o)
50 );
51
52 endmodule
```

El módulo top_pwm_alt conecta reg_iface y pwm_unit para formar un sistema
PWM completo.

#### Funciones clave
- Mapeo de Registros a PWM: El registro ctrl_reg de 32 bits se divide en
period_ch0 (16 bits superiores) y duty_ch0 (16 bits inferiores) para el módulo PWM.
- Detección de Errores: Establece error_flag si duty_ch0 es mayor que
period_ch0, y lo almacena en status_in.
- Integración: Conecta las salidas de reg_iface a las entradas de pwm_unit,
permitiendo configurar la señal PWM mediante escrituras en registros.

#### Cómo funciona

El módulo top_pwm_alt cumple la función de intermediario o puente entre la interfaz de configuración (reg_iface) y la unidad generadora de la señal (pwm_unit). A través de reg_iface, se escriben los valores deseados para el período (cfg_period) y el ciclo de trabajo (cfg_duty) en el registro de control. Estos valores son luego transmitidos internamente a pwm_unit, que se encarga de generar la señal PWM correspondiente, modulando su salida según los parámetros recibidos.

Una característica importante de este diseño es que incorpora una verificación automática de validez en los parámetros configurados. Si el valor asignado al ciclo de trabajo excede el valor del período —lo cual representa una condición inválida en el contexto de señales PWM— el sistema detecta este error de forma inmediata. Como respuesta, se activa una bandera de error en el registro de estado, accesible para el usuario mediante lectura. Esta funcionalidad permite detectar configuraciones erróneas sin comprometer el funcionamiento del sistema, mejorando así su robustez y facilidad de depuración.



