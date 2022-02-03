module Types 
(
    Row, Column, Charge, Position, Direction,
    Corral, Dirt, Obstacle, Kid, Robot,
    Corrals, Dirts, Kids, Obstacles, Robots
) where

type Row = Int 
type Column = Int
type Charge = Bool 
type Position = (Row, Column)
type Direction = [Char]

type Corral = Position
type Dirt = Position
type Obstacle = Position
type Kid = (Position, Charge)
type Robot = (Position, Charge)

type Corrals = [Position]
type Dirts = [Position]
type Kids = [Kid]
type Obstacles = [Position]
type Robots = [Robot]