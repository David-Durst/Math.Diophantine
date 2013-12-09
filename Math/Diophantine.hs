-- |
-- Module      : Math.Diophantine
-- Copyright   : Joe Jevnik 2013
--
-- License     : GPL-2
-- Maintainer  : joejev@gmail.org
-- Stability   : stable
-- Portability : GHC
--
-- A module for solving quadratic diophantine equations.

module Math.Diophantine
    (
    -- * Data
      Equation(GeneralEquation) -- instance of: Show
    , Solution(..)              -- instance of: Eq, Show
    , Z
    , SolveError                -- Instance of: Show
    -- * Utilities
    , specializeEquation        -- :: Equation -> Equation
    , toMaybeList               -- :: Solution -> Maybe [(Integer,Integer)]
    , mergeSolutions            -- :: Solution -> Solution -> Solution
    -- * Equation Solving
    , solve                     -- :: Equation -> Solution
    ) where

import Math.Diophantine.Internal

-- -------------------------------------------------------------------------- --
-- data types.

-- | A way to report an error in solving.
data SolveError = SolveError String deriving Show

-- -------------------------------------------------------------------------- --
-- added exported functions.

-- | Extracts the list of solution pairs from a 'Solution'.
toMaybeList :: Solution -> Maybe [(Z,Z)]
toMaybeList (SolutionSet ns) = Just ns
toMaybeList _                = Nothing

-- -------------------------------------------------------------------------- --
-- exported solving functions.

-- | Determines what type of equation to solve for, and then calls the
-- appropriate solve function. Example:
--
-- >>> solve (GeneralEquation 1 2 3 3 5 0)
-- [(-3,0),(-2,-1),(0,0),(1,-1)]
solve :: Equation -> Either SolveError Solution
solve e = case specializeEquation e of
              e@(LinearEquation{})           -> Right $ solveLinear           e
              e@(SimpleHyperbolicEquation{}) -> Right $ solveSimpleHyperbolic e
              e@(ElipticalEquation{})        -> Right $ solveEliptical        e
              e@(ParabolicEquation{})        -> Right $ solveParabolic        e
              e@(HyperbolicEquation{})       -> Left  $ SolveError "hyperbolic"
