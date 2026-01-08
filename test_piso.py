import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, FallingEdge
from cocotb.regression import TestFactory

async def reset(dut):
    dut.rst_n.value = 1
    await RisingEdge(dut.bd_clk)
    await RisingEdge(dut.bd_clk)
    dut.rst_n.value = 0
    await RisingEdge(dut.bd_clk)
    dut.rst_n.value = 1
    cocotb.log.info("Reset completed.")

async def tx(dut,data,parity):
    dut.data_in.value = data
    dut.parity.value = parity
    dut.tx_start.value = 1
    await RisingEdge(dut.bd_clk)
    dut.tx_start.value = 0
    await FallingEdge(dut.active)

#@cocotb.test()
async def test_piso(dut):
    cocotb.start_soon(Clock(dut.bd_clk, 10, units='ns').start())
    await reset(dut)
    await tx(dut,0x0F,0)
    await tx(dut,0xAB,0)
    await tx(dut,0x12,0)


    await Timer(1000,"ns")


@cocotb.test()
async def test_piso(dut):
    cocotb.start_soon(Clock(dut.bd_clk, 10, units='ns').start())
    await reset(dut)
    dut.data_in.value = 0x6
    dut.parity.value = 1
    await RisingEdge(dut.bd_clk)
    await RisingEdge(dut.bd_clk)
    await RisingEdge(dut.bd_clk)
    await RisingEdge(dut.bd_clk)

    dut.tx_start.value = 1
    await RisingEdge(dut.bd_clk)
    dut.tx_start.value = 0
    
    


    await Timer(1000,"ns")