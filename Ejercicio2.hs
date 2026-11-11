import Data.Char (isSpace)
import Data.List (intercalate)
import System.IO
import Text.Read (readMaybe)

potencias :: Integer -> [Integer] -> [Integer]
potencias n = map (\x -> x ^ n)

mostrarLista :: [Integer] -> String
mostrarLista xs = "[" ++ intercalate ", " (map show xs) ++ "]"

-- Acepta los números separados por espacios o comas, con o sin corchetes.
leerEnteros :: String -> Maybe [Integer]
leerEnteros texto = mapM readMaybe (words (map (\c -> if c `elem` "[]," then ' ' else c) texto))

pedirLista :: IO [Integer]
pedirLista = do
  putStr "Lista de enteros (Enter para usar [1, 2, ..., 10]): "
  linea <- getLine
  if all isSpace linea
    then return [1 .. 10]
    else case leerEnteros linea of
      Just xs -> return xs
      Nothing -> do
        putStrLn "Entrada no válida, ingrese solamente números enteros."
        pedirLista

pedirN :: IO Integer
pedirN = do
  putStr "Valor de n (Enter para usar 3): "
  linea <- getLine
  if all isSpace linea
    then return 3
    else case readMaybe linea of
      Just n | n > 0 -> return n
      _ -> do
        putStrLn "El valor de n debe ser un entero positivo."
        pedirN

main :: IO ()
main = do
  hSetBuffering stdout NoBuffering
  hSetEncoding stdin utf8
  hSetEncoding stdout utf8
  xs <- pedirLista
  n <- pedirN
  putStrLn ("\nLista original: " ++ mostrarLista xs)
  putStrLn ("Resultado con n = " ++ show n ++ ": " ++ mostrarLista (potencias n xs))
