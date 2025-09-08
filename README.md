# UART Transmitter (Verilog)

This project implements a **UART Transmitter** in Verilog using a simple **finite state machine (FSM)** and a **shift register**.  
The design can be used on FPGAs or in simulation to transmit 8-bit serial data over a UART-compatible interface.

---

## 📖 Features
- 8-bit data transmission (LSB first).
- 1 start bit (`0`), 8 data bits, 1 stop bit (`1`).
- Configurable baud rate via external `baud_tick` input.
- `tx_busy` signal indicates when the transmitter is active.
- Clean shift-register based implementation for efficiency and clarity.
- Easily extensible for:
  - Parity bit support
  - Multiple stop bits
  - Data width changes

---

## 🗂️ Module Overview

### Inputs
| Signal     | Width | Description                                |
|------------|-------|--------------------------------------------|
| `clk`      | 1     | System clock                               |
| `rst_n`    | 1     | Active-low reset                           |
| `baud_tick`| 1     | 1-cycle pulse at baud rate (from generator)|
| `tx_data`  | 8     | Data byte to transmit                      |
| `tx_start` | 1     | Start transmission request                 |

### Outputs
| Signal     | Width | Description                                |
|------------|-------|--------------------------------------------|
| `tx_out`   | 1     | UART serial output line                    |
| `tx_busy`  | 1     | High while transmission is in progress     |

---

## 🔧 How It Works
1. **Idle**: Line is held high. If `tx_start` is asserted, the data is latched.
2. **Start Bit**: A `0` is driven for one baud period.
3. **Data Bits**: The byte is shifted out LSB-first, one bit per baud period.
4. **Stop Bit**: A `1` is driven for one baud period.
5. Return to **Idle** and wait for the next byte.

Total frame length = **10 baud ticks** (1 start + 8 data + 1 stop).

---
