import cocotb
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def demo_pwm_driver(dut):
    # Inicializa
    dut.reset_n.value = 0
    dut.addr.value = 0
    dut.wdata.value = 0
    dut.wen.value = 0
    dut.ren.value = 0

    # Espera unos ciclos
    for _ in range(5):
        await RisingEdge(dut.clk)
    dut.reset_n.value = 1

    period = 100
    # Recorre duty del 0 al 100 en pasos de 20
    for duty in range(0, period+1, 20):
        # Escribe periodo y duty
        dut.addr.value = 0
        dut.wdata.value = (period << 16) | duty
        dut.wen.value = 1
        await RisingEdge(dut.clk)
        dut.wen.value = 0

        # Espera para ver el efecto
        for _ in range(30):
            await RisingEdge(dut.clk)

        # Lee status
        dut.addr.value = 4
        dut.ren.value = 1
        await RisingEdge(dut.clk)
        print(f"DUTY: {duty}, STATUS: {dut.rdata.value.integer:08x}")
        dut.ren.value = 0

        await Timer(50, units='ns')
