// src/lukas.gleam
import actors
import argv
import gleam/float
import gleam/int
import gleam/io
import gleam/list

// Parse command line arguments properly
fn parse_and_run() -> Nil {
  case argv.load().arguments {
    [n_str, k_str] -> {
      case int.parse(n_str), int.parse(k_str) {
        Ok(n), Ok(k) -> {
          case n > 0, k > 0 {
            True, True -> {
              run_single_case(n, k)
            }
            _, _ -> {
              io.println("Error: N and k must be positive integers")
              print_usage()
            }
          }
        }
        Error(_), _ -> {
          io.println("Error: Invalid number format for N: " <> n_str)
          print_usage()
        }
        _, Error(_) -> {
          io.println("Error: Invalid number format for k: " <> k_str)
          print_usage()
        }
      }
    }
    [] -> {
      // No arguments - run test cases
      run_test_cases()
    }
    [_] -> {
      io.println("Error: Missing second argument")
      print_usage()
    }
    _ -> {
      io.println("Error: Too many arguments")
      print_usage()
    }
  }
}

fn print_usage() -> Nil {
  io.println("")
  io.println("Usage:")
  io.println("  gleam run N k")
  io.println(
    "  where N = maximum starting point, k = number of consecutive squares",
  )
  io.println("")
  io.println("Examples:")
  io.println("  gleam run 3 2")
  io.println("  gleam run 40 24")
  io.println("  gleam run 1000000 4")
  io.println("")
  io.println("Run without arguments to see all test cases.")
}

fn run_single_case(n: Int, k: Int) -> Nil {
  let num_workers = 4
  let work_unit_size = actors.calculate_work_unit_size(n, num_workers)

  io.println(
    "Lucas Square Problem: N=" <> int.to_string(n) <> ", k=" <> int.to_string(k),
  )
  io.println(
    "Using "
    <> int.to_string(num_workers)
    <> " workers, work unit size="
    <> int.to_string(work_unit_size),
  )
  io.println("")

  let result = actors.solve_parallel(n, k, num_workers, work_unit_size)

  // Print only the solutions (as required by assignment)
  case result.solutions {
    [] -> Nil
    // No output if no solutions
    solutions -> {
      list.each(solutions, fn(sol) { io.println(int.to_string(sol)) })
    }
  }

  // Print performance stats
  let real_time_sec = int.to_float(result.real_time_ms) /. 1000.0
  io.println("")
  io.println("Performance:")
  io.println(
    "Real time: "
    <> int.to_string(result.real_time_ms)
    <> " ms ("
    <> float.to_string(real_time_sec)
    <> " seconds)",
  )
  io.println("CPU/Real time ratio: " <> float.to_string(result.cpu_time_ratio))
}

fn run_test_cases() -> Nil {
  io.println("LUCAS SQUARE PROBLEM SOLVER")
  io.println("Using Actor Model for Parallel Computation")
  io.println("==========================================\n")
  io.println("Running all test cases...\n")

  // Test case 1
  io.println("=== Test Case 1: lukas 3 2 ===")
  run_single_case(3, 2)
  io.println("")

  // Test case 2  
  io.println("=== Test Case 2: lukas 40 24 ===")
  run_single_case(40, 24)
  io.println("")

  // Test case 3
  io.println("=== Test Case 3: lukas 1000000 4 ===")
  run_single_case(1_000_000, 4)

  io.println("")
  io.println("All test cases completed!")
  print_usage()
}

// Main entry point
pub fn main() {
  parse_and_run()
}
