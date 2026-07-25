# Leo Beck
# 2026-07-24

# Pyramid cards monte carlo simulation

# This runs a monte carlo simulation to determine the probability of drawing m unique cards from a pyramid of n cards.
# A pyramid of cards is a triangular arrangement of cards where there is 1 1 card, 2 2 cards, the 3 3 cards, and so on, up to n cards of value n. 
# The total number of cards in a pyramid with n rows is given by the formula: total_cards = n * (n + 1) / 2.


# Import packages
import random
import numpy as np

# Number of unique cards to draw
m = 7
# Size of the pyramid (number of rows)
n = 12

# Optional square (True False)
make_square = False

# Number of simulations
num_simulations = 100000

# Number of cards in the pyramid
total_cards = n * (n + 1) // 2

# Create the pyramid
pyramid = []
for i in range(1, n + 1):
    pyramid.extend([i] * i)

# Function to run the simulation
def run_simulation():
    # Draw m cards from the pyramid
    drawn_cards = random.sample(pyramid, m)
    # Check if all drawn cards are unique
    return len(set(drawn_cards)) == m

# Run the simulations
successes = sum(run_simulation() for _ in range(num_simulations))
# Calculate the probability
probability = successes / num_simulations
print(f"Probability of drawing {m} unique cards from a pyramid of {n} rows: {probability:.4f}")