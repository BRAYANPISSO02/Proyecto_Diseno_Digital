# Testbenches – Verificación del Módulo PWM

Este directorio contiene los bancos de prueba (testbenches) utilizados para verificar funcionalmente los módulos del sistema generador de señal PWM implementado en Verilog HDL.

---

## Objetivo

Verificar el comportamiento funcional de:

- `pwm_unit.v` (generador PWM)
- `reg_iface.v` (interfaz de registros)
- `top_pwm_alt.v` (sistema completo)

---

## Justificación del diseño de testbenches

Los testbenches incluidos en este proyecto fueron seleccionados para cubrir de manera progresiva y estructurada los aspectos más relevantes del sistema PWM. Se organizaron de forma modular para facilitar pruebas unitarias e integración total.

- `tb_pwm_unit.v`: permite validar de forma aislada el núcleo funcional más crítico: la generación de la señal PWM. Esta prueba verifica que la señal `pwm_o` se modula correctamente según los valores de `period` y `duty`, sin depender de una interfaz externa.

- `tb_reg_iface.v`: enfocado en validar el acceso por registros, imitando el comportamiento de un microprocesador al interactuar con el periférico. Asegura que las configuraciones se cargan correctamente y que el sistema responde a lecturas y escrituras, así como a condiciones de reset.

- `tb_top_pwm_alt.v`: integra ambos componentes anteriores en una simulación completa, permitiendo observar el comportamiento conjunto del periférico en condiciones cercanas a uso real. Se incluyen pruebas de escritura secuencial, verificación del `error_flag` y lectura de estado.

Esta estructura modular permite identificar errores específicos en cada componente antes de verificar el sistema global, optimizando el proceso de depuración y validación funcional.


## Archivos incluidos

| Archivo               | Descripción                                                                 |
|-----------------------|-----------------------------------------------------------------------------|
| `tb_pwm_unit.v`       | Prueba unitaria del núcleo PWM. Cambia `cfg_period` y `cfg_duty` para observar la forma de onda. |
| `tb_reg_iface.v`      | Verifica operaciones de lectura/escritura sobre los registros.              |
| `tb_top_pwm_alt.v`    | Simula el sistema completo como si fuera controlado por un microprocesador. |
| `.vcd`                | Archivos de forma de onda para visualización en GTKWave.                   |
| `.vvp`                | Binarios generados por `iverilog` para cada testbench.                     |

---

## Herramientas utilizadas

- **Icarus Verilog (iverilog)** – compilación de testbenches
- **GTKWave** – visualización de formas de onda `.vcd`

---

## Instrucciones de ejecución

Desde la terminal, en el directorio `tb/`, ejecutar:

```bash
# Compilar testbench del sistema completo
iverilog -o tb_top_pwm_alt.vvp tb_top_pwm_alt.v ../rtl/pwm_unit.v ../rtl/reg_iface.v ../rtl/top_pwm_alt.v

# Ejecutar simulación
vvp tb_top_pwm_alt.vvp

# Visualizar resultados
gtkwave tb_top_pwm_alt.vcd

---

## Cómo correr las simulaciones y visualizar los resultados

1. **Compila el testbench junto con los módulos RTL necesarios**  
   (Ejemplo para `tb_top_pwm_alt.v`):

   ```bash
   iverilog -o tb/tb_top_pwm_alt.vvp tb/tb_top_pwm_alt.v ../rtl/pwm_unit.v ../rtl/reg_iface.v ../rtl/top_pwm_alt.v
   ```

## Descripción y funcionamiento de cada testbench

### 1. `tb_pwm_unit.v`

- **Propósito:** Verifica el funcionamiento interno del generador PWM (`pwm_unit`).
- **Funcionamiento:**
  - Genera un reloj y secuencias de reset.
  - Aplica diferentes valores de periodo (`cfg_period`) y ciclo útil (`cfg_duty`).
  - Monitorea la salida PWM para asegurar que responde correctamente a los cambios.
- **Cobertura:**
  - Prueba valores mínimos, máximos y límites.
  - Permite observar la relación entre periodo y duty en la onda de salida.
- **Motivación:**  
    Este banco de pruebas es fundamental para asegurar que el núcleo PWM funciona correctamente antes de ser integrado.

---

### 2. `tb_reg_iface.v`

- **Propósito:** Valida la lógica de la interfaz de registros (`reg_iface`).
- **Funcionamiento:**
  - Simula accesos de lectura y escritura a diferentes registros mediante señales de bus (`addr_i`, `wr_en_i`, `rd_en_i`, etc).
  - Verifica la correcta actualización y recuperación de los valores de control y estado.
- **Cobertura:**
  - Prueba escritura de distintos valores, lectura posterior, y casos borde.
  - Permite verificar protección frente a escrituras fuera de rango, reset, etc.
- **Motivación:**  
    Así se garantiza que el microcontrolador o procesador pueda configurar y leer el periférico de forma robusta.

---

### 3. `tb_top_pwm_alt.v`

- **Propósito:** Valida el funcionamiento global del sistema integrado (`top_pwm_alt`).
- **Funcionamiento:**
  - Simula un entorno de usuario que escribe configuraciones y lee resultados del periférico completo.
  - Cambia el periodo y el duty, prueba casos con duty mayor al periodo, y lee el registro de estado.
  - Observa la salida PWM ante cada configuración.
- **Cobertura:**
  - Pruebas realistas de uso, cambios de parámetros en caliente y monitoreo de flags de error.
- **Motivación:**  
    Permite validar que todos los módulos interactúan correctamente cuando se integran.

---

## Cómo correr las simulaciones y visualizar los resultados

1. **Compila el testbench junto con los módulos RTL necesarios**  
   (Ejemplo para `tb_top_pwm_alt.v`):

   ```bash
   iverilog -o tb/tb_top_pwm_alt.vvp tb/tb_top_pwm_alt.v ../rtl/pwm_unit.v ../rtl/reg_iface.v ../rtl/top_pwm_alt.v
   ```

## Resultados obtenidos
### `tb_reg_iface.vcd` – Lectura y escritura de registros
![WhatsApp Image 2025-07-24 at 2 18 04 PM (1)](https://github.com/user-attachments/assets/fb01aab4-2704-4f95-9002-32f2b54ce0b3)

### `tb_pwm_unit.vcd` – Generación PWM
![WhatsApp Image 2025-07-24 at 2 18 04 PM](https://github.com/user-attachments/assets/8f61afef-4dd3-4f12-874c-e48f63fe6559)

Como se observa, los testbenches permiten:
- Confirmar que `wr_en` y `rd_en` actualizan correctamente los registros.
- Ver que `pwm_o` varía según `cfg_duty` y `cfg_period`.
- Validar el reset y la transición suave de estado.

## Estructura de carpetas

<img width="197" height="194" alt="image" src="https://github.com/user-attachments/assets/df1dccea-5352-441b-9964-d75204f8096d" />

## Diagrama de tiempo

<img width="1280" height="301" alt="image" src="https://github.com/user-attachments/assets/47c791da-c3f2-4696-b63c-0a1d06926a7a" />

## Posibles mejoras futuras
- Automatizar pruebas con scripts (`Makefile` o `bash`)
- Incluir pruebas de límites extremos o casos de error en hardware
- Medir cobertura de simulación
