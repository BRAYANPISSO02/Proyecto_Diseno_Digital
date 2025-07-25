# Testbenches de la carpeta `tb`

## Descripción general

Esta carpeta contiene los **testbenches** (bancos de pruebas) para validar y verificar el funcionamiento de los módulos RTL del periférico PWM. Cada testbench simula un escenario diferente (unidad, interfaz de registro y top-level), permitiendo observar la funcionalidad, robustez y posibles errores en condiciones realistas.

---

## Estructura de la carpeta

- **tb_pwm_unit.v**: Testbench para el módulo generador PWM (`pwm_unit`).
- **tb_reg_iface.v**: Testbench para la interfaz de registros (`reg_iface`).
- **tb_top_pwm_alt.v**: Testbench para el módulo top-level integrado (`top_pwm_alt`).

---

## Justificación de la estructura

Se escogió esta estructura modular porque:
- **Facilita el aislamiento de errores**: Permite probar cada módulo de forma individual antes de hacer una integración completa.
- **Acelera el ciclo de desarrollo y depuración**: Puedes verificar cambios en un solo bloque antes de probar todo el sistema.
- **Permite pruebas unitarias y de integración**: Se asegura que cada bloque cumple su función por separado y luego integrado.

---

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
