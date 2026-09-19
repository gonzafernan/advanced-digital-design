"""
@title GP01 Exercise 1 testbench implementation.
@author Gonzalo G. Fernandez
@date 10-09-2026
@version Advance Digital Design - GP01
"""

import cocotb
from cocotb.triggers import Timer
from enum import Enum


class Operation(Enum):
    ADDITION = 0
    SUBTRACTION = 1
    AND = 2
    OR = 3


async def apply_inputs(dut, operation: Operation, value1: int, value2: int) -> None:
    dut.i_dataA.value = value1
    dut.i_dataB.value = value2
    dut.i_sel.value = operation.value
    await Timer(1, unit="ns")


async def get_dut_result_signed(
    dut, operation: Operation, value1: int, value2: int
) -> int:
    await apply_inputs(dut, operation, value1, value2)
    return dut.o_dataC.value.to_signed()


async def get_dut_result_unsigned(
    dut, operation: Operation, value1: int, value2: int
) -> int:
    await apply_inputs(dut, operation, value1, value2)
    return dut.o_dataC.value.to_unsigned()


@cocotb.test
async def test_addition(dut):
    assert await get_dut_result_signed(dut, Operation.ADDITION, 5, 3) == 8
    assert await get_dut_result_signed(dut, Operation.ADDITION, 0, 0) == 0
    assert await get_dut_result_signed(dut, Operation.ADDITION, -5, 3) == -2
    assert await get_dut_result_signed(dut, Operation.ADDITION, -1, 1) == 0
    assert await get_dut_result_signed(dut, Operation.ADDITION, 32767, 1) == -32768
    assert await get_dut_result_signed(dut, Operation.ADDITION, -32768, -1) == 32767


@cocotb.test
async def test_subtraction(dut):
    assert await get_dut_result_signed(dut, Operation.SUBTRACTION, 5, 3) == 2
    assert await get_dut_result_signed(dut, Operation.SUBTRACTION, 3, 9) == -6
    assert await get_dut_result_signed(dut, Operation.SUBTRACTION, 7, 7) == 0
    assert await get_dut_result_signed(dut, Operation.SUBTRACTION, 0, -32768) == -32768
    assert await get_dut_result_signed(dut, Operation.SUBTRACTION, -32768, 1) == 32767


@cocotb.test
async def test_bitwise_and(dut):
    def and_(a, b):
        return get_dut_result_unsigned(dut, Operation.AND, a, b)

    assert (
        await and_(0b0000_0000_0000_0011, 0b0000_0000_0000_1001)
        == 0b0000_0000_0000_0001
    )
    assert (
        await and_(0b1111_1111_1111_1111, 0b0000_0100_1101_0010)
        == 0b0000_0100_1101_0010
    )
    assert (
        await and_(0b0000_0000_0000_0000, 0b1111_1111_1111_1111)
        == 0b0000_0000_0000_0000
    )
    assert (
        await and_(0b0101_0101_0101_0101, 0b1010_1010_1010_1010)
        == 0b0000_0000_0000_0000
    )
    assert (
        await and_(0b1000_0000_0000_0000, 0b1111_1111_1111_1111)
        == 0b1000_0000_0000_0000
    )


@cocotb.test
async def test_bitwise_or(dut):
    def or_(a, b):
        return get_dut_result_unsigned(dut, Operation.OR, a, b)

    assert (
        await or_(0b0000_0000_0000_0011, 0b0000_0000_0000_1001) == 0b0000_0000_0000_1011
    )
    assert (
        await or_(0b0000_0000_0000_0000, 0b0000_0100_1101_0010) == 0b0000_0100_1101_0010
    )
    assert (
        await or_(0b1111_1111_1111_1111, 0b0000_0100_1101_0010) == 0b1111_1111_1111_1111
    )
    assert (
        await or_(0b0101_0101_0101_0101, 0b1010_1010_1010_1010) == 0b1111_1111_1111_1111
    )
    assert (
        await or_(0b1000_0000_0000_0000, 0b0000_0000_0000_0001) == 0b1000_0000_0000_0001
    )
