# Sums of Consecutive Squares

## Project Overview

This project implements a parallel solution to the Lucas Square Problem using Gleam's actor model. The problem involves finding sequences of consecutive integers whose squares sum to a perfect square.

### Examples

- **Pythagorean Identity**: 3² + 4² = 5² (k=2, starting at 3)
- **Lucas Square Pyramid**: 1² + 2² + ... + 24² = 70² (k=24, starting at 1)

## Implementation Architecture

### Actor Model Design

The implementation uses a **actor model** with the following components:

1. **Worker Actors**: Each worker processes a specific range of starting points
2. **Result Collector**: Aggregates solutions from all workers
3. **Parallel Coordinator**: Manages work distribution and timing
4. **Message Passing**: Workers send results via process communication

## Performance Analysis

### Work Unit Size Determination

The optimal work unit size is calculated using the formula:

```
work_unit_size = N / (num_workers * 2)
```

**Reasoning:**

- Creates 2 work units per worker for good load balancing
- Prevents workers from finishing too quickly (under-utilization)
- Avoids work units that are too large (poor parallelization)
- Includes bounds checking: minimum 1, maximum 50,000

**Determined optimal sizes:**

- Small problems (N ≤ 100): Work unit size = max(1, N/num_workers)
- Medium problems: Work unit size = N/(num_workers * 2)
- Large problems: Work unit size capped at 50,000

### Results for `lukas 1000000 4`

**Command:** `gleam run 1000000 4`

**Results:**

  **Solutions Found**: 0 (no consecutive sequences of 4 squares found up to 1,000,000)
  
```
complied in 0.12s
SOLUTION(S):
No solutions found
```

- **CPU Time / Real Time Ratio**: 3.2
- **Workers Used**: 4
- **Work Units Created**: 200 (1,000,000 / {4 * 2} = 125,000 per unit, capped at 50,000)

### Performance Metrics

**Real Time vs CPU Time Analysis:**

- **Real Time**: 374ms
- **CPU Time Ratio**: 3.2 indicates ~ 3.2 cores effectively utilized

- **Efficiency**: 80% parallel efficiency (3.2/4.0 cores)

### Largest Problem Solved

**Maximum tested configuration:**

- **Problem Size**: N = 1,000,000, k = 4
- **Completion Time**: < 10 seconds
- **Memory Usage**: Minimal (actors process ranges independently)
- **Scalability**: Architecture supports N > 10,000,000 with sufficient time

### Commands to Run

```bash
gleam build
gleam run N K
```

## Implementation Details

### Actor Communication Pattern

1. **Main Process** creates result collector
2. **Work Distribution** creates worker actors for each range
3. **Workers Process** assigned ranges concurrently
4. **Result Collection** aggregates solutions from all workers
5. **Final Output** returns first (smallest) solution found

## Dependencies

```toml
gleam_stdlib = ">= 0.34.0 and < 2.0.0"
gleam_otp = ">= 0.10.0 and < 2.0.0"
gleeunit = ">= 1.0.0 and < 2.0.0"  # For testing
```

## Project Structure

```
lukas/
├── src/
│   ├── lukas.gleam          # Main entry point and CLI
│   └── actors.gleam         # Actor model implementation
├── test/
│   └── lukas_test.gleam     # Unit tests
├── gleam.toml               # Project configuration
└── README.md                # This file
```
