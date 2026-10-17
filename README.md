# 🚦 Traffic Light Controller — Verilog-Based FSM

[![Verilog](https://img.shields.io/badge/HDL-Verilog--2001-blue?style=flat-square&logo=v)](https://en.wikipedia.org/wiki/Verilog)
[![Quartus Prime](https://img.shields.io/badge/Tool-Quartus%20Prime-orange?style=flat-square)](https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/overview.html)
[![ModelSim](https://img.shields.io/badge/Simulation-ModelSim-green?style=flat-square)](https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/modelsim.html)
[![FPGA](https://img.shields.io/badge/Target-Intel%20FPGA-0078D7?style=flat-square)](https://www.intel.com/content/www/us/en/products/programmable.html)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

A fully synthesizable **3-state Traffic Light Controller** implemented as a **Finite State Machine (FSM)** in Verilog-2001. Designed, simulated, and compiled using **Intel Quartus Prime** and **ModelSim**, targeting an Intel FPGA device.

---

## 📋 Table of Contents

- [Overview](#-overview)
- [FSM State Diagram](#-fsm-state-diagram)
- [Project Structure](#-project-structure)
- [Module Description](#-module-description)
- [Testbench](#-testbench)
- [Simulation Waveforms](#-simulation-waveforms)
- [Screenshots](#-screenshots)
- [Tools Used](#-tools-used)
- [How to Run](#-how-to-run)
- [Pin Assignment](#-pin-assignment)
- [Author](#-author)

---

## 🔍 Overview

This project implements a **Traffic Light Controller** using a synchronous **Moore FSM** in Verilog. The controller cycles through three states — **RED → YELLOW → GREEN → RED** — driven by a clock signal, with an active-low reset.

| Signal   | Direction | Description                         |
|----------|-----------|-------------------------------------|
| `clk`    | Input     | System clock (100 MHz)              |
| `rst_n`  | Input     | Active-low reset (forces RED state) |
| `red`    | Output    | RED light output (one-hot)          |
| `yellow` | Output    | YELLOW light output (one-hot)       |
| `green`  | Output    | GREEN light output (one-hot)        |

---

## 🔄 FSM State Diagram

```
         reset
           │
           ▼
        ┌──────┐
  ┌────►│  RED  │◄─────┐
  │     └──────┘       │
  │         │           │
  │         ▼           │
  │    ┌────────┐       │
  │    │ YELLOW │       │
  │    └────────┘       │
  │         │           │
  │         ▼           │
  │     ┌───────┐       │
  └─────│ GREEN │───────┘
        └───────┘
```

| Current State | Next State | Active Output |
|---------------|------------|---------------|
| RED (00)      | YELLOW     | `red = 1`     |
| YELLOW (01)   | GREEN      | `yellow = 1`  |
| GREEN (10)    | RED        | `green = 1`   |

---

## 📁 Project Structure

```
traffic_light/
│
├── traffic_light.v              # Main RTL source — FSM implementation
├── traffic_light_tb.v           # Testbench for functional simulation
├── traffic_light.qpf            # Quartus Prime Project File
├── traffic_light.qsf            # Quartus Settings File (pin assignments)
├── traffic_light.qws            # Quartus Workspace state
├── traffic_light_nativelink_simulation.rpt  # Simulation report
├── c5_pin_model_dump.txt        # Cyclone V pin model dump
├── README.md                    # This file
│
├── image/                       # 📸 Screenshots & diagrams
│   ├── Compilation  Fitter Summary Report.png
│   ├── Detailed Routing View  LAB Interconnect View.png
│   ├── Floorplan & Placement View.png
│   ├── Functional Simulation Waveform.png
│   ├── Package Pin-Out View  Wire Bond Top View.png
│   ├── RTL Schematic  Gate-Level Netlist View.png
│   ├── State Machine Diagram  FSM Bubble Diagram.png
│   ├── Technology Map Netlist View  Post-Mapping Schematic.png
│   └── Top-Level RTL Block Diagram  RTL Entity View.png
│
├── output_files/                # Quartus compilation output
│   ├── traffic_light.sof        # FPGA programming bitstream
│   ├── traffic_light.fit.rpt    # Fitter report
│   ├── traffic_light.map.rpt    # Mapping report
│   ├── traffic_light.sta.rpt    # Timing analysis report
│   └── ...
│
├── simulation/modelsim/         # ModelSim simulation files
├── db/                          # Quartus internal database
├── incremental_db/              # Incremental compilation database
└── work/                        # ModelSim work library
```

---

## 📄 Module Description

### `traffic_light.v`

```verilog
module traffic_light (
    input  wire clk,
    input  wire rst_n,   // active-low reset
    output reg  red,
    output reg  yellow,
    output reg  green
);
```

**Key Design Decisions:**
- **State Encoding:** 2-bit binary (`2'b00` = RED, `2'b01` = YELLOW, `2'b10` = GREEN)
- **Reset Behavior:** Active-low asynchronous reset — forces state to `RED` immediately
- **Output Logic:** Combinational (Moore-style), one-hot encoded outputs
- **Compatibility:** Verilog-2001 compliant — works with Quartus, ModelSim, Vivado, and Icarus Verilog

---

## 🧪 Testbench

### `traffic_light_tb.v`

The testbench verifies the full state transition sequence:

1. **Clock:** 10 ns period (100 MHz)
2. **Reset Phase:** `rst_n` held LOW for 20 ns — confirms reset state is `RED`
3. **Stimulus:** Clock runs for 200 ns (20 cycles) — observes complete state transitions
4. **VCD Dump:** Optional waveform dump via `` `ifdef VCD `` preprocessor flag

**Expected Simulation Output:**
```
Time 0:  rst_n=0 → red=1, yellow=0, green=0  (RESET / RED state)
Time 20: rst_n=1 → transitions begin
Time 30: red=0, yellow=1, green=0             (YELLOW state)
Time 40: red=0, yellow=0, green=1             (GREEN state)
Time 50: red=1, yellow=0, green=0             (RED — cycle repeats)
...
Testbench finished at time 220000
```

---

## 📊 Simulation Waveforms

Functional simulation captured in ModelSim confirming correct FSM transitions:

![Functional Simulation Waveform](image/Functional%20Simulation%20Waveform.png)

---

## 🖼️ Screenshots

### RTL Schematic (Gate-Level Netlist View)
![RTL Schematic](image/RTL%20Schematic%20%20Gate-Level%20Netlist%20View.png)

### State Machine Diagram (FSM Bubble View)
![State Machine Diagram](image/State%20Machine%20Diagram%20%20FSM%20Bubble%20Diagram.png)

### Top-Level RTL Block Diagram
![Top-Level RTL](image/Top-Level%20RTL%20Block%20Diagram%20%20RTL%20Entity%20View.png)

### Floorplan & Placement View
![Floorplan](image/Floorplan%20%26%20Placement%20View.png)

### Technology Map Netlist View (Post-Mapping Schematic)
![Technology Map](image/Technology%20Map%20Netlist%20View%20%20Post-Mapping%20Schematic.png)

### Compilation & Fitter Summary Report
![Compilation Summary](image/Compilation%20%20Fitter%20Summary%20Report.png)

### Package Pin-Out View (Wire Bond Top View)
![Pin-Out View](image/Package%20Pin-Out%20View%20%20Wire%20Bond%20Top%20View.png)

### Detailed Routing View (LAB Interconnect View)
![Routing View](image/Detailed%20Routing%20View%20%20LAB%20Interconnect%20View.png)

---

## 🛠️ Tools Used

| Tool                     | Purpose                              |
|--------------------------|--------------------------------------|
| **Intel Quartus Prime**  | Synthesis, P&R, Timing Analysis      |
| **ModelSim-Intel**       | Functional Simulation                |
| **Verilog-2001**         | Hardware Description Language        |
| **Intel Cyclone V FPGA** | Target synthesis device              |

---

## ▶️ How to Run

### Option 1: ModelSim (CLI)

```bash
# Compile design + testbench
vlog traffic_light.v traffic_light_tb.v

# Run simulation
vsim -c traffic_light_tb -do "run -all; quit"

# With VCD waveform dump
vlog +define+VCD traffic_light.v traffic_light_tb.v
vsim -c traffic_light_tb -do "run -all; quit"
```

### Option 2: Icarus Verilog (open-source, free)

```bash
# Install: sudo apt install iverilog gtkwave

# Compile
iverilog -o traffic_light_sim traffic_light.v traffic_light_tb.v

# Run
vvp traffic_light_sim

# With VCD waveform (open in GTKWave)
iverilog -DVCD -o traffic_light_sim traffic_light.v traffic_light_tb.v
vvp traffic_light_sim
gtkwave traffic_light.vcd
```

### Option 3: Intel Quartus Prime (GUI)

1. Open **Quartus Prime**
2. `File → Open Project → traffic_light.qpf`
3. **Compile:** `Processing → Start Compilation` (or `Ctrl+L`)
4. **Simulate:** `Tools → Run Simulation Tool → RTL Simulation`
5. **Program FPGA:** `Tools → Programmer` → select `output_files/traffic_light.sof`

---

## 📌 Pin Assignment

Pin assignments are stored in [`traffic_light.qsf`](traffic_light.qsf). Key I/O mappings:

| Port     | Direction | Description              |
|----------|-----------|--------------------------|
| `clk`    | Input     | Board oscillator clock   |
| `rst_n`  | Input     | Push button (active-low) |
| `red`    | Output    | LED — Red                |
| `yellow` | Output    | LED — Yellow/Amber       |
| `green`  | Output    | LED — Green              |

> Refer to `output_files/traffic_light.pin` for the complete pin assignment report.

---



## 📜 License

This project is licensed under the **MIT License** — free to use, modify, and distribute with attribution.

---
