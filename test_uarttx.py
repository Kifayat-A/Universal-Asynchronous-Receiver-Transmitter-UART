import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, FallingEdge
from cocotb.regression import TestFactory
import random

async def reset(dut):
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst_n.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    cocotb.log.info("Reset completed.")


async def tx(dut,data):
    dut.data_in.value = data
    dut.send.value = 1
    await RisingEdge(dut.bd_clk_out)
    dut.send.value = 0
    await FallingEdge(dut.active)

#@cocotb.test()
async def test_uart_tx(dut):
    cocotb.start_soon(Clock(dut.clk, 20, units='ns').start())
    await reset(dut)
    dut.parity_type.value = 1
    dut.baud_rate.value = 3
    await RisingEdge(dut.bd_clk_out)
    await tx(dut,0xAB)
    await tx(dut,0x0F)
    await tx(dut,0x11)
    await Timer(150000,"ns")
    await tx(dut,0x15)
    await Timer(1000,"ns")

async def write_fifo(dut):
    dut.data_in.value = random.randint(0,0xFF)
    dut.wr_en.value = 1
    await RisingEdge(dut.clk)
    dut.wr_en.value = 0

@cocotb.test()
async def test_uart_tx_with_txfifo(dut):
    cocotb.start_soon(Clock(dut.clk, 20, units='ns').start())
    await reset(dut)
    dut.parity_type.value = 1
    dut.baud_rate.value = 3
    for i in range(5):
        await write_fifo(dut)
    await RisingEdge(dut.bd_clk_out)
    #await FallingEdge(dut.bd_clk_out)
    #dut.send.value = 0
    #await RisingEdge(dut.active)
    #await FallingEdge(dut.active)
    
    await Timer(1000,"us")
    await Timer(1000,"us")
    await Timer(1000,"us")
    await Timer(1000,"us")
    await Timer(1000,"us")


