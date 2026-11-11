import Data.Char (isSpace)
import Data.List (dropWhileEnd, intercalate, sortBy)
import System.IO
import Text.Read (readMaybe)

-- Los valores pueden ser texto o números enteros, como en el ejemplo del enunciado.
data Valor = Texto String | Numero Int
  deriving (Eq, Ord)

type Diccionario = [(String, Valor)]

ejemplo :: [Diccionario]
ejemplo =
  [ [("make", Texto "Nokia"), ("model", Numero 216), ("color", Texto "Black")]
  , [("make", Texto "Apple"), ("model", Numero 2), ("color", Texto "Silver")]
  , [("make", Texto "Huawei"), ("model", Numero 50), ("color", Texto "Gold")]
  , [("make", Texto "Samsung"), ("model", Numero 7), ("color", Texto "Blue")]
  ]

ordenarPor :: String -> [Diccionario] -> [Diccionario]
ordenarPor clave = sortBy (\a b -> compare (lookup clave a) (lookup clave b))

mostrarValor :: Valor -> String
mostrarValor (Texto s) = "'" ++ s ++ "'"
mostrarValor (Numero n) = show n

mostrarDiccionario :: Diccionario -> String
mostrarDiccionario d =
  "{" ++ intercalate ", " (map (\(k, v) -> "'" ++ k ++ "': " ++ mostrarValor v) d) ++ "}"

mostrarLista :: [Diccionario] -> String
mostrarLista ds = "D = [" ++ intercalate ",\n     " (map mostrarDiccionario ds) ++ "]"

limpiar :: String -> String
limpiar = dropWhileEnd isSpace . dropWhile isSpace

separar :: Char -> String -> [String]
separar c s = case break (== c) s of
  (a, []) -> [a]
  (a, _ : resto) -> a : separar c resto

leerValor :: String -> Valor
leerValor s = case readMaybe s of
  Just n -> Numero n
  Nothing -> Texto s

leerPar :: String -> Maybe (String, Valor)
leerPar texto
  | null k || null v = Nothing
  | otherwise = Just (k, leerValor v)
  where
    (antes, despues) = break (== '=') texto
    k = limpiar antes
    v = limpiar (drop 1 despues)

leerDiccionarios :: IO [Diccionario]
leerDiccionarios = do
  putStr "> "
  linea <- getLine
  if null (limpiar linea)
    then return []
    else case mapM leerPar (separar ',' linea) of
      Nothing -> do
        putStrLn "Formato incorrecto, use clave=valor separados por comas."
        leerDiccionarios
      Just d -> do
        resto <- leerDiccionarios
        return (d : resto)

pedirLlaves :: [Diccionario] -> IO ()
pedirLlaves ds = do
  putStr "\nLlave para ordenar (Enter para salir): "
  clave <- fmap limpiar getLine
  if null clave
    then putStrLn "Fin del programa."
    else do
      if any (\d -> clave `elem` map fst d) ds
        then putStrLn (mostrarLista (ordenarPor clave ds))
        else putStrLn ("La llave '" ++ clave ++ "' no existe en los diccionarios.")
      pedirLlaves ds

main :: IO ()
main = do
  hSetBuffering stdout NoBuffering
  hSetEncoding stdin utf8
  hSetEncoding stdout utf8
  putStrLn "Ingrese un diccionario por línea, con pares clave=valor separados por comas."
  putStrLn "Por ejemplo: make=Nokia, model=216, color=Black"
  putStrLn "Deje la línea vacía para terminar. Si no ingresa ninguno se usa el ejemplo del enunciado."
  ingresados <- leerDiccionarios
  let ds = if null ingresados then ejemplo else ingresados
  putStrLn "\nLista original:"
  putStrLn (mostrarLista ds)
  pedirLlaves ds
