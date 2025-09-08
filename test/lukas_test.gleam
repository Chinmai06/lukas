// test/lukas_test.gleam
import actors
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// Test the mathematical functions
pub fn perfect_square_test() {
  // Test known perfect squares
  actors.is_perfect_square(0) |> should.be_true()
  actors.is_perfect_square(1) |> should.be_true()
  actors.is_perfect_square(4) |> should.be_true()
  actors.is_perfect_square(9) |> should.be_true()
  actors.is_perfect_square(16) |> should.be_true()
  actors.is_perfect_square(25) |> should.be_true()

  // Test non-perfect squares
  actors.is_perfect_square(2) |> should.be_false()
  actors.is_perfect_square(3) |> should.be_false()
  actors.is_perfect_square(5) |> should.be_false()
  actors.is_perfect_square(8) |> should.be_false()
}

pub fn consecutive_squares_test() {
  // Test the classic Pythagorean example: 3² + 4² = 5²
  let solutions_2 = actors.find_consecutive_square_sums(1, 10, 2)
  // Check if 3 is in the list
  let has_solution_3 = list_contains(solutions_2, 3)
  has_solution_3 |> should.be_true()

  // Test Lucas' Square Pyramid: 1² + 2² + ... + 24² = 70²
  let solutions_24 = actors.find_consecutive_square_sums(1, 5, 24)
  // Check if 1 is in the list
  let has_solution_1 = list_contains(solutions_24, 1)
  has_solution_1 |> should.be_true()
}

pub fn small_problem_test() {
  // Test the example: lukas 3 2 should find 3
  let result = actors.solve_parallel(3, 2, 2, 1)
  let has_three = list_contains(result.solutions, 3)
  has_three |> should.be_true()
}

pub fn medium_problem_test() {
  // Test the example: lukas 40 24 should find 1
  let result = actors.solve_parallel(40, 24, 4, 10)
  let has_one = list_contains(result.solutions, 1)
  has_one |> should.be_true()
}

// Helper function to check if list contains an element
fn list_contains(list: List(Int), element: Int) -> Bool {
  case list {
    [] -> False
    [head, ..tail] ->
      case head == element {
        True -> True
        False -> list_contains(tail, element)
      }
  }
}


