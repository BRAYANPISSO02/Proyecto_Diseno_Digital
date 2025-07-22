`timescale 1ns/1ps

module tb_pwm_core;

    // Parámetros igual que el módulo
    localparam WIDTH_PERIOD = 16;
    localparam WIDTH_DUTY   = 16;

    reg clk;
    reg reset_n;
    reg [WIDTH_PERIOD-1:0] period;
    reg [WIDTH_DUTY-1:0] duty;
    wire pwm_out;

    pwm_core #(
        .WIDTH_PERIOD(WIDTH_PERIOD),
        .WIDTH_DUTY(WIDTH_DUTY)
    ) dut (
        .clk(clk),
        .reset_n(reset_n),
        .period(period),
        .duty(duty),
        .pwm_out(pwm_out)
    );

    // Generador de reloj
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset_n = 0;
        period = 10;
        duty = 4;

        // Aplica reset
        #12;
        reset_n = 1;

        // Espera para ver la forma de onda PWM con duty=4/10
        #120;

        // Cambia duty a 7 (PWM ON 7/10 del tiempo)
        duty = 7;
        #100;

        // Cambia el periodo a 16, duty a 8
        period = 16;
        duty = 8;
        #160;

        // Prueba duty=0 y duty=period
        duty = 0; // PWM siempre en 0
        #20;
        duty = 16; // PWM siempre en 1 (period = 16)
        #20;

        $finish;
    end

    // Guardar onda y monitorear
    initial begin
        $dumpfile("tb_pwm_core.vcd");
        $dumpvars(0, tb_pwm_core);
        $display("time\tcounter\tpwm_out");
        // No puedes monitorear el counter directamente desde aquí,
        // pero puedes observar pwm_out y los cambios de duty/period
        $monitor("%g\t%b", $time, pwm_out);
    end

endmodule
