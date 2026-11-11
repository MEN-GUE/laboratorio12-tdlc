import Data.Char (isSpace)
import Data.List (intercalate)
import System.IO
import Text.Read (readMaybe)

type Matriz = [[Integer]]

ejemplo :: Matriz
ejemplo =
  [ [1, 2, 3, 1]
  , [4, 5, 6, 0]
  , [7, 8, 9, -1]
  ]

-- Cada columna j de la matriz original se convierte en la fila j del resultado.
transpuesta :: Matriz -> Matriz
transpuesta [] = []
transpuesta x@(primera : _) = map (\j -> map (\fila -> fila !! j) x) [0 .. length primera - 1]

mostrarFila :: [Integer] -> String
mostrarFila fila = "[" ++ intercalate ", " (map show fila) ++ "]"

mostrarMatriz :: String -> Matriz -> String
mostrarMatriz nombre m = nombre ++ " = [" ++ intercalate (",\n" ++ sangria) (map mostrarFila m) ++ "]"
  where
    sangria = replicate (length nombre + 4) ' '

leerFila :: String -> Maybe [Integer]
leerFila texto = mapM readMaybe (words (map (\c -> if c `elem` "[]," then ' ' else c) texto))

-- El argumento es la cantidad de columnas esperada; 0 indica que aún no se ha ingresado ninguna fila.
pedirFilas :: Int -> IO Matriz
pedirFilas columnas = do
  putStr "> "
  linea <- getLine
  if all isSpace linea
    then return []
    else case leerFila linea of
      Nothing -> do
        putStrLn "La fila solo puede contener números enteros."
        pedirFilas columnas
      Just fila
        | null fila -> do
            putStrLn "La fila no puede estar vacía."
            pedirFilas columnas
        | columnas > 0 && length fila /= columnas -> do
            putStrLn ("La fila debe tener " ++ show columnas ++ " elementos.")
            pedirFilas columnas
        | otherwise -> do
            resto <- pedirFilas (length fila)
            return (fila : resto)

main :: IO ()
main = do
  hSetBuffering stdout NoBuffering
  hSetEncoding stdin utf8
  hSetEncoding stdout utf8
  putStrLn "Ingrese la matriz fila por fila, con los números separados por espacios o comas."
  putStrLn "Deje la línea vacía para terminar. Si no ingresa ninguna fila se usa la matriz del enunciado."
  filas <- pedirFilas 0
  let x = if null filas then ejemplo else filas
  putStrLn ""
  putStrLn (mostrarMatriz "X" x)
  putStrLn ""
  putStrLn (mostrarMatriz "Y" (transpuesta x))
