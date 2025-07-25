# Módulos RTL – Generador PWM

Este directorio contiene los módulos escritos en Verilog HDL que implementan el periférico generador de señal PWM configurable mediante una interfaz de registros. La arquitectura modular permite pruebas unitarias, integración flexible y reutilización en diferentes proyectos digitales.

---

## Archivos incluidos

| Archivo         | Descripción                                                              |
|-----------------|---------------------------------------------------------------------------|
| `reg_iface.v`   | Módulo que implementa la interfaz de registros de control y estado.       |
| `pwm_unit.v`    | Núcleo generador de la señal PWM a partir de `period`, `duty`, `enable`. |
| `top_pwm_alt.v` | Módulo de integración. Conecta los módulos anteriores para formar el periférico completo. |

---

## Interconexión de módulos

```
+-------------+ +-----------+
addr_i ---> | | | |
wr_data_i ->| reg_iface.v |-----> | pwm_unit |
wr_en_i --->| | | |---> pwm_o
rd_en_i --->| | | |
+-------------+ +-----------+
```

`top_pwm_alt.v` instancia `reg_iface.v` y `pwm_unit.v`, conectando el bus de control con el generador PWM.

---

## Puertos del módulo principal (`top_pwm_alt.v`)

| Señal       | Dirección | Descripción                             |
|-------------|-----------|-----------------------------------------|
| `clk_i`     | Entrada   | Señal de reloj                          |
| `rst_ni`    | Entrada   | Reset asincrónico, activo en bajo       |
| `addr_i`    | Entrada   | Dirección del registro                  |
| `wr_data_i` | Entrada   | Dato a escribir                         |
| `wr_en_i`   | Entrada   | Habilitación de escritura               |
| `rd_en_i`   | Entrada   | Habilitación de lectura                 |
| `rd_data_o` | Salida    | Dato leído desde el registro            |
| `pwm_o`     | Salida    | Señal PWM generada                      |

---

## Mapeo de registros (`reg_iface.v`)

| Dirección (`addr_i`) | Registro | Función                             |
|----------------------|----------|-------------------------------------|
| `0x0`                | period   | Duración del ciclo PWM              |
| `0x1`                | duty     | Ciclo útil de la señal              |
| `0x2`                | enable   | Habilitación del PWM (`1` = ON)     |

---

## Convenciones de diseño

- El reset global (`rst_ni`) es **activo en bajo**.
- Todas las operaciones de lectura/escritura se realizan sobre flancos de subida de `clk_i`.
- La salida `pwm_o` permanece en bajo cuando `enable = 0` o `duty = 0`.

---

## Consideraciones

- El diseño puede escalarse fácilmente para incluir nuevas funcionalidades (e.g. interrupciones, dead-time, múltiples canales).
- Compatible con buses simples de 1 ciclo para integración en SoCs o microcontroladores soft.

---

## Referencias

- [README general del proyecto PWM](../README.md)
- [README de Testbenches](../tb/README.md)
- Icarus Verilog: https://steveicarus.github.io/iverilog/
- GTKWave: http://gtkwave.sourceforge.net/
