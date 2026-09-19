import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles, Timer

@cocotb.test()
async def test_comp(dut):
 #clock setting
 clock = Clock(dut.clk,10,units="ns")
 cocotb.start_soon(clock.start())

 #initial reset
 dut.program_in.value = 0b0000_0000
 dut.rst_n.value = 0b0
 dut.start_button.value = 0b0
 dut.program_mem_write_button.value =0b0
 dut.read_result_button.value =0b0

 await ClockCycles(dut.clk, 2)
 dut.rst_n.value =0b1

 #send first command - PUSH_COMP 1001
 dut.program_mem_write_button.value =0b0
 
 await RisingEdge(dut.clk)
 await RisingEdge(dut.clk)
 dut.program_in.value = 0b1101_1001
 await RisingEdge(dut.clk)
 await RisingEdge(dut.clk)
 dut.program_mem_write_button.value =0b1
 await ClockCycles(dut.clk, 7)

 #send second command - PUSH 0001
 dut.program_mem_write_button.value =0b0
 await RisingEdge(dut.clk)
 await RisingEdge(dut.clk)
 dut.program_in.value = 0b1110_0001
 await RisingEdge(dut.clk)
 await RisingEdge(dut.clk)
 dut.program_mem_write_button.value =0b1
 await ClockCycles(dut.clk, 7)

 #send third command - ADD 0001
 dut.program_mem_write_button.value =0b0
 await RisingEdge(dut.clk)
 await RisingEdge(dut.clk)
 dut.program_in.value = 0b1011_0001
 await RisingEdge(dut.clk)
 await RisingEdge(dut.clk)
 dut.program_mem_write_button.value =0b1
 await ClockCycles(dut.clk, 7)
 
 #send forth command - JMPC 0010
 dut.program_mem_write_button.value =0b0
 await RisingEdge(dut.clk)
 await RisingEdge(dut.clk)
 dut.program_in.value = 0b0010_0010
 await RisingEdge(dut.clk)
 await RisingEdge(dut.clk)
 dut.program_mem_write_button.value =0b1
 await ClockCycles(dut.clk, 7)

 #send fifth command - PUSH 0001
 dut.program_mem_write_button.value =0b0
 await RisingEdge(dut.clk)
 await RisingEdge(dut.clk)
 dut.program_in.value = 0b1110_0001
 await RisingEdge(dut.clk)
 await RisingEdge(dut.clk)
 dut.program_mem_write_button.value =0b1
 await ClockCycles(dut.clk, 7)

 #start running
 dut.program_mem_write_button.value =0b0
 dut.start_button.value =0b1
 await ClockCycles(dut.clk, 7)
 dut.start_button.value =0b0

 #read result
 await Timer(2000, units="ns")
 dut.read_result_button.value =0b1
 await ClockCycles(dut.clk, 7)
 dut.read_result_button.value =0b0
 await Timer(100, units="ns")

 #check result 
 assert dut.after_compute.value == 0b0001
