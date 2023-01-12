# Easter-Island-Cooperation-Simulation
Multi-Agent Simulation of Easter Islanders to Study Emergence of Cooperation on the Island

## Table of Contents

* [Supporting Documentation](https://github.com/colinmichaellynch/Easter-Island-Cooperation-Simulation/blob/main/Environmental%20stochasticity%20and%20resource%20heterogeneity%20may%20have%20driven%20the%20evolution%20of%20cooperation%20on%20Rapa%20Nui%20.docx)

* [Create Random Rainfall](https://github.com/colinmichaellynch/Easter-Island-Cooperation-Simulation/blob/main/random_to_periodic_2.R)

* [Simulation Code](https://github.com/colinmichaellynch/Easter-Island-Cooperation-Simulation/blob/main/evo_coop_periodic_rainfall_v3.nlogo)

* [Simulation Data](https://github.com/colinmichaellynch/Easter-Island-Cooperation-Simulation/blob/main/finalSims.csv)

* [Data Analysis](https://github.com/colinmichaellynch/Easter-Island-Cooperation-Simulation/blob/main/final_analysis.R)

## Background

Contrary to popular believe, the people of Rapa Nui (Easter Island) maintained a stable relationship with their environment before European colonization. However, other similar islands were not so fortunate, having been abandoned after constant warfare. What made Rapa Nui different? One clue could be that the weather on Easter Island is not seasonal, its random. This could have forced islanders to cooperate through bet-hedging, saving their resources rather than 'cheating' by exploiting all possible resources. In a random environment, cheaters would not be able to predict when the next harvest would come. Here, I use a multi-agent simulation to test this hypothesis by creating a population of cooperators (who bet hedge) and cheaters (who consume everything) who exist in an environment that could have either be random or periodic rainfall, which determines when energy will be available. In these simulations, cooperators and cheaters reproduce when they get enough energy from the environment, or die off if their energy levels reach 0. I then determine if cooperators are more likely to subsist in random environments relative to cheaters. 

## Methods

* Randomness of rainfall
  - In the virtual island, it is either raining or not raining. 
  - I define a process in which the parameter P continuously controlls how periodic rainfall is. P = 0 = random, P = 1 = periodic. 
  - P is a free parameter of the model. 
  - In the following figure, the x-axis is time, and the y-axis shows whether it is raining (1) or not raining (0). Each panel shows a different level of P.

<p align="center">
  <img width="600" height="400" src=/Images/periodicRainfall.png>
</p>

* Multi-Agent Simulation
  - Agents can exist in a 2-dimensional grid
  - Each grid square can have some energy available for gathering
  - A patch is a section of the grid which has food on it, it is separated by black grid squares which will never have food
  - Food can only increase when its raining
  - Cooperators will only eat a fraction of the food
  - Non-Cooperators will eat all available food
  - Agents can reproduce if they have a high enough energy level 
  - Cooperators beget cooperators and non-cooperators beget non-cooperators
  - Agents die if they run out of energy 
  - In the following figure, the grid represents the world the agents (humanoid figures) can inhabit. Red figures are cheaters, and blue ones are cooperators. Green represents land that agents can forage food from, brown is land that needs rain to grow food, and black represents ground that will never have food. 

<p align="center">
  <img width="500" height="500" src=/Images/simulatedWorld.png>
</p>

* Data collection/analysis 
  - At the end of every simulation, I find the number of cooperators / the number of non-cooperators. This is the cooperator ratio 
  - I simulate over all combinations of free parameters, which include P, how patchy the virtual world is, etc. 
  - I use a GLM to measure the effect of each free parameter on the cooperator ratio 
  
## Results

* Overall, non-cooperators survive more often than cooperators, and the randomness of rainfall does not effect the cooperator ratio
* However, when the environment is patchy AND rainfall is random, then cooperators start to dominate non-cooperators 
* In the following figure, A) shows the relationship between cooperator ratio (y-axis) and P (x-axis) across the entire parameter space. B) Shows this relationship when the land is also very patchy. 

<p align="center">
  <img src=/Images/cooperatorRatio.png>
</p>

* Resources are also scattered in patches on Rapa Nui. Most farming occurs around discrete wells that line the coast, which validates the simulation 
* The evolution of cooperation could have been supported by the randomness of rainfall. 

## Acknowledgements

I would like to thank my collaborators Dr. Terry Hunt and Dr. Carl Lipo for creating the project idea and for introducing me to archaeology. I would also like to thank my other collaborator Michaela Starkey for her advice on producing and analyzing the simulation. 
